# Java，Scala，Kotlin——JVM语言的成长历程

前些时间对函数式编程产生了兴趣，于是学了一点 Scala。加上原本经常使用的 Java 和 Kotlin，如今我已经接触了三门 JVM 语言 

这些语言之间各有不同，却又彼此借鉴、互相启发。在对比与思考的过程中，我逐渐对编程范式有了一些新的理解，于是写下这篇文章，聊聊 JVM 世界的演化与思维的迁移。

## 一切都要从很久很久以前说起......

Java 诞生于 1990 年代初，由 SUN 公司创建，那是一个令人怀念的时代，面向对象编程正快速崛起，各大公司和研究团队都在尝试探索软件开发的最佳方式，而 Java 正是在这样的背景下诞生的。

在那个年代，程序员们常常为**平台差异性**而困扰——一个程序在 A 平台上能正常运行，却可能在 B 平台上崩溃。

为了解决这一问题，SUN 公司提出了一个极具前瞻性的概念：**虚拟机（JVM）**。让程序运行在一个统一的虚拟执行环境中，由 JVM 负责处理底层平台差异。程序员只需面对一套统一的 API，就能实现“一次编写，到处运行”的理想。

除此之外，JVM 还接管了诸如内存管理、垃圾回收等底层操作，让开发者可以从繁琐的资源管理中解放出来，专注于业务逻辑。  

可以说，SUN 的设计理念是：**让程序员更专注于创造，而非琐碎的维护**。而这些理念直到今天仍然深刻地影响着现代语言的设计。

随着时间推移，软件开发逐渐形成新的共识——新的语言不断出现，旧的语言也在被重新思考，新时代的编程语言的发布（比如C#），与此同时，开发者们也在尝试用新的语言设计理念来继承并改进Java的优势，也在指明Java这个老东西可能有一些地方应该改进

当然，Java作为一门开放且积极的语言自然也在不断的优化自己，不过由于历史包袱的原因，这个过程肯定是漫长的，于是，人们开始尝试在 JVM 上打造新的语言，既能继承 Java 的优势，又能突破它的限制，这便催生了 Scala、Groovy、Clojure、Kotlin 等语言的诞生

## Scala——JVM在函数式方向的尝试

函数式编程（Functional Programming）早在上世纪 50 年代就已出现。它主张让函数成为“一等公民”，避免副作用，用表达式代替语句，并尽量不修改状态。

由于硬件与时代背景，这些理念在当时并未流行，但随着软件复杂度的上升，函数式编程的思想被越来越多的现代语言吸收，成为编程中不可或缺的一部分。

Scala 的诞生正是 JVM 世界向函数式编程迈出的一步。

Scala是2000年初发布的语言，他的主导者Martin Odersky是一位热爱函数式编程的大学教授，并且曾经参与过Java语言核心内容的开发（尤其是 JDK5 中的泛型）

Martin Odersky教授曾在Java在一个名为 “Pizza” 的实验项目证明了JVM+函数式编程是可行的。这个实验的成功，让他坚信 JVM 完全有能力承载函数式思想。

最初Martin Odersky教授致力于让Java变得更好，但Java的一些强约束始终令他困扰（这也是Java现在时常被开发者们诟病的一点），这给他为Java实现真正的函数式编程带来了很大的阻挠，外加早期Java泛型（GJ）被SUN的搁置，导致他决定后退一步，重新设计一门编程语言，这也就有了我们熟知的Scala。

在Scala正式成型之前，Martin Odersky教授的团队还曾设计过一门更学术化的语言 **Funnel**，但他们很快发现：Funnel 在**学术上足够优雅，却离实际开发需求**。这与Scala的初心相悖。这令Martin Odersky教授不得不重新思考——开发者真正需要的语言，究竟是什么

最终，Scala 选择落地于现实世界：既要保持函数式编程的纯粹，又不放弃工程化的实用性

这直接奠定了 Scala 的独特气质——它既是学术派的代表，又是工程师手中的利器，他让我们真正的看到：**在 JVM 上，函数式编程不仅可能，而且强大。**

## Kotlin——SUN时代之后对于Java的思考

