# RAG工程

## 简介

**RAG（Retrieval-Augmented Generation）** 又名检索增强生成，是一种将外部的知识输入给大模型，然后让大模型根据输入的知识来进行回答的工程

**关键部分：**
- 索引：将非结构化文档（PDF/Word /Markdown等）进行切片，然后通过嵌入模型（Embedding Model）转化为向量数据