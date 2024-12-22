# RocketMQ——来自Alibaba的消息队列

## 为什么要MQ

**MQ：message queue————消息队列**

早期在写项目时也曾用过MQ，但仅仅是用来进行邮件的发送，相信很多小伙伴都和我一样不理解MQ在分布式项目中究竟有何作用，那么这个大名鼎鼎的MQ究竟在分布项目中有何作用呢？

### 解耦

我们都知道，在分布式项目中格外重要的一点就是项目的解耦，那么对于原本mvc架构中一个Service之间的来回调用我们如何实现之间即使的联系呢？

这里我们假设有一个场景

A项目业务完成后可能后面会有B，C，D三种模块执行后续可能的业务，这时我们在不讲代码写在一起的情况下就可以使用MQ，我们可以在A项目完成业务后向消息队列中塞入一个消息，该消息被标记为仅B，C，D中某一指定模块接受，这样我们就完成了项目的解耦

不仅如此，如果BCD是平行的业务（A业务完成后均要执行，且无所谓先后完成顺序）我们也可以用MQ与其广播机制来完成这一操作

### 异步

现在有这么一个场景：

用户去下单购买东西，然后支付宝扣钱，数据库减少商品数量，接着会发送短信提醒用户，然后后端返回给前端购物成功的讯息，前端显示。

在这一场景中，只有短信发送完前端才会显示购买成功，但其实我们知道购买成功这一业务在数据库完成处理后基本就完成了，后面的发送短信的业务只是为了给用户一层安全感。

而在同步系统中，我们只有在短信发送完后才可以在前端显示数据。这是没有必要的，因此我们可以尝试讲数据库之前的部分和短信发送这两块业务分开进行异步处理。

这时我们就可以使用MQ，当我们数据库完成操作后，我们可以向MQ中塞入一条消息，然后就将返回完成购买的信息给前端，而发送短信的业务则实时监听MQ，若发现MQ中存在消息，则取出消息，并跟据消息中的内容发送短息。

### 消峰

还是刚刚的场景

我们将购买和发短信两个业务分别部署在两台不同的服务器上，且购买业务的服务器好于发短信的服务器。

这时突然出现大量的用户进入购买的服务器，很幸运的是我们的购买业务服务器抗住了压力，但是短信业务服务器就没这么好运了。

有没有什么解决方案？

这里我们也可以使用MQ，我们在短信业务消费MQ中消息时设定一个值，让他在保证不崩溃的前提下尽可能多的去消费业务，而未消费的业务信息展示挤压在MQ中。

这样我们就完成了业务的消峰。

## RocketMQ的核心概念

**Broker：**消息队列服务器，队列的存储位置，生产者生产的消息的去处和消费者获取消息的来源。

**Topic/主题：**用于区分一类消息，在分布式项目中往往使用业务来命名区分

**Group/组：**一个消费者或生产者的集合，同一组的生产者或消费者往往生产或消费同一业务的消息

**Tag：**在一个Topic下如果我们还想再次细分，可以使用Tag来区分不同的消费者

****

**Broker与Topic是多对多的关系，一个Broke上可以有多个Topic，一个Topic可以同时存在于多个Broker上，这样有利于集群部署**

****

**NameServer/注册中心：**所有的Broker注册的地方用于管理Broker，接受业务端生成的消息转交给Broker，接受Broker发送的消息给业务端（中介）



## ACK机制——重试机制

**ACK(Acknowledgement Mechanism)**是RocketMQ内置的消息确认机制，RocketMQ通过该机制保证消息的可靠消费

**Producer**

对于生产者来说，ACK机制用于检验消息成功发送到MQ，当MQ成功接受到Producer发送的消息后，MQ会返回给Producer一个ACK讯息，Producer可以跟据该信息做出后续操作（重发或者也可以不等待ACK讯息直接执行后续代码）

**Consumer**

对于消费者来说，ACK机制用于确保消息成功被使用，当消费者消费消息失败时，消息会重新返回原本的队列当中，接着重新发送给Consumer，当在经过一定的次数（默认为16次）的重试后，若Consumer还未成功，则将该消息丢到死信队列中。

