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

在了解`JEP 515`和`JEP 514`之前，我们有必要提前了解以下他们基于的另一个提案——JEP 483

#### [JEP 483 提前类加载和链接（AOT缓存）](https://openjdk.org/jeps/483)

JEP 483提出，目前基于JIT的编译模式会在每次编译前扫描大量的类并进行处理，这一过程尽管经过了许多的优化，但在运行一个服务端业务时可能还是要经历几秒到几分钟的编译时间（可以联想一下你使用Spring写的服务端项目）

在这个过程中JVM会处理许多的工作，其中包含：

-  扫描大量的JAR文件，并读取解析数千个类文件到内存中

-  将解析后的类数据加载到类对象中并将其链接在一起，以便类可以使用彼此的API，这一过程涉及到字节码的验证和对符号引用的解析，并且可能涉及到lambda的实例化

-  执行类的静态初始程序（static代码块），创建许多对象，甚至进行一些IO操作（比如运行日志系统）

Project Leyden团队精准的发现了在同一程序的多次启动的执行过程中存在大量重复的步骤：扫描相同的 JAR 文件，读取、解析、加载和链接相同的类，执行相同的静态初始化函数，以及使用反射配置相同的应用程序对象，于是JEP 483 提出希望通过配置专门的缓存文件来让JVM编译时缓存一部分类，以便在后续启动的时候进行使用

现在你可以在程序运行前通过配置一些基本的AOT配置，然后进行训练运行，就可以生成AOT缓存，在有了AOT缓存的情况下，JVM 通常在程序运行第三步时执行的读取、解析、加载和链接工作被提前到了第二步，因此，程序在第三步启动速度更快，因为缓存中的类可以立即使用。

#### [JEP 514 提前命令行人体工程学](https://openjdk.org/jeps/514)

JEP 483提出后，Project Leyden及时的发现最初设想的缓存方案存在问题，为了创建AOT缓存需要执行两次Java指令，这不方便也不符合逻辑，此外AOT缓存的残留文件也很不方便，他只是一个开发时需要的文件，再生产环境应该丢弃。

JEP 514，正如他的名字一样，创建了一种更加符合人体工程学的AOT缓存方案，使得创建AOT缓存只需一步

#### [JEP 515 提前编译方法分析](https://openjdk.org/jeps/515)

JEP 515指出，HotSpot在JIT的过程中会尝试寻找热点方法，并尝试将热点方法编译为原生代码，这样就提高了热点方法的使用速度。

但是这个过程存在一个先有鸡还是先有蛋的问题：即应用程序只有在其方法行为被预测到时才能达到最佳性能，而方法行为只有在应用程序运行了相当长一段时间后才能被预测。

为了实现预热的目的，JVM选择的方案是在应用运行初期投入一定的资源去收集和剖析数据来解决这些问题，这也就是为什么预热阶段你的程序运行的会相对较慢，因为这时你的热点方法还没有转换成原生方法，且有部分资源被投资到了预热的过程中

基于JEP 483提出的缓存理论，JEP515进一步拓展：将热点方法的分析数据进行缓存，进而减少下次启动过程中寻找热点方法的时间与资源消耗

上面三个JEP的关系也可以简单的理解为:

- **JEP 483**：缓存类加载和链接的结果（解决冷启动慢的问题）

- **JEP 514**：让 **JEP 483 的使用方式更方便**

- **JEP 515**：缓存热点方法的分析数据（解决预热慢的问题）

### [JEP 511 模块导入声明](https://openjdk.org/jeps/511)

早年间我们想要一次导入一个模块内的所有代码会使用类似下面的语句

```java
import java.util.*
```

而在Java 9之后，模块化定义模式允许将一系列高度相关的包定义为一个模块（module），一个标准的module中包含的包应该高度内聚，围绕着一个功能前进

比如现在我们要同时使用 `List` 、 `Map` 、 `Stream` 和 `Path`这几个类，老的写法是引入

```java
import java.util.*;
import java.util.stream.*;
import java.nio.file.*;
```

而这些包在Java 9中已经被归属到 java.base模块中

因此JDK提供了一种新的导入模式

```java
import module java.base;
```

**同时新的导入模式还解决了歧义的问题**

老的导入

```java
import com.a.Date; 

public class Main{
	public static void main(String args[]){
		com.b.Date date=new Date(); //如果要引入同名类
	}
}
```

但现在你只需要类似这样的写法

```java
import moudle com.a;//假设A所属的模块
import com.b.Date;

public class Main{
	public static void main(String args[]){
		Date date=new Date(); //会使用import com.b.Date
	}
}
```

### [JEP 513 灵活的构造函数](https://openjdk.org/jeps/513)

再老的Java程序中（<JDK22），子类的构造函数强制要求父类的构造函数必须在其构造函数的第一行，也就是类似

```java
public class Person {  
  
    private String name;  
    private int age;  
  
    public Person(String name, int age) {  
        this.name = name;  
        this.age = age;  
    }  
}

public class Employee extends Person{  
  
    public Employee(String name, int age) {  
        super(name, age);  
        //剩余的代码
    }  
}
```

但是这样不够灵活，JEP 513中提出一个例子，比如雇员的年龄都要超过18岁，这时如果你想要对年龄进行校验，那么必须要在父类构造函数之后，但是如果校验结果失败，抛出异常，那么就代表之前对父类构造函数的调用是没必要的

这是我们不想看到的情况

除此之外，JEP 513中还举了这么一个例子

