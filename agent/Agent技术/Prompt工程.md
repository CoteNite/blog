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
- **Frequency Penalty**：AI