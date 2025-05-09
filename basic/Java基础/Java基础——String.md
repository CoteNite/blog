# Java基础——String

String是Java基础类型中较为特殊的一个类，我们这里着重探讨一下这个类。

## String

String底层使用一个char类型的数组来存储字符串，且该数组使用了private和final修饰

### 为什么说String是不可变的

1. final与private修饰该字符数组且未暴露修改方法，杜绝了从外部修改该对象的可能性
2. 由于final的使用导致子类无法继承该对象，进而导致子类不可能修改该数组

因而String是不可变的

### 线程安全性

由于不可变，进而可以理解为常量，因此所以线程安全

## StringBuffer与StringBuilder

StringBuffer与StringBuilder均继承自AbstractStringBuilder（构造器模式），因此我们先来介绍一下AbstractStringBuilder类。

AbstractStringBuilder类中使用一个char类型的数组来存储字符串，同时为我们提供了大量字符串修改操作（insert，append....）

### 线程安全性

* StringBuffer使用了锁机制，因此线程安全。
* StringBuilder由于未使用锁机制导致线程不安全。

### 性能

StringBuilder的效率高于StringBuffer。

## 比较String，StringBuilder，StringBuffer

* 常量使用String
* 修改+多线程使用StringBuffer
* 修改+单线程使用StringBuilder

## Java9的改动

Java9将上面三个类的底层char数组改成了byte数组

## 修改的底层

String的+与+=是Java唯二两个重载的运算符，我们通过观察字节码可以发现String的+和+=是创建了一个StringBuilder类来完成这一操作。

但是在for循环中，字节码无法优化成自创建一个StringBuilder类（即for每进行一次循环就要新创建一个StringBuilder），因此我们仍然建议存在大量修改的情况下使用StringBuilder或StringBuffer

## 字符串常量池

JVM为了提升性能减少内存消耗而专门为字符串开辟了一块区域，我们称呼为字符串常量池。

```java
String s1 = "Java";
String s2 = "Java";
```

s1赋值时，JVM会先看常量池中是否有这个对象，如果没有则创建该对象在常量池中，并返回常量池中的这个对象。

s2赋值时，JVM发现常量池中已经有这个对象，因此直接常量池中这个对象的引用赋值给s2。

因此s1==s2

## new String（）和等于的区别

使用构造方法创建字符串变量时，JVM仍然会去常量池中寻找是否存在该对象，但与＝的不同点在于。

* 若不存在，则会创建两个对象，一个给常量池（用于以后的等于赋值），一个给到变量作为变量的值
* 若存在，则直接给到变量

简单地说，构造方法一定会返回一个新的对象给到变量，同时若常量池子中没有该对象，还会在常量池中创建一个与该对象值一样的对象。

## intern方法

intern方法的意义是通过调用该方法的String变量的值去获取常量池中该与该变量值相同的对象并将其引用返回。

这又分为以下两种情况

* 若常量池中没有该与该变量值相同的对象，则将该变量丢入常量池中，并返回该变量的引用（与直接使用等于逻辑一致）
* 若常量池中存在与该变量值相同的对象，则直接返回常量池中对象的引用

