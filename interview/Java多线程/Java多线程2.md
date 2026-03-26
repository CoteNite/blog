# Java多线程2

## Lock接口

除了synchronized以外，Java还我们提供通过类来操作锁的方式，这种类均实现类Lock接口。

## ReentrantLock

ReentrantLock是一个可重入且独占式的锁类似synchronized，但功能更加强大。

```java
ReentrantLock reentrantLock=new ReentrantLock();  //默认false
ReentrantLock reentrantLock=new ReentrantLock(true);
```

false时为非公平锁，true时为公平锁

### 公平锁？非公平锁？

所谓的公平指的是拿锁的先后顺序。

一般情况下我们的锁是非公平锁，锁释放后随机被一个等待锁的线程拿到。

而公平锁则是决定让先请求的锁去获取到锁。

### 可重入锁？

**ReentrantLock与synchronized均为可重入锁**

所谓可重入锁就是锁内可以重复的获取当前持有的锁

```java
 Thread thread=new Thread(()->{
           synchronized (Object.class){
               System.out.println(1);
               synchronized (Object.class){
                   System.out.println(2);
               }
           }
        });
```

若没有可重入锁，理论上这段代码会在调用第二次Obect.class时死锁，但是由于synchronized是可重入的，因此不会有这种问题

### ReentrantLock相对synchronized的优势

synchronized基于JVM实现而ReentrantLock基于API实现

ReentrantLock相对synchronized提供了更多的功能。

* 等待可中断：我们可以lock.lockInterruptibly()方法来讲等待当前锁的其他线程中断，被中断的线程会抛出 InterruptedException异常

* 实现了公平锁

* 支持超时：lock.trylock(long time)可以为锁设计一个最长等待时间，进而预防死锁，同时还可以完成一些时间敏感的操作（比如全局异常捕获，然后反馈给用户一个等待超时的友好提醒，进而提升用户的体验）

* 可实现选择性通知：

  选择性通知借助于Conditio接口，通过lock.newCondition()来获得一个condition，接着对他使用await与signal操作（必须在lock.lock()后，即lock已经上锁），其中await会将当前线程挂起并将锁释放，而signal则会唤醒之前挂起的线程

## ThreadLocal

Thread类中存在一个threadLocals和inheritableThreadLocals变量，均为ThreadLocalMap类型，我们可以初略的把ThreadLocalMap理解为他是该线程独有的一个HashMap，初始时二者均为null，仅在ThreadLocl类调用set，get时才会创建和调用，本质上其实也是在用ThreadLocalMap的get和set。

而我们的ThereadLocl类的set和get方法。

ThreadLocalMap的key为ThreadLocal，值为Object

### 内存泄漏问题

ThreadLocal存在内存泄漏问题。

因为ThreadLocalMap中的key为弱引用，当ThreadLocal不再指向任何强引用，垃圾回收器会在下次 GC 时回收该实例，使key为null。

而value 是强引用，key即使被回收，value仍然存在于ThreadLocalMap中。

**因此当线程持续存活且ThreadLocal不再使用时，value会一直存活，进而造成内存泄漏**

（ThreadLocal的set，get，remove均会尝试清除key为null的value，但由于是被动的，因此不完全可靠）

**我们建议用完ThreadLocal时即时的使用remove移除当前entry**

## 线程池

AlibabaJava开发指南会推荐我们`不要显式创建线程，请使用线程池`，那什么是线程池呢？

**线程池就是管理一系列线程的资源池，线程池中的线程执行完任务后不会立刻销毁，而是等待下一个线程的到来**

### 优势

* 降低资源消耗：重复利用线程，避免多次创建线程
* 提高相应速度：对于任务的到来，可以使用已有线程，省去创建线程的这一步
* 提高线程的可管理性：线程池同意优化

### 创建方式

存在使用`Executors`框架创建或自行使用`ThreadPoolExecutor`两种方式

Alibaba代码指南中强制我们使用ThreadPoolExecutor显示创建线程池

```java
  public ThreadPoolExecutor(int corePoolSize,//未达到队列容量前最大可容纳线程数
                              int maximumPoolSize,//等待队列满时，可以创建临时线程，临时等于最大-核心
                              long keepAliveTime,//临时线程的存活时间
                              TimeUnit unit,//时间单位
                              BlockingQueue<Runnable> workQueue,//任务队列，当线程达到maximumPoolSize(即临时线程也达到最大时)，我们将任务临时存储的位置
                              ThreadFactory threadFactory,//线程工厂，用来创建线程，一般默认即可
                              RejectedExecutionHandler handler//最大线程达到的时候我们对新任务的拒绝方案
                               ) 
```

### 等待队列

等待队列决定了等待中的线程如何进入核心线程

* ArrayBlockingQueue：使用数组实现的有界队列，必须传入长度

* LinkedBlockingQueue：单向链表实现的可选有界阻塞队列，默认长度为Integer的最大值

  Executors框架中的FixedThreadPool和 SingleThreadExecutor均使用该队列，且长度均为Integer的最大值，为防止OOM进而不使用这两个线程池

* PriorityBlockingQueue：支持优先排序的无界阻塞队列，创建时必须传入一个Comparator对象以决定如何排序，并且不能插入 null 元素。

* SynchronousQueue：同步队列，不存储元素，每个插入操作都必须等待对应的删除操作

* DelayedWorkQueue：延迟队列，元素只有到了其指定的延迟时间，才能够从队列中出队

### 拒绝策略

* ThreadPoolExecutor.AbortPolicy：拒绝所有新任务并抛出RejectedExecutionException异常
* ThreadPoolExecutor.DiscardPolicy：拒绝新任务且不抛出异常
* ThreadPoolExecutor.DiscardOldestPolicy：丢弃最早进入的任务（即等待时间最久的任务），然后将新任务加入队列
* ThreadPoolExecutor.CallerRunsPolicy：使用当前线程（调用线程池execute方法的线程）去执行该任务。如果执行程序已关闭，则会丢弃该任务。会影响整体程序的运行速度（主程序运行新任务时会导致线程池注射），但是会保证任务不被丢弃

### 执行流程

1. 若线程池中线程小于核心线程，则创建核心线程并运行当前任务（核心线程在核心线程池中不会回收）
2. 若线程池中大于等于核心线程，则放入等待队列。
3. 若等待队列已满但仍小于最大，则创建临时线程并运行当前任务（临时线程在不运行时长大于设定时长时会回收）
4. 若最大线程已经达到。则会跟据拒绝策略选择拒绝的方式

### 预热

ThreadPoolExecutor为我们提供了两个创建核心线程的方法，进而完成线程池的预热

* prestartCoreThread()：创建一个核心线程，若核心线程已满返回false。
* prestartAllCoreThreads()：启动所有的核心线程，并返回启动成功的核心线程数。

### 报错的处理

* execute：使用execute的任务，报错时会摧毁当前线程并新启一个线程来为下一个任务使用，报错信息会打印到控制台回日志文件中
* submit：使用submit的任务,报错会放在返回的Future类中，调用Future.get()方法时，可以捕获到一个ExecutionException，线程不会摧毁，会继续在池中

### 如何给线程池命名

使用自定义的Factory或使用Guava为我们提供的ThreadFactoryBuilder类

自定义的Factory需要继承自ThreadFactory接口

```java
public interface ThreadFactory {

    /**
     * 构造一个新的 Thread.实现还可以初始化 priority、name、daemon status ThreadGroup等。
     * 形参:r – 由新线程实例执行的 Runnable
     * 返回值:构造的线程，或者 null 创建线程的请求被拒绝
     */
    Thread newThread(Runnable r);
}

```



