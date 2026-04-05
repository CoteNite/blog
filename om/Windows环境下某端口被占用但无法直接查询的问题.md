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

根据查阅资料得知，Windows的Hyper-V会强制占领一些端口，这是因为Windows认为

