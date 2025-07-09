# MySQL是怎样运行的——读书笔记

## 字符集

MySQL中的utf8指的是utf8mb3这个字符集只用到了3个字节，若要使用使用完整的字符集需要使用utf8mb4

### 比较规则

`utf8_general_ci`我们来看这个比较规则，它分为三部分

- utf-8：该规则用于哪个字符集
- general：