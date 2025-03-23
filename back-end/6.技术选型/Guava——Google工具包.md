# Guava——Google工具包

## 介绍
Guava是Google出品的一款工具包，里面有许多实用的工具包，内置**更多的集合，更好的缓存，消息总站，布隆过滤器...**

最有代表性的使用方式
1. Guava缓存替代Redis。
2. EventBus以替代MQ。

## 缓存
### 现存问题
原有JVM缓存中存在的问题
1. 不能按照一定的规则淘汰数据,如 LRU,LFU,FIFO
   * FIFO：First In First Out，先进先出，淘汰最早被缓存的对象；
   * LRU：Least Recently Used，淘汰最长时间未被使用的数据，以时间作为参考；
   * LFU：Least Frequently Used，淘汰一定时期内被访问次数最少的数据，以次数作为参考
2. 数据被清除时没有回调操作
3. 并发能力差（HashMap Vs CurrentHashMap）

### Guava缓存的优势
1. 存在淘汰规则，有具体的缓存时间，且超出最大储存时使用LRU方式清理缓存
2. GuavaCache类似CurrentHashMap,是线程安全的。
3. 对于不同情况均有回调方法

### 具体使用

**使用Cache**
```java
        Cache<String, String> cache = CacheBuilder
                .newBuilder()
                .initialCapacity(5)//默认存储空间（在创建时就创好的空间）
                .maximumSize(100)//最大存储空间
                .expireAfterWrite(5000, TimeUnit.MILLISECONDS) //超时时间
                .removalListener(new RemovalListener<String, String>() {
                    @Override
                    public void onRemoval(RemovalNotification<String, String> removalNotification) {
                        System.out.println(removalNotification.getKey() + ":remove==> :" + removalNotification.getValue());
                    }
                })//数据被清理时的回调方法，参数为一个键值对
                .build();
                
        String key1 = cache.getIfPresent("java金融1");  //使用getIfPresent
        System.out.println(key1);//null
        if(StringUtils.isEmpty(key1)){
            /**
             * null
             * value - java金融2
             * value - java金融3
             */
            cache.put("java金融1","value - java金融1");
            cache.put("java金融2","value - java金融2");
            cache.put("java金融3","value - java金融3");
            System.out.println(cache.getIfPresent("java金融1"));
            System.out.println(cache.getIfPresent("java金融2"));
            System.out.println(cache.getIfPresent("java金融3"));
        };
        
        
        cache.get("key1",new Callable<String>() {
            @Override
            public String call() throws Exception {
                return "value1";
            }
        });//这种情况下当Cache找不到k-v会自动开一个线程走回调函数
```



**LoadingCache**
```java
LoadingCache<String, String> cacheLoadInit = CacheBuilder
                .newBuilder()
                .initialCapacity(5)
                .maximumSize(100)
                .expireAfterWrite(5000, TimeUnit.MILLISECONDS) //
                .removalListener(new RemovalListener<String, String>() {
                    @Override
                    public void onRemoval(RemovalNotification<String, String> removalNotification) {
                        System.out.println(removalNotification.getKey() + ":remove==> :" + removalNotification.getValue());
                    }
                })
                .build(
                        new CacheLoader<String, String>() {
                            @Override
                            public String load(String key) throws Exception {
                                System.out.println("first init.....");
                                return key;
                            }
                        }); //当get方法找不到k-v是使用这个回调
                String key1 = cache.getIfPresent("java金融1");
        System.out.println(key1);//null
        if(StringUtils.isEmpty(key1)){
            /**
             * null
             * value - java金融2
             * value - java金融3
             */
            cache.put("java金融1","value - java金融1");
            cache.put("java金融2","value - java金融2");
            cache.put("java金融3","value - java金融3");
            System.out.println(cache.getIfPresent("java金融1"));
            System.out.println(cache.getIfPresent("java金融2"));
            System.out.println(cache.getIfPresent("java金融3"));
        }
```

**回收缓存机制**
1. 存储超过最大限度则会走LRU
2. 定时回收
```java
expireAfterAccess(long, TimeUnit):缓存项在给定时间内没有被读/写访问,则回收。请注意这种缓存的回收顺序和基于大小回收一样
expireAfterWrite(long, TimeUnit):缓存项在给定时间内没有被写访问创建或覆盖,则回收。如果认为缓存数据总是在固定时候后变得陈旧不可用,这种回收方式是可取的
```

**手动删除**

1. 清除单个key:Cache.invalidate(key) //将key=1 删除 cache.invalidate(“1”); 
2. 批量清除key:Cache.invalidateAll(keys)//将key=1和2的删除 cache.invalidateAll(Arrays.asList(“1”,“2”));
3. 清除所有缓存项:Cache.invalidateAll()//清空缓存 cache.invalidateAll();

Guava的删除和清理使用的是懒删除，即只有你在使用put或get方法时他才会去主动删除这个参数


**获取底层CurrentHashMap**

1. cache.asMap()包含当前所有加载到缓存的项。因此相应地,cache.asMap().keySet()包含当前所有已加载键; 
2. asMap().get(key)实质上等同于cache.getIfPresent(key),而且不会引起缓存项的加载。这和Map的语义约定一致。 
3. 所有读写操作都会重置相关缓存项的访问时间,包括Cache.asMap().get(Object)方法和Cache.asMap().put(K, V)方法,但不包括Cache.asMap().containsKey(Object)方法,也不包括在Cache.asMap()的集合视图上的操作。比如,遍历Cache.asMap().entrySet()不会重置缓存项的读取时间


**统计功能**
1. Cache.stats(): 返回了一个CacheStats对象, 提供一些数据方法 
2. hitRate(): 请求点击率 
3. evictionCount(): 清除的个数
