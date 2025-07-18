# Spring错误50例——阅读笔记

## 包位置问题

我们在写SpringBoot项目的时候会发现我们类都是建在启动类的同级目录下，这其实是由SpringBoot启动类上的@SpringBootApplication注解决定的

```java
@Target(ElementType.TYPE) 
@Retention(RetentionPolicy.RUNTIME) 
@Documented @Inherited @SpringBootConfiguration 
@EnableAutoConfiguration 
@ComponentScan(excludeFilters = { @Filter(type = FilterType.CUSTOM, classes = TypeExcludeFilter.class), @Filter(type = FilterType.CUSTOM, classes = AutoConfigurationExcludeFilter.class) }) public @interface SpringBootApplication { //省略非关键代码 
}
```

这里我们会发现SpringBootApplication上有一个@ComponentScan注解，这个注解就是决定SpringBoot扫描的包的范围的

```java
public @interface ComponentScan {

/**
 * Base packages to scan for annotated components.
 * <p>{@link #value} is an alias for (and mutually exclusive with) this
 * attribute.
 * <p>Use {@link #basePackageClasses} for a type-safe alternative to
 * String-based package names.
 */
@AliasFor("value")
String[] basePackages() default {};
//省略其他非关键代码
}
```

basePackages的值就是我们要扫描的目录，当basePackages为空时，会使用和SpringBoot启动类所在的包

## Bean缺少问题

```java
@Service
public class ServiceImpl {

    private String serviceName;

    public ServiceImpl(String serviceName){
        this.serviceName = serviceName;
    }

}
```

上面的代码很简答，就是定义了一个Service，然后内部有一个serviceName作为必要的参数

在SpringBoot创造Bean实例的时候，会通过构造器来寻找必要的参数，因此如果要创造这个ServiceBean，那么必须要有一个名字叫做serviceName的Bean。

因此还必须要有这样的代码

```java
@Bean
public String serviceName(){
    return "MyServiceName";
}
```

## 原型Bean

SpringBoot默认的创建Bean的方式是单例的，也就是说你不管怎么取，全局用到的同一个名称的Bean都是同一个。

SpringBoot也为我们提供了每次请求都重新new的获取方式，这就是原型Bean。

要创建原型Bean，你只需要在Bean上添加一个注解即可

```java
@Service
@Scope(ConfigurableBeanFactory.SCOPE_PROTOTYPE)
public class ServiceImpl {
}
```

但是需要注意的是，如果你注入Bean用的是@Autowired注解，那么他会在一个Bean生成时固定住注入的Bean

```java
@RestController
public class HelloWorldController {

    @Autowired
    private ServiceImpl serviceImpl;

    @RequestMapping(path = "hi", method = RequestMethod.GET)
    public String hi(){
         return "helloworld, service is : " + serviceImpl;
    };
}
```

也就是说这个Controller每次拿到的ServiceImpl都是同一个

对此我们有两种解决方案

**从SpringBoot上下文中获取**

```java
@RestController
public class HelloWorldController {

    @Autowired
    private ApplicationContext applicationContext;

    @RequestMapping(path = "hi", method = RequestMethod.GET)
    public String hi(){
         return "helloworld, service is : " + getServiceImpl();
    };
 
    public ServiceImpl getServiceImpl(){
        return applicationContext.getBean(ServiceImpl.class);
    }

}
```

**使用@Lookup注解**

```java
@RestController
public class HelloWorldController {
 
    @RequestMapping(path = "hi", method = RequestMethod.GET)
    public String hi(){
         return "helloworld, service is : " + getServiceImpl();
    };

    @Lookup
    public ServiceImpl getServiceImpl(){
        return null;
    }  

}
```

这里的Lookup注解会走CGLIB代理产生的代码，因此我们这里方法内部具体写什么不重要，因为都不会执行

## Bean重复问题

当我们注入Bean的时候可能时长会遇到这样的问题

```java
@Repository
@Slf4j
public class OracleDataService implements DataService{
   
}
```

```java
@Repository
@Slf4j
public class CassandraDataService implements DataService{
    
}
```

出于某些原因，我们的项目里同时存在下面两个DataSerivce的具体实现，其中一个是基于Oracle，另一个是基于Cassandra。

然后我们要在一个类中注入DataService类

```java
@RestController
@Slf4j
@Validated
public class StudentController {
    @Autowired
    DataService dataService;

    @RequestMapping(path = "students/{id}", method = RequestMethod.DELETE)
    public void deleteStudent(@PathVariable("id") @Range(min = 1,max = 100) int id){
        dataService.deleteStudent(id);
    };
}
```

然后就会报错

```text
required a single bean, but 2 were found
```

