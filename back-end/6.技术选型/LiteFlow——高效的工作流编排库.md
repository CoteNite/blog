# LiteFlow——高效的工作流编排库

最近公司有一些工作流相关的任务，让我提前学习一下，最近把他的文档看了一下，也算有些理解，这里写下和大家一同分享

## LiteFlow的意义

LiteFlow旨在简化工作流的实现复杂度，这里我们需要先了解工作流是什么

![image.png](https://raw.githubusercontent.com/CoteNite/Blog_img/master/blogImg/20260610210252.png)

像上图中（官网图）这样的流程图就是一个工作流，我们可以使用原始的方法调用的方式实现，但是这样会导致代码的高度耦合，于是我们就尝试使用别的方式来降低耦合度，这就是工作流

在LiteFlow种，我们将上图中的节点定义为Node，图的整体结构则由XML进行编排，最终在代码中通过FlowExecutor来进行链的调用

## 基本配置

[去官网导入最新的依赖](https://liteflow.cc/pages/9bf6be/)

然后简单的配置一下yaml文件，这里主要是让Spring知道我们的XML文件在resource文件下的哪个位置
## 节点的实现

在LiteFlow中，所有的节点全部继承自NodeComponent类，这个抽象类中存在必须要实现的方法process，这个方法中定义了节点在当前处应该如何执行

在SpringBoot环境下，我们需要使用LiteFlowComponent注解来将其注册为SpringBean，只有注册为SpringBean才可以让我们的Spring来托管我们的节点，同时方便的使用Spring的任务管理

```kotlin
import com.yomahub.liteflow.annotation.LiteflowComponent  
import com.yomahub.liteflow.core.NodeComponent  
  
@LiteflowComponent("b")  //这里的b是节点的名字，必须要定义
class BCmp : NodeComponent(){  
    override fun process() {  
        println("This is B CMP")  
    }  
}
```

值得一提的是，LiteflowComponent注解继承自Component，这也就表明我们的节点本质就是一个Component

根据节点类型的不同LiteFlow实现了多种不同的节点类，我们都可以通过继承来实现我们需要的节点，具体内容参考[文档](https://liteflow.cc/pages/8486fb/)

另外，我们还可以使用[声明式组件](https://liteflow.cc/pages/46f0fa/)的方式来定义节点，官网提到这种方式的出现是为了解决Java只能单继承的问题，即节点实现占用了唯一的继承位置（当然，我们可以手写中间类来实现继承的传递，不过这就有些麻烦了）

声明式组件取消了使用继承来实现节点，而是使用注解来实现，不过这一过程会带来大量的注解参数配置，同时方法级的节点声明有违开闭原则，因此若非必要不推荐使用

## EL规则

EL规则是LiteFlow用于实现图整体编排的方法，

