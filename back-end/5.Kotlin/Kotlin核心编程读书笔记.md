# Kotlin核心编程读书笔记

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

## when表达式

switch一直被很多Java程序员诟病，其语法方面由于一些历史原因导致显得过于落后，很多程序员喜欢使用if来代替switch能实现的逻辑

为了优化switch语句，Kotlin采用了更好的when表达式

```kotlin
val a:Int=1
val c=when(a){
	1->{
		a+1
	}
	2->{
		a+2
		a/2
	}
	else ->0
}
```

when使用了更像函数的写法，在小括号中传入要匹配的变量，后面紧跟的花括号为匹配的内容，使用箭头语法来指明具体要进入的部分，else则实现了default的功能，同时还具备表达式的能力，返回公共的父类

除此之外，when还可以省略小括号，用来实现多组判断的if-else效果

```kotlin
val a=true  
val b=true  
val c=true  
when{  
    a->println("hello")  
    (b&&c)->println("world")  
}
```

上面的代码，由于a先执行到并满足结果，于是打印hello，结束when（特别注意的是，如果when没有小括号，则强制花括号中的箭头表达式的左边是一个布尔表达式）

由此我们可以实现更加好的if-else的写法

## for循环

while由于和Java区别不大，这里就不提了

在Kotlin中我们可以简洁的去写for循环

```kotlin
for(i in 1..10){
	println(i)
}
```

这里的..叫做范围表达式（range表达式），表示一个范围，只有实现了Comparable接口的类才可以使用(比如String)

这里需要注意的是，虽然实现了Comparable接口的函数可以使用范围表达式，但是只有存在迭代器的类才可以使用i in range这种写法写在for循环中

当然，我们也可以自定义跳过的步数，或者是到过来排序等方法

```kotlin
for(i in 1..10 step 2){
	println(i)
}
for(i in 10 downTo 1){

}
for(i in 1 until 10){
	//左开右闭（正常是双开）
}
```

除此之外Kotlin还支持了in来检查一个元素是否在列表中

```kotlin
val a=1
val b=2
val list=listOf(1,2,3,4)
a in list
b !in list
```

甚至可以这样

```kotlin
"kot" in "abc".."xyz"   //等价于“kot”>=“abc”&&“kot”<=“xyz”
```

那么我们想要带有下标的循环呢

可以这样

```kotlin
for((index,value)in array.withIndex()){
	
}
```

## 中缀方法

我们之前看的in downTo until这种像是关键字一样的单词其实也是一种方法，这种方法被称作中缀方法，其固定写法就为

```text
A 中缀 B
```

定义的形式为

```kotlin
infix fun <A,B> A.to(that:B):Pair<A,B>
```

其中infix就是中缀方法声明的关键字，我们定义中缀方法强制要求：

- 中缀方法必须是一个类的成员方法或是拓展方法（上面就是拓展方法的写法）
- 中缀方法只能有一个入参
- 中缀方法的入参不允许有默认值，也不允许是可变参数

```kotlin
fun main() {
    val user = User("张三")
    println(user all "B23")
}

data class User(
    val name: String,
){
    infix fun all(className: String)="$className:$name"
}
```

## 可变参数

所谓可变参数就是变量长度不固定的参数，在Java中使用..表示，但在Kotlin中使用单独的关键字varargs（var args：许多变量）

相对Java，Kotlin不强制可变参数必须作为函数的最后一个变量，取而代之的是使用调用函数时的显式传参

在方法中，可变函数会作为一种列表的形式使用（xxArray），我们也可以使用解构语法对可变参数的函数进行传参

```kotlin
fun sum(vararg a: Int) {  
    var sum = 0  
    for (i in a) {  
        sum += i  
    }  
    println(sum)  
}  
  
val listOf = arrayOf(1, 2, 3, 4, 5)  
sum(1, 2, 3, 4, 5)  
sum(*listOf.toIntArray())
```

## === 与 ==

Kotlin也存在三等号语法，用于表示的是引用是否相同同样的!== 就是判断引用是否不相同，至于== 就和原本Java中的含义一样了（调用.equals方法）


## 面向对象

Java是一门强面向对象的语言，这在早年间的软件开发很有帮助，直接让软件开发的流程结构化，但是随着越来越多的实践诞生，软件的规模不断变大，开发者们逐渐发现强面向对象的语言有些太”死板“了，这也是Scala，C#乃则我们现在的Kotlin都想解决的问题

我们先来定义一个基本的类

```kotlin
class User(
	val name:String="user",
	val age:Int
){
	fun printAll(){
		print("$name+$age")
	}
}
```

这里有几个注意点：

- val变量：这里其实等价于Java中被final修饰的变量，至于final类型的好处我们就不多说了
- 属性默认值：我们可以显式的声明一个属性的默认值，这样可以减少我们在使用构造函数时的出参
- 默认开放：对于Kotlin，一个类如果不声明则默认是可以被外界访问的，一个.kt文件中可以有多个能够被外界访问的类
- 自带的get/set：在kotlin中，使用实例.字段实际上是调用字段的.get方法，这一点和js类似，同样的，赋值就是使用了set方法

而接口相对Java来说则更加开放

```kotlin 
interface UserService{
    val user:User  
    fun printAll()  
    fun printName(){  
        print(user.name)  
    }       
}

class UserServiceImpl(  
    override val user:User  
):UserService{  
    override fun printAll() {  
        print("$user")  
    }  
}
```

我们的接口可以有自带实现的方法，可以有参数，也可以有未实现的方法，如果你熟悉Scala的话，你会发现Kotlin的接口其实更像Scala中的trait（模板），他的主要作用的是定义出一个类的大概样子（里面有哪些内容），以及写一些这个类中的共有部分

## 更好的构造方法

Kotlin的构造方法在方法名的后面,构造方法中直接定义了构建类必要的所有的字段（这一点和JS的基于构造方法的对象有些类似）

我们可以给构造函数中的字段设置默认值，这也就等价于给字段设置默认值，同时得益于方法的显式传参，我们还可以在构造方法中直接写出类似构造器的形式

## init块

我们可以在函数中定义一个init代码块，这个代码块理论上属于是构造函数的一部分，但是在Kotlin中独立了出来成为了类中的一个代码块

```kotlin
class User(  
    val name:String,  
    val age:Int  
){  
  
    init {  
        println("初始化")  
    }  
  
    fun printAll(){  
        print("$name+$age")  
    }  
}
```

init代码块中的部分会在类初始化的时候执行，我们的一个类中也可以有多个init代码块，这写init代码块会按照从上到下的顺序执行

那如果我们在类的内部定义一个字段呢？

```kotlin
class User(  
    val name:String,  
    val age:Int  
){  
  
    val sex: String
  
    fun printAll(){  
        print("$name+$age")  
    }  
}
```

这里IDEA会直接爆红，这是因为Kotlin不允许在非抽象类中只声明一个字段而不再构建的时候向他传值，所以就延伸出两种写法

```kotlin
class User(  
    val name:String,  
    val age:Int  
){  
  
    val sex: String = "s" //写默认值
  
    fun printAll(){  
        print("$name+$age")  
    }  
}

class User(  
    val name:String,  
    val age:Int  
){  

    val sex: String   

	init{
		sex="a" //init代码块中声明类型
	}
	
    fun printAll(){  
        print("$name+$age")  
    }  
}
```

但是如果我们不想在构建的时候就传入值呢？Kotlin也很贴心的为我们准备了两种方式

## by lazy 与 lateinit

对于val字段，Kotlin设计了by lazy方法（利用了Kotlin的委托语法），比较常见的场景是存在字段是动态的由构造函数中的字段来确定值

```Kotlin
class Bird(
){
	val sex:String by lazy{
		 
	}
}

```

lazy的本质上是一个函数，当你第一次访问该属性的时候会通过lazy接受的lambda表达式返回结果

