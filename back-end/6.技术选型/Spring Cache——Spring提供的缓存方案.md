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

