# Agent Skills

Agent Skills最初是`Authrpic`为Claude开发的技术，希望能够通过这一技术来拓展Claude的工作边界，但后来由于其较强的能力被VSCode等众多平台使用，在这一情景下，`Authrpic`决定将AgentSkills以一种类似MCP的标准发布出来，使其作为通用的协议来进行使用

## What is Agent Skills

要说什么是Agent Skills，我们不妨先来看一个已经实现好的Agent Skills的案例

[Anthropics的Skills仓库](https://github.com/anthropics/skills/blob/main/skills/skill-creator/SKILL.md)

上面这个是Anthropics的Skills仓库，我们可以通过其基本内容看到Agent Skills的样子

这样的一个`skill-creator`这样的一个文件夹，就是一个Agent Skills，我们关注的重点就在于这个文件夹下的内容


![image.png](https://raw.githubusercontent.com/CoteNite/Blog_img/master/blogImg/20260306104159.png)


这就是一个Agent Skills的基本目录重点在于SKILL.md,Scripts和references

SKILL.md是Agent Skills官方标准所要求的所要求的文件，内含这个Agent Skills所必备的内容，也是**作为一个Agent Skills唯一必须包含的一个文件**