lateinit关键字则比较简单，只要在var前面加上lateinit关键字就可以消除编译器的报错

```kotlin
class Bird(){
	lateinit sex:String
}
```

lateinit的本质也是通过委托方法进行的实现，但是lateinit有一个限制，就是不能给基本类型的包装类使用

## 主从构造方法

在Java中，多构造函数是通过重写实现的，但是在Kotlin中，多构造函数是通过委托机制实现的

首先，我们先看平常定义的Kotlin类

```kotlin
class User(  
    val name:String,  
    val age:Int  
){  
}
```

其中和类名在一起的小括号表示的就是主构造函数，你可以理解为创建这个类所必要的所有字段，有这些字段就一定可以创建出这个类

但是有时候我们可能想要使用别的方式创建这个类，比如User类中的年龄，我们可能希望通过输入出生日期然后减去当天的日期进行求值，根据设计模式，我们知道这种情况最好的实现方式是创建一个工厂类/工厂方法

```kotlin
object UserFactory{
    fun createUserByBirthday(name:String,birth: LocalDateTime): User {
        val age = birth.year - LocalDateTime.now().year
        return User(name,age)
    }
}
```

这样的缺点在于工厂类与被创建类的关系不够直观

因此Java中可以通过多创建一个构造方法来解决，而Kotlin则在此基础上进一步建立了一种主从的关系

```kotlin
class User(  
    val name:String,  
    val age:Int  
){   
    constructor(name:String,birth: LocalDateTime): this(name,birth.year - LocalDateTime.now().year) {  
        }  
 }
```

我们可以观察一下这个方法，首先是通过constructor方法创建了一个从构造函数，这个从构造函数将创建实例的任务委托给了主构造方法，从构造方法也可以有方法体，会先按主构造方法->从构造方法的顺序执行

## 访问控制原则

在Kotlin中，类默认是不可以被继承的，方法也是默认不可以被重写的，如果你希望其可以被重写，则可以使用open关键字将其开放

这样设计其实适合面向对象设计中大名顶顶的**迪米特法则**相对应：

- 子类可以实现父类的抽象方法，但不得覆盖父类的非抽象方法
- 子类可以有自己的方法
- 当子类的方法实现父类的方法时，方法的前置条件（即方法的入参）要比父类的方法的输入参数更宽松
- 当子类的方法实现父类的抽象方法时，方法的后置条件（即方法的出参）要比父类更加严格

这些规则想要全部遵守实际上有些困难的（当然如果你的继承只涉及字段之间的继承关系则另谈：D）

因此《Effective Java》中也提出了这样一个原则：“如果没有为继承做好设计并提供文档，那么就不要使用继承”

因此Kotlin直接选择默认关闭继承，也就是逼迫开发者在使用继承和重写时提前想好自己是否真的有必要要这么做，其对应的Java代码其实就是在方法和类的前面使用的了final进行修饰

当然，默认final的做法也引起了社区的广泛讨论，不过对于Kotlin来说这样的做法或许是利大于弊，这是因为：

- 目前Kotlin的主要使用还是在Android开发上，而Android开发相对服务端开发（比如知名的服务端开发框架Spring）来说并不需要大量的继承，虽然开发者可能没有写过final，但由于不常使用继承，因此其实和声明final是类似的（或者说是大家都懒得写了：D）
- 继承的主要作用实际上是为原本的类进行拓展，但是Kotlin为我们提供了专门的拓展语法，Google著名的Android库android-ktx就是通过拓展语法实现的对于类的增强，这让我们进一步思考使用子类继承实现类增强是否真的是一种好的写法

## 密封类

Kotlin中还存在一种特殊的类——密封类，需要通过关键字sealed进行创建

```kotlin
sealed class Bird{

}
```

密封类的特点是其继承的类只可以在与他相同的文件中定义，你可以将其当作一种更加强大的枚举类，实际上在MVI设计中，他也常常被这样用来表示页面当前的状态或用户进行的某项操作

## 多继承与钻石问题

我们都知道Java中是没有多继承的，那么什么语言有多继承呢？那就是我们的C++，C++中的多继承就会引出一个经典的钻石问题

假设存在一个公共的抽象父类A，然后BC均是A的子类，实现了A的run方法，现在又存在一个D类，D类同时继承了B和C，那么我现在执行D类的run方法，究竟是执行的B的run还是C的run呢？

这就是经典的钻石问题，由于多继承造成的代码耦合，除此之外，根据面向对象的设计模式，如果存在一个类同时继承太多的类，会导致代码不符合**单一功能原则**

那么Kotlin中是如何实现多继承的呢？

首先我们知道，Kotlin中的接口是可以有默认方法的，那么一个接口同时存在两个同样的方法就会出现钻石问题

```kotlin
interface A{  
    fun print(){  
        println("A")  
    }  
}  
interface B{  
    fun print(){  
        println("B")  
    }  
}  
  
class C:A,B{  
  
}
```

这时IDEA中C类爆红，但是我们知道接口的默认方法不需要在实现类中实现啊，这就是Kotlin在编译器上做出的规定，**一旦遇上钻石问题，那么就必须重写方法**

```kotlin
class C:A,B{  
    override fun print() {  
        super<A>.print()  
    }  
}
```

这里是Kotlin解决钻石问题的方法，使用`super< 父类 >.方法`的形式来在类中指定使用哪个父类的方法，而造成钻石问题的方法必须被实现类重写

当然，除了同名方法，还会出现同名的字段，不过由于字段不会造成逻辑上的钻石问题，所以只需要我们在实现类中重写一下这个字段即可（也就是告诉编译器如果要使用这个字段，则使用实现类的）

## 使用内部类实现多继承

在Kotlin中内部类通过inner关键字实现，不使用inner关键字在类中定义出的类为嵌套类

嵌套类和内部类的区别在于，内部类可以使用外部类的字段和方法，但嵌套类不可以使用外部类的字段和方法

进而，我们可以在一个类的内部定义两个内部类，让这两个内部类分别继承不同的类，然后通过调用这两个类的实例的方法实现继承的效果

## 使用委托实现多继承

委托也是一种经典的设计模式，你调用A类的a方法实际上是在调用B类的a方法去执行，这种设计模式本身较难实现，不过Kotlin在语法层面实现了这一功能，只需要使用by关键字即可

```kotlin
interface Flyable {
    fun fly()
    fun takeOff() {
        println("准备起飞...")
    }
}

interface Swimmable {
    fun swim()
    fun dive() {
        println("潜入水中...")
    }
}

class Airplane : Flyable {
    override fun fly() {
        println("✈️ 飞机正在高空飞行。")
    }
}

class Submarine : Swimmable {
    override fun swim() {
        println("🚢 潜艇正在水下巡航。")
    }
}

class AmphibiousVehicle(
    private val flyer: Flyable = Airplane(),
    private val swimmer: Swimmable = Submarine() 
) : Flyable by flyer, Swimmable by swimmer {
    override fun takeOff() {
        println("🚦 两栖载具：检查系统，准备起飞/入水。")
        flyer.takeOff()
    }
    fun startEngine() {
        println("⚙️ 两栖载具引擎启动！")
    }
}
```

我们可以看出来和使用接口实现多继承的区别并不大，那么为什么还是建议使用委托实现多继承呢？

首先，接口是无状态的，这也就代表着接口实际上不能承载太多的信息，而如果我们真的需要一个类实现真正意义上的多继承，那么处了继承父类的方法，一定还要持有父类的信息，因此这里就要使用委托，将信息放在两个委托类中，进而实现多继承

## data class

在Java Bean中，如果我们的一个类要同时拥有一堆的getset方法，这样很不方便，于是Kotlin中就出现了data class

```kotlin
data class User(
	val name:String
)
```

一个data class类会自动的生成他的get set equls hashcode 构造函数等方法，就如同lombok一样

除此之外data class还会生成copy和componentN两个Java中一般不会设定的方法

