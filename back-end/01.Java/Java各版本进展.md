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

为了更好的实现重新绑定的功能，ScopedValue放弃了使用set方法，而是使用了更加复杂的where+run的方法，上面的内容可能看不出什么，但下面的例子可以很好的表明这个特性

```java
void main() throws InterruptedException {  
  
    ScopedValue<String> CONTEXT = ScopedValue.newInstance();  
  
    ScopedValue.where(CONTEXT,"father").run(()->{  
        System.out.println("this is "+CONTEXT.get());  
        ScopedValue.where(CONTEXT,"son").run(()->{  
            System.out.println("this is "+CONTEXT.get());  
        });  
        System.out.println("this is "+CONTEXT.get());  
    });  
  
}
```

最后代码打印出来的结果是

```text
this is father
this is son
this is father
```

我们可以发现，新的作用域中，同一个实例有了新的赋值，ScopedValue 通过 where+run 语义替代了 set，保证了作用域边界，避免了 ThreadLocal 的滥用，当你设定了新值后，你就属于在了一个新的作用域，新的作用域属于新的代码单元，其被包含在上一个作用域中，被上一个作用域所管理

当然，全新的理念也代表了ScopedValue 不支持随意重置值，它强制开发者在新的作用域中重新绑定，因此正如JEP 506中说的那样，如果你的代码中的数据不是单项绑定（即A设置，B使用，不存在B重新设置再被A使用的情况），那么ThreadLocal才是更加适合你的选择。

### Project Leyden 相关

长期以来，Java受利JVM技术，使得“一次编译，到处运行”成为了一个时代的标志，除此之外基于JVM预编译技术也成为了JVM生态中不可或缺的一部分。

然而随着硬件水平的提升和时代的发展，JVM预编译的问题逐渐显露，尤其是在云原生时代，我们渴望Java能够减少其对于内存的高需求和较慢的编译时间，而Project Leyden就是为了解决这个问题而诞生的，Project Leyden 的目标是优化Java程序的启动时间，达到峰值的性能以及其占用的空间

在JDK 25中，JEP 515和JEP 514正式上线， 他们都理智与提供更好的编译过程与编译方式

在了解`JEP 515`和`JEP 514`之前，我们有必要提前了解以下他们基于的li

#### [JEP 515 提前编译方法分析](https://openjdk.org/jeps/515)

JEP 515 指出，HotSpot