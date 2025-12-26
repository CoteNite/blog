# PgSQL

[PostgreSQL 教程](https://neon.com/postgresql/postgresql-tutorial/postgresql-select)

PostgreSQL是目前市面上处了MySQL以外最受欢迎的开源数据库，在大多情况下PgSQL性能要优于MySQL，同时支持多种丰富的插件

## Selcet

基本查询与MySQL一致

```sql
select * from table
```

通过上面的SQL语句即可查询出的表下所有数据

### 含有表达式的查询

我们可以书写这样的语句

```sql
select 
first_name ||  ' '  || last_name name,
email
from customer
```

最后查询的结果为

![image.png](https://raw.githubusercontent.com/CoteNite/Blog_img/master/blogImg/20251226194401.png)

上述sql语句中的||为连接运算符，表示将两部分拼接起来，中间的' '为在两个列中插入一个空格

由于同时使用了两个列，所以这个新生成的列没有名字，我们是使用了别名为其命名，其中别名语法与MySQL一致

