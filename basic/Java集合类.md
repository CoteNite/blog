# Java集合类

Java集合类是Java为我们提供的一系列数据结构的实现。

## List

对于List，我们绝大多数场景使用的都是**ArrayList**。

ArrayList底层通过Object类型的数组实现，在无参构造时数组大小为0，只有在对数组进行添加操作时才会为其分配容量。

### 说一下ArrayList的扩容机制

**创建**

```java
    /**
     * 用于第一次初始化数组
     */
    private static final int DEFAULT_CAPACITY = 10;

    /**
     * 用于无参创建数组
     */
    private static final Object[] EMPTY_ELEMENTDATA = {};

    /**
     * 用于有参数，但参数是0的时候创建数组
     */
    private static final Object[] DEFAULTCAPACITY_EMPTY_ELEMENTDATA = {};

    /**
     * 数组
     */
    transient Object[] elementData;

    /**
     * 有参构造
     */
    public ArrayList(int initialCapacity) {
        if (initialCapacity > 0) {
            this.elementData = new Object[initialCapacity];  //通过创建新数组再赋值的形式来完成初始化
        } else if (initialCapacity == 0) {
            this.elementData = EMPTY_ELEMENTDATA;  //或者直接赋值
        } else {
            throw new IllegalArgumentException("Illegal Capacity: "+
                                               initialCapacity);
        }
    }

    /**
     * 无参构造
     */
    public ArrayList() {
        this.elementData = DEFAULTCAPACITY_EMPTY_ELEMENTDATA;
    }
```

**扩容**

在第一次添加add时，会先检查是否需要完成扩容操作后才会进行赋值。

这时若发现当前为无参构造，则会创建一个大小为10的数组，

若发现为参数为0的构造，则会创建按一个大小为2的数组。

后续扩容每次均会检查是否需要扩容，若需要则扩大到原先的1.5倍。

若出现扩容后超出”int的最大值减8“，则需进一步判断

* 未超出则扩建到int的最大值减8。
* 超出则继续判断判断此处扩容应该扩建的最小值（即扩容到”原容量+本次扩容的数量“）是否比int的最大值大，
  * 若大，则为int最大值
  * 若不大，则为最小值

## 线程安全性

我们在开发应用时经常要考虑到多线程的情况，当一个集合最为一个公用的变量（常会被当做缓存）时，我们应当确保多个线程对着一个集合操作不会出现我们意料之外的运行结果。

Java中很多集合都是线程不安全的，比如ArrayList，HashMap等，当多个线程对其进行操作时会出现问题甚至会抛出异常。

为了解决这些问题，Java也为我们提供并发集合类，比如ConcurrentHashMap（HashMap），CopyOnWriteArrayList（ArrayList）等

由于考虑到了并发问题，所以这些类的性能会有所下降。

## 排序

使用sort方法对集合排序时，我们可以通过让类继承Comparable并重写compareTo方法来自定义规则，亦或是我们在使用sort时传入一个Comparator类型的参数，并通过匿名内部类的形式对其内部的compare进行实现来完成自定义排序

## Set

set是集合类，常用的有HashSet（一般集合，基于HashMap），LinkedHashSet（支持FIFO的集合，基于链表和哈希表），TreeSet（排序后的集合，基于红黑树）

## Queue

### Queue

单端队列，只能从一头出入，一般遵循 **先进先出（FIFO）** 规则。

### DeQueue

双端队列，在队列的两端均可以插入或删除元素。DeQueue还为我们提供了push与pop操作，可以充当栈来使用。

上述两种Queue均扩展了Collection接口，针对插入删除操作失败的情况进一步区分出报错和返回特殊值两种情况。

### PriorityQueue

优先队列，会对队列中的元素进行排序，默认为小顶堆的形式。

### BlockingQueue

阻塞队列，其支持当队列没有元素时一直阻塞，直到有元素；还支持如果队列已满，一直等到队列可以放入新元素时再放入。我们常常会在使用线程的时候见到这东西。

## Map

map本身指的是映射y=f(x)，只不过我们常常用HashMap来实现。

### 扩容机制

HashMap初始值为16，且每次扩容会将其扩充为2的n次方。

这一操作是为了保证Hash映射的均匀，但由于Hash值的计算结果高达40亿，因此我们还要在映射时进行取模运算，取模的过程为了提高性能，源码希望能够使用位运算，但hash%length==hash&(length-1)的前提是 length 是 2 的 n 次方，因此选择了2的n次方

### 1.7与1.8上HashMap的区别/HashMap的底层结构

1.7及以前HashMap使用原始的拉链法来解决hash冲突问题，但原始的拉链法使用的过程中存在一个问题，即在发生冲突的元素过多时查找速度会降低，为了解决这个问题，1.8即以后的版本引入红黑树来作为HashMap的底层结构组成部分。

当链表大于默认阈值8时，将链表转化为红黑树，进而进一步解决查询降速的问题。

### ConcurrentHashMap

ConcurrentHashMap为并发集合，采用数组+链表/红黑二叉树，通过锁机制实现线程稳定

需要特别注意的是，线程安全无法保证复合操作（多个基本操作）具有原子性，不过ConcurrentHashMap为我们提供了一些原子性复合操作，比如putIfAbsent，compute等。

