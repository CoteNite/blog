# 开源自然语言转SQL——nl2sql

SpringAIAlibaba下的开源项目，主要用于自然语言转化为SQL

[项目链接](https://github.com/alibaba/spring-ai-alibaba/tree/main/spring-ai-alibaba-nl2sql)

[README](https://github.com/alibaba/spring-ai-alibaba/tree/main/spring-ai-alibaba-nl2sql/spring-ai-alibaba-nl2sql-chat)

Alibaba按照（或者说是为了）[百炼析言](https://www.aliyun.com/product/bailian/xiyan)制作的产品，使用了SpringAi的工作流，仍处于迭代期（半成品），最终打算制作成Data Agent的形式，目前可以直接嵌入到SpringBoot应
用中使用。

目前向量数据库仅支持SimpleVector（轻量级，不适合生产）和AnalyticDB（阿里巴巴云原生数据仓库）

实际体验效果一般，仍然存在部分bug，且网络教程较少。

## 存在的问题

尝试生成插入方法，在调用方法时会一直报错并重复生成同一句错误的sql语句，debug发现原因在于其源码使用executeQuery去检查SQL语句是否存在语法错误，因此不支持插入语句。

下面是对于这个issue nl2sql主要贡献者的回复

![image.png](https://raw.githubusercontent.com/CoteNite/Blog_img/master/blogImg/20250721141423.png)
## 使用教程

引入依赖

```xml
<dependency>
    <groupId>com.alibaba.cloud.ai</groupId>
    <artifactId>spring-ai-alibaba-starter-nl2sql</artifactId>
    <version>${spring-ai-alibaba.version}</version>
</dependency>
```

配置

```yaml
server:
  port: 8062 # 服务器端口配置
spring:
  ai:
    dashscope:
      api-key: sk-c15ed4dbabc34f57813d281fcb782a36
    mcp:
      server:
        name: xiyan-server # MCP服务器名称
        version: 0.0.1 # 服务器版本号
    vectorstore:
      analytic:
        enabled: false
    openai:
      base-url: https://dashscope.aliyuncs.com/compatible-mode
      api-key: sk-c15ed4dbabc34f57813d281fcb782a36
      model: qwen-max
chatBi:
  dbConfig:
    url: jdbc:mysql://localhost:3306/nl2sql?useUnicode=true&characterEncoding=UTF-8&serverTimezone=Asia/Shanghai #数据库 JDBC 连接地址，示例：MySQL: jdbc:mysql://host:port/databasePostgreSQL: jdbc:postgresql://host:port/database
    username: root
    password: 123456
    connectiontype: jdbc
    dialecttype: mysql
```

```java
package com.alibaba.cloud.ai.controller;  
  
import com.alibaba.cloud.ai.dbconnector.DbConfig;  
import com.alibaba.cloud.ai.graph.CompiledGraph;  
import com.alibaba.cloud.ai.graph.NodeOutput;  
import com.alibaba.cloud.ai.graph.OverAllState;  
import com.alibaba.cloud.ai.graph.StateGraph;  
import com.alibaba.cloud.ai.graph.async.AsyncGenerator;  
import com.alibaba.cloud.ai.graph.exception.GraphStateException;  
import com.alibaba.cloud.ai.graph.streaming.StreamingOutput;  
import com.alibaba.cloud.ai.request.SchemaInitRequest;  
import com.alibaba.cloud.ai.service.simple.SimpleVectorStoreService;  
import com.alibaba.fastjson.JSON;  
import jakarta.servlet.http.HttpServletResponse;  
import org.slf4j.Logger;  
import org.slf4j.LoggerFactory;  
import org.springframework.beans.factory.annotation.Autowired;  
import org.springframework.beans.factory.annotation.Qualifier;  
import org.springframework.http.MediaType;  
import org.springframework.http.codec.ServerSentEvent;  
import org.springframework.web.bind.annotation.GetMapping;  
import org.springframework.web.bind.annotation.RequestMapping;  
import org.springframework.web.bind.annotation.RequestParam;  
import org.springframework.web.bind.annotation.RestController;  
import reactor.core.publisher.Flux;  
import reactor.core.publisher.Sinks;  
  
import java.util.Arrays;  
import java.util.Map;  
import java.util.Optional;  
import java.util.concurrent.CompletableFuture;  
import java.util.concurrent.CompletionException;  
  
import static com.alibaba.cloud.ai.constant.Constant.INPUT_KEY;  
import static com.alibaba.cloud.ai.constant.Constant.RESULT;  
  
/**  
 * @author zhangshenghang  
 */@RestController  
@RequestMapping("nl2sql")  
public class Nl2sqlForGraphController {  
  
    private static final Logger logger = LoggerFactory.getLogger(Nl2sqlForGraphController.class);  
  
    private final CompiledGraph compiledGraph;  
  
    @Autowired  
    private SimpleVectorStoreService simpleVectorStoreService;  
  
    @Autowired  
    private DbConfig dbConfig;  
  
    @Autowired  
    public Nl2sqlForGraphController(@Qualifier("nl2sqlGraph") StateGraph stateGraph) throws GraphStateException {  
       this.compiledGraph = stateGraph.compile();  
       this.compiledGraph.setMaxIterations(100);  
    }  
	
	//核心代码
    @GetMapping("/search")  
    public String search(@RequestParam String query) throws Exception {  
       // 初始化向量  
       SchemaInitRequest schemaInitRequest = new SchemaInitRequest();  
       schemaInitRequest.setDbConfig(dbConfig);  
       schemaInitRequest  
          .setTables(Arrays.asList("categories", "order_items", "orders", "products", "users", "product_categories"));//手动输入数据库的表名  
       simpleVectorStoreService.schema(schemaInitRequest);  
  
       Optional<OverAllState> invoke = compiledGraph.invoke(Map.of(INPUT_KEY, query));  
       OverAllState overAllState = invoke.get();  
       return overAllState.value(RESULT).get().toString();  
    }  
  
    @GetMapping("/init")  
    public void init() throws Exception {  
       // 初始化向量  
       SchemaInitRequest schemaInitRequest = new SchemaInitRequest();  
       schemaInitRequest.setDbConfig(dbConfig);  
       schemaInitRequest  
          .setTables(Arrays.asList("categories", "order_items", "orders", "products", "users", "product_categories"));  
       simpleVectorStoreService.schema(schemaInitRequest);  
    }  
  
    @GetMapping(value = "/stream/search", produces = MediaType.TEXT_EVENT_STREAM_VALUE)  
    public Flux<ServerSentEvent<String>> streamSearch(@RequestParam String query, HttpServletResponse response)  
          throws Exception {  
       response.setCharacterEncoding("UTF-8");  
  
       Sinks.Many<ServerSentEvent<String>> sink = Sinks.many().unicast().onBackpressureBuffer();  
  
       // 使用流式处理  
       AsyncGenerator<NodeOutput> generator = compiledGraph.stream(Map.of(INPUT_KEY, query));  
  
       CompletableFuture.runAsync(() -> {  
          generator.forEachAsync(output -> {  
             try {  
                // System.out.println("output = " + output);  
                if (output instanceof StreamingOutput) {  
                   StreamingOutput streamingOutput = (StreamingOutput) output;  
                   String chunk = streamingOutput.chunk();  
                   if (chunk != null) {  
                      sink.tryEmitNext(ServerSentEvent.builder(JSON.toJSONString(chunk)).build());  
                   }  
                   else {  
                      logger.warn("Received null chunk from streaming output, skipping emission.");  
                   }  
                }  
             }  
             catch (Exception e) {  
                e.printStackTrace();  
                throw new CompletionException(e);  
             }  
          }).thenAccept(v -> sink.tryEmitComplete()).exceptionally(e -> {  
             logger.error("Error in stream processing", e);  
             sink.tryEmitError(e);  
             return null;  
          });  
       });  
  
       return sink.asFlux()  
          .doOnCancel(() -> System.out.println("Client disconnected from stream"))  
          .doOnError(e -> System.err.println("Error occurred during streaming: " + e));  
    }  
  
}
```

上述代码也进一步展示了nlsql可以做到开箱即用，同时也是nl2sql的核心功能