
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

OAuth在客户端和服务端中间设置了授权层（authorization layer），进而使得客户端不能直接登录服务端，只能登录服务端提供的授权层，进而将客户和客户端区分开来，客户端登录授权则需要使用登录授权层赋予的令牌（Token），与用户的密码不同，用户可以在登陆的时候指定授权层的权限范围和有效期

客户端登录授权层以后，服务端根据令牌的权限范围和有效期，向客户端开放用户储存的资料

![image.png](https://raw.githubusercontent.com/CoteNite/Blog_img/master/blogImg/20260405224727.png)

1. 用户打开客户端后，客户端向用户索要授权
2. 用户同意并给予客户端授权
3. 客户端使用上一步获得的授权，向认证服务器申请令牌
4. 认证服务器对客户端进行认证以后，若确认无误，则发放令牌
5. 客户端使用令牌，向资源服务器申请资源
6. 资源服务器确认lin'go'ai
