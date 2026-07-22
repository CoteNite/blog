# Spring Reactor

[Reactor3参考指南](https://easywheelsoft.github.io/reactor-core-zh/index.html#intro-reactive)

Spring Reactor基于Reactive Stream规范，通过发布-订阅模式实现，本身是一种多线程编程的方式，但是解决了原本多线程编程的一些问题

在Java中，我们的多线程常使用回调的方式实现，但是回调又容易引发回调地狱的问题，为了解决这一问题，Java引入了Future，和JS的Promise一样，都试图在同步编程的范式中引入异步编程，但是Future又存在以下问题：

- 调用get()会让调用get的地方出现阻塞的情况
- 不支持惰性运算
- 无法像Kotlin Flow一样多次连续的发送值

因此我们需要一个新的编程范式来解决这些问题，这就是为什么要床罩Reactor

## 命令式到响应式

响应式编程具有可组合性和易读性的特点，易读性大家都懂，这里重点说一下可组合性

可组合性就是指能够编排多个异步任务，我们使用先前任务的结果将输入提供给后续任务，另外我们也可以是用fork-join的形式运行多个任务

我们可以将响应式的数据处理当作在组装流水线上流动，我们从生产者中获取到数据作为原料，然后处理后推送到消费者的手上

Reactor中用于处理数据的被称之为操作符，每个操作符都会添加行为到Publisher中，并将上一步的Publisher包装到新的实例中，因此整个链被连接在一起，数据会从第一个Publisher沿着链向下移动并进行转换