时间来到 2008 年，SUN 公司由于经营问题与经济危机的双重冲击，最终宣告破产，并于次年被甲骨文公司（Oracle）收购，这个曾经被评为行业内最有创造力的公司，一个时代的缩影，最终宣告结束。

在SUN陨落后，Oracle接管了SUN名下包括Java和MySQL在内的大量资产，但是他们却改变了SUN长期以来”以开发者与开源为核心“的思想，对Java进行了一系列的限制，这也导致了Oracle与Google长达十余年的官司问题

<p style="font-size:13px;">正如当年诺基亚被微软收购时，Jorma Ollila 在发布会上那句意味深长的话：我们没有做错什么，但不知为何，我们输了。</p>

在这种氛围下，JetBrains公司站了出来，决定自己来开创一门更好的Java，一个真正面向开发者的现代化 JVM 语言，这也就是未来的Kotlin

Kotlin 从一开始就带着“让开发更简单、更愉快”的目标，它借鉴了 Scala 的许多思想——空安全、扩展函数、lambda 表达式、不可变性等——但舍弃了 Scala 过于复杂的类型系统与语法结构。  

正如Kotlin的设计哲学不是“追求完美”，而是“追求实用”一样，他是一门真正注重工程师每天面对代码时的体验的语言。

凭借 JetBrains 的开发经验与庞大用户基础，Kotlin 得以快速迭代，2016 年，Kotlin 正式发布 1.0 版本——标志着这门语言的成熟登场，它不仅完美兼容 Java，还以更简洁、更安全、更现代的方式解决了 Java 多年来的痛点。

如今，Kotlin 已成为 Android 与 Spring 官方推荐语言之一，他仍然准守着“简洁、高效、可维护”的承诺，也让人们看到了——Java 的精神，正在以新的形式继续延伸。

## 对基本类型的舍弃

我们都知道，Java，Scala，Kotlin，都是面向对象的语言，但是Java却由于时代原因保留了八种基本类型——byte short int long float double boolean char

这是Java相对保守的一面，但是在后面的实践体验中，开发者们逐渐意识到这几个基本类型是不必要的，基本类型想要使用方法必须借由外界类或者将自己封装为包装类型，虽然基本类型相对包装类型更节约空间，但是在使用上却给开发者带来了大量的负担

因此在Kotlin和Scala中，他们都选择了舍弃掉基本类型，统一使用对象，这也就导致了在Kotlin和Scala中，实现了真正的万物皆对象

## 类型推断

在新生代语言中，大家都不约而同的选择了类型推断作为自己的基本语法，也就是开发者在编写代码时不用主动的声明变量的类型，而是交由编译器执行推导，这极大的方便了开发

```java
Integer a=1;
```

```kotlin
val a=1
```


## 最小可变性

《Effective Java》第三版的第十七条中提到**不可变类比可变类更易于设计，实现和使用。 他们不容易出错，并且更安全。**

这要求我们在非必要时刻要将字段设计为final类型，这一要求使得开发者必须注重自己的变量类型，在最开始就应该明确字段是否为可变的。在Java中你需要通过 final 类名的方式声明不可变类，但是在Kotlin和Scala中，自需要使用val关键字就可以创建不可变类，并且Scala和Kotlin会建议你使用不可变类作为一个字段的默认值（这也就是为什么一些语法糖中，没有val/var 那么就是默认不可变）

```java
final Integer a=1;  
a=3; // 产生报错
```

```kotlin
val a=1
a=3 // 产生报错
```

```scala
val a=1
a=3 // 产生报错
```

同时，对于不可变的要求还符合函数式编程的思想，即尽可能的减少副作用，当你要对一个类做出修改时，做好的方法就是返回这个类的一个复制品，而不是直接修改这个类并将这个类返回，这也就是为什么Kotlin和Scala中都会引入一个copy方法。

```kotlin
fun main() {  
    val person = Person("CoteNite", 21)  
    val oldPerson = person.copy(age = 20)  
}  
  
data class Person(  
    val name: String,  
    val age:Int   
)
```