其中copy方法就是复制一个相同的类实例出来，在复制的时候你可以传入不同字段的参数，进而实现修改的效果

这一点有点像是Spring中BeanUtil中的copyProperties方法，但是更加灵活（可以通过向方法传入参数的方式修改字段），至于这样设计的原因还是为了进一步让程序员去使用不变字段以及减少编码过程中的副作用

而componentN方法则是用来实现类似js中的解构语法

```kotlin
data class User(val id: Int, val name: String, val email: String)

fun main() {
    val user = User(101, "张三", "zhangsan@example.com")
    val (userId, userName, userEmail) = user
    val (_, nameOnly, _) = user // 忽略 id 和 email

    val map = mapOf(1 to "Apple", 2 to "Banana", 3 to "Cherry")
    for ((key, value) in map) {
        println("Key: $key, Value: $value")
    }
}
```

需要注意的是，和一般的类不同，数据类中的字段必须使用val或者var指明

## ADT/代数数据类型

Kotlin对于函数式编程的另一方面体现在于其对ADT（代数数据类型的支持）

我么可以将Kotlin中的代数数据类型认定为一个存在有限集的类型，并且可以进行一定的运算（这里可以认为是操作）再得到有限的类型

比如我们常见的Boolean就是一种ADT，他只有两个值，而且可以进行和运算或运算

Kotlin中常见的ADT有和类型和积类型

### 积类型

顾名思义，积类型模仿的就是数学运算中的积运算，其代表特点是有两个乘数的特点，在Kotlin中往往使用组合来实现，由于组合的类都是有限类，因此组合出的积类型也是有限的

### 和类型

顾名思义，积类型模仿的就是数学运算中的和运算，其代表特点是具有有限的实例数量，且各个实例之间是非此即彼的关系，在Kotlin中经常使用密封类实现

```kotlin
sealed class Shape{
	class Circle(val radius:Double):Shape()
	class Rectangle(val width:Double,val height:Double):Shape()
	class Triangle(val base:Double,val height:Double):Shape()
}
```

## 模式匹配

ADT在函数式编程中一个很大的意义就是可以实现模式匹配，这里我们先来解释一下模式是什么意思，模式匹配的英文是Pattern Match，熟悉Java的小伙伴肯定知道，Java中存在Pattern类和Matcher类，两者共同实现了Java中的正则表达式，正则表达式实际上就是检验一个字符串是不是**匹配**一个正则表达式，而模式表达式则可以理解为检验一个东西是不是匹配一个模式，而这里的模式你可以理解为一个任意的表达式

