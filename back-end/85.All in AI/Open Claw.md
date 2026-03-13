# Open Claw

[Hello-Claw](https://datawhalechina.github.io/hello-claw/)

Open claw成为了26年初最火热的项目，作为开发者肯定要第一时间来调研一下（虽然其实已经有些晚了）

## 安装

[HelloClaw的安装教程](https://datawhalechina.github.io/hello-claw/cn/adopt/chapter2/)

类似的教程还有很多，这里就不赘述了

值得一提的是，如果你使用的是Docker构建，且还是建立在WSL环境下，那么大概率会遇到部署上的问题，OpenClaw Gateway会一直重启，这是目前版本的小bug（2026-3），可以在OpenClaw的issue上找到相对应的解决方案，回答者也已经即时提交了PR，相信不久后就会得到修复

## OpenClaw究竟是什么

**OpenClaw是Agent**

这是对OpenClaw最好的诠释，即时OpenClaw核心基于Multi-Agent的思想进行开发，仍然逃脱不开Agent的定义

正如Google Agent白皮书上写的一样：

**宽泛地来说，生成式 AI Agent 可以被定义为一个应用程序， 通过观察周围世界并使用可用的工具来实现其目标**

不论是最近的OpenClaw还是当年的Manus，其本质都是Agent开发的爆火，只是Manus是一个闭源的，运行在云端上的，可定制化低的Agent，而OpenClaw这是一个开源的，可以运行在本地的，高定制化的Agent

这也进一步的说明了目前Agent开发的趋势————让Agent通过电脑来尽可能的完成人可以完成的操作

## OpenClaw的工具

**工具是将基础模型与外部世界连接起来的桥梁**

OpenClaw的强大能力就来源于各种各样的Tools，某种程度上，MCP，AgentSkills都属于广义上的Tools，但是我们一般会将编码在项目内部的Tools称之为Tools

OpenClaw的工具分为四个档次

|    配置档    |          能力范围          |        适用场景        |
| :-------: | :--------------------: | :----------------: |
|   full    |       无限制，所有工具可用       |   推荐——个人电脑上的全能助手   |
|  coding   | 文件读写、命令执行、会话管理、记忆、图片分析 |   开发者专用，不含消息和浏览器   |
| messaging |     消息收发、会话浏览、状态查看     | 纯聊天机器人，不能操作文件或执行命令 |
|  minimal  |         仅状态查看          |   最小权限，几乎什么都不能做    |

网上传的神乎其神的功能本质上就是启动了full权限，我们可以通过下列指令将其修改为full权限

```sh
# 查看当前配置
openclaw config get tools.profile

# 设置为 full（推荐）
openclaw config set tools.profile full
openclaw gateway restart
```