```java
class Person {

    ...
    int age;

    void show() {
        System.out.println("Age: " + this.age);
    }

    Person(..., int age) {
        if (age < 0)
            throw new IllegalArgumentException(...);
        ...
        this.age = age;
        show();
    }

}

class Employee extends Person {

    String officeID;

    @Override
    void show() {
        System.out.println("Age: " + this.age);
        System.out.println("Office: " + this.officeID);
    }

    Employee(..., int age, String officeID) {
        super(..., age);        // Potentially unnecessary work
        if (age < 18  || age > 67)
            throw new IllegalArgumentException(...);
        this.officeID = officeID;
    }

}
```

这个代码的结果是什么？你可能希望是 `Age: 42` ，或许还有 `Office: CAM-FORA` ，但实际上它打印 `Age: 42` ， `Office: null` ，这是因为父类的构造函数全部都发生于officeID的赋值之前，但是父类调用函数时却可以调用到子类被重写的函数，因此就会出现这个令人意外的结果，在《Effective Java》第19条中也明确的提到“不要再构造函数中调用可以被重写的函数”。

总而言之，老的构造方法模型是不安全且不灵活的，因此我们必须要求一种新的构造方法模型

这也就是JEP513提出的新构造方法

现在我们允许在父类的构造方法前书写代码了，我们可以将父类构造方法前的代码称为前言，父类构造方法后的代码称呼为结尾

那么现在就是这样样子

```java
class Employee extends Person {

    String officeID;

    @Override
    void show() {
        System.out.println("Age: " + this.age);
        System.out.println("Office: " + this.officeID);
    }

    Employee(..., int age, String officeID) {
        //前言
        super(..., age);
        //结尾
    }

}
```

而新的模型的创建方式如下

```text
Person 前言
    --> Employee 前言
        --> Object 对象的构造方法
    --> Employee 结尾
Person 结尾
```

这样的写法可以避免上述我们提到的重写问题，我们现在只需要这样书写我们的构造函数

```java
class Employee extends Person {

    String officeID;

    @Override
    void show() {
        System.out.println("Age: " + this.age);
        System.out.println("Office: " + this.officeID);
    }

    Employee(..., int age, String officeID) {
       if (age < 18  || age > 67)
            throw new IllegalArgumentException(...);
        this.officeID = officeID;
        super(..., age);        // Potentially unnecessary work
    }

}
```

现在打印的结果就是`Age: 42,officelID: xxx` 因为我们已经提前的将OfficialID注入到了子类中

::: warning 注意
**除此之外还有一些值得关注的在Java21——Java24中已经完成与交付，可以作为正规语法的JEP**
:::

### [JEP 485 流收集器](https://openjdk.org/jeps/485)

JEP 485 对老的Stream API进行升级，希望让开发者能够享受到更加便捷的Stream。

在老的Stream流中存在一个问题，那就是我们的处理方法基本都是1-0..1的形式，然而实际业务中经常会出现n-m的映射形式，为了解决这个问题JEP 485引入了新的API——Stream.Gather

内置的Gather函数如下：

| 名称              | 对应  | 功能                                                                                        | 使用场景          |
| --------------- | --- | ----------------------------------------------------------------------------------------- | ------------- |
| `fold`          | 多对一 | 将多个元素进行处理得到一个元素，通过多个元素间两两进行函数运算实现，两个入参的值分别为：1.使用lambda提供一个用于与第一个元素进行计算的值 2.两两计算式的lambda函数 | 平均值、总和、计数、最大值 |
| `scan`          | 一对一 | 将该元素和其前一个元素进行函数操作，返回一个操作结果，两个入参与上方一样                                                      | 前缀和、累积乘积、费式数列 |
| `mapConcurrent` | 一对一 | 并发的对每一个元素执行lambda的内容，两个参数分别为并发数的上限和要执行的并发lambda                                           | 下载、读档、图片运算    |
| `windowFixed`   | 多对多 | 将指定个数的元素转化为一个List，从上一个list的最后以一个值截断（即所有List应该不含相同元素），当元素不够时则返回一个不够指定个数大小的元素，入参为指定个数的大小    | 批次处理、缓冲区读取    |
| `windowSliding` | 多对多 | 将指定个数的元素转化为一个List，但每次只从第一个使用的元素那里截断，直到List中包含最后一个元素，入参为指定个数的大小                            | 移动平均、局部最大值    |

`windowFixed`和windowSliding区别的参考代码：

```java
System.out.println(Stream.of(1, 2, 3, 4,5,6,7)  
        .gather(Gatherers.windowFixed(5))  
        .toList()); 
//结果为[[1, 2, 3, 4, 5], [6, 7]]
```

```java
System.out.println(Stream.of(1, 2, 3, 4,5,6,7)  
        .gather(Gatherers.windowSliding(5))  
        .toList()); 
//结果为[[1, 2, 3, 4, 5], [2, 3, 4, 5, 6], [3, 4, 5, 6, 7]]
```

### [JEP 467 MarkDown格式的JavaDoc](https://openjdk.org/jeps/467)

现在JavaDoc 支持MarkDown格式了👏👏👏

### [JEP 456 未命名变量和模式](https://openjdk.org/jeps/456)

JEP 456 明确的指出开发人员有时会声明一些他们不打算使用的变量，这可能是出于代码风格考虑，也可能是因为语言在某些特定情况下需要声明变量。那么在这种情况下，语法上提供一种好的方式来让用户不给这个无用的变量命名，或许能够在一定程度上减少b'j'a
