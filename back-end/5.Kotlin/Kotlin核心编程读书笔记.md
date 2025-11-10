## Kotlin核心编程读书笔记

:::tip
本文为Kotlin核心编程一书的读书笔记，推荐大家购买本书进行阅读学习
:::

## 基础语法

## 变量的声明

```java
String a="Hello Java"
```

```Kotlin
val a:String="Hello Kotlin"
val b=a//自动推断
```

Kotlin中引入了val关键字用于声明变量，同时将变量的类型后置，这和很多的现代语言都一样。同时Kotlin默认使用val作为变量创建出的类型，一方面这是因为不变类具有更好的稳定性和易读性，另一方面，不可变类更加符合函数式编程的思想

同样的，Kotlin还支持创建可变变量，可变变量使用关键字var来进行创建

```kotlin
var a="12"
a="1"
```

## 一等公民————函数

在Kotlin中，函数作为一等公民，这意味着你可以将函数放在任何地方，甚至可以在函数中定义函数

```Kotlin
fun f(){
	fun a(){
	}
	a()
}
```

同样的，函数也可以作为变量

```kotlin
val f:(Int)->Unit={a->
	a+1
}
```

关键点在于：

- 变量类型必须要用小括号包裹
- 如果没有返回值必须要用Unit显式声明

除此之外我们还可以给变量定义名字

```Kotlin
(a:Int)->Unit
```

当然也可以函数返回函数

```kotlin
(a:Int)->((A:Int)->Unit)
```

举个例子

```kotlin
   val f:(a:Int)->((A:Int)->Unit)={
        it+1
        {
            it-1
        }
    }
```

## 方法引用

Kotlin可以使用双引号语法获取一个类的一个方法中的引用

```Kotlin
User::copy
::User  //这种特殊的写法是获取类的构造方法
```

获得的引用可以直接赋值给变量

```kotlin
data class GitUser(  
    val name: String,  
    val email: String  
){  
    fun test(): String{  
        return this.name  
    }  
  
    fun sum(): Int{  
        return 1  
    }  
  
}
val function = GitUser::test  
val function1 = GitUser::sum//这些方法除了自己的参数外还需要传入一个GitUser类，这里可以认为是调用这个方法的类的实例
```

## 缺省函数/匿名函数

Kotlin还支持没有函数名的函数，这些函数大多用于只使用一次的场合

```kotlin
fun main() {  
    test(fun(){  
        println("hello")  
    })  
}  
  
fun test(a:()-> Unit){  
    a()  
}
```


## Lambda表达式与后缀函数

Lambda表达式起源于Lambda演算，是构建函数式编程最为底层的基石，著名的函数式语言Lisp就是基于Lambda演算而来的，Lisp中匿名函数的部分就被称之为Lambda表达式，可以将其认为是一种匿名函数的语法糖

```kotlin
{a:Int,b:Int->
	a
}
```

上面就是一个Lambda表达式的例子，其中第一行用于表示当前lambda表达式的参数,箭头函数后的内容用于表示函数体，当未显示声明Lambda表达式的返回值为Unit时，则认为最后一行的量就是返回值

在Kotlin类型推导的帮助下，我们可以省略声明Lambda表达式入参的类型

```kotlin
fun a(c:(Int)->Unit){

}

a{b->
	b+1
}
```

特别的，如果lambda表达式中只有一个参数，那么可以省略参数的命名，直接使用it来代替

```kotlin
fun a(c:(Int)->Unit){

}

a{
	it+1
}
```

## 闭包

闭包就是一块能够访问外界环境的代码块，在Kotlin中常常用花括号来框住。

一个简单的例子

```kotlin
var sum=0
fun a(b:Int):Int{
	sum+=b
	sum
}
a(1)
```

除此之外Kotlin还支持Lambda的直接运行

```kotlin
{x:Int->println(x)}(1)   //直接运行了
```

## 柯里化

我们曾经提到过，Lambda演算是函数式编程的基石，如果要严格准寻函数式编程的话，那么一个函数应该至多只能有一个参数，但根据长期的编程实践来看，一个函数只有一个参数会对业务的实现造成很大的困扰

