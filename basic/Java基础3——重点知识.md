# Java基础3——重点知识

前段时间因为过年休息了一会，最近继续来学我们的八股（过年真是懈怠了啊）。

**这里先祝大家新年好啊，祝各位都能offer拿到手软，薪资心满意足！！！**

## 值传递

### 两种传递模式

1. 值传递：x=1 y=1，此时变化x或y中的一个另一个均不会变化
2. 引用传递：直接传参数的地址，相当于函数调用的就是这个参数本身

### Java只存在值传递

1. 对于基本类型，**Java根本无法实现引用传递**。

2. 对于对象

   很多初学者会认为Java存在引用传递就是在这里

   ```java
   public class Main {
       public static void main(String[] args) {
           Person p1=new Person("a",1);
           Person p2 =new Person("b",2);
   
           change(p1,p2);
   
           System.out.println(p1);
           System.out.println(p2);
       }
   
   
       public static void change(Person pt1,Person pt2){
           pt1.setName("a1");
           pt2.setName("a2");
       }
   }
   ```

   ![image-20250201184056755](C:\Users\29543\AppData\Roaming\Typora\typora-user-images\image-20250201184056755.png)

   这样不是影响到main里了吗，为什么说不是引用传递？

   实际上对于对象，Java传递的是对象的地址。

   即pt1->p1的地址，pt2->p2的地址

   这时你对该地址内的参数操作，只然会影响到p1和p2

   

   另一种情况是这样

   ```java
   public class Main {
       public static void main(String[] args) {
           Person p1=new Person("a",1);
           Person p2 =new Person("b",2);
   
           swap(p1,p2);
   
           System.out.println("======外界=======");
   
           System.out.println(p1);
           System.out.println(p2);
       }
   
   
       public static void change(Person pt1,Person pt2){
           pt1.setName("a1");
           pt2.setName("a2");
       }
   
       public static void swap(Person pt1, Person pt2) {
           System.out.println("======swap内部=======");
           Person temp = p1;
           p1 = p2;
           p2 = temp;
           System.out.println(pt1);
           System.out.println(pt2);
       }
   }
   ```

   

   ![image-20250201184957069](C:\Users\29543\AppData\Roaming\Typora\typora-user-images\image-20250201184957069.png)

我们会发现这次就没有变化了。

因为跟据之前的逻辑，swap方法做的事其实是将pt1指向的地址由p1转化为p2的地址，这一过程对外界没有任何影响

## 序列化

在对**数据结构/对象进行持久化操作亦或是网络传输的过程中**，我们都需要序列化。

### 那么序列化究竟是什么呢

* 序列化：将数据结构/对象转化为可以存储或传输的形式
* 反序列化：将序列化后的数据再次转化为原本的数据结构。对象

### 序列化的形式

可以是二进制，json，xml....

### 序列化协议

序列化协议就是如何将数据结构/对象转化为持久化文件/可被网络传输的文件

常见的方式有转化为二进制，json，xml等

二级制性能差但可读性弱

json等性能但可读性强

### **常见的序列化协议**

JDK自带的方式

让类实现Serializable接口并定义一个static final long serialVersionUID的变量

在反序列化的过程中会先判断反序列化前数据的serialVersionUID与反序列化后的serialVersionUID是否一致，若不一致则抛出InvalidClassException异常。

### **为什么static变量修饰的serialVersionUID会被序列化？**

serialVersionUID经过了特殊处理，会被写入序列化的二进制流中。

### **如何处理不想被序列化的变量？**

使用transient关键字修饰，需要注意的是，基本变量若被transient关键字修饰则反序列化后会变为默认值

### **JDK自带的序列化方式存在的隐患**

1. 被该方式序列化后的对象无法被其他语言反序列化，不利于多语言开发
2. 性能相对其他框架较差
3. 存在安全问题

### **其他方案有哪些？**

Kryo ProtoStuff 等等

## 反射

我们平常写代码时可能很少用到反射，但对于一些轮子项目/框架，那么反射则是最不可获取的。

Spring两大特性（IOC和AOP）都使用到了反射

### 反射可以干什么

通过反射我们可以直接拿到一个类的所有参数，方法，可以直接调用这些方法，或者改变一个类里的参数。

## 代理模式

