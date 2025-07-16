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
