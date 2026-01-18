# Nginx——必备代理服务器

在小型项目中，Nginx其实主要和前端有关，但是由于大多前端不会Nginx，所以公司中很有可能是让前端将dist文件夹传给后端，然后后端去部署Nginx

## 代理

Nginx最主要的一个作用就是进行反向代理
### 正向代理与反向代理

所谓正向代理和反向代理是针对部署位置的，如果是在客户端（也就是用户的电脑上）进行代理（将信息代理到某个指定的服务器上），就是作为正向代理；如果是在服务端上，将用户请求的信息代理到不同的端口/IP，就是进行的反向代理

### 基本使用

nginx配置文件为conf文件下的nginx.conf

```text
user root;
worker_processes auto;
error_log /usr/local/nginx/logs/error.log;  #错误日志路径
pid /usr/local/nginx/logs/nginx.pid;

include /usr/share/nginx/modules/*.conf;


events {
    worker_connections  1024;
}


http {

    log_format  main  '$remote_addr - $remote_user [$time_local] "$request" '
                      '$status $body_bytes_sent "$http_referer" '
                      '"$http_user_agent" "$http_x_forwarded_for"';

   #access_log  /usr/local/nginx/logs/access.log  main;  #访问日志路径，可以关掉

    sendfile            on;
    tcp_nopush          on;
    tcp_nodelay         on;
    keepalive_timeout   65;
    types_hash_max_size 2048;
    client_max_body_size 20M;

        
    server {
         #如果根据 listen   server_name  没有匹配到的话，默认使用第一个server
         #可以在listen后面加添加default_server来设置匹配不成功的默认使用的server
        listen       8888;
        server_name  101.31.7.23;  #多个的话可以用空格分隔

       #以下配置是开启gzip压缩的，不需要开启的话，可以去掉，一般建议开启
        gzip on;  #是否开启gzip模块 on表示开启 off表示关闭
        gzip_buffers 4 16k;  #设置压缩所需要的缓冲区大小
        gzip_comp_level 6;  #压缩级别1-9，数字越大压缩的越好，也越占用CPU时间
        gzip_min_length 100k;  #设置允许压缩的最小字节
        gzip_http_version 1.1;  #设置压缩http协议的版本,默认是1.1
        gzip_types text/plain text/css application/json application/x-javascript text/xml application/xml application/xml+rss text/javascript;  #设置压缩的文件类型
        gzip_vary on;  #加上http头信息Vary: Accept-Encoding给后端代理服务器识别是否启用 gzip 压缩
        location /api {
            # proxy_pass 端口后面加路径，该路径就会替换location中的路径，有/也会替换
            #没加路径就只替换访问路径的ip和端口
            proxy_pass http://101.31.7.23:8180/;
        }
        
    }
        
}
```

这里主要看的是server中的内容

- listen：监听的端口，也就是说只要listen的端口遇到请求，Nginx就会进行服务
- server_name：当前服务的IP
- location：如何进行路由转发
	location后面的`/api`其实就是路径，再后面的内容就是转发到哪里
	1. 如果`proxy_pass`最后`http://ip:端口`的形式(比如`http://101.31.7.23:8180`)，则会保留`/api`并将路径拼接上去（即`http://101.31.7.23:8180/api/xxxxx`）
	2. 如果`proxy_pass`最后`http://ip:端口/xxx`的形式(比如`http://101.31.7.23:8180/`或`http://101.31.7.23:8180/`)，则不会保留`/api`，直接拼接路径上去（即`http://101.31.7.23:8180/xxxxx`）

## 动静分离

所谓动静分离，其中动指的是后端的接口，也就是动态返回的信息，静则是指前端打包出来的静态资源，静态资源则包括HTML、JavaScript、CSS和图片等文件

Nginx将动态和静态的内容分开，提高了前后端分离项目的可维护性

### 基本使用

```text
server {
         #如果根据 listen   server_name  没有匹配到的话，默认使用第一个server
         #可以在listen后面加添加default_server来设置匹配不成功的默认使用的server
        listen       8888;
        server_name  101.31.7.23;  #多个的话可以用空格分隔
        location /api {
            # proxy_pass 端口后面加路径，该路径就会替换location中的路径，有/也会替换
            #没加路径就只替换访问路径的ip和端口
            proxy_pass http://101.31.7.23:8180/;
        }
        
        location / {
            root  /home/zcloud/applications/iomp-web; #前端部署目录
            index  index.html index.htm;
        }

        location /images/ {
            alias /home/zcloud/file/;   #静态文件存放目录
            autoindex    off;  #关闭自动索引，开启后用户可以访问目录下的文件（就是一些老的资源站的样子），一般建议关闭
        }
    }
```

主要看后两个location

第一个location表示默认的访问页面，也就是首页，即访问`/`路径时，会找到`/home/zcloud/applications/iomp-web`下的index.html文件，这里写两个就是在这两个文件中找一个，有先用前面的

第二个location就是将`/images/`，的访问内容直接去`/home/zcloud/file/`文件夹下找，这里有root和alias两种区别

- root：去寻找指定目录下的文件
- alias：会将指定的url替换为alias下的路径，再将url后的内容拼接上

举个例子：

请求/images/1.png，root和alias均为`/home/zcloud/file/`

- root：找`/home/zcloud/file/1.png`
- alias：找`/home/zcloud/file/iamges/1.png`

**如果alias的location是/结尾，那alias也必须是/结尾**


## 负载均衡

所谓负载均衡，就是将请求分配给不同的服务，进而提高服务的可用性

### 基本使用

```text
http {

    log_format  main  '$remote_addr - $remote_user [$time_local] "$request" '
                      '$status $body_bytes_sent "$http_referer" '
                      '"$http_user_agent" "$http_x_forwarded_for"';

    access_log  /usr/local/nginx/logs/access.log  main;  #访问日志路径，可以关掉
    
    #轮询的方式
    upstream server_group {
         server 101.31.7.24:8080; #node1
         server 101.31.7.25:8081; #node2
         server 101.31.7.26:8082; #node3      
   }
   
    #加权轮询的方式
  #  upstream server_group {
  #       server 101.31.7.24:8080 weight=3; #node1
  #       server 101.31.7.25:8081 weight=5; #node2
  #       server 101.31.7.26:8082 weight=2; #node3      
  # }
  
    
    #ip_hash的方式，基于客户端IP的分配方式  
  #  upstream server_group {
  #       ip_hash;
  #       server 101.31.7.24:8080; #node1
  #       server 101.31.7.25:8081; #node2
  #       server 101.31.7.26:8082; #node3      
  # }
   #最少连接的方式，把请求分发给连接请求较少的那台服务器
  #  upstream server_group {
  #       least_conn;
  #       server 101.31.7.24:8080; #node1
  #       server 101.31.7.25:8081; #node1
  #       server 101.31.7.26:8082; #node1      
  # }
        
    server {
         #如果根据 listen   server_name  没有匹配到的话，默认使用第一个server
         #可以在listen后面加添加default_server来设置匹配不成功的默认使用的server
        listen       8888;
        server_name  101.31.7.23;  #多个的话可以用空格分隔
        location /api {
            # proxy_pass 端口后面加路径，该路径就会替换location中的路径，有/也会替换
            #没加路径就只替换访问路径的ip和端口
            proxy_pass http://server_group/; #和反向代理一样
        }
    }
```

## 常用命令

nginx一般会在/usr/local/nginx目录下，如果没有则使用nginx -t命令查找

**启动nginx**

```sh
移动到sbin目录下
./nginx
```

**检查nginx配置是否有问题**

```shell
nginx -t
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

