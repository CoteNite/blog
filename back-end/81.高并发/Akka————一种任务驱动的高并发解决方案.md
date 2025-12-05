# Akka————一种任务驱动的高并发解决方案

Akka是一门使用Scala语言编写的基于Actor模型解决高并发问题的框架，因此我们先来了解一下Actor的具体含义

首先是传统的OOP无并发的情景，我们可以看一下情景

![image.png](https://raw.githubusercontent.com/CoteNite/Blog_img/master/blogImg/20251205203225.png)

我们会发现，在单线程OOP的情境下，我们的方法调用是一种栈的感觉，且操作是时序的

但是回到多线程的情景，我们发现一切都乱起来了

![image.png](https://raw.githubusercontent.com/CoteNite/Blog_img/master/blogImg/20251205204002.png)


