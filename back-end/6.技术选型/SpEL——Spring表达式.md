# SpEL——Spring表达式

SpEL表达式是Spring提供的一种可以被解析的字符串

## 原理

Spring内置了一套字符串解析器用来解析Spring表达式，进而将普通的字符串转换为了可以使用的语法

```java
    @Test
    void contextLoads() {
        ExpressionParser parser = new SpelExpressionParser();
        Object value = parser.parseExpression("11").getValue();
        System.out.println(value);

    }
```

这里的`ExpressionParser`就是SpEL的解析器，用来解析SpEL的语法，使用parseExpression方法填入字符串，使用getValue方法获取解析出来的值

## 可解析值

SpEl表达式的结果只能被映射成四种情况：字符串，数字，布尔，null

## 加减乘除

Spring表达式本身是支持加减乘除的

支持的运算符：+ - * / % ^（幂）

## 判断语句

SpEL表达式也支持判断语句，除了Java支持的几种外，还特别支持了between（区间）

`1 betwen {1,2}` ——> true

## 判断语句

&& ||  ！  均支持







