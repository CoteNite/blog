# MySQL常见面试题——锁相关

## MySQL中有哪些锁？

- **全局锁**：让整个表变成只读状态
- **表级锁**：
	- **表锁**：所有线程均只读
	- **元数据锁**：防止用户执行CRUD操作时有线程修改表结构
	- **意向锁**：进行增改删前先加上`意向独占锁`，然后对该记录加锁。**用于快速判断该数据是否被上锁**
- **行级锁**：对行加锁
- **记录锁**：对记录加锁，锁分为S锁与X锁，满足读写互斥，读读互斥
- **间隙锁**：用于可重复读，解决幻读用
- **临键锁/Next-Key Lock**： Record Lock + Gap Lock 的组合，锁定一个范围，并且锁定记录本身

## MySQL多个线程同时对一条数据修改是否会阻塞

会的，InnoDB实现了行级锁

## 锁的范围

where = 锁条数，where 范围锁范围，没有命中索引锁全表

# MySQL常见面试题——日志相关

## 日志类型

- redo log：用于持久化与数据恢复
- undo log：用于事务回滚与MVCC
- bin log：用于数据备份与主从复制

## bin log的具体操作

binlog用于主从复制与数据备份，因此仅记录增改删操作，不记录查询操作

当一条操作产生后，Server层线生成一条bin log，等数据提交后再写入bin log文件

## undo log的具体操作

undo log实现原子性，会将更新前的数据记录在undo log中，若事务回滚则使用undo log来恢复数据

## 为什么有了bin log还需要redo log

bin log不会记录脏页和刷盘，而redo log记录了，因此redo log可以恢复未刷盘的脏页数据

## 日志的两次提交/bin log和redo log的一致性

bin log 和 redo log 是两段不同的逻辑，但都要在事务commit后写入各自的日志，这个过程要保证二者一致，因此就引入了两段提交的机制

MySQL内部实现了一个XA事务，整个两段提交就是基于这个XA事务来完成的

- **Prepare阶段**：先将XId（XA事务的Id）写入redo log，将redo log状态转变为prepare，然后持久化redo log
- **Commit阶段**：将XId写入bin log，然后持久化bin log，接着将redo log状态设置为Commit


