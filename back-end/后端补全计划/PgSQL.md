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

### DISTINCT

distinct是用来进行去重的语法，具体使用方式与MySQL一致

```sql
select distinct
colume1,
colume2
from table
```

上面的查找方式实际上就是在查找table中colume1和colume2组合的不重复的情况

值得注意的是，如果希望所有的列都不一样可以使用`select distinct *`，但是一般很少会有人这么写，因为id一般不会重复

## 条件判断

### where

与MySQL一致，where的执行顺序在from后，select和order by之前

常用的where运算符：

|   操作符    |    功能    |
| :------: | :------: |
|    =     |    等于    |
|    >     |    大于    |
|    <     |    小于    |
|    >=    |   大于等于   |
|    <=    |   小于等于   |
| <> or != |   不等于    |
|   AND    |   逻辑和    |
|    OR    |   逻辑或    |
|    IN    | 元素是否在列表中 |
| BETWEEN  | 元素是否在范围内 |
|   LIKE   |  字符串匹配   |
| IS NULL  |    非空    |
|   NOT    |   逻辑非    |

来一些例子

```sql
SELECT 
first_name,
last_name
FROM customer
WHERE first_name IN ('Ann', 'Anne', 'Annie');
```

这里我们用in进行列表检索，同时用小括号的形式创建出一个列表

```sql
SELECT
first_name, last_name
FROM 
customer 
WHERE first_name LIKE 'Ann%';
```

这里使用的是like进行模糊匹配，用到的是%，表示该位置的内容任意且可以有无数长度的字符，与此相似的还有占位符_，表示当前位置内容任意，但只能有一个字符

```sql
SELECT 
first_name, 
LENGTH(first_name) name_length 
FROM customer 
WHERE first_name LIKE 'A%' 
AND LENGTH(first_name) BETWEEN 3 AND 5 
ORDER BY name_length;
```

这是BETWEEN的使用方式，A and B 用来创造一个左右闭合的区间

### 布尔值

PgSQL中的布尔值有三种，true false null

其中PgSQL将`true` 、 `'t'` 、 `'true'` 、 `'y'` 、 `'yes'` 、 `'1'` 表示 `true` ，使用 `false` 、 `'f'` 、 `'false'` 、 `'n'` 、 `'no'` 和 `'0'` 表示 `false` 

- **在过滤行时**：`WHERE` 只认 `TRUE`。所以 `NULL` 和 `FALSE` 产生的**效果一致**（都不显示）
- **在逻辑计算时**：`NULL` 具有传染性（Unknown）
- **在比较大小时**：`NULL` 不能用 `=` 比较。`column = NULL` 结果永远是 `NULL`

### BETWEEN

between在PgSQL中是左右闭合的区间，一般配合AND一起使用

```sql
SELECT
  payment_id,
  amount
FROM
  payment
WHERE
  payment_id BETWEEN 17503 AND 17505
ORDER BY
  payment_id;
```

### LIKE/模糊匹配

与MySQL类似，模糊匹配与%和_搭配使用

### IS Null

鉴定该列是否非空

## 连接

### 左连接，内连接，右连接

这三个部分和MySQL一致

```sql
SELECT
  select_list
FROM
  table1
INNER JOIN table2
  ON table1.column_name = table2.column_name;
```

JOIN语句与ON搭配使用

### 自连接

自连接本身就是使用内连接将自己和自己连接起来，在MySQL中也有应用

```sql
CREATE TABLE employee (
  employee_id INT PRIMARY KEY,
  first_name VARCHAR (255) NOT NULL,
  last_name VARCHAR (255) NOT NULL,
  manager_id INT,
  FOREIGN KEY (manager_id) REFERENCES employee (employee_id) ON DELETE CASCADE
);

SELECT
  e.first_name || ' ' || e.last_name employee,
  m.first_name || ' ' || m.last_name manager
FROM
  employee e
  INNER JOIN employee m ON m.employee_id = e.manager_id
ORDER BY
  manager;
```

在上面的例子中，我们的employee表在设计中包含了普通员工（employee）和管理层员工（manager）

普通的员工会有一个manager_id，用来表示其直属上级是谁，这种情况下我们会使用自连接

### 全外连接/FULL OUTER JOIN

全外连接可以理解为左连接和右连接的并集，其返回的内容类似下图

![外连接](https://neon.com/_next/image?url=%2Fpostgresqltutorial%2FPostgreSQL-Join-Full-Outer-Join.png&w=640&q=75&dpl=dpl_F9bdjKJK2Tq8GsFjQf8UHmeJsvcQ)

```sql
SELECT
  employee_name,
  department_name
FROM
  employees e
FULL OUTER JOIN departments d
  ON d.department_id = e.department_id
WHERE
  department_name IS NULL;
```

上面的代码就是输出不属于任何部门的员工

### 交叉连接/笛卡尔积/CROSS JOIN

交叉连接就是将A表中的所有元素依次与B表中的所有元素两两组合，最常见的作用是对可能性进行穷举，交叉连接不与ON一同使用（因为没有必要，同时也没有设置这个语法）

```sql
SELECT *
FROM products
CROSS JOIN warehouses;
```

像上面的语句，就是在进行尝试所有的商品在某个仓库的可能性

### 自然连接

PgSQL将自然连接转化为了一种语法层面的实现

```sql
SELECT select_list
FROM table1
NATURE [INNER, LEFT, RIGHT] JOIN table2
   ON table1.column_name = table2.column_name;
```

此处的\[INNER, LEFT, RIGHT]如果不填写，则默认你使用的是INNER JOIN

自然连接的本质上就是默认你ON后面的比较是对两个表中的所有同名列进行比较

