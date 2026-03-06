# Agent Skills

Agent Skills最初是`Authrpic`为Claude开发的技术，希望能够通过这一技术来拓展Claude的工作边界，但后来由于其较强的能力被VSCode等众多平台使用，在这一情景下，`Authrpic`决定将AgentSkills以一种类似MCP的标准发布出来，使其作为通用的协议来进行使用

## What is Agent Skills

要说什么是Agent Skills，我们不妨先来看一个已经实现好的Agent Skills的案例

[Anthropics的Skills仓库](https://github.com/anthropics/skills/blob/main/skills/skill-creator/SKILL.md)

上面这个是Anthropics的Skills仓库，我们可以通过其基本内容看到Agent Skills的样子

这样的一个`skill-creator`这样的一个文件夹，就是一个Agent Skills，我们关注的重点就在于这个文件夹下的内容


![image.png](https://raw.githubusercontent.com/CoteNite/Blog_img/master/blogImg/20260306104159.png)


这就是一个Agent Skills的基本目录重点在于SKILL.md,Scripts和references

Agent Skills正是通过这些文件实现的对于LLM基模的功能拓展

## Why Agent Skills

Agent Skills提供了一种更加便捷的提供工具的模式，通过SKILL.md，scripts和references三者的调用，以一种简单的，不依赖外部中间件的方式实现了简单的类似Tools和Rag的功能

### 对比MCP

MCP的重点实则在于联网，也就是让渡出Tools的开发权力，让服务提供商去向外提供服务，我们只需要调用MCP即可

而就目前阶段，Agent SKills还是要基于下载到本地来使用，所以本地使用Agent Skills还要查看是否存在其scripts下的环境

### 对比RAG

RAG提供的是一种基于外部数据库（即向量数据库）的对海量文本进行查找的功能，实现了大型文本库的知识获取和长期记忆系统的实现

Agent Skills则是提供的较短的文本的知识，其提供的知识本质来源于reference