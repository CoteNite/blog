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

- 布隆过滤器判断元素存在则一定存在
- 布隆过滤器判断元素不存在可能出错（有可能判断一个存在于集合中的元素为不存在）

听起来可能有些麻烦，但实际上jiou