# Java多线程3

## Future类

### 介绍

当一个异步线程（任务）在执行时，我们可能想要中止这个任务，或者当任务结束时，我们希望线程能向外传递一个参数。这时就需要使用Future类。

```java
public interface Future<V> {

    boolean cancel(boolean mayInterruptIfRunning);  //取消任务，返回值为是否成功取消
    boolean isCancelled(); //判断任务是否被取消
    boolean isDone();  //判断任务是否执行完成
    V get() throws InterruptedException, ExecutionException;  // 获取任务执行结果
    V get(long timeout, TimeUnit unit) throws InterruptedException, ExecutionException, TimeoutException;  // 指定时间内没有返回获取到任务执行结果就抛出 TimeOutException 异常
}

```

### CompletableFuture类——更强更好的Future

Future类中存在很多的问题，比如get方法是同步的，异常和结构都能通过同样的方法get来处理等

为了解决这些问题，JDK8引入CompletableFuture类，该类继承自Runnable类与Future类，并提供了一系列开发人员可能会用到的方法。

绝大多数的方法返回值均为CompletableFuture，因此可以实现多个任务的先后组合

* runAsync：提交一个没有返回值的任务
* supplyAsync：提交一个有返回值的任务
* handle：实现BiFunction接口，接口仅一个方法（lambda），传入两个参数，第一个为任务完成return的值，第二个为报错信息，进而完成分别处理
* allOf：传入多个CompletableFuture，进而对他们进行统一管理
* exceptionally:实现Function接口，仅接受一个Expection作为报错信息，自定义实现方式

### 自定义线程池使用CompletableFuture

CompletableFuture全局共享 ForkJoinPool.commonPool()作为执行器，若不自定义线程池全局所有CompletableFuture均使用同一个线程池

自定义线程池的方式也很简单，我们只需要在提交任务的时候传入一个线程池作为入参即可

```java
    ThreadPoolExecutor pool=new ThreadPoolExecutor(
                3,3, 100,TimeUnit.MILLISECONDS,
                new LinkedBlockingQueue<>(),
                new ThreadPoolExecutor.CallerRunsPolicy()
        );


        CompletableFuture<Object> completableFuture= CompletableFuture.supplyAsync(() -> {
            System.out.println(1 + 1);
            return 2;
        },pool);

```



## AQS

### 多线程同步与同步器

在了解AQS之前我们需要先了解多线程同步和同步器是什么。

[美团技术团队——一文讲清多线程和多线程同步](https://tech.meituan.com/2024/07/19/multi-threading-and-multi-thread-synchronization.html)

**多线程同步**

同一个进程的多个线程会共享部分数据，共享的数据可能存在Race Condition（竞争条件），美团大佬将这个词翻译为竞争状态

**为什么要同步多线程**

多线程中由于要操作同一个变量，常常会存在一个变量取到的结果并非我们想要的结构的情况。

比如那个经典的问题，两个线程对一个初始值为0的公共变量同时运行自增，很有可能出现该变量结果不为2的情况。

这个时候为了保证我们结果的正确，我们就需要多线程同步

**保护什么？**

通过上面的例子不难发现，在根本上我们要保护的其实是那个共有的数据

**同步器是什么？**

同步器本身就是要完成将多线程同步的装置

### AQS

AQS 即AbstractQueuedSynchronizer类，是Java用来构建锁和同步器的框架，通过AQS我们可以高效的构造出同步器。

ReentrantLock，ReentrantReadWriteLock（读写锁），FutureTask 等都是基于 AQS 的

**核心思想**

AQS的核心思想将状态区分为锁定。和非锁定状态，当线程请求资源时，若资源未被锁定则锁定资源表示该资源被该线程占用。若再有线程请求锁定资源，那么就需要一套线程阻塞等待以及被唤醒时锁分配的机制，AQS是通过CLH队列实现这一需求，即将等待线程加入一个队列中。

**CLH队列**

CLH为一个虚拟双向队列，不存在实例，仅存在该关系，每一个节点均存在线程的引用，前驱，后驱，状态这些信息。

AQS中会持有一个int类型的变量state，用其来表示资源是否持有，tryAcquire()方法会通过state来判断当前资源的状态，并选择等待还是运行，然后更新state的状态

## JMM——Java内存模型

### CPU缓存模型

前文我们说过，对于一个变量，线程会先将他复制到自己的高速缓存区（CPU高速缓存区，解决CPU读写速度大于内存速度的问题）

主要操作就是先将内存数据读到CPU Cache，然后CPU使用Cache中数据处理完后将数据反馈给内存的过程，但是这样也就导致了缓存不一致的问题。

而为了解决这个问题，CPU定制了一系列协议或采取使用了一定的手段。

由于操作系统将各种硬件虚拟化，因此操作系统也要解决这些问题，而这个解决方式就是内存模型。

### 指令重排序

为了实现代码的优化，编译器和处理器会对指令进行一个重排序，重排序的过程保证了单线程语义的一致，但是无法保证多线程语义的一致性。

我们可以主动禁止编译器的部分重排序以及通过内存屏障的方式主动禁止处理器重排序

### JMM

为了实现Java的**“一套代码哪都能用”**的思想，Java引入了自己的内存模型，你可以粗略的将其理解为Java针对于并发情景定义的一系列规范，早期Java的内存模型存在一系列问题，Java5开始，Java引入全新的内存模型（JMM）。

JMM内部通过指定一系列的规范与操作进而为开发者提供了一系列解决并发问题的方案（volatile，synchronized，锁，原子类等）

### happens-before原则

happens-before即发生在xx之间。

Leslie Lamport 于 1978 年发表的论文中提出了**逻辑时钟**这个概念，希望通过这个概念来解决分布式系统中由于NTP协议的误差导致的物理时钟~~（钟表上的时间）~~不可信导致的代码先后顺序出错的问题。这就是happens-before原则出现的背景。

* 如果一个操作a`happens-before`另一个操作b,那么我们认为a的结果对于b可见，且a应该执行在b之前。
* 即使a`happens-before`b，为了效率的优化，我们不强制a和b的关系必须严格遵守happens-before的关系，只要最后结果于happens-before的结果一致即可

happens-before重点强调的是两个代码间的可见性关系，即a的结果必须对于b操作可见，我们才可以认为a`happens-before`b

happens-before 的常见的5条规则

* 单线程原则：书写在前面的代码一定happens-before后面的代码
* 锁原则：解锁一定happens-before于加锁
* volatile原则：volatile变量的写一定happens-before于其他操作
* 传递性原则：a`happens-before`b，b`happens-before`c,则a`happens-before`c
* 线程启动原则：线程的start方法happens-before线程中的任意方法

### happens-before 和 JMM的关系

happens-before像是JMM为我们提供的可视化于编程的多线程解决方案，程序员可以依靠happens-before原则去实现无多线程问题的代码，而编译/硬件层面的具体解决过程由JMM为我们实现。