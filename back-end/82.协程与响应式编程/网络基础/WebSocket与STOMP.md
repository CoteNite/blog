# WebSocket与STOMP

[STOMP与WebSocket](https://shibd.github.io/message-center-1/#WebSocket%E5%8D%8F%E8%AE%AE)

## WebSocket简介

WebSocket是用于解决服务端和客户端双向通信的问题，其本身基于TCP协议，实现了长连接的功能，其在握手阶段仍然采用Http协议，需要从Http协议升级而来

## STOMP协议

STOMP本身并非为WS设计，他只是一种消息队列的协议，与ASMQ，JMS一样，但其简单的特性恰好可以用来定义WS的消息体的格式

目前很多的消息队列服务都支持了STOMP吗，比如RabbitMQ，ActiveMQ等，很多语言自身也有STOMP的客户端解析库

STOMP只是文本传输协议，不参与通信细节，我们可以将它视为一个简单的消息订阅模式，客户端和服务端都可以推送接受消息，而且它支持灵活的根据url进行消息分发

WebSocket结合STOMP就实现了一个消息队列，服务端和客户端都可以作为生产者和消费者，根据订阅的队列的不哦那个是实现单播，广播和多播（WebSocket是点对点通信，所以广播和多播都只是服务端轮询客户端发送实现的）

## SpringBoot实现WebSocket和STOMP

SpringBoot做了极其方便的STOMP正回家二