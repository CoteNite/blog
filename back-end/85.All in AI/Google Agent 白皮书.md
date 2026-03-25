# Google Agent 白皮书

[中文版出处](https://arthurchiao.art/blog/ai-agent-white-paper-zh/)

[英文原版](https://drive.google.com/file/d/1oEjiRCTbd54aSdB_eEe3UShxLBWK9xkt/view?pli=1)

## Agent是什么

简单的来说Agent就是一个基于大模型的应用程序，核心功能是在大模型的调配下使用各种工具实现大模型无法完成的各种功能，当前Agent的核心功能是根据自然语言完成各种复杂的工作

### 组件

当前的大模型由model，tool，orchestration三个层次组成

![image.png](https://raw.githubusercontent.com/CoteNite/Blog_img/master/blogImg/20260325163440.png)

### 模型（model）

模型即LLM，也就是Agent中用于进行运转的核心部分