```scala
@main def main(): Unit = {  
  val person = Person("CoteNite", 20)  
  val personOld = person.copy(name = "Old CoteNite")  
}  
  
case class Person(name: String,age:Int)
```

不可变类有很多的优势，比如线程安全，易于维护，当然他也有自身的缺点，比如对于一个“大”的不可变类实例，你想要复制一个他的实例出来就是相对困难的，可能需要开发者对其copy方法进行重写或者创建其他的专门用于复制出实例的方法

除此之外，为了尽可能的限制类的可变性，一个不可变类应该不能被继承

当然，在必要时刻我们肯定还是会使用继承，但是对于很多的类（比如数据类），我们实际上是很少会遇到继承的情况的，对于这一点Kotlin和Scala都有自己的语法规定

- Kotlin：data class允许作为别的类的子类，但不允许成为别的类的父类

- Scala：case class不允许被case class继承

正如《Effective Java》中写的一样——**除非有充分的理由使类成为可变类，否则类应该是不可变的。如果一个类不能设计为不可变类，那么也要尽可能地限制它的可变性**

## 更简洁的主方法

在Java中有一个经常被Java程序员喜闻乐道的东西，那就是我们写一个代码永远都要先写一堆

```Java
public class Main{
   public static void main(String[] args){
	   
   }
}
```

这是Java对于面向对象给出的答案，也是Java强约束的体验，诚然，在Java刚诞生不久的那个年代，这样的写法很有意义，但是时至今日，这样的写法有些过于臃肿了，甚至在Java25中，Java也不得不对这种写法做出优化

在Kotlin和Scala中，我们都允许使用一种简便的方式实现主函数

```scala
@main def main():Unit={

}
```

```kotlin 
fun main(){
	
}
```

## 类的差异

作为一名Java程序员，我们都知道我们可以在Java中创建以下几种形式的类：类（包含record 类和异常类），接口，枚举，注解，这是Java对于面向对象给出的答案，基于这几个类，我们可以写出完美的OOP代码

而在Scala中，可以创建的类变成了以下几种：类，Trait，case class，枚举，单例类

其中类对应Java中的普通类，Trait对应接口，case class类对应record类（或者说Java的record类对应案例类，因为推出时间更晚），枚举和单例类就不多说了

Trait和接口最大的区别是Java早期接口不可以有字段参数和方法的默认实现，而在Scala的Trait中这一问题得到了解决，Scala对于Trait的定义就和Trait（特性）的名字一样，是一些特性的集合，所有继承Trait的类都具有Trait中的特性

而case class则是Scala对于数据类（一些用来承载一些字段/状态的类）的思考，在Java中，如果一个类作为数据类，那么我们往往要重写他的toString equals 等方法，虽然Lombok包可以使用注解的形式解决这个问题，但这毕竟不是语言层面上的解决方案

case class是Scala在语言层面提供的解决方案，它自带比较（equals的作用），复制（copy方法）和toString方法

同样的，Kotlin你可以创建的类是：类，接口，数据类，枚举类，注解，对象（其实就是单例，IDEA中用的是用来定义单例类的关键字的object的直译）

其中data class就类似Scala中的case class 而接口则类似Trait，但是由于Kotlin正式版发布的时候Java正式版（Java 8/9）中已经引入了很多Scala中Trait的思想，所以这里仍然使用的接口作为名字

从Scala和Kotlin的创建中我们不难发现，他们都渴望一种更加方便于开发者的类：

- 接口 == 一些特性的体验，进而减少abstract class的使用
- 数据类在语言层面的实现，排除Lombok这种外界包对语言的影响
- 单例对象在语言层面的实现，排除开发者由于自身水平不足无法编写好的单例类以及过多的样板代码（boilerplate）

## 表达式代替语句

Java中的语句类似于C/C++语言（statement-based），这是因为在Java推出的年代C/C++语言是市面上最火的语言，这使得C/C++程序员可以很轻松的入门Java

而在Scala和Kotlin中，他们则选择了一种面向表达式的编程范式，这是一更符合函数式的编程范式，在原本的语句中，我们的代码大多是带有副作用的，因为这就是语句的意义，通过副作用来影响外界，但是在面向函数的编程中，我们则是希望尽可能的减少代码的副作用，因此我们会希望各种结构带有返回值
### Scala

