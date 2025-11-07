## Kotlin核心编程读书笔记

:::tip
本文为Kotlin核心编程一书的读书笔记，推荐大家购买本书进行阅读学习
:::

## 基础语法

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