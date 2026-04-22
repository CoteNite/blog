# AGENTS.md

[AGENT.md官方文档](https://agents.md/)

[vercel在AGENT.md上的实践](https://vercel.com/blog/agents-md-outperforms-skills-in-our-agent-evals)

AGENTS.md是OpenAI和Google联合退出的一个新标准，其核心作用是为Agent提供一种可预测的方式来理解和操作项目

AGENTS.md可以理解为是给AI看到README文件，其核心价值是让AI更好的理解当前的项目或是使用当前项目

## 为什么需要AGENT.md

### 统一的数据管理

在VibeCoding盛行的时代，我们的每一个AI IDE都会添加上一个.xxx的目录来存放自己需要的东西在项目的根目录下，比如cursor是.cursor，kiro是.kiro，这会极大程度的污染我们的根目录，我们迫切的需要一个统一的标准来放置给agent的信息

AGENT.md就是这个愿景下产生的工具，其核心是实现了对项目的README文件，将整个项目的结构，我希望如何开发，等一系列数据都告诉了Agent

### 可预测的流程

**Agent的发展是不断的规范自己操作流程的过程**

Harness工程告诉我们一个道理：好的Agent重要的不只是模型，而是一个更好的架构

AI对于一些想法有自己的实现方式，他会尝试这个指令，只有失败才会尝试另一种方案

一个典型的例子是我在Windows环境下使用Cursor为我写代码，他会频繁的尝试在powershell中使用`&&`来将两个命令连在一起，但很显然我们知道这是不可能的，而AI也知道这个事情，所以他会在出错后立刻选择另一种方案

这种情况下，我们如果提前告诉AI我们现在运行的环境是Windows，那么AI就不会出现这种错误

另一个案例是skills的使用，众所周知skills采取的是按需加载的方式，Agent会在对话的开始将skill的名字和描述交给AI，但是AI很可能会觉得你的要求并不需要使用这个skills（即时你觉得是需要的），那么AI就会放弃使用Skills而自己进行操作

这个时候，如果我们能提前告诉Agent：在执行xx操作下必须使用xx skills，那么Agent就会使用这个Skills了

## 实践指南

