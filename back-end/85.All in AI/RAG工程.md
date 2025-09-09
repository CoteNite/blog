# RAG工程

## 参考文档

[ALL in RAG](https://datawhalechina.github.io/all-in-rag/#/chapter2/05_text_chunking)

## 简介

**RAG（Retrieval-Augmented Generation）** 又名检索增强生成，是一种将外部的知识输入给大模型，然后让大模型根据输入的知识来进行回答的工程

**关键部分：**

- 索引：将非结构化文档（PDF/Word /Markdown等）进行切片，然后通过嵌入模型（Embedding Model）转化为向量数据存入向量数据库中
- 检索：通过用户输入的需求，搜索出最具关联性的文档片段、
- 生成：让LLM结合检索出的内容生成对话

## 加载与分块

### 加载

首先我们面临的问题就是如何将非结构化的文档解析为结果化的内容，这里我们选用Spring整合的[Apache Tika](https://tika.apache.org/)作为我们的工具

```kotlin
implementation("org.springframework.ai:spring-ai-tika-document-reader")
```

```kotlin
@Test  
fun contextLoads() {  
    val path="D:\\workspace\\study-demo\\rag-study\\src\\main\\resources\\Prompt.pdf"  
    val resource = PathResource(path)  
    val reader = TikaDocumentReader(resource)  
    val documents = reader.get()  
  
    if (documents.isNotEmpty()){  
        val chunk = documents[0]  
        println("文档内容——————${chunk.text}")  
        println("元数据——————${chunk.metadata}")  
    }  
}
```

最新版本中需要通过text来获取解析的文本，metadata是文件除了内容外的其他数据

### 分块

为了更好的检索效果和