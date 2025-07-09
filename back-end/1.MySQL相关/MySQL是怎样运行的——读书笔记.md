# MySQL是怎样运行的——读书笔记

## 字符集

MySQL中的utf8指的是utf8mb3这个字符集只用到了3个字节，若要使用使用完整的字符集需要使用utf8mb4

### 比较规则

`utf8_general_ci`我们来看这个比较规则，它分为三部分

- utf-8：该规则用于哪个字符集
- general：主要根据哪个语种的特点进行排序，这里的general是一种相对通用的规则
- ci：是否区分重音和大小写

|   后缀   |         英文释义         |    描述    |
| :----: | :------------------: | :------: |
| `_ai`  | `accent insensitive` |  不区分重音   |
| `_as`  |  `accent sensitive`  |   区分重音   |
| `_ci`  |  `case insensitive`  |  不区分大小写  |
| `_cs`  |   `case sensitive`   |  区分大小写   |
| `_bin` |       `binary`       | 以二进制方式比较 |

特别注意的是，每种字符集都有自己默认的比较规则`utf8`字符集默认的比较规则就是`utf8_general_ci`。