为了解决这个问题 Haskell Curry提出了一种方式，也就是让函数仅接受一个参数，并对这个参数进行可以执行的一切必要的处理，然后再返回一个函数，在返回的函数中同样也是只接受一个函数，但这个函数要包含本函数接受的参数以及返回这个函数的函数接受的参数这两个参数之间的处理

这样一只套娃下去，直到接受了所有的参数，完成了所有必要的处理，再最后一个函数中直接返回结果

上述操作最大的意义就是通过函数返回函数的方式，成功的实现了多元函数到一元函数的降元，解决了实际应用于Lambda演算之间的矛盾

为了纪念提出这个理论的科学家Haskell Curry，这个操作又被命名为Currying——柯里化

上面的内容可能听起来有些绕，不过没有关系，Kotlin本身也支持柯里化，这里我们就来写一个柯里化函数

```kotlin
fun main() {
    println(add(1)(2)(3))
    println(add(1,2,3))
}

fun add(x: Int)={y: Int-> {z: Int-> x+y+z } }
fun add(x:Int,y:Int,z:Int)=x+y+z
```

上面就是柯里化函数和非柯里化函数之间的区别，两者的输出结果与实现的功能完全等价，但是写出来的样式却天差地别

## 面向表达式编程

表达式这个名词经常被提到，但是很多小伙伴并不熟悉究竟是什么含义，这里可以回顾一下之前提到的几种表达式

- if表达式
- 函数体表达式
- Lambda表达式
- 函数引用表达式

表达式和语句是极度相似的两个概念，语句我们并不陌生，在代码中我们写的任何一个有独立含义（在Java中往往用分号断开）的代码就被称为语句，至于表达式，我们可以通俗的理解为“一个返回值的语句就是表达式”

这里我们来看一下上面的表达式

```kotlin
if (a>1) a else 1 //if表达式，值是a或1
{x:Int-> x+1} //Lambda表达式，返回值是一个函数
```

这样的设计在Scala中也很常见，那么Kotlin为什么大量推荐我们使用表达式呢

**让程序更加安全的表达式**

这里我们可以看一下一个Java代码

```java
String str;
if(a==1){
	str="true"
}
System.out.println(str.length())
```

这个代码纯在两个问题，一是空安全问题，即当a!=1时，后面的sout部分会出现空指针异常，IDEA也会在这里爆黄标

其次就是副作用问题，对于if语句的整个部分，str属于整个if语句的外部，这一操作直接影响了外部的环境，不论是在易读性还是安全性上都不佳

```kotlin
val str = if (a==1) "true" else ""
println(str.length)
```

换成Kotlin的写法，我们会发现副作用消失了，因为表达式起到了类似函数中返回值的效果，返回的值直接被str接受

但是Kotlin无法做到一切皆为表达式，这要由Java的设计说起

在Java中，函数可以没有返回值，这时函数的返回值为void，但是Kotlin和Scala为了尽可能兼容表达式，因此引入了Unit类

我们可以通俗的将Unit理解为和Java中Void类似的类，它不代表任何信息，仅表示函数没有返回值，最大的意义是来在代码底层为高阶函数兼容泛型来铺垫

这里看一个例子

```kotlin
inteface Function<Arg,Return>{
	Return apply(Arg arg)
}
Function<String,Integer> stringLength=new Function<String,Integer>(){
	public Integer apply(String arg){
		return arg.length();
	}
}
```

这里是一个类函数式的接口，用于模拟函数式编程，接口中有两个泛型，一个是入参类型，一个是出参类型

但是如果我希望引入一个没有出参的函数呢？

这里就需要把出参的泛型变化为Void类，但Void没有实例，因此只能返回null，但是返回null又相当丑陋

因此Java引入了大量函数式接口，用来对应各种情况（n个入参，n个出参排列组合）

而Kotlin则是选择引入Unit类，这个类本身是个单例，只要返回其单例的值即可

