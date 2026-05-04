# Prompt工程

总所周知，大模型的核心能力是next token prediction，即给定上文，推断出下一个token，而Prompt就是我们这里的上文

Prompt功能之所以有效，是因为LLM在实际生产中出现了一个惊人的能力————In-Context Learing（ICL，上下文学习）

虽然上下文学习为什么会出现在学术届仍有争议，但是ICL的结论是一样的：“Prompt的内容和格式直接决定了模型的行为”，这就是Prompt工程的理论基础

## Prompt的工程价值层级

| 层级 | 技术                            | 适用场景       | 实现复杂度 |
|----|-------------------------------|------------|-------|
| 基础 | Zero-Shot, System Prompt      | 简单问答、格式控制  | 低     |
| 进阶 | Few-Shot, Output Format       | 分类、抽取、翻译   | 中     |
| 推理 | CoT, Self-Consistency         | 数学、逻辑、代码   | 中     |
| 高级 | ToT, ReAct, Structured Output | 复杂推理、Agent | 高     |