代理模式本身是编程设计模式的一种，这里单独拿出来是因为代理模式中的动态代理实现方式与反射密切相关，且Spring源码也大量使用到了该模式

### 理念

对于一个接口的实现类，我们可以创建一个代理类（Proxy类），使用代理类来对方法调用前后做一些处理。

**为什么不直接在实现类中添加前后处理？**

代理类本身是用来应付多种不同场景的，比如实现类中定义的方法是通用的，适合任何场景，但跟据场景不同我们所需要做的预处理不同，因此可能需要不同的代理类。

**举个例子**

比如卖东西，卖东西这个过程很简单，买家指明要买的东西，卖家提供东西，买家付钱拿起东西走人。

世界上的买卖基本都是这样，这基本上可以说是一成不变的。

但是假设我们这时一个国际店铺，有许多不同国家的人来买东西，这时买家与卖家之间的交流语言就不同，因此这一过程不能直接将其算在买卖过程中（不统一），需要跟据不同情况单独处理（卖家使用不同语言的翻译机来为用户服务）

**过程**

定义接口，实现类实现接口，代理类实现接口（或者继承实现类），接着代理类通过调用实现类实现接口（或者重写实现类的方法），来完成代理的过程。

**好处**

由于去分出了代理类和实现类

1. 成功实现了代码的高复用（实现类中部分被不同代理类多次使用）
2. 成功提高了代码的优雅度（不用跟据n多种情况定义n多个接口，而是由代理类来帮忙）

### 动态代理

刚才说的方式用最简单的思路写出来就是静态代理，我们这里着重讨论一下动态代理。

**想法**

一些小伙伴可能发现了上面静态代理存在的一些小瑕疵，比如我们对于一个实现类，如果只有少量方法需要被代理，这时使用实现的方式就不太优雅，而使用继承则要使用super来调用父类的方法，有没有其他的解决方案呢？

JDK为我们提供了动态代理的解决方案

**过程**

1. 首先定义接口和实现类是不变的

2. 定义一个处理类并继承InvocationHandler 接口

   ```java
   public interface InvocationHandler {
       public Object invoke(Object proxy, Method method, Object[] args)
           throws Throwable;
   }
   ```

   该接口的引用方法会在你调用方法时使用，需要你传入使用方法的类，方法，以及参数

3. 使用JDK提供的Proxy类来获取代理类

   ```java
   public class Proxy implements java.io.Serializable {
       @CallerSensitive
       public static Object newProxyInstance(ClassLoader loader,
                                             Class<?>[] interfaces,
                                             InvocationHandler h) {
           //.....
       }
   }
   //传入的参数分别为实现类的类加载器，实现类的接口的类，处理类
   ```

4. 使用

   ```java
       public static void main(String[] args) throws Exception{
           SmsServiceImpl target=new SmsServiceImpl();
           SmsService smsService =(SmsService) Proxy.newProxyInstance(
                   target.getClass().getClassLoader(),
                   target.getClass().getInterfaces(),
                   new DebugInvocationHandler(target)
           );;
           smsService.send("java"); //send为接口定义好的方法
       }
   ```

   

通过以上的流程获取道德SmsService即为代理类，每当你使用代理类中的方法时就会执行处理类中的invoke()方法实现预处理

**值得注意的是，JDK提供的动态代理只支持代理实现了接口的类**

若一个类未实现接口还想动态代理，那就要使用开源库**CGLIB**了

### 对比

1. 灵活性：个人认为动态代理更适合接口中方法少且前后处理方式一样的类，若要根据每一个方法的不同实现不同的预处理，则还是推荐静态代理
2. JVM：静态代理在编译时就将接口、实现类、代理类这些都变成了一个个实际的 class 文件。而动态代理是在运行时动态生成类字节码，并加载到 JVM 中的。

## BigDecimal类

BigDeciaml类是Java中用来进行精准计算的一个类

在《AlibabaJava 开发手册》存在不少对BigDecimal类的规定。~~（我猜是因为Alibaba主要是做电商服务的，所以在这数字精确度这一块特别敏感）~~

这一块主要是注意需要高准确性的数值的时候使用BigDecimal类，使用BigDecimal时使用compareTo而不是equalls比较，建议使用String类型创建实例

