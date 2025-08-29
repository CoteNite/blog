# Spring Event——Spring内置的事件驱动方案

事件驱动是很多小伙伴都听说过的，我们将一切接收到的前端请求理解为一个事件，然后我们根据事件的不同交给其对应的处理器（handler）

这样的好处是可以让你的代码耦合度降低（因为取消了类和类之间的相互引用的直接调用，进而转化为了事件发出者和事件接受者之间的关系）

一般这样的流程需要我们通过设计模式来进行实现，但Spring为我们内置了这套组件，让我们只需要使用简单的注解就可以实现

## 最小实例

对于事件驱动，最小的实现只需要三个部分——事件，事件发出者，事件接收者

那么我们先来定义一个事件（一个简单的Java Bean）

```java
@Data  
@RequiredArgsConstructor  
public class OpenDoorEvent {  
    private final String event;  
    private final String time;  
}
```

然后就是