**死信队列**

该信息的队列只有写没有读，不能被Consumer重新消费的，只能进行人工干预。

## SpringBoot整合RocketMQ

引入以下依赖

```xml
        <dependency>
            <groupId>org.apache.rocketmq</groupId>
            <artifactId>rocketmq-spring-boot-starter</artifactId>
            <version>2.1.0</version>
        </dependency>
```

配置yml/properties文件

```properties
rocketmq.name-server=127.0.0.1:9876  broker地址
rocketmq.producer.group=my-group  群组
```

```java
@SpringBootApplication
@Import(RocketMQAutoConfiguration.class)  //在SpringBoot3.X版本之后自动引入发生变化，因此必须加上这个注解
public class RocketMqStudyApplication {

    public static void main(String[] args) {
        SpringApplication.run(RocketMqStudyApplication.class, args);
    }

}

```

### Producer

**同步发送**

同步发送即消费者发送完消息后等待MQ返回ACK信息后再执行后续代码

```java
@Slf4j
@Component
public class Producer {
    
    private static final String topic = "RLT_TEST_TOPIC";

    // 直接注入使用，用于发送消息到broker服务器
    @Autowired
    private RocketMQTemplate rocketMQTemplate;
    
    public void send(Order order) { //Order是自己定义的实体类
   		rocketMQTemplate.syncSend(topic + ":tag1", order); //tag若要使用直接在topic后冒号加上即可
    }
}
```

**异步发送**

异步发送即消费者发送完消息后不等待MQ返回ACK信息后就执行后续代码

```java
@Slf4j
@Component
public class Producer {
    
    private static final String topic = "RLT_TEST_TOPIC";

    // 直接注入使用，用于发送消息到broker服务器
    @Autowired
    private RocketMQTemplate rocketMQTemplate;
    
    public void send(Order order) {
   		rocketMQTemplate.syncSend(topic + MessageBuilder.withPayload(msgBody).build(), new SendCallback() {
            @Override
            public void onSuccess(SendResult sendResult) {
                // 处理消息发送成功逻辑
            }
            @Override
            public void onException(Throwable throwable) {
                // 处理消息发送异常逻辑
            }
        });
    }
```

我们发现异步执行由于后续拿到ACK后操作不确定，所以我们这里需要实现一个回调类SendCallback

**发送延时消息**

延时消息即生产者发送完消息后需要等待一段时间才可以被消费者消费，由于该方法仍然是同步调用，所以仍然使用syncSend

```java
@Slf4j
@Component
public class Producer {
    
    private static final String topic = "RLT_TEST_TOPIC";

    // 直接注入使用，用于发送消息到broker服务器
    @Autowired
    private RocketMQTemplate rocketMQTemplate;
    
    public void sendDelayMsg(String msgBody, int delayLevel) {
        rocketMQTemplate.syncSend(topic, MessageBuilder.withPayload(msgBody).build(), 3000, delayLevel);
    }
}
```

**直接发送**

直接发送即消费者发送完消息后忽略MQ返回的ACK信息直接执行后续代码

```java
@Slf4j
@Component
public class Producer {
    
    private static final String topic = "RLT_TEST_TOPIC";

    // 直接注入使用，用于发送消息到broker服务器
    @Autowired
    private RocketMQTemplate rocketMQTemplate;
    
    public void sendDelayMsg(String msgBody) {
      rocketMQTemplate.sendOneWay("orderly_topic", msg);
    }
}
```

**有序发送**

当我们的Topic中存在大量消息时，我们的Consumer其实是乱序获取的Topic中的讯息，这时如果我们想要获得有序的信息，需要生产者生产时进行一定的处理

