
# 认证设计——OAuth

[阮一峰老师的OAuth博客-1](https://www.ruanyifeng.com/blog/2014/05/oauth_2_0.html)

[阮一峰老师的OAuth博客-2](https://www.ruanyifeng.com/blog/2019/04/oauth_design.html)

![image.png](https://raw.githubusercontent.com/CoteNite/Blog_img/master/blogImg/20260405223440.png)


OAuth是一个开放的网络**标注**，目前在全球范围得到了广泛的应用，现在最新的版本是2.1，主流版本是2.0（也就是我们常说的OAuth2.1和OAuth2.0）

OAuth的核心作用为第三方登录，也就是我们在使用软件的时候经常看到的Google登录或是Github登录

要了解OAuth的话就必须先了解一些概念

- Third-party application:第三方应用，也可以理解成所谓的客户端。即使用第三方登录的那一端
- Http Service：Http服务提供商，也可以理解为服务端，即第三方登录中的那个第三方
- User Agent：用户代理，可以简单的理解为浏览器
- Authorization Server：认证服务器，即服务端提供的专门用来进行第三方认证的服务器
- Resource server：资源服务器，即服务端存放用户生成的资源的服务器，它与认证服务器，可以是同一台服务器，也可以是不同的服务器。

OAuth在客户端和服务端中间设置了授权曾
