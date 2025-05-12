# Java集合

## ArrayList的动态扩容机制

每次在原有的基础上扩大到原来的1.5倍

1. 先计算扩大到1.5倍之后的大小，再看是否超过了最大限制
2. 创建新数组
3. 复制元素到数组
4. 让ArrayList底层的数组指向新数组

## CurrentHashMap的实现原理

Jdk1.8的CurrentHashMap底层是基于了数组+链表/红黑树的形式实现，优化了原本的HashMap的实现，使得速度加快

其安全性依赖volatile+CAS或Synchronized来实现

