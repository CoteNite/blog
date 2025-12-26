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

### ORDER BY

排序语法与MySQL类似

特别的，PgSQL运行我们对null进行排序，只需要使用下列语法

```sql
SELECT num
FROM sort_demo
ORDER BY num nulls FIRST
```

在PGSQL中null默认排序在最下（ASC顺序下），我们可以将其放置为最上方，使用的就是最后的nulls first指令

同样的，除了nulls first，自然还有nulls last，就是将null放在最后

这里有两个注意点：

- nulls last/nulls first与desc/asc无关，就是直接放在最上或最下
- PgSQL中的null往往以空字符串的形式表现