#### 判断结构

```scala
@main def main(): Unit = {  
  val a=1  
  val b=if (a<3){  
    a+1
    1  
  }else{  
    2  
  }  
}
```

我们可以看出判断语句是自带返回值的，返回值可以直接写在代码块的最后一行，表示其作为返回值

这也是为什么Scala中没有三目表达式的原因，因为不需要，你可以使用if-else语句很自然的写出三目表达式

```scala
val a=true
val b=if(a) 1 else 2
```

#### 循环结构

for语句基于一个可以被遍历的类实例

```scala
val ints=List(1,2,3)
for(item <- ints){
	println(item)
}
```

其中 i <- ints 这一部分被称之为生成器，故名思意就是用来产生item这个元素的

由于for表达式的特殊性（你无法很明确的得知返回值的具体类型及数量），Scala没有直接将for表达式化，而是采用 `yield` 关键字来实现for的表达式

```scala
val ints=List(1,2,3)
val list=for(item <- ints)yield{
	item
}
```

与判断语句if一样，代码块的最后一行就是返回值，最后返回值会是一个列表

你也可以获取带下标的循环

```scala
val myList = List("A", "B", "C", "D")

for ((element, index) <- myList.zipWithIndex) {
  println(s"索引: $index, 元素: $element")
}
```

**除此之外就是Scala for的两个强大的语法了——守卫和多生成器**

我们先来看一下守卫，其实就是C语言中for对i判断的写法的增强

```scala
val list = for (  
  item <- ints  
  if item > 1  
) yield {  
  item  
}
```

守卫的作用就是对生成器中产生的数据进行一个判断

再然后是多生成器

```scala
@main def main(): Unit = {

  val ints1 = List(1, 2, 3, 7, 8, 9)
  val ints2 = List(4, 5, 6)

  for(
    i <- ints1;
    j <- ints2;
    if i < j
  ){
    print(s"${i+j} ")
  }
  //运行结果为 5 6 7 6 7 8 7 8 9 
}
```

根据结果我们不难看出，这其实就是执行了一个双重循环，并且在双重循环的过程中都执行了以下守卫的内容

由此我们就可以实现多守卫多生成器

得益于Scala对解构语法的支持，我们还可以对map使用for

```scala
val map = Map(1 -> "one", 2 -> "two", 3 -> "three")  
  
for((num, str)<-  map){  
  println(s"$num -> $str")  
}
```

也可以这样玩

```scala
@main def main(): Unit = {

  val map = Map(1 -> "one", 2 -> "two", 3 -> "three")

  val stringToInt = for ((num, str) <- map) yield {
    println(s"$num -> $str")
    str -> num
  }

  print(stringToInt) 
  
  //Map(one -> 1, two -> 2, three -> 3)
}
```

**至于循环结构中的另一种——while，则是基本和Java一样，因此这里就不提了**

细心的小伙伴们可能会发现，Scala中没有break和continue，这是因为Scala并不提倡使用这两个关键字，因为对于函数式编程来说，如果你要是用break或是continue，那么最好的选择是使用递归函数+if替代

除此之外，Scala确实引入了一个break函数用来解决break的缺失，但是并不提倡使用

#### 匹配结构

类似Java的switch Scala也有自己的匹配结构——match，他功能更加强大

```scala
val i =1 
val str = i match {
  case 0 => "Sunday"
  case 1 => "Monday"
  case 2 => "Tuesday"
  case 3 => "Wednesday"
  case 4 => "Thursday"
  case 5 => "Friday"
  case 6 => "Saturday"
  case _ => "invalid day"   // 除了上述外的其他值,default语句必须在最后一行，且default语句一旦出现则后面的语句无法抵达
}
```

然后就是对于缺省值的使用 

```scala
val i =1 
val str = i match {
  case 0 => "Sunday"
  case 1 => "Monday"
  case 2 => "Tuesday"
  case 3 => "Wednesday"
  case 4 => "Thursday"
  case 5 => "Friday"
  case 6 => "Saturday"
  case what => s"this is $what"   // 除了上述外的其他值
}
```

