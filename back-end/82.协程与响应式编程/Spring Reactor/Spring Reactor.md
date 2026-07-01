# Spring Reactor

[Reactor3参考指南](https://easywheelsoft.github.io/reactor-core-zh/index.html#intro-reactive)

Spring Reactor基于Reactive Stream规范，通过发布-订阅模式实现，本身是一种多线程编程的方式，但是解决了原本多线程编程的一些问题

在Java中，我们的多线程常使用回调的方式实现，但是回调又容易引发回调地狱的问题，为了解决这一问题，Java引入了Future，和JS的Promise一样，都试图在同步编程的范式中引入异步编程，但是Future又存在以下问题：

- 调用get()会让调用get的地方出现阻塞的情况
- 不支持惰性运算
- 无法多次连续的发送值（像Kotlin Flow一样）

