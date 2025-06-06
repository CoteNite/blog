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

- 防缓存击穿：将所有存在的key放到布隆过滤器中，这样一旦访问到不存在的key，直接返回没有即可，（不存在的一定不存在，不会误判），虽然仍然会有小部分的恶意流量打入数据库（存在的不一定真存在），但这都是小问题了
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

同时，由于布隆过滤器的不允许删除的特点，所以我们一般会将布隆过滤作为验证 **是否一次都没有存在过的检验** 或是 **不会删除的数据的校验**

比如一个系统的点赞逻辑，我们的布隆过滤器在里面起到的作用只有在用户第一次点赞前有用（因为点过赞后就被标为已点赞，这个时候若是为了正确率，就需要在ZSet中再查询一次）

那么这时候又出现一个问题——**既然只有这么有限的情况有用，那还有必要上布隆过滤器吗？**

答案肯定是有的，回答这个问题的思路其实很简单，你可以想一下用户在一个网站中实际点赞的帖子/视频的内容能占其浏览的总内容的多少，不难发现用户其实对大多数的内容都是不会点赞的，因此这种场景虽然局限性大，但是却很常见


## 位图(BitMap)

位图是一种用来操作二元状态（0/1，对/错等）的数据结构，底层基于字符串，利用每个bit位的0/1来存储信息，能够大规模节省内存

这里来看一下Redis的原生指令（或许应该叫RQL？）

```redis

SETBIT key offset value  将key对应的value的第offset位设置为value（value只能为1/0）

GETBIT key offset 获取key对应的value的第offset位上的数

BITCOUNT key  获取key对应的value的位上1的数量

```


由于直接访问位置，所以Bitmap的效率可以达到逆天O(1)级别

但是Bitmap也存在自己的问题，那就是当我们需要表示的offset巨大时，bitmap占用的空间也是巨大的

比如我们表示一篇文章是否被点赞过，那么offset很自然的就会使用文章的id，但是如果我们的系统的文章id使用的是雪花算法，那么，那么Redis甚至会提示“偏移量过大，超过了最大限制”，就算不使用雪花算法，也会由于点赞文章的随机性导致内存的无用占用（比如用户点赞了网站的第一篇和最新一篇文章，那么bitmap记录的其实是网站所有文章是否被该用户点赞）

### 与布隆过滤器的比较

由于都是用来存储一个二元状态的数据结构，因此我们可以将两者来比较一下

- bitmap的优势：
  - 简单的删改：使用setbit就可以轻松的改掉
  - 较高的效率：O（1）
  - 不会误判
- 布隆过滤器的优势：
  **不会有大量的无用占用**

## 咆哮位图(Roaring Bitmap)

由于布隆过滤器与bitmap各自都有自己不尽人意的情况，那么有没有一个两全其美的解决方案呢？

有的兄弟，有的

为了解决bitmap对于系数数据的大内存占用，Daniel Lemire团队于2015年提出Roaring Bitmap来解决这个问题，Roaring Bitmap通过自能分层的存储机制，在保证bitmap效率的同时，对bitmap进行了相当逆天的空间压缩（仅存储有效位）

| 对比维度         | Redis Bitmap           | Roaring Bitmap       |
| :----------- | :--------------------- | :------------------- |
| **存储机制**     | 连续内存位数组                | 分桶三态容器               |
| **最大基数**     | 2^32（512MB）            | 2^32（动态扩展）           |
| **内存占用**     | 固定O(N)                 | 动态O(1)-O(N)          |
| **稀疏数据存储**   | 严重浪费（存0也占位）            | 极致压缩（仅存有效位）          |
| **10万随机数存储** | 1.25MB                 | 约25KB                |
| **AND运算速度**  | O(N)                   | O(min(N,M)) + SIMD加速 |
| **范围查询**     | BITCOUNT key start end | 原生支持批量范围检索           |
| **持久化方式**    | RDB/AOF全量保存            | 支持内存映射文件直接加载         |
| **分布式支持**    | 需自行分片                  | 原生支持分片聚合             |
| **典型适用场景**   | 简单标记、布隆过滤器             | 复杂集合运算、海量数据处理        |

[Github上的一个Redis的RoaringBitmap的插件](https://github.com/aviggiano/redis-roaring)


在Redisson Pro版本中提供了对RoaringBitmap的支持