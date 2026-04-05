# Windows环境下某端口被占用但无法直接查询的问题

随着写代码的时间变长，项目的依赖环境逐渐被Docker来管理，但是最近经常发现一个问题，我在启动某个容器的时候时常会出现

```text
Error response from daemon: Ports are not available: exposing port TCP 0.0.0.0:5432 -> 0.0.0.0:0: listen tcp 0.0.0.0:5432: bind: An attempt was made to access a socket in a way forbidden by its access permissions.
[31mError: Failed to start container[0m
```

简单翻译一下就能知道是这个端口无法使用，于是我直接对端口进行查询

```sh
netstat -ano | findstr :5432
```

结果是没有内容，也就说明这个端口没有被程序占用。。。吗？

根据查阅资料得知，Windows的Hyper-V会强制占领一些端口，这是因为WinNAT（Windows虚拟机的虚拟网络驱动）需要一系列的端口做为出口，将内部的流量映射到外部，而Windows则认为，预期在每个容器启动时去争夺端口，不如在系统启动时，直接通过内核驱动（tcpip.sys）大批量地圈占（Exclude）一部分端口。

但是则就导致Windows圈定的端口是不可控的，我们一旦想要使用某个被他圈定的端口就会出现上面的问题

解决方案也很简单

```sh
net stop winnat 
net start winnat
```

将WinNAT重启，这样系统会释放它当前占用的所有动态端口

当然，为了可以使我们常用的端口避免被占用，也可以使用

```sh
net stop winnat
netsh int ipv4 add excludedportrange protocol=tcp startport=5432 numberofports=1
net start winnat
```

来让5432端口长期不被Hyper-V随机占用

## 为什么
