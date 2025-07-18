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

//注入系统参数、环境变量或者配置文件中的值
@Value("${ip}")
private String ip

//注入其他Bean属性，其中student为bean的ID，name为其属性
@Value("#{student.name}")
private String name;
```