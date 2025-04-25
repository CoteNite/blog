# ElasticSearch——数据分析与搜索引擎

我们做项目时经常遇到一个场景，就是如果要实现一个搜索功能该如何办？

一个很自然的想法就是使用MySQL的模糊搜索。

但是模糊搜索存在一个问题，那就是我们的MySQL采用的是正向索引，也就是根据索引进行排序，这时如果我们去根据字符串去搜索一个固定的值，那么可以采用一定的算法，但是如果要查询索引字符串中是否含有某段字符串，那就只能一个个的扫描过去了（效率为O(n)）

这个效率是极其低下的，因此我们必须选择另一种索引的方式

这个时候就出现了倒叙索引

## 倒排索引

倒排索引中存在两个关键的概念

* 文档(Document):用来搜索的数据，一条数据就是一个文档
* 词条(Term):用来搜索文档的数据（使用分词算法进行分词，得到的是又含义的词条）

倒排索引进行了这样的一套操作

1. 文档经过分词算法得到一堆词条（词条与文档是多对多的关系）
2. 创建词条与含有该词条文档id，所在位置等相关信息的表
3. 针对词条创建索引，提高查询词条的效率

然后我们的搜索就变成了

1. 用户输入一段文字
2. 文字分词得到词条
3. 搜索词条
4. 根据词条获取对应的文档id
5. 根据文档id获取文档

这样就大幅的提高了我们模糊搜索的速度

tip：我们可以大致的认为，正向索引适合关系搜索，而倒排索引适合模糊搜索

## 核心定义

这里我们还是和MySQL去对应着理解

* 文档(Document)：类似MySQL中的行，一个文档就是一条完整的数据
* 字段(Field)：类似MySQL中的列，一个文档中含有多个列
* 索引(Index)：类似MySQL中的表，内含许多文档

## DSL 语句

像SQL一样，ElasticSearch有自己的一套语句，我们称之为DSL

DSL整体像是一种编写网络请求的方式，大致分为以下三个部分：请求方式，请求路径，请求体

举个例子

```DSL
PUT /note
{
	"mappings":{
		"properties":{
			"title":{
				"type":"keyword",
				"index":"false"
			}
		}
	}
}
```


上面的内容我们很容易就能看明白，就是向我们的ES客户端发起一个PUT请求，请求的连接是/note，请求的内容是下面的一整个json

### 创建索引

mapping用来创建索引，properties是索引中含有的字段，字段含有以下属性
* type：字段类型
  * 字符串：text（可分词的文本）、keyword（精确值，例如：品牌、国家、ip地址）
  * 数值：long、integer、short、byte、double、float、
  * 布尔：boolean
  * 日期：date（可以含有format用来定义格式）
  * JSON 对象：object
* index：是否创建索引（默认为true，可不指定）
* analyzer：创建索引时使用哪种分词器（es设定了默认值，可不指定）
* search_analyzer：搜索时使用哪种分词器（若不指定默认与analyzer使用的保持一致）

### 请求类型

常用的CRUD分为针对索引库和针对文档

**针对索引库**

* 创建：PUT /索引库名
* 查询(返回的是索引库的信息)：GET /索引库名
* 删除：DELETE /索引库名
* 修改（索引建成后，ES仅允许添加字段这一种修改）：PUT /索引库名/\_mapping

**针对文档**

- 创建文档：POST /{索引库名}/\_doc/文档id   
  请求体为一个文档
- 查询文档：GET /{索引库名}/\_doc/文档id
- 删除文档：DELETE /{索引库名}/\_doc/文档id
- 修改文档：
    - 全量修改（删除原文档，创建新文档）：PUT /{索引库名}/\_doc/文档id
     响应体是一个文档
    - 增量修改：POST /{索引库名}/\_update/文档id 
      响应体类似 { "doc": {字段}}
- 搜索文档 GET /note/\_search
  响应体
```json
{ 
	"query":{ 
		"match_all": {},  //和match互斥，match_all就是不限定，全搜索
		"match":{}  //里面放入部分字段以及字段中的词
	}, 
	sort:[
		{
			"字段名":{
				"order":"desc/asc"
			}
	    }
	],
	"from": 0,
	"size": 2 
}
```
其中from和size是分页搜索才会有的，from是页数(从零开始)，size是一页的条数

## SpringBoot 集成

ElasticSearch本身提供了优秀的Java客户端（RestHighLevelClient），除此之外我们还可以使用SpringBoot为我们提供的Spring Data ElasticSearch（本事是对RestHighLevelClient的封装），让我们可以使用Spring Data的格式来操作ES客户端

[这里放出RestHighLevelClient的文档](https://www.elastic.co/docs/reference/elasticsearch-clients/)

## Logstash-JDBC，Canal，FlinkCdc

ES本身是一种数据库，同时特化了模糊搜索的方向，我们在后端方案中时常将其与我们的SQL数据库组合使用

这也就延申出一个问题，难道我每次对数据库内容进行操作时都要对ES进行相同的操作吗？

答案肯定是否，市面上已经有成熟的解决方案

对于这里的解决方案可以看这个贴子

[V2EX-mysql 数据同步 elasticsearch 方案](https://www.v2ex.com/t/922102)

### Logstash-JDBC

> Logstash 是一种开源的服务器端数据处理管道，能够从多个来源采集数据，转换数据，然后将数据发送到您喜欢的 “存储库” ，如 Elasticsearch 中。


`Logstash` 是ES为我们提供的解决方案

其中Logstash-input-jdbc插件为我们提供了构建全量索引和增量索引的操作

我们可以在ES官网上下载Logstash并配置进行操作，然后Logstash就会自动的根据你的需求构建增量索引和全量索引

### Canal

Canal是Alibaba的解决方案，Canal将自己伪装成数据库的从库，然后获取数据库发送的binlog对象

我们在配置好Canal后就可以在项目中引入CanalClient然后检测Canal获取的binlog，接着对其进行消费，从而完成对数据的同步

### Apache Flink Cdc

Apache Flink Cdc是Apache基金会旗下的一个顶级项目，基于Apache Flink，主要用于完成数据同步功能

**CDC（Change Data Capture 变更数据获取）**

FlinkCdc相对Cancal提供了更加完善的集成，可以在相对较低的代码量的情况下完成对数据的同步

### 总结

得益于Alibaba在国内的Java贡献目前市面上教程最多的就是Canal

ApacheFlinkCdc的上手难度相对Canal高一些，要求团队对ApacheFlink有一定的了解，但是ApacheFlinkCdc的解决方案也提供了更加强大的实时数据处理能力，可以让你的团队在Flink框架下完成整套流程

而Canal需要自己实现一系列的CDC服务，但是相对来说对于更容易上手（因为相当于让你自己实现一个CDC服务，也算是客制化了），适合小项目使用