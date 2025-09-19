# Java各版本进展

::: tip 注意
本页面内容会长期随着JDK版本的更新而更新

关注语言的走向对程序员了解未来趋势有着一定的帮助
:::

## JDK25

写这篇文章的时候是九月十七号，刚刚发布了JDK25，这是继JDK21之后又一个长期维护的版本，本次更新了18给特性，让我们来一起了解一下他们都是什么吧

ps：记得将你的IDEA更新到`2025.2`版本

### Project Amber 相关

Project Amber主要涉及的是一些“小而美”的特性，他们以生产力为导向，旨在让程序员更加舒适的写出更加优质的代码

本次更新中[JEP 512 紧凑源文件和实例主方法](https://openjdk.org/jeps/512)被确定了下来，这个JEP希望能够提供给Java初学者亦或是非Java开发者一个更加便捷的学习方式，同时这项JEP也**希望可以通过这次提案来简化Java开发小型程序的难度**（我认为这或许更有价值的一点）

### Project Loom 相关

Project Loom是Java针对新时代对协程的需求（或者说是开发者迫切的需要一种更加简单便捷的并发开发模型的需求）而创建的项目，旨在利用Java语言实现基于JVM的协程包（也就是围绕虚拟线程进行的包），同时可以完美兼容老的线程模型

Project Loom在JDK21中就已经登场，但由于其初次登场的原因，仍然存在一些bug/不好用的地方，其中最受大家关注的就是ThreadLocal在虚拟线程中的问题，而为了解决这些问题，[JEP 506，作用域值（Scoped Values）](https://openjdk.org/jeps/506)被提出，并于JDK25中正式引入到LTS版本中

在JEP 506 中明确指出，现在的线程局部变量模型（ThreadLocal及其子类）存在三个问题——昂贵的开销（指InheritableThreadLocal可以被子线程获取，该类会导致子线程在创建前提前开辟出父线程所有的指InheritableThreadLocal实例的空间），不可控的生命周期（指必须开发人员手动remove，不然就会在线程中一直存在）以及不受约束的可变性（指可以随意的get和set）

这些问题在过去使用线程实现并发模型的时代是可以接受的，因为线程的开辟本身就是一个相对困难/重量级的事情，这也就要求了开发者在使用多线程时已经有了足够的经验和开发水平

但虚拟线程旨在为开发者提供一种更加轻量级，便捷的并发模型，这极大程度的降低了并发开发的难度，也就使得我们迫切的需要一个更加轻量级的并发局部变量模型，这也就是JEP 506中要实现的`ScopedValue`类

我们先来看一段代码

```java
public class ScopedValueService {

    private static final ScopedValue<String> CONTEXT = ScopedValue.newInstance();

    public void run(String str, Runnable runnable) {
        ScopedValue.where(CONTEXT, str).run(runnable);
    }

    public void printContext() {
        System.out.println(CONTEXT.get());
    }
}
```

```java
//这里用到的是上面提到的简化main
void main() throws InterruptedException {  
    ScopedValueService scopedValueService=new ScopedValueService();  
    scopedValueService.run("this is now Value", scopedValueService::printContext); 
}
```

ScopedValue通过newInstance方法创建其实例，在获得其实例后，我们需要在其静态方法`where`中对其进行赋值

Scoped的含义是作用域，而这里的作用域指的则是实例的run方法，在run方法中接受的Runable代码中，ScopedValue实例的值将能够直接的被其get方法获取，同样的，出了run方法后，则无法使用设定的ScopedValue实例的值

通过这种方法，ScopedValue强迫开发者在使用其时明确其有效的位置，进而完成了对ScopedValue的自动回收
