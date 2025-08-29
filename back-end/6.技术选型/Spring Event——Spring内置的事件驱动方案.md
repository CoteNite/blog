# Spring Event——Spring内置的事件驱动方案

事件驱动是很多小伙伴都听说过的，我们将一切接收到的前端请求理解为一个事件，然后我们根据事件的不同交给其对应的处理器（handler）

这样的好处是可以让你的代码耦合度降低（因为取消了类和类之间的相互引用的直接调用，进而转化为了事件发出者和事件接受者之间的关系）

一般这样的流程需要我们通过设计模式来进行实现，但Spring为我们内置了这套组件，让我们只需要使用简单的注解就可以实现

## 最小实现

对于事件驱动，最小的实现只需要三个部分——事件，事件发出者，事件接收者

那么我们先来定义一个事件（一个简单的Java Bean）

```java
@Data  
@RequiredArgsConstructor  
public class OpenDoorEvent {  
    private final String event;  
    private final String time;  
}
```

然后就是事件发出者

```java
@Service  
public class EventService {  
  
    @Resource  
    private ApplicationEventPublisher publisher;  
  
    public void goHome() {  
        publisher.publishEvent(new OpenDoorEvent("open door", LocalDateTime.now().format(DateTimeFormatter.ISO_LOCAL_DATE_TIME)));  
    }  
  
}
```

这里有一个`ApplicationEventPublisher`是Spring为我们提供的，其作用就是为我们发送事件

```java
@FunctionalInterface
public interface ApplicationEventPublisher {
    default void publishEvent(ApplicationEvent event) {
        this.publishEvent((Object)event);
    }

    void publishEvent(Object event);  //这里我们可以看到源码就是发送一个事件（Object）出去
}
```

最后就是事件接受者了

```java
@Component
@Slf4j
public class HomeEventListener {

    @EventListener
    public TurnOnLightsEvent listenOpenDoorEvent(OpenDoorEvent event) {
        log.info("已经接收到事件————{}: {}", event.getTime(), event.getEvent());
        return new TurnOnLightsEvent("turn on light", LocalDateTime.now().format(DateTimeFormatter.ISO_LOCAL_DATE_TIME));
    }

}
```

这里记得要将接收者也要注册为Spring Bean，因为只有Spring Bean才能被我们的Spring管理，进而使用Spring的各种强大功能

## 事件链

接着我们再来说一些高级一些的使用

我们可以在监听者的代码中返回一个事件（比如上面的`TurnOnLightsEvent`），这个事件会被我们的Spring控制，如果你还有一个新的接受该事件的方法，那么就会自动发送过去

```java
@Component  
@Slf4j  
public class HomeEventListener {  
  
    @EventListener  
    public TurnOnLightsEvent listenOpenDoorEvent(OpenDoorEvent event) {  
        log.info("已经接收到事件————{}: {}", event.getTime(), event.getEvent());  
        return new TurnOnLightsEvent("turn on light", LocalDateTime.now().format(DateTimeFormatter.ISO_LOCAL_DATE_TIME));  
    }  
  
    @EventListener  
    public void listenOpenDoorEvent(TurnOnLightsEvent event) {  
  
        log.info("链式成功————{} {}", event.getEvent(), event.getTime());  
  
    }  
  
}
```

## 一个方法监听多个事件

我们上面使用了一个方法监听一个事件，但是我们其实可以一个方法监听多个事件，这需要我们在`@EventListener`上下点功夫

```java
public @interface EventListener {
    ...
	@AliasFor("value")
	Class<?>[] classes() default {};
	...
}
```

EventListener会监视classes中的class，所以我们只需要指定他即可

```java
@EventListener(classes = {OpenDoorEvent.class, TurnOnLightsEvent.class})
public void listenMultiEvent(Object object) {
    log.info("监听到了事件:{}",object);
}
```

不过这里接受的参数就是两个类共同的父类了

## 监听的条件

EventListener中存在一个condition，内部填充的是SpEL表达式（相关内容我会再写一篇文章，这里可以理解成就是一个可解析的string），只有当填充SpEL为`true` 时才能接收到

```java
public @interface EventListener {
	...
    String condition() default "";
	...
}
```

## 异步执行

再默认的情况下，事件的发出者和接受者是同步的，但是有时我们会希望他是异步实现的，这里我们就要使用Spring为我们提供的异步注解`@Async`(当然，异步注解和事件发布没有直接关系，这里只是配合使用)

启动异步逐渐需要我们在SpringBootApplication或则某个Configuration类上使用`@EnableAsync`注解，同时我们建议自定义一个线程池去实现它

```java
@Slf4j
@EnableAsync
@Configuration
public class ConcurrencyConfig {

    @Primary
    @Bean
    public TaskExecutor threadPoolExecutor() {
        ThreadPoolTaskExecutor executor = new ThreadPoolTaskExecutor();
        executor.setCorePoolSize(2);
        executor.setMaxPoolSize(8);
        executor.setQueueCapacity(20);
        executor.setKeepAliveSeconds(1);
        executor.setWaitForTasksToCompleteOnShutdown(true);
        executor.setThreadNamePrefix("task-thread-");
        executor.setRejectedExecutionHandler(new ThreadPoolExecutor.AbortPolicy());

        executor.initialize();
        return executor;
    }
}

```

然后就只需要我们为监听者的方法加上`@Async`注解即可

## 事务机制

如果你在一个 **事务尚未提交** 的方法里发布事件（`@EventListener`），而监听器又在 **同一个事务上下文中执行**，那么此时事务还没提交，此时其他事务（包括监听器新开启的事务）是看不到未提交的数据的，所以「查不到刚刚 insert 的数据」。

为了解决这个问题，Spring提供了另一个注解`@TransactionalEventListener`

```java
// @since 4.2 注解的方式提供的相对较晚，其实API的方式在第一个版本就已经提供了。
// 值得注意的是，在这个注解上面有一个注解：`@EventListener`，所以表明其实这个注解也是个事件监听器。 
@Target({ElementType.METHOD, ElementType.ANNOTATION_TYPE})
@Retention(RetentionPolicy.RUNTIME)
@Documented
@EventListener //有类似于注解继承的效果
public @interface TransactionalEventListener {
	// 这个注解取值有：BEFORE_COMMIT、AFTER_COMMIT、AFTER_ROLLBACK、AFTER_COMPLETION
	// 各个值都代表什么意思表达什么功能，非常清晰，下面解释了对应的枚举类~
	// 需要注意的是：AFTER_COMMIT + AFTER_COMPLETION是可以同时生效的
	// AFTER_ROLLBACK + AFTER_COMPLETION是可以同时生效的
	TransactionPhase phase() default TransactionPhase.AFTER_COMMIT;

	// 表明若没有事务的时候，对应的event是否需要执行，默认值为false表示，没事务就不执行了。
	boolean fallbackExecution() default false;

	// 这里巧妙的用到了@AliasFor的能力，放到了@EventListener身上
	// 注意：一般建议都需要指定此值，否则默认可以处理所有类型的事件，范围太广了。
	@AliasFor(annotation = EventListener.class, attribute = "classes")
	Class<?>[] value() default {};
	@AliasFor(annotation = EventListener.class, attribute = "classes")
	Class<?>[] classes() default {};
	
	String condition() default "";
}
```