# Nginx——前端必备反向代理服务器



## 正向代理与反向代理

**正向代理：**  “**代理**” 的是 **客户端**，而且 **客户端**是**知道目标**的，而目标是不知道客户端是通过VPN访问的。

**反向代理：** **代理**” 的是 **服务器端**，间请求**代理到内网**，这一个过程对于客户端而言是透明的。

## 基本使用

nginx配置文件为conf文件下的nginx.conf

```conf
    server {
        listen       80;   #监听端口
        server_name  localhost; #ip地址  
    }
```

**启动nginx**

```shsh
移动到sbin目录下
./nginx
```

**重新加载配置**

```sh
nginx -s reload
```

**关闭nginx**

```sh
nginx -s stop (快速关闭，可能会导致数据未完全保存)
nginx -s quit (安全关闭)
```

**指定配置文件**

```sh
nginx -c filename
```

