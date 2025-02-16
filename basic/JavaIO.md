# JavaIO

## IO？

**IO=Input/Output**即输入输出，数据输入到计算机内存的我们视为Input，输出到外部存储（远程主机/网络，数据库，文件）的我们视为Output，由于这个过程类似水流，因此我们称为IO流。

JavaIO流的40多个类都是从如下 4 个抽象类基类中派生出来的。

* InputStream：字节输入流
* Reader：字符输入流
* OutputReader：字节输出流
* Writer：字符输出流

则四个类又继承了Closeable类，因此建议使用try-with-resource语句

## FileInputStream

FileInputStream类是InputStream类的常用实现类，其主要作用是将文件以字节形式读入内存。

```java
InputStream inputStream=new FileInputStream("hello.txt")  //传入读入文件的路径，相对路径是基于最外层项目文件
```

InputStream的一些方法

* read():读入一个字节，读不到为-1表示结束
* read(byte b[])：一次读数组长度的内容到b数组中，返回读入的字节数量
* read(byte b[], int off, int len)：在上一个的基础上增加了一个偏移量，即从什么地方开始读（从数组下标off开始读len个）
* skip(long n)：跳过n个字节
* avaliable()：返回可读取的字节数
* close()：关闭流

## FileOutputStream

FileOutputStream类是OutputStream类的常用实现类，其主要作用是将字节以文件的形式形式写入外部。

```java
OutputStream outputStream=new FileOutputStream("hello.txt");
```

OutputStream的一些方法

* write(int b):将特定字节写入输出流
* write(byte b[])：将b写入输出流
* write(byte b[], int off, int len)：在上一个的基础上增加了一个偏移量，即从什么地方开始读（从数组下标off开始写len个）
* flush()：刷新此输出流并强制写出所有缓冲的输出字节。
* close()：关闭流

**该过程会删除原本文件中的数据**

## FileReader

FileReader是Reader的实现类，用于将文件中数据以Unicode的形式读入内存

```java
Reader reader=new FileReader("hello.txt");
```

Reader的一些方法

* read()：读一个字符，返回值是int，需要手动转char
* read(char[] c)：将字符读入数组c
* read(char[] cbuf, int off, int len)：偏移读
* skip(long n)：跳过n个字符
* close()：关闭

## FileWriter





