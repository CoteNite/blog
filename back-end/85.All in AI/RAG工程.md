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

由于嵌入模型上下文的限制以及为了更好的检索效果，我们必须要对检索到的文档进行分块，每个块包含了原文档的部分文本。

**好的分块策略？**

一个块中应该包含单独的语义与功能，比如一个软件包含简介，使用方法和开发者教程，那么这三个部分理应在不同的块中，这样才能保证检索出的分块语义单一，能更好的被大模型使用

**块是不是越长越好？**

既然都这么问了，那肯定就不是了，但为什么呢？这要从嵌入模型的原理说起

嵌入模型基于Transformer 编码器，其工作时大抵有三个重要的步骤

1. 分词：将文本块拆分为独立的Token
2. 向量化：将每一个Token都生成一个高维的向量表示
3. 池化：通过某种方法将所有的Token**压缩**为**一个单一的向量**，这个向量将代表了整个文本块的含义

而上面的压缩过程中就必然存在着信息的损失，而越长的文本块包含的语义就越多，语义越多化作单一向量的时候损失的信息肯定越多（语义被模糊化了），进而也就导致检索的精度降低了。

同时过长的文本块输入到大模型的上下文中也会导致大模型的幻觉，**有研究表明，当大模型处理的上下文特别长时，他会倾向于记住开头与结尾的内容，忽略中间的内容**，同时，过长的上下文也会带来大量无关的噪声，进而导致产生幻觉

### 分块策略

目前Java生态中对文档的切分没有像py那种完善的生态，大部分都是相对简单的切分方式

以下是Langchain4j中对文档切分的接口分类

LangChain4j has a `DocumentSplitter` interface with several out-of-the-box implementations:

- `DocumentByParagraphSplitter`
- `DocumentByLineSplitter`
- `DocumentBySentenceSplitter`
- `DocumentByWordSplitter`
- `DocumentByCharacterSplitter`
- `DocumentByRegexSplitter`
- Recursive: `DocumentSplitters.recursive(...)`

从名字中我们不难看出他们的切分规则

而Spring AI中则是提供了一个`TokenTextSplitter`作为切分器，他会尝试在合适的断点（句号、问号、感叹号或换行符）中进行切分

```kotlin
@Test  
fun contextLoads() {  
    val path="D:\\workspace\\study-demo\\rag-study\\src\\main\\resources\\Prompt.pdf"  
    val resource = PathResource(path)  
    val reader = TikaDocumentReader(resource)  
    val documents = reader.get()  
  
    val splitter = TokenTextSplitter()  
    val splitDocuments = splitter.apply(documents)  
  
    splitDocuments.forEach {  
        println("chunk————${it.text}")  
        println("Metadata————${it.metadata}")  
    }  
  
}
```

除此之外，Spring AI还提供了一个`MetadataEnricher`用于让大模型根据切片内容为文本生成元数据，也是一种提高检索准确度的不错的模式

## 嵌入模型

嵌入模型用于将信息（文档，自然语言，音频，图片等）转化为数学上的向量表述

所谓嵌入就是指将每一个词、每一段话、每一张图片都放在一个巨大的多维空间里，并给它一个独一无二的坐标。这个坐标就是一个向量，它“嵌入”了原始数据的所有关键信息。这个过程，就是 Embedding。

那么为什么嵌入模型和向量能帮助我们来做rag呢？

首先，我们的