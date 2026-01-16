# Nginx——必备代理服务器

在小型项目中，Nginx其实主要和前端有关，但是由于大多前端不会Nginx，所以公司中很有可能是让前端将dist文件夹传给后端，然后后端去部署Nginx

## 代理

Nginx最主要的一个作用就是进行反向代理
### 正向代理与反向代理

所谓正向代理和反向代理是针对部署位置的，如果是在客户端（也就是用户的电脑上）进行代理（将信息代理到某个指定的服务器上），就是作为正向代理；如果是在服务端上，将用户请求的信息代理到不同的端口/IP，就是进行的反向代理

## 基本使用

nginx配置文件为conf文件下的nginx.conf

```text
    server {
        listen       80;   #监听端口
        server_name  localhost; #ip地址  
    }
```

**启动nginx**

```sh
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

