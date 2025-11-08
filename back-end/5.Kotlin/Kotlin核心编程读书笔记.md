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

为了解决这个问题 Haskell Currying