但是值得注意的是，缺省值必须使用小写字母开头的变量定义，这就造成了缺省值和变量的冲突，因此Scala中强制如果要在match语句中引入外界变量，则要使用大写字母开头的变量

```scala
val i =42
val N = 42
val n=42
i match {
  case 0 => println("1")
  case 1 => println("2")
  case N => println("42")  //会匹配到这里
  case n => println(s"You gave me: $n" )
}
```

当然，模式匹配也是支持守卫的

```scala
val i =42
val N = 42
val n=42
i match {
  case 0 => println("1")
  case 1 => println("2")
  case N if N>42 => println("42") //左脑搏击右脑
  case n => println(s"You gave me: $n" ) //会匹配到这里
}
```

Scala的match表达式对case class 有着极好的支持，因此你可以这样写代码

```scala
case class Person(name: String,age:Int)

def speak(p: Person) = p match {
  case Person(name,_) if name == "Fred" => println(s"$name says, Yubba dubba doo")
  case Person(name,_) if name == "Bam Bam" => println(s"$name says, Bam bam!")
  case _ => println("Watch the Flintstones!")
}

speak(Person("Fred",1))      // "Fred says, Yubba dubba doo"
speak(Person("Bam Bam",2))   // "Bam Bam says, Bam bam!"
```

在这个代码中我们可以看出守卫模式的意义，在这种复杂的匹配中守卫的作用就很大了

然后值得一提的是Scala的match还支持或的形式

```scala
val i=1
i match{
	case 1|2|3|4 => println("small")
	case 5|6|7 => println("big")
	case _ => println("none")
}
```

最后就是Scala match的逆天功能性了，这里就简单的复制一下Scala Book中的内容

```scala
def pattern(x: Matchable): String = x match {

  // 常规匹配
  case 0 => "zero"
  case true => "true"
  case "hello" => "you said 'hello'"
  case Nil => "an empty List"

  // 列表元素匹配
  case List(0, _, _) => "一个0开头长度为3的List"
  case List(1, _*) => "一个1开头且长度不固定的List"
  case Vector(1, _*) => "一个1开头且长度不固定的Vector"

  // 元组匹配
  case (a, b) => s"got $a and $b"
  case (a, b, c) => s"got $a, $b, and $c"

  // 字段匹配
  case Person(first, "Alexander") => s"Alexander, first name = $first"
  case Dog("Zeus") => "found a dog named Zeus"

  // 类型匹配
  case s: String => s"got a string: $s"
  case i: Int => s"got an int: $i"
  case f: Float => s"got a float: $f"
  case a: Array[Int] => s"array of int: ${a.mkString(",")}"
  case as: Array[String] => s"string array: ${as.mkString(",")}"
  case d: Dog => s"dog: ${d.name}"
  case list: List[?] => s"got a List: $list"
  case m: Map[?, ?] => m.toString

  // the default wildcard pattern
  case _ => "Unknown"
}
```

### Kotlin

Kotlin在设计上很大程度的吸取了Scala的经验，但是去掉了一些过于繁重的功能

#### 判断结构

与Scala类似，Kotlin的判断语句也是表达式的形式，因此你也可以这样写

```kotlin
val i=1  
val a= if(i==1) 1 else 2
```

#### 循环结构

也是与Scala类似

```kotlin
val list=mutableListOf(1,2,3)  
for(item in list){  
    println(item)  
}
```

如果你想要下标可以使用 `withIndex` 方法

```kotlin
val list=mutableListOf(1,2,3)
    for((index,item) in list.withIndex()){
        println("$index - $item")
    }
```

当然也少不了Map

```kotlin
val list=mutableMapOf(
    1 to "one",
    2 to "two",
    3 to "three"
)
for((index,item) in list){
	println("$index - $item")
}
```

**但是Kotlin中的for循环并不支持返回值，也就是说Kotlin的for循环是纯粹的语句而无表达式的形式**

至于continue和break，Kotlin则是进行了保留，并且使用了独特的标签语0法进行了功能上的增强

```kotlin
loop@ for (i in 1..100) {
    for (j in 1..100) {
        if (……) break@loop
    }
}
```

