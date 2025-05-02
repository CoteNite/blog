# Redisson——功能更加强大的Redis客户端

就像MySQL是大多数开发者学习的第一个SQL一样，Redis是大多数开发者学习的第一个NoSQL。这里注重聊一下Redisson和Redis的一些平常不太常用到的类型
## Redisson VS Spring Data Redis

相信大家在操作redis的时候经常会用到SpringDataRedis这个包，这是Spring为我们提供的一个SpringData风格操作Redis的方案（虽然平常都是再用RedisTemplate，但你确实可以像SpringDataJpa一样定义Repository来操作Redis）

对于二者的区别我们可以看这篇文章[Redisson VS SpringDataRedis](https://redisson.pro/blog/feature-comparison-redisson-vs-spring-data-redis.html)

本文主要使用Redisson来操作Redis

## 布隆过滤器

由于数据量不断地增长，使用传统的哈希表或树的方式来判断一个资源是否存在于一个集合中已经无法解决需求（占用的资源过大），我们迫切的需要一个新的数据结构来更加高效的解决**一个数据是否在一个集合中的问题**。为了解决这一需求，布隆在1970年提出了布隆过滤器。

- 优点：速度快，占用小
- 缺点：有误判，删除困难

### 假阳性（误判）

我们一般将布隆过滤器的误判情况称为假阳性

- 布隆过滤器判断元素存在不一定存在（有可能判断一个不存在于集合中的元素为存在）
- 布隆过滤器判断元素不存在一定不存在

听起来可能有些绕，但实际上就是在说一个事

**有的不一定真有，没有的那是一点没有**

### 其他缺点

- **禁止删除：**
  由于布隆过滤器的底层算法设计，导致布隆过滤器不允许删除元素（因为删除元素会导致hash值的变化，会对其它元素造成影响）
  后续有人设计了计数布隆过滤器(Counting Bloom Filter)针对这一现象进行了优化，进而允许删除，但是内存开销也相对增加了

- **误判上升：**
  布隆过滤误判的概率会随着过滤器内数据量的上升而上升

- **不支持获取元素：**
  术业有专攻，布隆过滤器只负责判断元素存不存在集合中这一件事

### 适合场景

- 防缓存击穿：将所有存在的key放到布隆过滤器中，这样一旦访问到不存在的key，直接返回没有即可（不存在的一定不存在，不会误判）
- 黑名单：可以快速的判断用户是否在黑名单上，但是可能阻拦一些正常用户（存在的不一定存在）

## Redisson集成

Redisson对bloom过滤器作了专门的集成

```kotlin
fun test(){  
    val bloomFilter = redissonClient.getBloomFilter<String>("bloomFilter")  
    bloomFilter.tryInit(1000000,0.09)  
    bloomFilter.add("1")  
    bloomFilter.add("3")  
    bloomFilter.add("5")  
    bloomFilter.add("7")  
    bloomFilter.add("9")  
}  
  
fun test2(){  
    val bloomFilter = redissonClient.getBloomFilter<String>("bloomFilter")  
    println("开始1的测试")  
    for (i in 1..2000){  
        println(bloomFilter.contains("2"))  
    }  
}
```

### 使用逻辑

一般我们会让布隆过滤器作为ZSet的辅助，判断是否存在，如果存在则需要再次校验，如果不存在则不需要校验（相当于优化了半边）

+