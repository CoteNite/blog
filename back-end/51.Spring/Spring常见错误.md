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