原因很简单，有两个DataService的类，此时SpringBoot会根据两个方面选择注入哪个类

1. 调用determineAutowireCandidate方法来选出优先级最高的依赖。
2. 被注解类可以不用选择，比如是Map一类

解决方法也有很多

**方法一：标注优先级**

```java
@Repository
@Primary
@Slf4j
public class CassandraDataService implements DataService{
    
}
```

**方法二：指定名称**

```java
@Autowired
DataService oracleDataService; //这里精确到了具体的类
```

## @Qualifie的名字问题

Spring源码中如果Bean未指定名字，则会对一个Bean生成一个默认的名字，这个名字一般和类名一致，但是会有一个大小写的问题，其中值得注意的是：

1. 如果类名以一个大写字母开头，那么默认名称会使用小写字母开头
2. 如果类名以一个以上的大写字母开头，那么默认会直接使用类名

## 内部类注册成Bean的情况

如果我们将一个内部类注册为Bean，那么Bean的名字会使\[内部类].\[外部类]的格式，然后他仍然会使用上面的两条规则，但这次的首字母则是外部类决定的了

## @Value的使用

对于@Value我们都不陌生，我们常常会用他向我们的代码中注入我们再配置文件中声明的内容，但是@Value的功能仅限于此吗？

肯定不是，@Value本身实际也能完成Bean的注入

```java
//注册正常字符串
@Value("我是字符串")
private String text; 

//注入Bean
@Value("#{student}")
private Student student;

//注入系统参数、环境变量或者配置文件中的值
@Value("${ip}")
private String ip

//注入其他Bean属性，其中student为bean的ID，name为其属性
@Value("#{student.name}")
private String name;
```

可以发现@Value在某种程度上功能甚至比@Autowired还要强大，只是由于其部分功能我们用不到而且还强制要输入Value才使用@Autowired而已

## @Value的注入顺序问题

如果我们在yml文件里顶一个了一个username的变量，那么使用@Value能否顺利拿到呢？

大概率是不能的，因为@Value的范围并不仅限于yml文件中的变量

```java
[ConfigurationPropertySourcesPropertySource {name='configurationProperties'}, 
StubPropertySource {name='servletConfigInitParams'}, ServletContextPropertySource {name='servletContextInitParams'}, PropertiesPropertySource {name='systemProperties'}, OriginAwareSystemEnvironmentPropertySource {name='systemEnvironment'}, RandomValuePropertySource {name='random'},
OriginTrackedMapPropertySource {name='applicationConfig: classpath:/application.properties]'},
MapPropertySource {name='devtools'}]
```

- **`configurationProperties`**: 这通常是指通过 `@ConfigurationProperties` 注解绑定的属性，它们在应用启动时被处理。
    
- **`servletConfigInitParams`**: 从 Servlet 配置的初始化参数中加载的属性。
    
- **`servletContextInitParams`**: 从 Servlet 上下文的初始化参数中加载的属性。
    
- **`systemProperties`**: Java 系统属性（例如，通过 `-D` 参数传递的属性）。
    
- **`systemEnvironment`**: 操作系统环境变量。
    
- **`random`**: 这是一个特殊的 `PropertySource`，允许您注入随机值（例如 `${random.uuid}`）。
    
- **`applicationConfig: classpath:/application.properties`**: 这是您应用程序中 `application.properties`（或 `application.yml`）文件的位置。这也是最常用的配置来源。
    
- **`devtools`**: 如果您使用了 Spring Boot DevTools，它会提供一个额外的 `PropertySource`，通常用于一些开发时的特性，例如自动重启。

可以看到系统变量是在我们的配置文件之前的，因此@Value会先读入系统变量的值

## 集合类Bean装载问题

在Spring中你可以定义多个同类型的Bean，然后将其统一注入到一个List中，具体可以有两种写法

1. 定义多个Bean，然后让Spring自动的去将其装载到你需要的List中
2. 定义一个List类型的Bean，然后提前装载好，等待注入

这是两个非此即彼的方法，也就是这两个方法并不能共存，当同时存在时Spring会装配第一种进入List中

## Bean声明周期问题

```java
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;
@Component
public class LightMgrService {
  @Autowired
  private LightService lightService;
  public LightMgrService() {
    lightService.check();
  }
}
```

上面的代码在Spring启动的时候lightService.check()会执行成功吗？

答案是不会（不然也不会有这个问题了XD）

原因是Spring在自动装配的时候，实例化往往在装配之前完成（如果构造参数是上面这种无参的）

那么此时内部的lightService肯定还没有注入，但是构造方法已经被调用用来创建实例了，所以自然会报错（空指针异常）

也是因此**Spring推荐我们使用构造参数进行实例化**

```java

```