对于方法而言，你可以直接使用方法名作为标签

```kotlin
listOf(1, 2, 3, 4, 5).forEach {
        if (it == 3) return@forEach // 局部返回到该 lambda 表达式的调用者——forEach 循环
        print(it)
}
// 打印结果为1245
```

这里的return@forEach 实际上起到的是类似正常循环结构中的continue的功能，如果你要实现真正意义上的break可以这样写

```kotlin
run loop@ {
        listOf(1, 2, 3, 4, 5).forEach {
            if (it == 3) return@loop // 局部返回到该 lambda 表达式的调用者——forEach 循环
            print(it)
        }
    }
```

#### 匹配结构

Kotlin中的匹配基于when关键字，他和Scala一样也是一个表达式

```kotlin
val a=1
val b=when(a){
	1 -> 2
	else -> print("null")  //这里返回的类是Unit
}
```

比较特别的是Kotlin中的when可以没有主语（也就是小括号的那一部分），如果去除之后就是一个类似if的功能

```kotlin
val message = when {
    a > b -> "a is greater than b"
    a < b -> "a is less than b"
    else -> "a is equal to b"
} //这里必须要注意的是，如果没有主语，那么必须存在else
```
## 类似Builder的传参形式

《Effective Java》第三版的第二条提到当构造方法的参数过多时应该使用builder模式，这是因为当参数过多时，你很难按照构造方法规定的顺序去将参数一一对应的传入，这一点也适用于一些参数较多的方法（当然，当一个方法的参数较多时，我们就应该考虑是否要将他拆分为两个方法并且使用lambda/方法参数的方式来将其进行优化，虽然Java中对于这一块的支持并不是很好）

在Kotlin和Scala中，这一问题得到了优化，我们可以通过参数名=的方式进行优化

```kotlin
fun main() { 
    val person = Person(name="CoteNite", age =  21)  
}  
  
data class Person(  
    val name: String,  
    val age:Int  
)
```

```scala
@main def main(): Unit = {  
	val person = Person(name = "CoteNite", age = 21)
}  
case class Person(name: String,age:Int)
```

除此之外，你还可以通过为参数设置默认值的方式来决定其是否必须被传入

```scala
@main def hello(): Unit = {
  test(value="hello")
  test(value="hello", value2="world")
}

def test(value:String,value2:String=""): Unit = {
  println(s"$value $value2")
}
```

## 语法层面的单例实现

单例模式是一种很优秀的设计模式，我们会经常使用单例模式来实现一些工具类

在Java中，你要实现单例模式是有些困难的，因此Scala和Kotlin内置了单例模式

```scala
@main def hello(): Unit = {  
  Util.add(1)  
}  
  
object Util {  
  def add(num:Int): Int = num+1  
}
```

```kotlin
fun main() {  
    Util.add(1)  
}  
  
object Util{  
    fun add(num: Int): Int = num+1  
    }
```

## 基于函数式实现的try-with-resource

在《Effective Java》第三版的第九条中提倡使用try-with-resource语法来代替try-finally语法，try-with-resource 是Java中的一个极其实用的语法糖，他的诞生是为了取代使用try-final来实现Closeable类的自动关闭

```java
public static void main(String[] args) throws IOException {  
    try(FileInputStream fis = new FileInputStream("d:/a.txt");){  
        //一些代码  
    }  
}
```

但是这种写法更像是一种面向过程的写法，在Scala和Kotlin中，他们认为这种写法或许应该有所改变

在Scala和Kotlin中取消了这种形式，并且两者各有不同

Scala中使用Using类来实现try-with-resource，这是一种函数式的实现方式，在Scala的世界里，它会将一个Closeable的类定义为当前代码的上下文

```scala
Using(new BufferedReader(new FileReader("d:/a.txt"))){reader =>  
   
}
```

而在Kotlin中，则更加方便，Kotlin提供了一个use方法，只需要对Closeable类使用其use方法就可以实现try-with-resource

```kotlin
fun main() {  
    BufferedReader(FileReader("d:/a.txt")).use { it ->  
		    
	    }  
    }
```

