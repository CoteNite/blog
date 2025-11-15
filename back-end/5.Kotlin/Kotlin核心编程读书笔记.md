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


