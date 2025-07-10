# Shell脚本编写

在公司中后端往往会与服务器打交道，一些任务使用单行命令或者Java代码编写其实是较为复杂的，因此学习Shell脚本对于后端程序员也是格外重要的

## 创建一个Shell脚本

在你的Linux文件夹下使用vim编辑器创建一个文件，输入

```shell
#!/bin/bash  [这个是Linux一般存放shell执行程序的位置]
```

然后:wq 文件名.sh就可以创建一个shell脚本，接着使用

```shell
chmod +x yourfilename
```

将其转换为可执行文件，再使用

```shell
./youfilename
```

就可以执行这个脚本
