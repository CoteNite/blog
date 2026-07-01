# Spring Reactor

Spring Reactor基于Reactive Stream规范，通过发布-订阅模式实现，本身是一种多线程编程的方式，但是解决了原本多线程编程的一些问题

在Java中，我们的多线程常使用回调的方式实现，但是回调又容易引发回调地狱的问题，为了解决这一问题，Java引入了Future，和JS的P'r'm