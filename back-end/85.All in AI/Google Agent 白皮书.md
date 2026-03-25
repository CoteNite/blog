# Google Agent 白皮书

[中文版出处](https://arthurchiao.art/blog/ai-agent-white-paper-zh/)

[英文原版](https://drive.google.com/file/d/1oEjiRCTbd54aSdB_eEe3UShxLBWK9xkt/view?pli=1)

## Agent是什么

简单的来说Agent就是一个基于大模型的应用程序，核心功能是在大模型的调配下使用各种工具实现大模型无法完成的各种功能，当前Agent的核心功能是根据自然语言完成各种复杂的工作

### 组件

当前的大模型由model，tool，orchestration三个层次组成

![image.png](https://raw.githubusercontent.com/CoteNite/Blog_img/master/blogImg/20260325163440.png)

#### 模型（model）

模型即LLM，也就是Agent中用于进行运转的核心部分，可以对整个系统机型调用，模型可以是一个或者多个，可以是通用的也可以是多模态的，这也是我们系统的大脑

#### 工具（Tool）

由于大模型只擅长文字的理解，解析和生成，而我们又希望大模型可以真正的实现我们需要的功能，因此就产生了工具，工具就是为大模型提供外部内容操作的东西，正是工具才让大模型向Agent发生了转变

#### 编排层（orchestration）

编排层描述了一个循环过程，就是Agent如何接受信息并且完成内部推理，并用推理的内容指导其进行下一步的行动和决策，这个循环的结束是Agent完成了其目标或触发了终止条件，编排层的复杂程度和Agent的执行的任务直接相关，如果简单的任务其编排就会很简单，但复杂的任务就需要复杂的编排

### Agent和Model的区别

为了更清楚地理解 Agent 和模型之间的区别，这里整理个表格，

|**特征**|**模型 (Model)**|**智能体 (Agent)**|
|---|---|---|
|**知识范围**|知识仅限于其 **训练数据**。|通过工具连接外部系统，能够在模型自带的知识之外，实时、动态 **扩展知识**。|
|**状态与记忆**|**无状态**。每次推理独立，除非外部提供会话历史或上下文管理。|**有状态**。自动管理会话历史，并根据编排自主决策进行多轮推理。|
|**原生工具**|无。|有。自带工具集成或具备原生对工具的支持能力。|
|**原生逻辑层**|无。需借助提示词工程或推理框架（CoT、ReAct 等）指导预测。|有。拥有原生认知架构，内置 CoT、ReAct 等推理框架或 LangChain 等编排框架。|

由此我们不难看出，大模型是一个连“大脑”可能都没有办法完全算的上的东西，而Agent则是成为了一个可以真正完成任务的“人”

## 认知架构：Agent 是如何工作的

Agent的整个流程就是**规划 —— 执行 —— 调整**的循环

1. 首先接受用户的信息
2. 规划步骤，思考自己应该使用哪些工具
3. 对其计划进行执行

在以上的过程中，Agent会根据不同的情况进行调整，比如执行到某个阶段时，大模型发现工具无法正常使用，或者执行的结果不满足用户的需求，就会进一步的调整和完善整个计划，这就是一个**信息接收、规划、执行和调整（information intake, planning, executing, and adjusting**）的循环

Agent实现这样的架构是通过**认知架构**实现的，认知架构处理信息，做出决策，并且根据前一轮的输出调整下一个行动，如此循环迭代实现最终的目的

- 在 Agent 中，认知架构的核心是**编排层，负责维护记忆、状态、推理和规划（memory, state, reasoning and planning）**
- 它使用快速发展的**提示词工程及相关框架**（prompt engineering and associated frameworks)来**指导推理和规划**，使 Agent 能够更有效地与环境互动并完成任务
### 主流技术

当前主流的推理框架和推理技术有一下几种：

- ReAct： [(Reasoning + Acting)](https://react-lm.github.io/)，大语言模型以交错的方式生成推理痕迹和任务特定动作。通过在思考（“思维”）和行动（“行动”+“观察”）之间交替，模型解决复杂任务，与外部工具互动，并提升可信度，也是目前最主流的推理框架，已经证明 ReAct 优于几个 SOTA 基线
- CoT：Chain-of-Thought，通过中间步骤实现推理能力，CoT包含多种技术，包括自我一致性、主动提示和多模态 CoT，适合不同的场景
- ToT：Tree-of-Thoughts，非常适合探索或战略前瞻任务。概括了链式思考提示，并允许模型探索各种思考链，作为使用语言模型解决问题的中间步骤

### ReAct案例

让我们来看Agent在ReAct系统下的一个完整的的执行流程

1. 用户向Agent发送查询
2. Agent开始ReAct sequence
3. Agent提示模型，要求其生成下一个ReAct步骤及相关的输出
	1. 问题：提示词+用户输入的问题
	2. 思考：模型的想法/下一步应该做什么
	3. 行动：模型的决策，即下一步要采取什么样的行动，这里就是引用工具的地方，例如行动可以是\[Flights, Search, Code, None] 中的一个，前三个代表模型可以选择的已知工具，最后一个代表“无工具选择”
	4. 行动的输入：模型决定是否要向工具提供输入，如果需要提供的话要提供哪些输入
	5. 观察：行动/行动输入的序列的结果，根据需要，这个思考/行动/行动输入/观察（**`thought / action / action input / observation`**）可能会重复 N 次。
	6. 最终答案：模型返回对原始用户查询的最终答案
4. ReAct循环结束，将最终答案返回给用户

![image.png](https://raw.githubusercontent.com/CoteNite/Blog_img/master/blogImg/20260325174221.png)

上图就是一个完整的ReAct的流程

总的来说，Agent的响应质量与模型的推理能力和执行能力直接相关，包括选择正确工具的能力，以及工具自身的好坏，就像厨师做菜关注食客反馈并提升自己一样，Agent依赖于合理的推理和可靠的信息来提供最佳的结果

## 工具：模型通往现实世界的关键

由于众所周知的原因，大模型的能力受限于其训练数据中覆盖的信息，很难感知到现实世界中发生的变化，那么我们该如何赋予大模型与外部交互的能力呢？目前有以下几种方式

- Functions
- Extensions
- Data Stores
- Plugins

这些方式统一称之为**工具**，工具是将大模型和外部连接的桥梁

当拥有了工具后，大模型就有了**和外界进行交互的能力**

### Extensions

简单的讲，extension是一种以**标准化的方式连接API和Agent**的组件，能够让Agent调用外部的API而不考虑API背后是如何实现的

![image.png](https://raw.githubusercontent.com/CoteNite/Blog_img/master/blogImg/20260325183601.png)

如图所示，Extensions告诉了Agent应该如何使用API，并且告诉Agent这个API需要哪些具体的参数，这样Agent就可以根据提供的示例和模型来决定使用哪一个Extension来处理当前用户的对话

Extensions的核心有时在于**built-in example types（内置示例类型）**，允许 Agent 动态选择最适合所执行任务的 extension，如下图所示

![image.png](https://raw.githubusercontent.com/CoteNite/Blog_img/master/blogImg/20260325184046.png)

Agent可以从多个Extension中选择一个或多个符合当前用户需求的Extensions，然后加以使用

### Functions

Functions是一系列的自我完备的函数/工具，和我们自己写的函数一样，只是这次将函数的调用者从软件开发者转变为了模型，我们可以设置一系列的Functions，然后让Agent决定在何时使用何种Functions

Functions与Extensions的区别在于模型只输出函数名和参数信息，但不会执行函数，函数由客户端进行执行，与之相对的是Extensions则是在服务提供商的服务器上进行执行

![image.png](https://raw.githubusercontent.com/CoteNite/Blog_img/master/blogImg/20260325184629.png)
