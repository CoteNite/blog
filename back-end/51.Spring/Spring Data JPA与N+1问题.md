# Spring Data JPA与N+1问题


Spring Data JPA是Spring旗下的Spring Data项目下针对SQL的ORM，其名字中的JPA为`Java Persistent API(即Java持久化API)`，是Java为了统一各大ORM厂商的接口而定义的一套规范，至于JPA的具体实现则交由各大ORM厂商自行实现，目前Spring Data JPA默认采用的是Hibernate作为JPA实现

## N+1问题是什么

所谓N+1问题，是在这样一种yu'ji