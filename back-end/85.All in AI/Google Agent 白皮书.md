# Google Agent 白皮书

[中文版出处](https://arthurchiao.art/blog/ai-agent-white-paper-zh/)

[英文原版](https://drive.google.com/file/d/1oEjiRCTbd54aSdB_eEe3UShxLBWK9xkt/view?pli=1)

## Agent是什么

简单的来说Agent就是一个基于大模型的应用程序，核心功能是在大模型的调配下使用各种工具实现大模型无法完成的各种功能，当前Agent的核心功能是根据自然语言完成各种复杂的工作

### 组件

当前的大模型由model，tool，orchestration三个层次组成

![image.png](https://raw.githubusercontent.com/CoteNite/Blog_img/master/blogImg/20260325163440.png)

### 模型（model）

模型即LLM，也就是Agent中用于进行运转的核心部分，可以对整个系统机型调用，模型可以是一个或者多个，可以是通用的也可以是多模态的，这也是我们系统的大脑

### 工具（Tool）

由于大模型只擅长文字的理解，解析和生成，而我们又希望大模型可以真正的实现我们需要的功能，因此就产生了工具，工具就是为大模型提供外部内容操作的东西，正是工具才让大模型向Agent发生了转变

### 编排层（orchestration）

编排层描述了一个循环过程，就是Agent如何接受信息并且完成内部推理，并用推理的内容指导其进行下一步的行动和决策，这个循环的结束是Agent完成了其目标或触发了终止条件，编排层的复杂程度和Agent的执行的任务直接相关，如果简单的任务其编排就会很简单，但复杂的任务就需要复杂的编排

##