```java
@Slf4j
@Component
public class Producer {
    
    private static final String topic = "RLT_TEST_TOPIC";

    // 直接注入使用，用于发送消息到broker服务器
    @Autowired
    private RocketMQTemplate rocketMQTemplate;
    
    public void sendDelayMsg(String msgBody) {
        for (int i=0;i<100;i++){
            rocketMQTemplate.syncSendOrderly("orderly_topic", MessageBuilder.withPayload(msg+i).build(),"hashKey");
        }
        return "Orderly Message: '" + msg + "' sent.";
    }
}
```

其中最后一个参数为“select_queue_key”，该参数用于确保这些信息有序（底层实际为发送到Topic下的同一个Queue中）

### Consumer

```java
    @RocketMQMessageListener(topic = "自定义的topicName",selectorExpression = "自定义的tag",consumerGroup = "自定义的用户群",messageModel = MessageModel.BROADCASTING)
    public class ConsumerSend implements RocketMQListener<Order>{
        @Override
        public void onMessage(Order order) {
            //处理收到消息后的逻辑
            log.info(order.toString());
        }
    }
```

相对Producer，Consumer就简单很多，我们只需要标注RocketMQMessageListener注解并实现RocketMQListener即可

**RocketMQListener的泛型：**接受消息的类型

**OnMessage方法：**如何处理消息

**RocketMQMessageListener：**将类标记为消费者，topic指定topic，selectorExpression指定tag，consumerGroup指定消费者群，messageModel为监听类型（集群/普通，广播）

其中topic和consumerGroup为必要，当selectorExpression未标记tag且messageModel不为广播模式时，不允许两个消费者topic一样（同时取的bug）

## RocketMQ解决分布式事务

**特别鸣谢：[RocketMQ常见问题总结 | JavaGuide](https://javaguide.cn/high-performance/message-queue/rocketmq-questions.html#rocketmq-如何实现分布式事务)**

### 什么是分布式事务？

分布式事务完全是一个人为制造出来的不可规避的情景，当我们使用分布式架构时，由于存在多台服务器和多个数据库，且服务器间存在相互调用，那么就会出现下列情况。

用户——>A业务（完成，写入数据库）——>B业务（失败，回滚）。

这样就导致A和B两台数据库的数据不一致。

最常见的例子就是购买物品，付款成功（A），但是由于负责库存的服务器寄掉（B），导致未能即使减去库存。

### RocketMQ的解决方案

RocketMQ 中使用的是 **事务消息加上事务反查机制** 来解决分布式事务问题的。

这里需要了解一个概念

**半消息：**消费者可以发送一个半消息，将备份原消息的主题与消息消费队列，然后 **改变主题** 为 RMQ_SYS_TRANS_HALF_TOPIC。由于消费组未订阅该主题，故消费端无法消费 half 类型的消息，**然后 RocketMQ 会开启一个定时任务，从 Topic 为 RMQ_SYS_TRANS_HALF_TOPIC 中拉取消息进行消费**，根据生产者组获取一个服务提供者发送回查事务状态请求，根据事务状态来决定是提交或回滚消息。

![img](https://oss.javaguide.cn/github/javaguide/high-performance/message-queue/16ef38798d7a987f.png)

当A接受到用户信息后

1. A会先向MQ发送同步消息，等待MQ回复ACK讯息，若未等到MQ回复，说明MQ出现问题，后续代码不执行，保证安全

2. MQ存储半消息后返回ACK给Producer、表明半消息发送成功，此时A执行后续业务，**这里需要在数据库记录日志，用于后续复查**

3. S：A后续代码若成功执行则向MQ发送confirm指令，此时会将消息放入他原本应该去的Topic等待消费者消费

   F：A后续代码若未成功执行，则回查，通过回查我们在2中是否将日志存储进去判断事务是否正常执行

**ATTENTION**

在 `MQ Server` 指向系统 B 的操作已经和系统 A 不相关了，也就是说在消息队列中的分布式事务是——**本地事务和存储消息到消息队列才是同一个事务**。这样也就产生了事务的**最终一致性**，因为整个过程是异步的，**每个系统只要保证它自己那一部分的事务就行了**

```java
public class TestService{
    
}
```
