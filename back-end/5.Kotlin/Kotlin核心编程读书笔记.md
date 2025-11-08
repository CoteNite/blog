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






