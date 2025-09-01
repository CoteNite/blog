# JPA or Jimmer？ORM之间的区别是什么？

作为一名后端开发者，最常接触的业务就是CRUD，在这个过程中就离不开ORM框架的使用，在国内最常使用的ORM框架应该是Mybatis以及其延伸物Mybatis-xxx系列（flex plus join.......），而国外的话则应该是由hibernate延伸出的Spring Data JPA。

最近（其实已经有了一段时间了）国产又有一个新的框架——Jimmer，其优秀的设计以及队Kotlin原因的顶级支持吸引了很多开发者的使用。

后面和群友们聊了一下关于Jimmer和JPA的事情，又延申到队ORM的讨论，逐渐对ORM的形式有了一个自己的看法。

在我看来或许ORM只分为两类——围绕对象或围绕数据库。

比如Hibernate和JPA，我们会发现其具有将实体类直接映射为数据库bi