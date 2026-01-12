# Spring Data JPA与N+1问题


Spring Data JPA是Spring旗下的Spring Data项目下针对SQL的ORM，其名字中的JPA为`Java Persistent API(即Java持久化API)`，是Java为了统一各大ORM厂商的接口而定义的一套规范，至于JPA的具体实现则交由各大ORM厂商自行实现，目前Spring Data JPA默认采用的是Hibernate作为JPA实现

## N+1问题是什么

所谓N+1问题，是在这样一种语境下出现的：

存在表A B，其中表A中的实体与表B中的实体是一对多的关系，在这种情况下，如果我们使用JPA去查询N条表A中的数据，会连带进行N次查询，去查询每一条表A的实体下关联的表B的实体的数量，进而**总计为N次对表B的查询，与一次对表A的查询，即N+1问题**

## 解决方案

目前JPA会推荐我们使用