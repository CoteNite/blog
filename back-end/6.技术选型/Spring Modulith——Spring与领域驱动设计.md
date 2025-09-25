# Spring Modulith——Spring与领域驱动设计

老的伪MVC的架构模式在现代开发和大型项目开发中已经很难做到维护项目的高内聚低耦合，我们更希望能够通过一种模块化的方式来提高代码的质量。

Spring Modulith 是 Spring 公司出品的，用于帮助开发者更好的实现领域驱动设计的工具。

在Spring Modulith 的帮助/规范下，我们可以写出一种更加高质量的模块化的代码

## 基本使用

Spring Modulith 会自动的帮我们对包进行管理，它默认与启动类相同目录的包是一个模块，且只有模块中最外层的类可以被其他模块调用

![image.png](https://raw.githubusercontent.com/CoteNite/Blog_img/master/blogImg/20250925205237.png)

像这个代码分层中，只有最外层的Order，Product 可以被别的模块调用，这也是我们的聚合根，用来处理业务问题，在跨聚合业务中可能会被别的聚合下的cmd类使用到，因此应该作为该模块唯一被暴露出去的类

同样的，我定义了一个repository包，这个包用于来存放我们的仓储类，由于仓储和我们的具体业务无关，只是单纯的为了存放数据到不同的数据库中，因此也单独被设置为一个模块，我们任何模块的cmd类都可以使用并且调用他

## 访问问题

此时就会引入一个新的问题——如果存在多个数据库的问题

![image.png](https://raw.githubusercontent.com/CoteNite/Blog_img/master/blogImg/20250925210117.png)

那么我们的模块下可能是这样，但是这就导致了我们的仓储无法被领域模块使用

为了解决这个问题Spring Modulith提供了两种解决方案

### 命名接口

```kotlin
@NamedInterface("redisRepository")  
@PackageInfo
class RedisRepository {  
}
```

我们可以使用@NamedInterface+@PackageInfo注解为这个类提供一个名字，在这种情况下，这个类同一个包下的所有类均可被外界访问

### 开放模块

```kotlin
@ApplicationModule(type = Type.OPEN)
@PackageInfo
class MoudleMeta {

}
```

或者也可以像这样，在模块（也就是和启动类同一目录下的包）中放入一个这样的类，这也就表明1了这个模块是开放的，他下面的类可以被其他的模块自由的访问

## 为什么老的代码结构难以实现好的管理

在老的代码中，我们的业务逻辑可能大量的存在与一个Service类中，所有的业务都由Service和Service之间的互相调用完成，而数据类只是承载数据的贫血模型，其除了承载一定的数据之外mei'yo

而在Spring Modulith的要求下，我们强制的只能把少量的类放在模块根目录（比如我们的聚合根），这就要求我们把代码都集中在聚合根中(当然，你也可以把传统意义上的Service类放在最外面，但这也就失去了我们模块化的意义)

而由于我们的业务大部分又存放于Cmd类中，这就表示我们真正能运用的类只有repository类
