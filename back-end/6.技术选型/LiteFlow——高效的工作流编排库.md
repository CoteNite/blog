# LiteFlow——高效的工作流编排库

最近公司有一些工作流相关的任务，让我提前学习一下，最近把他的文档看了一下，也算有些理解，这里写下和大家一同分享

## LiteFlow的意义

LiteFlow旨在简化工作流的实现复杂度，这里我们需要先了解工作流是什么

![image.png](https://raw.githubusercontent.com/CoteNite/Blog_img/master/blogImg/20260610210252.png)

像上图中（官网图）这样的流程图就是一个工作流，我们可以使用原始的方法调用的方式实现，但是这样会导致代码的高度耦合，于是我们就尝试使用别的方式来降低耦合度，这就是工作流

在LiteFlow种，我们将上图中的节点定义为Node，图的整体结构则由XML进行编排，最终在代码中通过FlowExecutor来进行链的调用

## 节点的实现

在LiteFlow中，所有的节点全部继承自