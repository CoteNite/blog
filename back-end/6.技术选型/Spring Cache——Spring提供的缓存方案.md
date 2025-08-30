# Spring Cache——Spring提供的缓存方案

Cache大家肯定都使用过，一旦你的系统设计到了高并发，那么一定就会使用Cache。

市面上的缓存方案有很多，Redis，EhCache，Guava Cache，Caffeine甚至是直接使用ConcurrentHashMap都可以实现缓存，但是也都会引入更多的代码。

Spring希望通过一套约定俗成的方案统一缓存的定义，这也就是Spring Cache的来源。

## 使用

使用Spring Cache需要引入这个依赖

```xml
<dependency>
    <groupId>org.springframework.boot</groupId>
    <artifactId>spring-boot-starter-cache</artifactId>
</dependency>
```

Spring Cache支持九种缓存方案

- caffeine：Caffeine 是一种高性能的缓存库，基于 Google Guava。
- couchbase：_CouchBase_是一款非关系型JSON文档数据库。
- generic：由泛型机制和 static 组合实现的泛型缓存机制。
- hazelcast：一个高度可扩展的数据分发和集群平台，可用于实现分布式数据存储、数据缓存。
- infinispan：分布式的集群缓存系统。
- jcache：JCache 作为缓存。它是 JSR107 规范中提到的缓存规范。
- none：没有缓存。
- redis：用 Redis 作为缓存
- simple：用内存作为缓存。

配置好后需要在启动类上加上`@EnableCaching`注解，然后在需要缓存的方法上加上`@Cacheable`注解就能对这个方法开启缓存

```kotlin
@RestController
@RequestMapping("/test")
class WebController {

    @GetMapping("/getStr")
    @Cacheable(value = ["cache"])
    fun getStr(): String{
        return "hello world"
    }

}
```

当我们调用这个接口后，查看Redis中存储的数据，发现多了这样一个

![image.png](https://raw.githubusercontent.com/CoteNite/Blog_img/master/blogImg/20250830200752.png)

显而易见，我们的Cacheable注解的value属性就是其在缓存中对应的Key

然后我们修改原本代码的返回值，重启应用，再次调用同一个接口，会发生什么呢？

会返回之前的返回值！

这也就说明了我们的数据已经保存在了Spring Cache中，并且获取的数据也是从Cache中获取到的

此时我们再创建一个新的方法

```kotlin
@RestController
@RequestMapping("/test")
class WebController {

    @GetMapping("/getStr")
    @Cacheable(value = ["cache"])
    fun getStr(): String{
        return "hello 111 world"
    }

    @GetMapping("/getStr2")
    @Cacheable(value = ["cache"])
    fun getStr2(): String{
        return "hello 222 world"
    }

}
```

再去查询数据会发生什么呢？

我们会发现还是返回之前保存的Cache值，这也就说明了`@Cacheable`的value属性相同的方法公用了同一个Cache

如果不设置value呢？

实际测试结果会报错。

这里我们就可以得到一些结论

- 如果没有指定参数，则缓存生成的 key name，是默认自动生成的，叫做 SimpleKey\[]
- 我们可以使用`@Cacheable`的key参数来设置key的值
- key对应的值是JDK序列化后的值
- value默认的过期时间是永不过期

## 基础配置

我们也可以为Spring Cache配置一些内容

```yml
spring:
  cache:
    type: redis
    redis:
      # 缓存的过期时间，单位毫秒
      time-to-live: 3600000
      # 是否使用前缀
      use-key-prefix: true
      # 使用的前缀
      key-prefix: test
      # 防止缓存穿透
      cache-null-values: true
```

## 自定义Key

前面说了我们可以自定义Key，这里我们来细节的聊一下

```kotlin
@Cacheable(value = {"hot"}, key = "#root.method.name")
```

这里使用的是SpEL表达式，此时的#root指向了当前的这个类，method则指向了正在使用缓存的方法，name则为方法的名字

因此如果是

```kotlin
@Cacheable(value = {"hot"}, key = "#root.method.name")
fun test(){

}
```

等价于

```kotlin
@Cacheable(value = {"hot"}, key = "test")
fun test(){

}
```

