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

配置好后需要在启动类上加上`@EnableCaching`注解，然后在需要缓存的方法上加上`@Cacheable`注解就能对这个g'fan