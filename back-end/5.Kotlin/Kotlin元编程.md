# Kotlin元编程

:::tip
本篇为BennyHuo老师的著作《深入理解Kotlin元编程》的读书笔记
:::

## 什么是元编程

所谓元编程，就是操作编程代码的编程，这样说可能很抽象，我们可以先联想一下正常情况下我们的编程是在操作什么，如果是后端开发，那么操作的就是数据，将数据以一种正确的形式返回给消费者，而前端则是操作浏览器，让浏览器可以正确的返回页面的样式给用户。而元编程，就是操作代码，最后生成需要的代码的编程。

元编程最大的意义就是帮助我们消除无用的代码，像是我们最常用的lombok，就是在编译的时刻生成了我们需要的各种方法，同样的，Spring框架核心的AOP底层也是基于元编程实现的

使用元编程编写的程序一般被我们称之为元程序，编写元编程的语言称之为元语言，而被操作的语言称之为目标语言

早在Java5的时候，Java就对元编程在语法层面做出了适配，用来实现元编程的语法称之为**注解**，也被称之为**元编程注解**，同样的反射，APT这些也都属于元编程的范围之内

Kotlin和Java种元编程又分为运行时元编程和编译时元编程，顾名思义，就是在编译时和运行时对代码进行操作，一般运行时元编程是通过反射实现（即调用含有类的反射类的代码实现操作这个类的效果），而编译时元编程就是在编译器进行编译的过程中对编译过程进行干扰，向最终的编译产物中添加我们需要的代码

总之，我们可以将元编程视为一种通过代码生成代码的编程模式

## Kotlin中的元编程

Kotlin编译器在编译阶段会生成一系列的数据结构，包括PSI，FIR，IR。其中PSI，FIR由Kotlin编译器的前端部分处理，.kt文件会先被编译器处理为PSI或FIR，然后再被前端编译器处理成为IR，而不同目标平台的后端编译器会对IR进行进一步编译，以生成我们需要的平台上的代码，比如Kotlin JVM生成的是JVM字节码，Kotlin-JS生成的则是JS代码

由于元编程可以操作编程语言，因此就能使用元编程访问我们代码的任意部分，比如用于生成文档的Dokka就可以访问代码中定义的注释，进而生成更加健全的API文档

我们之前说过，Java/Kotlin中的元编程是基于注解实现的，而注解一般分为源代码可见注解，二进制可见注解和运行时可见注解

:::tip
可见：可以被感知，这里进一步=指会对哪个状态造成影响（因为可见所以才会造成影响）
:::

### 源代码可见注解

这类注解一般会对代码书写（通过IDE提示开发人员）和编译时造成影响，通过对注解类添加@Retention(AnnotationRetention.SOURCE)实现，比较常见的注解就是RequireKotlin注解，这个注解用来提示该注解标记的API所需的最低版本的Kotlin编译器版本，当我们在不正确的编译器版本中使用这个注解，编译器就会直接报错

### 二进制可见注解

二进制可见注解会出现在响编译产物（比如jar包）中，但不会在运行时被感知（也就是说不会对运行起来的代码照成影响），主要通过对注解类添加@Retention(AnnotationRetention.BINARY)实现

Kotlin的空安全就大量的使用了二进制可见注解来兼容Java代码，当Kotlin遇到了被注释为@Nullable的Java代码时就会知道这个部分是可空的，进而在编程过程中使用外部jar包时可以正确的感知出这里是否要用空安全语法

### 运行时可见注解

运行时可见代码是最为常用的注解形式，该注解会出现在编译产物中，并且会对运行时照成影响，适合除于二进制可见的注解的全部使用场景，也可以通过使用反射访问。该注解通过为注解类添加@Retention(AnnotationRetention.Runtime)实现

:::warn
需要说明的是，Kotlin目前只在JVM平台上支持功能完善的反射能力，因此运行时可见的注解的应用场景主要在JVM平台上。
:::

Java知名JSON序列化框架GSON中的@SerializedName就是一个典型的运行时可见注解，在程序运行的过程中，使用到了含有该注解的字段，就会将JSON字符串自然的转化为JavaBean

## 元数据

:::tip
所谓元数据就是关于数据的数据，也就是对于数据进行一些描述/数据的信息
:::

Kotlin有自己的一套元数据设计，用于为编译产物提供完善的Kotlin语法信息，可以说Kotlin中很多便捷的语法都是通过元数据进行实现的

Kotlin编译器会为每一个类文件生成一个@Metadata注解，这个注解中存放了Kotlin的语法信息，同时也会为模块内所有的顶级声明（Top-Level Declaration）生成一个模块专属的元数据文件，这些文件通常以kotlin_module为后缀。

```kotlin
@Retention(AnnotationRetention.RUNTIME)
@Target(AnnotationTarget.CLASS)
@SinceKotlin("1.3")
public annotation class Metadata(
    @get:JvmName("k")
    val kind: Int = 1,

    @get:JvmName("mv")
    val metadataVersion: IntArray = [],

    @Deprecated(
        "Bytecode version had no significant use in Kotlin metadata and it will be removed in a future version.",
        level = DeprecationLevel.WARNING,
    )
    @get:JvmName("bv")
    val bytecodeVersion: IntArray = [1, 0, 3],

    @get:JvmName("d1")
    val data1: Array<String> = [],

    @get:JvmName("d2")
    val data2: Array<String> = [],
    ......
```

里面最关键的就是data1和data2两个字段，其中data1直接存储的二进制字面量，而data2则是存储的data1中使用的类名函数名等字面信息，这样设计主要还是为了方便JVM可以直接将这些两加载到常量池中，方便内存使用

Kotlin的反射本身也是基于@Metadata注解中存储的信息的，例如我们可以通过Kotlin反射直接获取到类的伴生类。

```kotlin
Service::class.companionObjectInstance
```

同样的，由于Kotlin反射基于的是@Metadata注解，因此Java反射无法直接获取一些Kotlin反射能直接获取的内容

在Kotlin JVM中，Kotlin_moudle的文件存储了模块内JVM字节码不支持的一些内容，包括函数，属性，类型别名等，当Kotlin文件最后不含有kotlin_moudle文件的话很可能造成Kotlin编译器无法正常使用引入的Kotlin包

## 语法树

只有语法正确的代码才可以正常的被编译器运行，编译器对语法的检测一般基于内部维护一个抽象语法树来完成，同样的，如果我们想要生成代码，那么也需要依赖于语法树实现

早年间为了快速上线Kotlin的正式版，Kotlin编译器的语法树依赖于了IntelliJ平台的PSI，知道第二代Kotlin编译器（K2）正式登场，Kotlin才有了真正独立的语法树。

APT是Java元编程的重要技术之一，本质上可以理解为是Java编译器为元编程提供的接口，我们可以通过APT直接去访问Java语法树

早期的Kotlin实现了对APT的支持，即KAPT，他将Kotlin代码转换为Java存根，作为Java编译器的输入进而支持APT，但这样实现的弊端也是很明显的，也就是Kotlin高度依赖于Java符号，且Kotlin代码转换为Java存根也要消耗大量的时间，对于大型项目这几乎难以接受。

为了解决这个问题，作为Kotlin基金会核心成员的Google（Kotlin义父）开源了KSP，可以直接将Kotlin代码转换为抽象语法树，这也就解决了KAPT的问题（当前Kotlin已经不建议用户使用KAPT）

