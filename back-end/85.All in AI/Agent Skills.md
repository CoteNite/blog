# Agent Skills

[Agent Skills官方文档](https://agentskills.io/what-are-skills)

Agent Skills最初是`Authrpic`为Claude开发的技术，希望能够通过这一技术来拓展Claude的工作边界，但后来由于其较强的能力被VSCode等众多平台使用，在这一情景下，`Authrpic`决定将AgentSkills以一种类似MCP的标准发布出来，使其作为通用的协议来进行使用

## What is Agent Skills

要说什么是Agent Skills，我们不妨先来看一个已经实现好的Agent Skills的案例

[Anthropics的Skills仓库](https://github.com/anthropics/skills/blob/main/skills/skill-creator/SKILL.md)

上面这个是Anthropics的Skills仓库，我们可以通过其基本内容看到Agent Skills的样子

这样的一个`skill-creator`这样的一个文件夹，就是一个Agent Skills，我们关注的重点就在于这个文件夹下的内容


![image.png](https://raw.githubusercontent.com/CoteNite/Blog_img/master/blogImg/20260306104159.png)


这就是一个Agent Skills的基本目录重点在于SKILL.md,Scripts，assets和references

Agent Skills正是通过这些文件实现的对于LLM基模的功能拓展

## Why Agent Skills

Agent Skills提供了一种更加便捷的提供工具的模式，通过对SKILL.md，scripts，assets和references的调用，以一种简单的，不依赖外部中间件的方式实现了简单的类似Tools和Rag的功能

### 对比MCP

MCP的重点实则在于联网，也就是让渡出Tools的开发权力，让服务提供商去向外提供服务，我们只需要调用MCP即可

而就目前阶段，Agent SKills还是要基于下载到本地来使用，所以本地使用Agent Skills还要查看是否存在其scripts下的环境

### 对比RAG

RAG提供的是一种基于外部数据库（即向量数据库）的对海量文本进行查找的功能，实现了大型文本库的知识获取和长期记忆系统的实现

Agent Skills则是提供的较短的文本的知识，其提供的知识本质来源于reference下，且是对内容的全部注入，整个过程较为简单

## SKILL.md

SKILL.md是Agent Skills的元数据文件，其内部描述了Agent Skills所能提供的功能和基本信息

SKILL.md文件最上方有一个元数据层，里面包含了当前skill的基本信息，这些内容会在对话的过程子一并发给LLM

一次对话的流程：

1. 用户发起对话，Agent将内容与所有的AgentSkill元数据发送给LLM
2. LLM会选择自己本次要使用的Skill
3. Agent将完整的SKILL.md文件与内容发送给LLM
4. LLM将总结后的内容发送给用户


这就是Agent Skills的核心机制之一：**按需加载**，在按需加载的设定下，Token的消耗变得极为节约

对于SKILL.md文件，最上方必须写一组元数据，其必填内容为

```markdown
---
name: skill-name
description: A description of what this skill does and when to use it.
---
```

name和description组成了SKILL.md的基本信息，我们的LLM也是根据这个信息寻找的内容

除此之外还包含几个可选的字段

|     Field     | Required |            Constraints             |
| :-----------: | :------: | :--------------------------------: |
|     name      |   Yes    | 最多64个字符。仅限小写字母、数字和连字符。不得以连字符开头或结尾。 |
|  description  |   Yes    |    最多1024字符。非空的，描述技能的作用以及何时使用。     |
|    license    |    No    |          许可证名称或捆绑许可文件的引用。          |
| compatibility |    No    |   最多500字符。表示环境需求（预期产品、系统包、网络访问等）   |
|   metadata    |    No    |          任意键值映射以获取额外元数据。           |
| allowed-tools |    No    |     该技能可使用的预先批准工具的空间限定列表。（实验性）     |

当我们需要使用别的文件时，我们一般采用这样的写法

```markdown
See [the reference guide](references/REFERENCE.md) for details.

Run the extraction script:
scripts/extract.py
```

## Scripts

Agent Skill支持通过编写scripts来实现一些简单的工具，工具的实现一般依赖于我们本地服务的运行环境，常见的有Python、Bash 和 JavaScript

我们应该在SKILL.md文件中声明好需要的环境（比如直接写明“依赖于Node.js 18+”），当然，我们也可在SKILL.md文件中的`compatibility`字段中写明（使用字段的好处是可以让LLM对当前的环境进行判断）

我们可以这样在SKILL.md中写明如何引用脚本

```markdown
## Available scripts

- **`scripts/validate.sh`** — Validates configuration files
- **`scripts/process.py`** — Processes input data
```

然后再告诉Agent这个脚本该如何运行

![image.png](https://raw.githubusercontent.com/CoteNite/Blog_img/master/blogImg/20260306161415.png)

scripts下的脚本要求具有自包含性，即不依赖外部库就可以独立运行，在这种情况下我们需要寻找合适的方式运行脚本

对于JS脚本来说，使用Bun进行运行或许是一个不错的选择，因为Bun默认找不到 `node_modules` 目录时，会自动安装缺失的包。导入路径中直接的针位版本

```markdown
#!/usr/bin/env bun

import * as cheerio from "cheerio@1.0.0";

const html = `<html><body><h1>Welcome</h1><p class="info">This is a test.</p></body></html>`;
const $ = cheerio.load(html);
console.log($("p.info").text());
```

```markdown
bun run scripts/extract.ts
```

对于Scripts的要求，我们会希望用户能够输出足够多合理的信息，不论运行错误与否

## Reference

reference下是一些SKILL.md中未能涉及的数据，这样的分层机制主要还是为了减少Token的使用

reference可能包含以下的数据：

- `REFERENCE.md` - 详细技术参考
- `FORMS.md` - 表单模板或结构化数据格式
- 域特定文件（`finance.md`、`legal.md` 等）

## Assets

assets文件夹下包含的是一系列的静态资源，包含

- 模板（文档模板、配置模板）
- 图片（图示、示例）
- 数据文件（查找表，模式）

在作用上与reference一致，即提供补充的数据，区别在于assets中的内容不限于md文档

## skill-creator

[authropics官方出品的用于创建Skills的Skills](https://github.com/anthropics/skills/tree/main/skills/skill-creator)

我们可以使用这个工具快速的让AI帮我们创建Skills

## Agent Skills的使用

由于AgentSKills现在已经成为了一个统一的协议，因此AgentSkills的使用具有普适性

以cursor为例，我们只需要在项目的根目录下放置.agents文件夹，并在下方放置我们的agentSkills即可正常使用我们的AgentSkills

以上述的agent-skills-creator为例子，我们将其放置到项目根目录下的./agents文件夹下，然后对cursor进行提问，就能发现cursor正在尝试使用这个agent skills