Kotlin中使用when语法实现模式匹配，但when语法实际上并非是真正完全的模式匹配，有一些模式匹配的功能他无法实现，如果你想要体验完整的模式匹配，或许可以去看一下[scala的文档](https://docs.scala-lang.org/zh-cn/tour/pattern-matching.html)，那么Kotlin的设计者是没有能力实现模式匹配吗？当然不是，如果你熟悉Scala的模式匹配，你就会知道，Scala的模式匹配对于大多数的业务开发实在是过于"强大"了，这和Scala学院派的出身与其对程序员的高度信任有关，但是Kotlin是一门实用主义至上的语言，因此只保留了模式匹配中较为实用的部分（当然，你也可以理解为是进行了一定的简化）

### 常量模式

最简单的常量模式实际上和直接使用if-else并无区别

```kotlin
val a=0
when(a){
	1-> 1
	2-> 2
	else ->a
}
```

### 类型匹配

用来和enum与密封类组合的类型匹配则更加常用

```kotlin
sealed class Shape{
	class Circle(val radius:Double):Shape()
	class Rectangle(val width:Double,val height:Double):Shape()
	class Triangle(val base:Double,val height:Double):Shape()
}
val shape=Shape.Circle(3.14)
when(shape){
	is Shape.Circle->Math.PI*shape.radius*shape.radius
	...
	//这里不用else，因为密封类的情况是有限的
}
```

### 逻辑匹配

其实就是之前提到过的没有小括号的情况

```kotlin
when{
	true->true
	false->false
}
```

## 空安全

Tony Hoare是第一个使用null引用的学者，他在ALGOL W中引入了null引用，在此之后这一操作被众多语言效仿

我们不得不承认null应用在很大程度上为我们的代码编写提供了自由，如果想要表示一个实例当前不存在，只需要将他的值设置为null即可，但是我们必须知道，null在业务上实际是没有真正的对应情况存在（除非开发者故意为null赋予一个意义），同时null的出现也带来了程序员们最”喜闻乐见“的NullPointerException

正如Tony Hoare在2009年的Qcon技术会议上的演讲中说的一样，他发明了一个价值十亿美元的错误

我们先来看一下null存在的具体的几个问题：

- 该值未被初始化
- 该值不合法
- 该值不需要
- 该值不存在

在我们的日常业务中往往需要程序员根据实际的业务去为null赋予真实的意义，但这一步又为开发者带来了无谓的心智负担

除此之外，NPE也是一种十分令人恼火的错误，我们来看一个代码

```java
String str="null";
String strNull=null;

System.out.println(str.length());
System.out.println(strNull.length());
```

这段代码在编译时期不会出现报错但是在运行期会爆出NPE的问题，同时，当代码长到一定程度，被赋值为null的对象与调用它的语句距离太远，NPE也很难被程序员发现

万幸的是，IDEA有一套强大的类型检测系统，可以提前帮我们分析出一个对象实例是否存在为null的可能，但是在这种情况下，我们就不得不在这种情况下进行一些防御性代码

```kotlin
val len=if(str!=null){
	str.length
}
```

我们不得不承认，null会带来很多问题，但它也确实是一门语言在设计的时候近乎无法被取消的部分，因此Java也在努力的对null进行优化

在Java8，Java选择引入Optional类来解决null的各种问题，我们可以将一个对象封装为Optional类实例，并使用Optional类中带有的API去对其进行处理，但这一层的封装却又给类的使用带来了负担，好在在另一方面，我们可以使用Java的类函数式编程与Optional类提供的flatMap函数来进行较为简便的写法

```java
public class Seat {  
    private Optional<Student> student;  
  
    public Optional<Student> getStudent() {  
        return student;  
    }  
  
    public static void main(String[] args) {  
        Optional<Seat> seat = Optional.of(null);  
        seat.flatMap(Seat::getStudent)//虽然不能在这里对代码进行中断，但可以避免NPE出现
                .flatMap(Student::getName)  
                .map(Glasses::getDegree)  
                .ifPresent(System.out::println);  
    }  
}  
  
class Student {  
    private Optional<Glasses> name;  
  
    public Optional<Glasses> getName() {  
        return name;  
    }  
}  
  
class Glasses {  
    private double degree;  
  
    public double getDegree() {  
        return degree;  
    }  
}
```

不过值得注意的是，Optional的判空耗时大概是普通判空的数十倍，则主要是因为Optional< T>中包含了类型T引用的泛型类，在使用的过程实际上多创建了一次对象，在数据量大的情况下频繁的进行对象实例化会造成严重的性能负担

一些开源项目中则选择返回一些非空的实例来代表空，比如常见的一些获取List的方法，如果获取不到List，返回的并不是null而是Empty List

另一种被大家推广的方式则是使用注解，在一个对象被创造出来的时候就使用注解对其内部字段是否为空进行定义，进而强制开发者提前去思考一个字段的可空性，目前知名框架[Spring](https://docs.springframework.org.cn/spring-framework/reference/core/null-safety.html)联手[JSpecify组织](https://jspecify.dev/docs/start-here/)也正在努力的在这方面进行推广

而在Kotlin中，则是试图在语法层面结局空的问题，Spring在类型层面推出了可空类型，用来特别对空进行处理

在Kotlin中，如果我们想要将一个类型声明为空，需要显式的将其设置为可空类型

```kotlin
val student:Student? =null
```

那么，对于一个对象的调用使用的也是专门的语法

```kotlin
s.student?.glasses?.degree
```

这里的?.会在前面数据不为空时才会执行，否则这会立刻截断并返回null

除此之外Kotlin还支持Elvis表达式?:，其含义是如果?:前的部分不为空，则执行前面部分，否则执行后面部分

```kotlin
s.student?.glasses?.degree?:5.0
```

最后，Kotlin还支持一种非空断言!!.，该语法没有实际意义，仅仅是让编译器忽略!!.前面的部分为空的可能性（也可以理解为强制让编译器认为前面的部分为非空），这一步只是为了骗过编译器让其可以正常编译，但是运行时如果出现null的情况任然会出现NPE

## Either

有了可空类型就完全够了吗？实则不然，虽然我们可以给代码设置一个默认值，但是在一些情况下，外界传入了一个null的值，我们如何在不出现NPE的时候将异常表示出来呢，Kotlin选择使用Either进行实现

```kotlin
sealed class Either<A,B>(
	class Left<A,B>(val value:A):Either<A,B>()
	class Right<A,B>(val value:B):Either<A,B>()
)

seat?.student?.glasses?.let{Either.Right<Error,Double>(it.degree)}?:Either.Left<Error,Double>(Error(code=1))
```

```kotlin
public inline fun<T,R>T.let(block:(T)->R):R=block(this)
```

调用某个方法的let函数，会将该对象作为Lambda的参数，进而将对该对象的操作转化到该对象的let方法的后缀函数的函数体中，返回值使用return表示

## Smart Casts/智能类型转换

Kotlin实现了Smart Casts，可以隐式的将一个类型转换为另一种类型，举个例子

```kotlin
val str:Any="abc"
if(str is String) str.length
```

如果是Java，在if处其实还要完成一部类型转换，但是Kotlin中，由于前面已经识别到了str是String类型，所以可以直接的调用str的API

同样的，对于可空类型也是，如果我们的代码在前面已经确定了非null，那么后面的代码就不用在使用?语法

Kotlin的编译器只有在检测到变量不会变化的情况下才会发生智能转换，这一检测对多线程也有效

```kotlin
class Kot{
	var str:String?
	fun getStrLen():Int{
		return if(str!=null) str.length else -1  //这里会被拒绝，因为str本身多线程不安全
	}
}
```

当然，上述的代码将var修改为val就可以通过编译器了

亦或是我们可以使用更加高效的let方法

```kotlin
class Kot{
	var str:String?
	fun getStrLen():Int{
		return if(str!=null) str?.let{
			return it.length
		}?:-1
	}
}
```

不过有时候，我们不太能满足使用smart castas的情况，并且smart casts缺乏语义，不能使用于所有的场景，所以一旦我们需要显式的类型转换的时候，我们可以使用as操作符来实现

```kotlin
class Kot{
	val stu:Student?=getStu() as Student?
}
```

除此之外Kotlin还支持as的安全版本，as?

```kotlin
class Kot{
	val stu:Student?=getStu() as? Student?  //当as?前的部分非as?后的类型时，则返回null
}
```

## 比Java“更加”面向对象

我们知道Java是一门面向对象的语言，甚至为了保证面向对象的优先级，他会设置很多强制性的规定（这些规定甚至倒逼出了Scala的诞生 XD），但是我们也知道，Java中除了对象类型之外还有基本类型，因此在某个角度上Java实际上并不能算是“纯”面向对象的语言，而Kotlin去除了基本类型，在这个角度上来看，或许Kotlin会更加纯一点

当然，上面的内容只是简单的调侃，毕竟在现在这个面向对象已经诞生了数十年，软件开发领域各种范式横飞的年代，纠结谁“更加”面向对象没有意义，我们更应该将关注点放在Kotlin和Java在面向对象方面上设计的不同，以及为什么Kotlin有“作为更好的Java”的能力

总所周知，Java中存在一个Object类，作为所有类的父类，而在Kotlin中，实现这一功能的是Any类，Any类是所有非空类型的父类，而Any?则是所有非空+可空类型的父类，所以严格意义上讲Any?才是真正意义上Kotlin的“顶类”

当Kotlin使用Java的类型时，会将Java的类型（如果该类型是一个一个类的字段的形式出现，那还要特指没有被Java空安全注解标注的情况）转换为Kotlin中与之对应的平台类型（也就是我们有时会在IDEA的嵌入提示中看到的类型后面加一个！的样子，比如String!），其含义是表明这个类型可能为空也可能非空，就如同类型声明中的！一样，希望程序员可以重视这个类型的可空性，同样的，在语法层面，我们既可以对其使用?.一类的空安全语法，也可以采用直接.的形式调用API，这是Kotlin为了兼容Java的权衡之策

## 继承与子类型化

很多Java程序员会混淆子类型化和继承的关系，这是因为Java中的子类型化是通过继承间接实现的，也就是说，如果我们认为类型A继承了类型B，那么我们就认为A是B的子类

然而实际上，子类型化和继承是两个毫不相关的关系，在面向对象的设计中二者是地位相同的名词

子类型化特别强调的是**子类型可以在任何需要父类型的情况下替代父类型使用**，这里强调的是一种替代可行性的关系

而继承则重点在于代码的复用

同样的，虽然我们清楚Any?和Any之间并无继承的关系，但实际上，由于Any可以用在任何需要Any?的情况，因此Any是满足作为Any?的子类型的条件的

然后就会出现套娃问题，那是不是还有Any??这种玄学东西作为Any?的父类？

实际上并不会，因为Kotlin上的可空类型的设计实际上类似UnionType，也就是说Any?实际上类似Any并Null，而Any??从语义上看就是Any并Null并Null，也就等价于Any?，因此并无讨论意义

## Nothing与Nothing?

Kotlin中还引入了底类的定义，也就是所有类的子类型，这其实是为了进一步实现表达式而引入的

举个例子，如果我们的一个方法要产生报错，且我们还希望他能具有返回值（像是表达式一样），那么他的返回值应该是什么

这种情况下就是Nothing出现的意义，我们可以让其返回Nothing，Nothing在Kotlin中无法被实例化，也就是说，如果一个函数的返回值为Nothing，则直接表明这个函数没有返回值，且大概率会有意外终止

你可能会感觉这有点像Java中的return或是break的作用，实际上，Kotlin的return和throw的返回值都是Nothing

除此之外则是Nothing的可空类型Nothing?由于Nothing无法被实例化，实际上Nothing?的值只有一个，就是null，也正是因为这个设计，我们可以让null作为任何可空类型的值（因为本质上他是作为所有类的子类Nothing?的值被传入的）

## 自动装箱

Kotlin取消了基本类型，所有Java中的基本类型都是以其包装类型的情况在Kotlin中被使用，如果查看其字节码，我们会发现，Int的字节码会将其视为int，而Int?的字节码会将其视为Integer，这是为了进一步优化性能而实现的，同时，统一使用包装类型还可以减少程序员的心智负担，以一种统一的形式去使用一个变量

## “新”的数组类型

Java中数组的声明方式实际上比较类似C/C++，而Kotlin则是放弃了这种写法

```kotlin
val arr=arrayOf(n1,n2,n3)//Kotlin会自动识别arrayOf中的类，返回其最近父类或其自身
```

熟悉Google著名Java工具包Guava的小伙伴看这种写法应该很熟悉，Kotlin在语法层面相对Java有着更大的优势，可以不再通过调用类的方式直接调用方法创建数组

数组在Kotlin中也是以类的情况出现，我们可以将其视作Kotlin集合系统的一部分

```kotlin
val arr=arrayOf<Int>(1,2,3)//我们也可以手动声明array的类型
```

Array是一种大小固定的集合，同时在内存中地址连续，这些特点同样也是Kotlin中数组类的特点

除此之外，Kotlin还专门提供了IntArray，CharArray等类，用来作为基本类型的数组类，与直接使用Array的区别在于这些基本类型数组都做了专门的优化，因此推荐优先使用这些特殊数组，值得注意的是，这些基本类型数组与Array类之间不存在父子类关系

## 泛型

泛型大家并不陌生，这里我们简单的来总结一下泛型的优点

- 类型检查：在没有泛型的时候只能使用Object类型来替代，但是就会引入额外的类型检查负担
- 更加语义化：相对使用Object，List< String >能直接看出List中元素的类型
- 实现更加通用化的代码
- 自动类型转换

Kotlin中基本继承了Java泛型的所有优秀设计，并且沿用了java泛型的大部分写法，并在此基础上进行了功能上的升级

```kotlin
class SmartList<T>:ArrayList<T>()

fun <T> ArrayList<T>.find(t:T):T?
```

这是Kotlin中定义泛型类和泛型方法的代码，我们发现和Java几乎没有区别

但是我们观察下面这个代码

```java
List list=new ArrayList()
```

这个代码没有声明List的类型，同时编译器也无法对其进行推导，但是Java中可以正常编译通过，这是Java为了兼容Java5之前的版本做出的妥协

但是Kotlin最早的版本是基于Java6实现的，这个时候Java中已经有了泛型，因此Kotlin中不允许这种写法的出现，如果要定义一个空列表，则必须显示的声明列表的类型

```kotlin
val list=mutableListOf<String>()
``` 

## 上界约束

有时候我们不希望泛型的位置可以填充任意的内容，这时候我们就需要对泛型进行一些约束

```kotlin
class Cal<T:Number>{
	
}
```

这里我们定义了一个Cal类，用来进行一些基本的计算，由于涉及计算，我们希望它传入的都是数字类型，因此将其限定为了Number及其子类

这里的语法其实和继承一致，如果你还希望泛型传入的类型可空，还能这样

```kotlin
class Cal<T:Number?>{
	
}
```

那么我们对一个泛型有多个条件呢？

```kotlin
open class Animal{}
interface Eatable{}

class Duck:Animal(),Eatable{

}
```

现在有这么一个类Animal，其子类均为动物，同时存在一个接口Eatable，表示一个动物是否能被吃

那么现在存在一个类Cook，用来烹饪动物，他就要求传入的泛型同时继承Animal并实现Eatable，这时就要使用Kotlin提供的where语法

```kotlin
class Cook<T> where  T : Animal,T: Eatable{  //where放在最后，对T进行限制 
    fun cook(t:T): String ="can eat"  
}  

//泛型方法定义的方式，where同样也是放在了最后
fun <T> cook(t:T): String where T: Animal, T: Eatable ="can eat"
```

## 类型擦除

如果了解Java泛型的小伙伴应该清楚，Java泛型本质上其实是假泛型，本质上是通过类型擦除实现的，那么类型擦除究竟是什么呢？我们下来看一段代码

```java
List<String> list=new ArrayList<String>();
String[] array=new String[]{};
System.out.println(list.getClass());
System.out.println(array.getClass());

//输出结果
//class java.util.ArrayList
//class [Ljava.lang.String;
```

我们会发现，Java并不知道List的泛型究竟填入了什么，仅仅知道他是ArrayList类型，这一过程中，对于String泛型的定义就如同被擦除了一样，因此被称之为类型擦除

而之所以这样设计，是因为Java在最早期的版本并没有设计泛型这一概念，而等Java6引入泛型之后，市面上已经存在大量没有使用泛型的Java代码了

为了实现新版本对老版本的完全兼容，Java只能用这种别扭的方式来实现泛型

那么既然Java的泛型是违泛型，那么Java泛型的功能又是如何实现的呢？

首先，类型检测这一过程实际上发生在编译之前，因此不受类型擦除的影响，而自动转换，其本质上是JVM在字节码层面对取出的泛型进行了强制类型转换实现的

类型擦除固然解决了代码兼容的问题，但是我们需要知道泛型真正的类型的时候该怎么版呢？

一个常见的情景就是序列化与发序列化，当我们将一个Java实例序列化到程序外部后再将其反序列化到我们代码的内部，如何保证前后泛型的一致？

其中一种方式是通过匿名内部类实现

```kotlin
val list=object:ArrayList<String>(){}
println(list.javaClass.genericSuperclass) //打印java.utile.ArrayList<java.lang.String>
```

匿名内部类本质上创建出的是一个ArrayList的子类，而子类中保存父类的信息不会进行类型擦除，因此我们可以明确的知道他的泛型是什么

我们常用的Gson库本质上也是通过这种方式实现的泛型信息的获取

除此之外，Kotlin还支持使用内联函数的方式获取泛型信息

```kotlin
inline fun <reified T> getType(){
	return T:class.java
}
```

内联函数想要保存泛型的信息只需要在使用的泛型前面加上reified关键字即可，在编译的时候会将泛型的类型插入到字节码中，进而实现对泛型类型的记录，同样的，由于这个功能的特殊性，使用了reified关键字的Kotlin内联函数无法直接被Java代码调用 

## 协变与逆变

Kotlin本身支持协变与逆变，分别使用in和out关键字进行实现

```kotlin
class List<out T>{

}

val listChild=List<Int>()
val listFather:List<Number> =listChild
```

所谓协变就是泛型类实例A中使用的泛型是泛型类实例B的泛型的子类，那么泛型类实例A就是泛型类实例B的子类

对于协变，Kotlin的要求是协变类中使用泛型的字段是只读的，比如

```kotlin
fun main() {
    val int= Covariance(1)
    val any: Covariance<Any> = int
    any.value="s"
}

class Covariance<out T>(
    var value:T  //这里会报错，声明协变字段只能是只读类型
){
	fun setValue(inValue:T){  //这里也会报错，因为协变不能作为方法的入参

    }
}
```

之所以会强制这么设计，是因为协变中存在以下的问题

```kotlin
class List<out T>{

}

val listChild=List<Int>()
val listFather:List<Number> =listChild
listFather.add("12")
val value:Int=listFather.get()
```

上面的伪代码中，我们设计了一个场景，由于协变的存在，我们可以在协变中的父类中插入更加宽泛的值，但是将这个值取出时，应该是协变类中顶层父类的任意子类，这些子类之间不包含子类化的“替代关系”，因此使用它们是不安全的，唯一安全的形式就是将其统一当作父类取出（因为从协变中的父类中，去出的泛型字段也只能是父类的类型），而子类作为父类去使用是始终安全的

所以我们可以认为，协变类中，协变部分永远不能进行修改，也永远不能作为入参，只能作为出参，这也符合其关键字`out`

而逆变则刚好相反，逆变是如果逆变类A的泛型部分是逆变类B的泛型部分的子类，那么逆变类A就是逆变类B的父类，用关键字`in`表示

相对协变，逆变的管控更加严格（因为逆变本身的情景就很苛刻），逆变不能作为类中的字段使用，仅能作为方法的入参

还是用String Any Int举例，如果存在逆变类

```kotlin
class Inverse<in T>(
    var value:T  //实际上这里会报错
)

val inverse = Inverse<Any>("1")  
val parent: Inverse<Int> =inverse  
val value: Int =parent.value
```

根据上述的伪代码，我们知道根据逆变后，取出来的value实际上是原本类的任意一种子类，而输入的时候是原本类的任意一种子类，二者是平行关系，不存在子类化的替换关系，因此不安全

那么其意义是什么呢？

```kotlin
class Comparable<in T>{  
    fun compareTo(other:T){  
         
    }  
}

val comparableAny = Comparable<Any>()  
val comparableInt:Comparable<Int> = comparableAny  
comparableInt.compareTo(1)

```

我们来看上述方法，如果我们将comparableAny当作comparableInt使用，而老的代码中存在的compareTo方法，用的实际上是父类中的参数和方法，所以当你将其子类传入时，不会出现问题，因为子类的方法可以被使用

在逆变中，我们只能让逆变部分作为方法的入参，就如同他的关键字`in`一样

一些小伙伴看完一遍可能觉得这里很绕，没关系，我们总结一下

协变和逆变之所以在Kotlin中这么设计，实际上还是为了保证类型的安全性，其根本在于类型只有一种情况下是安全的————**当前类实例接受的是该类本身或子类的实例**以及**逆变的泛型是用来传出进而被使用的（所以要父类/给到最少），协变的泛型使用来传入进而调用的（所以要子类/要到最多）**

我们再来分别分析一下逆变和协变的设定：

- 协变只允许让泛型只能充当只读字段和方法出参/协变可以将子赋值给父：首先是只读字段，当将子赋值给父时，由于字段此时已经不可以修改，所以固定了此时我们拿到的一定是父亲的一个固定的子类，因此读出时也会是一个固定的子类，而当其作为出参时，由于是被当作父类使用，所以满足子替代父的关系
- 逆变只允许让泛型只能充当方法入参/协变可以将父赋值给子：当赋值给子后，逆变内部的方法其实是将原本已知父类的子类当作其父类去使用，仍然满足子替代父的方法

## Lambda表达式

在Kotlin中，Lambda表达式的形式以这种方式存在

```kotlin
{ 参数 ->
	代码
	返回值
}
```

Lambda表达式的返回值就是一个函数，所以我们可以轻松的用lambda表达式来创建一个函数

```kotlin
val fn = { a: Int ->  
    println(a)  
    a  
}
```

同时Kotlin对Java原有的使用Lambda表达式的方式进行了优化，当方法的最后一个参数为Lambda表达式时，可以以未随的形式使用Lambda表达式，当函数只有一个参数且为Lambda表达式时，可以省略小括号

## with与apply

Kotlin中提供了with与apply两个函数，用来让我们更加方便的调用一个实例的内部参数

```kotlin
fun main() {  
  
    val user = User("张三", 18)  
    user.apply {  
        println(this.name)  
        name="李四"  
        println(name)  
    }  
  
    with(user){  
        println(this.name)  
  
        println(age)  
    }  
}  
  
data class User(  
    var name: String,  
    val age: Int  
)
```

在apply和with的函数体中，我们就像是再写一个User类内部的函数一样对User实例进行操作

## 集合类中好用的，使用Lambda的方法

### map——转换

Kotlin中的map类似Java Stream API中的map，核心作用在于将集合中的`所有`元素都进行一遍操作，然后将其转化为一个新的集合

```kotlin
fun main() {  
    val listOf = listOf(1, 2, 3)  
    val map = listOf.map { it * 2 }  
    println(map)  //[2, 4, 6]  
}
```

### filter——筛选

filter实现了对集合的筛选操作，我们可以传入一个返回值为Bollean的Lambda表达式，他会对集合中的每一个元素进行检验，只有返回true的元素才会被留下

```kotlin
fun main() {  
    val listOf = listOf(1, 2, 3,4,5,6,7,8,9)  
    val map = listOf.filter { it>3 }  
    println(map)  //[4, 5, 6, 7, 8, 9]
}
```

Kotlin中类似的方法有很多，这里一并提及了

- filterNotNull：用来筛选出不是null的元素（不需要参数）
- filterNot：在返回false的时候才会保留元素
- count：返回会返回true的元素的个数

### sumOf——求和

sumOf函数用来接受一个可以执行`+`操作的元素，然后将所有的返回值累加起来

```kotlin
fun main() {  
    val listOf = listOf(1, 2, 3.3,4,5,6,7,8,9)  
    val sum = listOf.sumOf { it .toDouble() }  
    println(sum)  
}
```

对于一个固定的数字列表，还可以使用更加方便的sum方法直接求和

### fold

fold函数可以在进行返回本轮要累加的值之前对之前累加的值进行操作，该方法除了需要一个Lambda函数之外，还需要一个初始值，作为第一次累加的时候的参数

```kotlin
val listOf = listOf(1, 3, 4,7)  
val sum = listOf.fold(0){pre,now->  
    pre  
}  
println(sum)//0
```

Kotlin中还有一个类似fold的方法reduce，区别在于reduce自动使用列表的第一个值作为初始值

### groupBy——分组

groupBy用于对列表进行分组操作，要求Lambda表达式返回一个元素，Kotlin会根据该元素相同的实例来讲集合进行分组，分组后会产生一个Map集合，其中key为我们自定义的分组条件的值，value为分好组的集合

### 扁平化/处理嵌套集合——flatMap，flatten

有时候我们的集合中的内容是集合，我们想将这些集合中的元素在不分层的情况下转为一个只有一层的集合，这时我们就可以使用flatten方法

出此之外，Kotlin还提供了faltMap函数，要求Lambda返回一个列表，Kotlin会自动的将所有列表列表进行flatten（也可以理解成先Map再flatten，而flatMap只需要你写map中的部分）

## 集合库的设计

在Kotlin中，所有的集合都被分为了两类，带有Mutable（可变）和不带Mutable的，具体区别在于，带有Mutable的集合都是可变的，而不带Mutable的均为只读的

在本质上，Kotlin的集合都是基于Java的集合实现的，Kotlin只是使用了拓展函数对其进行了增强

一般情况下，Mutable的集合类是继承自非Mutable的集合类，也就是说，我们可以将一个MutableList赋值给一个List，这时，这个List就不再是只读的了，因此，只有使用普通的listOf方法创造出来的List实例才是只读的

另一方面，由于Java不区分是否可读的原因，因此Java函数调用Kotlin只读集合是可以对其进行修改操作的

## 序列

Kotlin中的链式操作会产生中间集合
`
```kotlin
val numbers = listOf(1, 2, 3, 4, 5, 6)

val result = numbers
    .filter { it % 2 == 0 } // 第一次操作
    .map { it * 10 }        // 第二次操作
    .take(2)               // 第三次操作
```

每次操作的过程中都会创建一个集合出来，当被处理的集合数据量较小时还好，但当数据量很大（比如以万为单位），此时中间集合的性能消耗就很严重了

为了解决这个问题Kotlin引入了序列，序列的特点是惰性求值，这里我们来解释以下惰性求值的概念

- **惰性求值**：只有在需要的时候才会进行求值计算，表达式只有在值被取用的时候才会进行求值

在这样的特点下我们甚至可以创建出无限序列

我们先来看使用序列对原本集合的改造

```kotlin
val numbers = listOf(1, 2, 3, 4, 5, 6)

val result = numbers.asSequence() // 转换为 Sequence
    .filter { it % 2 == 0 }
    .map { it * 10 }
    .take(2)
    .toList() // 触发求值并返回最终集合
```

序列的求值触发是由末端操作进行的，所谓的末端操作，就是放在序列的最后，用来告诉序列：“我现在需要这个值了”的操作，比如上述代码中的toList方法就是典型的末端操作

如果我们观察使用列表链式操作和序列链式操作的区别，我们还不难发现，序列的末端操作是针对元素执行的，举个例子，上面的列表，会先对1进行filter操作，如果满足在进行mao操作，然后再进行take操作，然后进行完所有操作之后再对第二个元素2进行操作

而集合的链式操作，则是先统一的完成filter再完成map，最后进行take

得益于这项特点，当map和fliter之间互换位置不影响时，我们往往建议先使用filter操作，因为可以减少代码执行的数量

除此之外，我们刚刚还提到了定义无限长度的序列的操作，这是怎么实现的呢？

我们可以看一下这个代码

```kotlin
val sequence=generateSequence(0){it+1}
```

所谓无限长度的序列，就是你给出一个初始值，然后可以往后一直推值的大小，这样就可以创建出一个无限长的序列

然后我们可以对他先执行链式操作，在执行末端操作，这样就可以实现对一部分代码的操作

```kotlin
list.takeWhile{it<=9}.toList
```

这里需要注意的是，我们没有办法真正的实现对无限序列的枚举，只是创造逻辑上的无限序列，并对其进行链式调用，这才是其存在的真正意义

## Java Stream API

我们其实不难联想到Java的Stream API，但是StreamAPI和Kotlin的链式操作还是有一定的区别的

在Java中，Stream API是一次性的，也就说是，如果我们创建了一个Stream类，并对他进行了链式操作，那么他就无法再被使用了

除此之外，Stream API还实现了多线程流，只需要通过集合类的paralleStream方法获取即可

## 内联函数

Kotlin中的内联函数其实是一个Java中不太需要的语法点，因为Kotlin设计他的主要目的是优化Lambda表达式产生的性能开销，而Java在Java7之后就通过JVM引入的invokednamic技术实现了隐式的Lambda优化

在早期，Kotlin的主要合作者是Google，其责任就是实现广大Android开发者的需求，而Android开发大多使用的都是Java 6，这也就导致在Java7中对Lambda进行的优化大多Android开发者是享受不到的

因此，Kotlin必须得想办法解决这个问题

在Java7中，JVM的invokenamic通过在运行时残生翻译代码来解决的这个问题，invokednamic在首次被调用的时候，就会触发产生一个匿名类来替换中间码invokednamic，后续的掉用会直接采用这个匿名类的代码，这样做的好处在于：

- 由于具体的转换发生在运行时，因此字节码中能看到的实际上只有一个invokednamic，所以要静态生成的类和字节码的大小都显著的减少了
- 由于将invokednamic的实际翻译策略隐藏在了JDK的实现中，因此提高了灵活性，可以保证在不断向后兼容的同时对翻译策略不断的优化
- JVM天然支持Lambda优化极大程度减小了开发者的心智负担

Kotlin为了最大程度的兼容Java6，导致它无法通过invokednamic来解决Lambda的开销问题，因此他被迫选择了使用另一种主流解决方式————内联函数，这也是C++/C#中选择的解决方式，其作用在于他们在函数体编译器将函数代码嵌入到每一个被调用的地方，以此减少生成的匿名类数，以及函数执行时的性能开销

想要定义内联函数，我们只需要在函数前面加上inline关键字即可，当我们对一个函数使用inline关键字，其本身方法体中的代码及其使用的Lambda表达式（或者进一步扩展为函数变量）均会被粘贴过来执行

有时候我们希望inline函数中有的Lambda参数不会被黏贴，这时候就要用noinline关键字对Lambda参数进行修饰了

## 非局部返回

Kotlin中的Lambda为了实现代码的简洁，不允许在Lambda中使用return关键字，但是inline函数是个例外，当你在inline函数的Lambda参数中写入了return关键字，由于inline的内联特性，会直接导致这部分代码返回

为解决这个问题，crossinline关键字对inline函数的Lambda参数进行修饰，这也就可以严格声明inline函数的Lambda参数中也不允许有return函数

## 具体化参数类型

由于Java自带的类型擦除，我们不能直接捕获一个参数的类型，但是，对于内联函数来说，由于其可以直接将代码粘贴到调用inline函数的地方，所以原本发生类型擦除的地方全都不会出现问题

实现这个效果，我们只需要使用reified关键字

```kotlin
inline fun <reified T> getType(){
	print(T::class)
}
```

## 子类型多态与参数多态

**多态**：多态指为不同数据类型的实体提供统一的接口，或使用一个单一的符号来表示多个不同的类型（Wiki百科）

多态是面向对象语言中最常见的特性，在Java中，我们最熟悉的就是子类型多态和参数多态，其中子类型多态其实就是我们平常说的继承，也就是可以用父类代表多个子类型的状态，而所谓的参数多态其实就是我们平常写的泛型，即用一个大写的T来代替任意类型

## 特设多态

特设多态是一种更加灵活的多态形式，举个例子

```kotlin
fun <T> sum(a:T,b:T):T=a+b
```

这个方法显然会报错，因为Kotlin并不确定T是否真的可以执行加法操作

对此的解决方式是使用特设多态，即一个多态函数有多个不同的实现，其实现的选择根据实参的类型而决定

为了实现这个功能，Kotlin特地设计了运算符重载这一语言特性来解决这个问题

```kotlin
data class Area(val v:Double)

operator fun Area.plus(that:Area):Area{
	return Area(this.value+that.value)
}

fun main(){
	print(Area(1.9)+Area(2.1)) 
}
```

实现运算符重载的是operator关键字，其作用是将一个函数标记为重载一个运算符或实现一个约定

这里的plus就是Kotlin规定的函数名，用来重载加法运算，除此之外还有许多其他的运算符也可以被重载

- 减法：minus
- 乘法：times
- 除法：div
- 取余：rem

此外，Kotlin的很多特殊的语法特性也是使用这种方式实现的

```kotlin
a in list//转化为 list.contain(a)
```

## 扩展

作为一名Java开发者，我相信大家一定都听说过开闭原则，即：软件实体是可扩展但不可修改的



开闭原则是所有面向对象设计的基石，也就是本身封装变化，降低耦合

但是在实际开发中往往不会这么理想，比如我们正在写一个项目，引入了第三方库，但是作者可能没有考虑到我们自身业务在开发中遇到的问题，这个时候你可以在github上向作者提个issue（如果可以的话最好也给作者点个star），但是作者很有可能会因为自身工作安排的原因或者是整体考虑而暂时无法解决你遇到的问题

这个时候我们不得不对第三方的文件做出一定的修改，在Java中常做的方式是继承父类，然后使用子类对其进行重写，但是这很有可能又会违背**里氏替换原则**

而Kotlin为了解决这个问题，实现了拓展语法，我们可以直接通过这个语法对第三方的包进行操作

在语法上，扩展函数基于< Type> ,除此之外我们还需要一个接受者类型，即拓展谁

```kotlin
fun MutableList<Int>.exchange(fromIndex:Int,toIndex:Int){
	val tmp=this[fromIndex]
	this[fromIndex]=this[toIndex]
	this[toIndex]=tmp
}
```

Kotlin的this相对Java更加强大，可以直接指代接收者对象

这里就是我们直接拓展了MutableList< Int>的方法

扩展函数本身是使用Java的静态方法实现，因此不会带来额外的性能消耗，我们一般会直接将他定义到我们的包内，亦或是定义在一个类中进行统一的管理

但是值得注意的是，如果我们将拓展函数定义在一个类中，那么只有在该类和该类的子类才可以使用这个拓展函数

除了拓展函数外，我们还可以定义拓展属性


```kotlin
val MutableList<Int>.sumIsEven:Boolean
	get()=this.sum%2==0
```

我们可以显示的为其提供get和set方法，但却无法为其设置默认值，这是因为拓展属性也是通过静态方法实现的，无法像属性那样直接生成getset方法

## 幕后字段与幕后属性

这里我们需要理解下属性和字段的区别

- 属性（property）：包含私有字段和访问器（也就是getter和setter），可以是可变也可以是只读
- 字段（filed）：拥有值的类成员变量，可以是只读或是可变，为了安全性一般是私有的

举个例子

```java
class Person{
	private String name="CoteNite"  //这里的是字段

	public void setAge(int age){
		
	}

	public int getAge(){
		
	}  //同时拥有set和get方法，认为存在属性age
}
```

这里有一个很常见的疑惑，就是如果一个字段也拥有get和set方法，那他是属性吗，那他还是字段吗

当然是，这里就像是子类型话和继承一样，属性和字段本身也是平行的关系，如果一个字段同时拥有get和set方法，那么这个字段就是一个属性，但这并不耽误它本身也是一个字段

对于面向对象而言，属性是对于字段的封装，由于get和set的存在，我们可以让外界对字段的访问在我们的控制之下，而不是直接取用，一般我们会将私有字段通过封装成公共属性，以便于外界访问和修改。

再回到Kotlin,如果我们这样定一个字段

```kotlin
class Person{
	val name
		set(value)=print(value)
		get()="CoteNite"
}
```

其反编译的代码为

```java
public final class Person {  
  
   public final String getName() {  
      return "CoteNite";  
   }  
  
   public final void setName(@NotNull String value) {  
      System.out.print(value);  
   }  
}
```

而如果我们这样去写

```kotlin
class Person{
	val name="CoteNite"
		set(value)=print(value)
		get()="CoteNite"
}
```

则会发生报错`Initializer is not allowed here because this property has no backing field`，即这个属性没有幕后字段

在Kotlin的文档中提到，只有我们在get和set方法中使用filed才会生成幕后字段，比如

```kotlin
class Person{  
    var name="CoteNite"  
        set(value){  
            field=value  
        }  
        get(){   
            return field  
        }  
}
```

这样就不会报错，因为其反编译出的Kotlin代码为

```kotlin
public final class Person {
   @NotNull
   private String name = "CoteNite";

   @NotNull
   public final String getName() {
      return this.name;
   }

   public final void setName(@NotNull String value) {
      Intrinsics.checkNotNullParameter(value, "value");
      this.name = value;
   }
}
```

也就是说，只有在get和set方法中使用了属性本身，Kotlin才会在反编译的时候生成幕后字段

而所谓幕后属性是指的这样一种情况

```kotlin
private var _table: Map<String, Int>? = null  
public val table: Map<String, Int>  
    get() {  
        if (_table == null) {  
            _table = HashMap() // 类型参数已推断出  
        }  
        return _table ?: throw AssertionError("Set to null by another thread")  
    }
```

存在一个私有的字段`_table`，其对外的获取完全基于另一个属性table

反编译的Java代码为

```java
private Map _table;  
  
   public final Map getTable() {  
      if (this._table == null) {  
         this._table = (Map)(new HashMap());  
      }  
  
      Map var10000 = this._table;  
      if (var10000 != null) {  
         return var10000;  
      } else {  
         throw (Throwable)(new AssertionError("Set to null by another thread"));  
      }  
   }
```

我们会发现，实际的存储是由私有的`_table`属性对应的Java字段`_table`来承担的。对外的访问是由公有的`table`属性对应的Java 方法`getTable()`来实现的。

因此_table字段就实现了对内可变，对外只读的特性（因为private修饰的字段Kotlin不会为其提供get，set方法，其操作都是基于内部的字段直接进行）

而_table就是所谓的幕后属性 

## 拓展的特殊情况

### 静态扩展函数

如果开发者想要生成一个静态扩展函数，那么其扩展对象实际上为操作对象的伴生对象

```kotlin
class Person{
	componion object{
	}
}

fun Son.Componion.foo(){

}
```

但是实际上，有的第三方库的类没有伴生对象，这种情况我们就没办法对其拓展了

### 成员方法优先级高于拓展函数

当我们对一个已有的方法进行拓展，也就是说我们想要通过拓展函数的形式实现方法的重写

这个时候你会发现，Kotlin还是会调用原有的方法，这是因为Kotlin希望尽可能保证开闭原则，所以拓展不会让你轻易的改动已有的代码

我们要始终记住，好的代码应该是**只做拓展不做修改**

## Kotlin中常用的拓展函数

- let：返回Lambda的运行结果或null，调用者本身通过it来使用，调用函数的对象为空时返回空
- run：返回Lambda的运行结果，调用者本身通过this来使用，
- apply：返回对象本身，调用者本身通过this来使用（因为闭包的范围是对象的内部），因此主要是对对象进行一些链式的调用，
- also：返回Unit，调用者本身通过it来使用，主要使用于进行一些存在副作用（比如日志操作）的操作
- takeIf：返回对象本身或null，调用者以it的形式来使用，其Lambda返回Boolean，当其Lambda为false时返回null
- takeUnless:takeIf的反向，也就是Lambda为false的时候返回对象本身

## 元编程

元编程，即操作编程的编程，其最主要的作用是动态生成或调用代码，以减少我们平常书写代码的重复量

在Kotlin中，我们常常使用反射来获取元数据，所谓元数据即表述数据的数据，也就是记录我们代码的信息，通过操作这些信息，我们可以实现基础的元编程

我们可以大概的将元编程抽象为两件事：**通过反射获取信息，通过信息生成/操作代码**

只是对于Kotlin来说，我们没法将直接获得的KClass进行一定操作转化为class文件，所以Kotlin的元编程其实是受限的

而对于Lisp或者Clojure这种高度支持元编程的语言，我们实际上是可以办到直接生成程序的

常见的元编程技术有

- 使用API动态获取代码信息，也就是反射
- 动态加载文本并将其作为代码执行，比如JS的eval函数
- 通过外部编译器将文本转换为AST，也就是语法糖

## AST/抽象语法树

在[计算机科学](https://zh.wikipedia.org/wiki/%E8%AE%A1%E7%AE%97%E6%9C%BA%E7%A7%91%E5%AD%A6 "计算机科学")中，**抽象语法树**（**A**bstract **S**yntax **T**ree，AST），或简称**语法树**（Syntax tree），是[源代码](https://zh.wikipedia.org/wiki/%E6%BA%90%E4%BB%A3%E7%A0%81 "源代码")[语法](https://zh.wikipedia.org/wiki/%E8%AF%AD%E6%B3%95%E5%AD%A6 "语法学")结构的一种抽象表示。它以[树状](https://zh.wikipedia.org/wiki/%E6%A0%91_\(%E5%9B%BE%E8%AE%BA\) "树 (图论)")的形式表现[编程语言](https://zh.wikipedia.org/wiki/%E7%BC%96%E7%A8%8B%E8%AF%AD%E8%A8%80 "编程语言")的语法结构，树上的每个节点都表示源代码中的一种结构。之所以说语法是“抽象”的，是因为这里的语法并不会表示出真实语法中出现的每个细节。比如，嵌套括号被隐含在树的结构中，并没有以节点的形式呈现；而类似于 `if-condition-then` 这样的条件跳转语句，可以使用带有三个分支的节点来表示。

![image.png](https://raw.githubusercontent.com/CoteNite/Blog_img/master/blogImg/20251124200718.png)

上述内容来自维基百科

## 反射

反射这个东西大家在学Java的时候肯定听说过，但是可能大家都没有想过他为什么叫这个名字

反射，又名自反，本身实际上是指元语言（即进行元编程的编程语言）与其操作的编程语言是一种语言

Kotlin的KClass和Java的Class都是如此，其本身属于一个类，同时其实例又能用充当用来表述其他类的元数据，这样用编程语言自己描述自己的行为就叫反射

## 宏

宏是指一种抽象，本身是指根据一系列预定义的规则替换一定的文本模式，解释器或编译器在遇到宏时会根据设定好的规则进行替换，将一个简单的指令替换为设定好的内容

在最早学C语言的时候我们就知道C语言中存在#define，用于定义宏

```c
#define SWAP(a,b){int _temp=a;a=b;b=_temp}
int main(){
	int i=0;
	int j=1;
	SWAP(i,j)
}
```

在上面的代码中，C会将SWAP的使用处替换为#define中定义的代码

C的宏相对简单除暴，大多数干的都是全局文本替换的工作，用来增强代码的语义，而Lisp或Scala则可以使用宏直接暴露抽象语法树，进而对抽象语法树进行操作，并生成需要的程序进行返回

这个操作相比听起来就很强大，而强大的背后是极高的操作风险与对语言本身抽象语法树的了解，Scala始终践行着自己相信程序员水平的承诺，所以将宏的自由度开到了很大的程度，而Kotlin由于以实用至上的理念，短时间内不会对宏这一操作进行实现

## Kotlin中的反射

