# Prompt工程

总所周知，大模型的核心能力是next token prediction，即给定上文，推断出下一个token，而Prompt就是我们这里的上文

Prompt功能之所以有效，是因为LLM在实际生产中出现了一个惊人的能力————In-Context Learing（ICL，上下文学习）

虽然上下文学习为什么会出现在学术届仍有争议，但是ICL的结论是一样的：“Prompt的内容和格式直接决定了模型的行为”，这就是Prompt工程的理论基础

## Prompt的工程价值层级

| 层级  |                                技术                                |    适用场景    | 实现复杂度 |
| :-: | :--------------------------------------------------------------: | :--------: | :---: |
| 基础  |        Zero-Shot（零样本，对于生产意义不大）, <br>System Prompt（系统级提示词）        | 简单问答、格式控制  |   低   |
| 进阶  |    Few-Shot(少量样本，即Prompt中给出你想要的结果),<br> Output Format（规定输出格式）    |  分类、抽取、翻译  |   中   |
| 推理  | CoT（Chain of Thought，主动让AI思考）,<br> Self-Consistency(多次采样，获取最优答案) |  数学、逻辑、代码  |   中   |
| 高级  |      ToT（思维树）,<br> ReAct(重思考),<br> Structured Output(结构化输出)      | 复杂推理、Agent |   高   |

## 模型设置

在进行Prompt之前，我们首先要先了解以下模型设置，在使用大模型API的时候，我们可以同v过设置一些参数来让大模型尽可能的给到我们想要的结果

![image.png](https://raw.githubusercontent.com/CoteNite/Blog_img/master/blogImg/20260504183321.png)
![image.png](https://raw.githubusercontent.com/CoteNite/Blog_img/master/blogImg/20260504183330.png)


- temperature：温度，或者可以理解成情感指数，当该参数越高时，AI会更加具有创意的进行回答，较为适合文学创作，当temperature较低时，AI会更加严谨的回答，比较偏向于工程操作
- Top-p：AI回答的范围，如果你将数设置的越小，AI将会在越有限/相关的内容进行回答，如果你将参数设置的较大，AI会在更加广泛/偏差的内容进行回答
- Max Length：最大回复Token数
- **Frequency Penalty**：重复度惩罚，尽可能让AI在后续的Token中不生成前面重复的内容
- **Presence Penalty**：重复度惩罚，但是和Frequency Penalty的惩罚机制不同，Presence Penalty的惩罚机制是认为重复十次的Token和重复两次的Token收到的惩罚是一样的此设置可防止模型在响应中过于频繁地生成重复的词。 如果您希望模型生成多样化或创造性的文本，您可以设置更高的 `presence penalty`，如果您希望模型生成更专注的内容，您可以设置更低的 `presence penalty`。

在使用过程中，temperature和Top-p一般只修改一个，Presence Penalty和Frequency Penalty一般也只修改一个

## Zero-Shot Prompt————零样本提示

所谓的零样本提示，就是不加篇幅的进行提示，**直接给模型一个指令，不提供任何示例**，我们平日里写的大部分的Prompt都是Zero-Shot Prompt

一个常见的Zero-Shot Prompt的示例

```text
将以下文本翻译成英文： 今天天气很好，我想去公园散步
```

现代的大模型经过SFT和RLHF对齐之后，基本上可以用Zero-Shot解决用户在现实中遇到的大部分问题

Zero-Shot的效果高度依赖模型本身，其优势显而易见，就是容易书写，但同样的，他也有很多的问题：

- **非标准任务**：模型在预训练中没有见过类似模式的任务（如自定义的分类体系）
- **精确格式要求**：需要严格遵循特定的输出格式（如 JSON Schema）
- **复杂推理**：需要多步推理的数学或逻辑问题——模型倾向于直接给出答案而非逐步推导，导致错误率高

## 让AI思考起来

在2022年，Takeshi Kojima提出了一个发现，那就是在Prompt的末尾加上一句“Let‘s think step by step”（让我们一步步思考）可以有效的降低AI回答问题的错误率

再加上了这句Prompt后，AI会展开推理过程：“首先...然后...因此...”，每一步的输出都为下一步的推理提供了内容，显著降低了错误绿

这个过程让**中间推理步骤作为”工作记忆”被写入上下文，为后续推理提供了额外的信息**，这也是自回归语言模型的特性所致，即每一个token的生成都依赖于前文

Zero-Shot-CoT 揭示了 LLM 的一个根本性质：**模型的推理能力受限于生成步数，而非模型大小**。让模型”说出”推理过程，本质上是增加了推理的”计算步数”——每个生成的 token 都是一次额外的前向传播，都能进行一步推理。这就是为什么”思维链”能显著提升推理任务的性能，思考模式往往会得到更好的结果




