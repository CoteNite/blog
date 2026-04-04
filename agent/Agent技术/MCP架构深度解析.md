# MCP架构深度解析

MCP（Model Context Protocol）作为一个开源标准，其核心价值在于为AI应用与外部系统之间建立了一套标准化的连接机制。就像USB-C接口统一了电子设备的连接方式一样，MCP统一了AI应用访问数据源、工具和工作流程的方式。这种标准化的接口设计使得AI应用能够连接到本地文件、数据库、搜索引擎、计算器等数据源和工具，进而获取关键信息并执行复杂任务

从架构层面来看，MCP采用了客户端-服务器模型，其中MCP服务器负责暴露特定的能力给AI应用，而MCP客户端则由宿主应用实例化以与特定的MCP服务器通信。这种设计的关键优势在于解耦——宿主应用（如Claude.ai或IDE）管理整体用户体验并协调多个客户端，每个客户端处理与一个服务器的直接通信。服务器通过三种核心功能模块提供服务：Tools（工具）允许LLM主动调用的函数，Resources（资源）提供只读数据访问，Prompts（提示）提供预定义的工作流模板。这种模块化设计让开发者可以根据需求灵活组合功能，而AI模型则能够根据用户请求智能决定何时使用这些工具

对于服务提供商而言，MCP提供了一种安全且可控的方式来实现AI应用与内部系统的对接。通过MCP协议，服务提供商可以在不暴露核心代码或数据库结构的情况下，让AI应用通过合适的认证密钥访问特定服务。这意味着企业可以精确控制AI应用能够访问的数据范围和操作权限，同时保持内部系统的安全性。例如，一个企业聊天机器人可以连接到组织内的多个数据库，让用户通过对话方式分析数据；或者一个AI助手可以访问用户的Google日历和Notion，提供更个性化的日程管理服务。这种"让渡工具创建权限"的设计理念，使得Agent开发变成了只需接入MCP协议、无需考虑具体实现的方式，大大降低了开发复杂度

## MCP核心功能详解

### Tools（工具）- 模型主动调用的能力

Tools是MCP中最核心的功能模块，它允许LLM根据用户请求主动决定何时调用以及如何调用这些工具。与传统的API调用不同，Tools的设计理念是让模型拥有"自主权"——模型会分析用户的意图，然后选择合适的工具来完成任务

**Tools的工作流程：**

1. **工具发现**：客户端向服务器发送`tools/list`请求，获取所有可用工具的列表
2. **工具选择**：LLM根据用户请求和工具描述，决定是否需要调用工具以及调用哪个工具
3. **工具执行**：客户端发送`tools/call`请求，服务器执行相应的逻辑并返回结果
4. **结果处理**：LLM根据工具返回的结果生成最终回复

**一个Tool的定义包含哪些信息？**

```kotlin
data class Tool(
    val name: String,              // 工具名称，如 "get_weather"
    val description: String,       // 工具描述，LLM根据这个描述判断何时使用
    val inputSchema: JsonSchema,   // 输入参数的JSON Schema定义
    val handler: (Map<String, Any>) -> ToolResult  // 实际的处理函数
)
```

**实际案例：旅行预订系统**

假设我们正在开发一个旅行预订的MCP服务器，我们可以提供以下工具：

```kotlin
// 搜索航班工具
val searchFlights = Tool(
    name = "search_flights",
    description = "搜索指定日期和航线的航班信息，返回可用航班列表",
    inputSchema = JsonSchema {
        addProperty("departure", String::class, "出发城市", required = true)
        addProperty("destination", String::class, "目的城市", required = true)
        addProperty("date", String::class, "出发日期（YYYY-MM-DD格式）", required = true)
    },
    handler = { params ->
        val flights = flightService.search(
            params["departure"] as String,
            params["destination"] as String,
            params["date"] as String
        )
        ToolResult(content = flights.toJson())
    }
)

// 预订航班工具
val bookFlight = Tool(
    name = "book_flight",
    description = "预订指定的航班，需要提供乘客信息和航班ID",
    inputSchema = JsonSchema {
        addProperty("flightId", String::class, "航班ID", required = true)
        addProperty("passengerName", String::class, "乘客姓名", required = true)
        addProperty("passengerId", String::class, "乘客身份证号", required = true)
    },
    handler = { params ->
        val booking = bookingService.book(
            params["flightId"] as String,
            params["passengerName"] as String,
            params["passengerId"] as String
        )
        ToolResult(content = "预订成功，订单号：${booking.id}")
    }
)
```

**用户交互模型是怎样的？**

当用户说"帮我查一下明天从北京到上海的航班"时，整个流程如下：

1. MCP客户端将用户消息和可用工具列表发送给LLM
2. LLM识别出需要查询航班，选择`search_flights`工具
3. LLM提取参数：departure="北京", destination="上海", date="2026-04-05"
4. 客户端调用工具，服务器返回航班列表
5. LLM根据航班信息生成友好的回复给用户

**Tools与Agent Skills的区别？**

Agent Skills是通过SKILL.md文件描述能力，而MCP Tools是通过JSON Schema定义接口。Agent Skills更偏向于"提示词工程"，而MCP Tools更偏向于"函数调用"。Agent Skills适合简单的、本地的功能扩展，而MCP Tools适合复杂的、需要访问外部系统的场景

### Resources（资源）- 只读数据访问

Resources提供了只读的数据访问能力，让服务器能够向客户端暴露文件、数据库记录、API响应等数据源。与Tools不同，Resources是被动访问的——客户端决定何时读取数据

**Resources的核心概念：**

- **URI标识**：每个Resource都有唯一的URI标识，如`file:///path/to/document.pdf`或`database://users/123`
- **模板化访问**：支持参数化的URI模板，如`weather://{city}/current`
- **订阅机制**：客户端可以订阅Resource的变化，当数据更新时收到通知

**Resources的工作流程：**

```kotlin
// 定义一个Resource
val userResource = Resource(
    uri = "user://{userId}/profile",
    name = "用户资料",
    description = "获取指定用户的个人资料信息",
    mimeType = "application/json",
    handler = { params ->
        val userId = params["userId"] as String
        val user = userService.findById(userId)
        ResourceContent(
            uri = "user://$userId/profile",
            mimeType = "application/json",
            text = user.toJson()
        )
    }
)

// 客户端读取Resource
val request = ReadResourceRequest(uri = "user://12345/profile")
val response = server.readResource(request)
```

**实际案例：旅行规划上下文**

在旅行规划场景中，我们可以提供以下Resources：

```kotlin
// 用户旅行偏好
val travelPreferences = Resource(
    uri = "travel://preferences/{userId}",
    name = "旅行偏好设置",
    description = "用户的旅行偏好，包括座位偏好、酒店星级等",
    handler = { params ->
        val prefs = preferenceService.getTravelPrefs(params["userId"])
        ResourceContent(text = prefs.toJson())
    }
)

// 目的地信息
val destinationInfo = Resource(
    uri = "travel://destination/{city}",
    name = "目的地信息",
    description = "城市的旅游景点、美食推荐等信息",
    handler = { params ->
        val info = destinationService.getInfo(params["city"])
        ResourceContent(text = info.toJson())
    }
)
```

**Resources与RAG的区别？**

RAG通过向量检索从海量文档中找到相关片段，适合知识库问答场景。而Resources提供结构化的数据访问，适合需要精确数据查询的场景。RAG是"模糊匹配"，Resources是"精确查询"

### Prompts（提示）- 预定义工作流模板

Prompts提供了预定义的提示词模板，帮助用户快速完成特定任务。通过Prompts，服务器可以向客户端暴露标准化的工作流程

**Prompts的设计理念：**

Prompts本质上是一组预定义的提示词模板，它可以包含：
- 静态文本：固定的指导说明
- 动态参数：用户输入的变量
- 嵌入资源：引用Resources的内容
- 工具调用：指定需要使用的Tools

**Prompts的定义方式：**

```kotlin
val travelPlanningPrompt = Prompt(
    name = "plan_trip",
    description = "帮助用户规划完整的旅行行程",
    arguments = listOf(
        PromptArgument(
            name = "destination",
            description = "旅行目的地",
            required = true
        ),
        PromptArgument(
            name = "duration",
            description = "旅行天数",
            required = true
        ),
        PromptArgument(
            name = "budget",
            description = "预算范围",
            required = false
        )
    ),
    handler = { args ->
        val destination = args["destination"] as String
        val duration = args["duration"] as String
        val budget = args["budget"] as? String ?: "不限"
        
        PromptMessage(
            role = Role.USER,
            content = """
                请帮我规划一次${duration}天的${destination}旅行。
                预算范围：${budget}
                
                请提供：
                1. 每日行程安排
                2. 推荐景点和活动
                3. 住宿建议
                4. 交通方案
                5. 预算分配
            """.trimIndent()
        )
    }
)
```

**Prompts的实际应用场景：**

1. **代码审查**：提供代码审查的标准流程和检查项
2. **文档生成**：根据代码自动生成API文档
3. **数据分析**：引导用户完成数据清洗、分析、可视化的完整流程
4. **旅行规划**：收集用户需求，生成详细行程

**Prompts与Agent Skills的关系？**

Prompts和Agent Skills都提供了预定义的工作流，但实现方式不同。Prompts通过MCP协议标准化，可以被任何MCP客户端使用；而Agent Skills需要特定的运行环境支持。Prompts更适合"一次性的任务引导"，Agent Skills更适合"复杂的多步骤操作"

## MCP架构角色定位

### MCP在系统架构中的位置

MCP在整体系统架构中扮演着"适配层"的角色，它位于AI应用和外部系统之间，提供统一的接口规范

**架构层次：**

```
┌─────────────────────────────────────┐
│      AI应用层（Claude, IDE等）        │
└──────────────┬──────────────────────┘
               │
┌──────────────▼──────────────────────┐
│         MCP客户端（协议层）            │
└──────────────┬──────────────────────┘
               │
┌──────────────▼──────────────────────┐
│         MCP服务器（能力层）            │
└──────────────┬──────────────────────┘
               │
┌──────────────▼──────────────────────┐
│    外部系统（数据库, API, 文件等）      │
└─────────────────────────────────────┘
```

**MCP如何增强系统模块化？**

1. **解耦AI应用与外部系统**：AI应用不需要了解外部系统的具体实现，只需通过MCP协议访问能力
2. **统一接口规范**：所有外部系统都通过相同的协议暴露能力，降低了集成成本
3. **独立演进**：外部系统可以独立升级和扩展，不影响AI应用的使用
4. **能力复用**：一个MCP服务器可以被多个AI应用同时使用

**MCP与微服务架构的关系？**

MCP与微服务架构有着天然的契合度。每个MCP服务器可以对应一个或多个微服务，通过MCP协议将微服务的能力暴露给AI应用。这种设计使得AI应用能够无缝集成到现有的微服务架构中

### 生命周期管理

MCP定义了完整的生命周期管理机制，包括初始化、能力协商、会话管理和错误处理

**初始化流程：**

```kotlin
// 1. 客户端发起初始化请求
val initRequest = InitializeRequest(
    protocolVersion = "2024-11-05",
    capabilities = ClientCapabilities(
        tools = ToolCapabilities(listChanged = true),
        resources = ResourceCapabilities(subscribe = true),
        prompts = PromptCapabilities(listChanged = true)
    ),
    clientInfo = ClientInfo(name = "MyApp", version = "1.0.0")
)

// 2. 服务器响应并返回能力
val initResponse = server.initialize(initRequest)
// initResponse包含：
// - protocolVersion: 协议版本
// - capabilities: 服务器支持的能力
// - serverInfo: 服务器信息

// 3. 客户端发送initialized通知
server.initialized()
```

**能力协商机制：**

MCP通过能力协商机制让客户端和服务器动态发现彼此支持的功能：

```kotlin
// 客户端查询服务器支持的Tools
val toolsResponse = server.listTools()
toolsResponse.tools.forEach { tool ->
    println("可用工具：${tool.name} - ${tool.description}")
}

// 服务器通知客户端Tools列表变化
server.onToolsListChanged {
    // 重新获取Tools列表
    val updatedTools = server.listTools()
}
```

**错误处理机制：**

MCP定义了标准的错误码和错误处理流程：

```kotlin
enum class ErrorCode(val code: Int) {
    PARSE_ERROR(-32700),           // 解析错误
    INVALID_REQUEST(-32600),       // 无效请求
    METHOD_NOT_FOUND(-32601),      // 方法未找到
    INVALID_PARAMS(-32602),        // 无效参数
    INTERNAL_ERROR(-32603)         // 内部错误
}

// 错误响应示例
data class ErrorResponse(
    val code: Int,
    val message: String,
    val data: Any? = null
)
```

## MCP服务器实现指南（Kotlin + LangChain4j）

### 环境准备

**依赖配置：**

```kotlin
// build.gradle.kts
dependencies {
    // MCP SDK
    implementation("io.modelcontextprotocol:mcp-sdk:1.0.0")
    
    // LangChain4j
    implementation("dev.langchain4j:langchain4j:0.36.2")
    implementation("dev.langchain4j:langchain4j-open-ai:0.36.2")
    
    // Kotlin协程
    implementation("org.jetbrains.kotlinx:kotlinx-coroutines-core:1.7.3")
    
    // JSON处理
    implementation("com.google.code.gson:gson:2.10.1")
    
    // 日志
    implementation("ch.qos.logback:logback-classic:1.4.14")
}
```

### 创建MCP服务器

**基础服务器实现：**

```kotlin
class TravelMCPServer : MCPServer() {
    
    private val flightService = FlightService()
    private val bookingService = BookingService()
    private val preferenceService = PreferenceService()
    
    init {
        // 注册Tools
        registerTool(searchFlightsTool)
        registerTool(bookFlightTool)
        registerTool(cancelBookingTool)
        
        // 注册Resources
        registerResource(travelPreferencesResource)
        registerResource(destinationInfoResource)
        
        // 注册Prompts
        registerPrompt(travelPlanningPrompt)
    }
    
    // 搜索航班工具
    private val searchFlightsTool = tool {
        name = "search_flights"
        description = "搜索指定日期和航线的航班信息"
        
        inputSchema {
            property("departure", String::class) { 
                description = "出发城市"
                required = true
            }
            property("destination", String::class) { 
                description = "目的城市"
                required = true
            }
            property("date", String::class) { 
                description = "出发日期（YYYY-MM-DD）"
                required = true
            }
        }
        
        handler { params ->
            val flights = flightService.search(
                departure = params["departure"] as String,
                destination = params["destination"] as String,
                date = params["date"] as String
            )
            
            ToolResult(
                content = buildJsonObject {
                    put("flights", flights.map { flight ->
                        buildJsonObject {
                            put("id", flight.id)
                            put("airline", flight.airline)
                            put("departure_time", flight.departureTime)
                            put("arrival_time", flight.arrivalTime)
                            put("price", flight.price)
                        }
                    }.toJsonArray())
                }.toString()
            )
        }
    }
    
    // 预订航班工具
    private val bookFlightTool = tool {
        name = "book_flight"
        description = "预订指定的航班"
        
        inputSchema {
            property("flightId", String::class) { 
                description = "航班ID"
                required = true
            }
            property("passengerName", String::class) { 
                description = "乘客姓名"
                required = true
            }
            property("passengerId", String::class) { 
                description = "乘客身份证号"
                required = true
            }
        }
        
        handler { params ->
            try {
                val booking = bookingService.book(
                    flightId = params["flightId"] as String,
                    passengerName = params["passengerName"] as String,
                    passengerId = params["passengerId"] as String
                )
                
                ToolResult(
                    content = buildJsonObject {
                        put("success", true)
                        put("booking_id", booking.id)
                        put("message", "预订成功")
                    }.toString()
                )
            } catch (e: Exception) {
                ToolResult(
                    isError = true,
                    content = buildJsonObject {
                        put("success", false)
                        put("error", e.message)
                    }.toString()
                )
            }
        }
    }
}
```

### 集成LangChain4j

**使用LangChain4j增强AI能力：**

```kotlin
class EnhancedTravelServer : MCPServer() {
    
    private val chatModel = OpenAiChatModel.builder()
        .apiKey(System.getenv("OPENAI_API_KEY"))
        .modelName("gpt-4")
        .build()
    
    private val assistant = AiServices.builder(TravelAssistant::class.java)
        .chatLanguageModel(chatModel)
        .tools(FlightTools(flightService))
        .build()
    
    // 使用LangChain4j的Tool
    private val smartSearchTool = tool {
        name = "smart_flight_search"
        description = "智能搜索航班，支持自然语言查询"
        
        inputSchema {
            property("query", String::class) { 
                description = "自然语言查询，如'明天去上海的便宜航班'"
                required = true
            }
        }
        
        handler { params ->
            val query = params["query"] as String
            val response = assistant.chat(query)
            ToolResult(content = response)
        }
    }
}

interface TravelAssistant {
    @SystemMessage("""
        你是一个专业的旅行助手。帮助用户搜索航班、预订机票。
        根据用户的自然语言描述，理解他们的需求并提供最佳建议。
    """)
    fun chat(@UserMessage query: String): String
}
```

### 数据库设计

**持久化层实现：**

```kotlin
// 实体定义
@Entity
@Table(name = "bookings")
data class Booking(
    @Id
    val id: String = UUID.randomUUID().toString(),
    
    @Column(name = "flight_id")
    val flightId: String,
    
    @Column(name = "passenger_name")
    val passengerName: String,
    
    @Column(name = "passenger_id")
    val passengerId: String,
    
    @Column(name = "status")
    val status: BookingStatus = BookingStatus.CONFIRMED,
    
    @Column(name = "created_at")
    val createdAt: LocalDateTime = LocalDateTime.now()
)

enum class BookingStatus {
    CONFIRMED, CANCELLED, COMPLETED
}

// Repository
interface BookingRepository : JpaRepository<Booking, String> {
    fun findByPassengerId(passengerId: String): List<Booking>
    fun findByStatus(status: BookingStatus): List<Booking>
}

// Service
@Service
class BookingService(
    private val bookingRepository: BookingRepository,
    private val flightService: FlightService
) {
    @Transactional
    fun book(flightId: String, passengerName: String, passengerId: String): Booking {
        // 检查航班是否存在
        val flight = flightService.findById(flightId)
            ?: throw IllegalArgumentException("航班不存在: $flightId")
        
        // 检查座位是否充足
        if (flight.availableSeats <= 0) {
            throw IllegalStateException("航班已满")
        }
        
        // 创建预订
        val booking = Booking(
            flightId = flightId,
            passengerName = passengerName,
            passengerId = passengerId
        )
        
        // 减少可用座位
        flightService.decreaseAvailableSeats(flightId)
        
        return bookingRepository.save(booking)
    }
    
    @Transactional
    fun cancel(bookingId: String) {
        val booking = bookingRepository.findById(bookingId)
            .orElseThrow { IllegalArgumentException("预订不存在: $bookingId") }
        
        if (booking.status == BookingStatus.CANCELLED) {
            throw IllegalStateException("预订已取消")
        }
        
        // 恢复座位
        flightService.increaseAvailableSeats(booking.flightId)
        
        // 更新状态
        booking.status = BookingStatus.CANCELLED
        bookingRepository.save(booking)
    }
}
```

### API端点设计

**RESTful API规范：**

```kotlin
@RestController
@RequestMapping("/api/mcp")
class MCPController(
    private val travelServer: TravelMCPServer
) {
    
    // MCP协议端点
    @PostMapping("/initialize")
    fun initialize(@RequestBody request: InitializeRequest): InitializeResponse {
        return travelServer.initialize(request)
    }
    
    @PostMapping("/tools/list")
    fun listTools(): ListToolsResponse {
        return travelServer.listTools()
    }
    
    @PostMapping("/tools/call")
    fun callTool(@RequestBody request: CallToolRequest): CallToolResponse {
        return travelServer.callTool(request)
    }
    
    @PostMapping("/resources/list")
    fun listResources(): ListResourcesResponse {
        return travelServer.listResources()
    }
    
    @PostMapping("/resources/read")
    fun readResource(@RequestBody request: ReadResourceRequest): ReadResourceResponse {
        return travelServer.readResource(request)
    }
    
    @PostMapping("/prompts/list")
    fun listPrompts(): ListPromptsResponse {
        return travelServer.listPrompts()
    }
    
    @PostMapping("/prompts/get")
    fun getPrompt(@RequestBody request: GetPromptRequest): GetPromptResponse {
        return travelServer.getPrompt(request)
    }
}
```

### 认证与授权

**安全机制实现：**

```kotlin
@Configuration
@EnableWebSecurity
class SecurityConfig {
    
    @Bean
    fun securityFilterChain(http: HttpSecurity): SecurityFilterChain {
        http
            .authorizeHttpRequests { auth ->
                auth.requestMatchers("/api/mcp/**").authenticated()
                    .anyRequest().permitAll()
            }
            .oauth2ResourceServer { oauth2 ->
                oauth2.jwt { jwt ->
                    jwt.jwtAuthenticationConverter(jwtAuthenticationConverter())
                }
            }
        
        return http.build()
    }
    
    private fun jwtAuthenticationConverter(): Converter<Jwt, JwtAuthenticationToken> {
        val converter = JwtAuthenticationConverter()
        converter.setJwtGrantedAuthoritiesConverter(JwtGrantedAuthoritiesConverter())
        return converter
    }
}

// MCP服务器中的权限检查
class SecureTravelServer : TravelMCPServer() {
    
    override fun callTool(request: CallToolRequest): CallToolResponse {
        val authentication = SecurityContextHolder.getContext().authentication
        
        // 检查用户是否有权限调用该工具
        if (!hasPermission(authentication, request.name)) {
            throw AccessDeniedException("无权限调用工具: ${request.name}")
        }
        
        return super.callTool(request)
    }
    
    private fun hasPermission(auth: Authentication, toolName: String): Boolean {
        val authorities = auth.authorities.map { it.authority }
        
        return when (toolName) {
            "search_flights" -> true  // 所有人都可以搜索
            "book_flight" -> authorities.contains("ROLE_USER")
            "cancel_booking" -> authorities.contains("ROLE_USER")
            "admin_tools" -> authorities.contains("ROLE_ADMIN")
            else -> false
        }
    }
}
```

## 集成与部署

### 测试策略

**单元测试：**

```kotlin
@SpringBootTest
class TravelMCPServerTest {
    
    @Autowired
    private lateinit var travelServer: TravelMCPServer
    
    @Test
    fun `should list all available tools`() {
        val response = travelServer.listTools()
        
        assertThat(response.tools).hasSize(3)
        assertThat(response.tools.map { it.name }).containsExactlyInAnyOrder(
            "search_flights",
            "book_flight",
            "cancel_booking"
        )
    }
    
    @Test
    fun `should search flights successfully`() {
        val request = CallToolRequest(
            name = "search_flights",
            arguments = mapOf(
                "departure" to "北京",
                "destination" to "上海",
                "date" to "2026-04-05"
            )
        )
        
        val response = travelServer.callTool(request)
        
        assertThat(response.isError).isFalse()
        assertThat(response.content).contains("航班")
    }
    
    @Test
    fun `should handle invalid parameters`() {
        val request = CallToolRequest(
            name = "search_flights",
            arguments = mapOf(
                "departure" to "北京"
                // 缺少destination和date
            )
        )
        
        val response = travelServer.callTool(request)
        
        assertThat(response.isError).isTrue()
        assertThat(response.content).contains("缺少必需参数")
    }
}
```

**集成测试：**

```kotlin
@SpringBootTest(webEnvironment = SpringBootTest.WebEnvironment.RANDOM_PORT)
class MCPIntegrationTest {
    
    @Autowired
    private lateinit var webTestClient: WebTestClient
    
    @Test
    fun `should complete full booking flow`() {
        // 1. 初始化
        val initRequest = InitializeRequest(
            protocolVersion = "2024-11-05",
            capabilities = ClientCapabilities(),
            clientInfo = ClientInfo(name = "TestClient", version = "1.0")
        )
        
        webTestClient.post()
            .uri("/api/mcp/initialize")
            .bodyValue(initRequest)
            .exchange()
            .expectStatus().isOk
            .expectBody<InitializeResponse>()
            .returnResult().responseBody
        
        // 2. 搜索航班
        val searchRequest = CallToolRequest(
            name = "search_flights",
            arguments = mapOf(
                "departure" to "北京",
                "destination" to "上海",
                "date" to "2026-04-05"
            )
        )
        
        val searchResponse = webTestClient.post()
            .uri("/api/mcp/tools/call")
            .bodyValue(searchRequest)
            .exchange()
            .expectStatus().isOk
            .expectBody<CallToolResponse>()
            .returnResult().responseBody
        
        val flights = JsonParser.parseString(searchResponse.content)
            .asJsonObject.getAsJsonArray("flights")
        val flightId = flights[0].asJsonObject.get("id").asString
        
        // 3. 预订航班
        val bookRequest = CallToolRequest(
            name = "book_flight",
            arguments = mapOf(
                "flightId" to flightId,
                "passengerName" to "张三",
                "passengerId" to "110101199001011234"
            )
        )
        
        webTestClient.post()
            .uri("/api/mcp/tools/call")
            .bodyValue(bookRequest)
            .exchange()
            .expectStatus().isOk
            .expectBody<CallToolResponse>()
            .value { response ->
                assertThat(response.isError).isFalse()
                assertThat(response.content).contains("预订成功")
            }
    }
}
```

### 部署配置

**Docker部署：**

```dockerfile
FROM openjdk:17-jdk-slim

WORKDIR /app

COPY build/libs/travel-mcp-server.jar app.jar

EXPOSE 8080

ENV SPRING_PROFILES_ACTIVE=prod
ENV JAVA_OPTS="-Xmx512m -Xms256m"

ENTRYPOINT ["sh", "-c", "java $JAVA_OPTS -jar app.jar"]
```

**Kubernetes部署：**

```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: travel-mcp-server
spec:
  replicas: 3
  selector:
    matchLabels:
      app: travel-mcp-server
  template:
    metadata:
      labels:
        app: travel-mcp-server
    spec:
      containers:
      - name: mcp-server
        image: travel-mcp-server:latest
        ports:
        - containerPort: 8080
        env:
        - name: SPRING_PROFILES_ACTIVE
          value: "prod"
        - name: DB_HOST
          valueFrom:
            secretKeyRef:
              name: db-secret
              key: host
        resources:
          requests:
            memory: "512Mi"
            cpu: "250m"
          limits:
            memory: "1Gi"
            cpu: "500m"
        livenessProbe:
          httpGet:
            path: /actuator/health
            port: 8080
          initialDelaySeconds: 30
          periodSeconds: 10
        readinessProbe:
          httpGet:
            path: /actuator/health
            port: 8080
          initialDelaySeconds: 5
          periodSeconds: 5
```

### 监控与日志

**日志配置：**

```xml
<!-- logback-spring.xml -->
<configuration>
    <springProfile name="dev">
        <appender name="CONSOLE" class="ch.qos.logback.core.ConsoleAppender">
            <encoder>
                <pattern>%d{yyyy-MM-dd HH:mm:ss} [%thread] %-5level %logger{36} - %msg%n</pattern>
            </encoder>
        </appender>
        
        <logger name="io.modelcontextprotocol" level="DEBUG"/>
        <root level="INFO">
            <appender-ref ref="CONSOLE"/>
        </root>
    </springProfile>
    
    <springProfile name="prod">
        <appender name="JSON" class="ch.qos.logback.core.rolling.RollingFileAppender">
            <file>/var/log/mcp-server/application.log</file>
            <encoder class="net.logstash.logback.encoder.LogstashEncoder">
                <includeMdcKeyName>traceId</includeMdcKeyName>
                <includeMdcKeyName>spanId</includeMdcKeyName>
            </encoder>
            <rollingPolicy class="ch.qos.logback.core.rolling.TimeBasedRollingPolicy">
                <fileNamePattern>/var/log/mcp-server/application.%d{yyyy-MM-dd}.log</fileNamePattern>
                <maxHistory>30</maxHistory>
            </rollingPolicy>
        </appender>
        
        <root level="INFO">
            <appender-ref ref="JSON"/>
        </root>
    </springProfile>
</configuration>
```

**监控指标：**

```kotlin
@Configuration
class MetricsConfig {
    
    @Bean
    fun mcpToolCallTimer(meterRegistry: MeterRegistry): Timer {
        return Timer.builder("mcp.tool.call.duration")
            .description("MCP工具调用耗时")
            .tag("tool", "unknown")
            .register(meterRegistry)
    }
    
    @Bean
    fun mcpToolCallCounter(meterRegistry: MeterRegistry): Counter {
        return Counter.builder("mcp.tool.call.count")
            .description("MCP工具调用次数")
            .tag("tool", "unknown")
            .tag("status", "unknown")
            .register(meterRegistry)
    }
}

// 在MCP服务器中记录指标
class MonitoredTravelServer(
    private val toolCallTimer: Timer,
    private val toolCallCounter: Counter
) : TravelMCPServer() {
    
    override fun callTool(request: CallToolRequest): CallToolResponse {
        val startTime = System.currentTimeMillis()
        
        return try {
            val response = super.callTool(request)
            
            // 记录成功调用
            toolCallTimer.record(System.currentTimeMillis() - startTime, TimeUnit.MILLISECONDS)
            toolCallCounter.increment()
            
            response
        } catch (e: Exception) {
            // 记录失败调用
            toolCallCounter.increment()
            throw e
        }
    }
}
```

## 最佳实践与注意事项

### 设计原则

**1. 单一职责原则**

每个MCP服务器应该专注于一个特定的领域或功能。例如，不要在一个服务器中同时提供航班预订和天气查询功能，而是创建两个独立的服务器

**2. 最小权限原则**

Tools应该只请求必要的参数，Resources应该只暴露必要的数据。避免过度授权导致的安全风险

**3. 错误友好原则**

所有的错误都应该提供清晰的错误信息和解决建议，帮助用户理解问题并采取正确的行动

### 性能优化

**1. 异步处理**

对于耗时的操作（如网络请求、数据库查询），使用异步处理避免阻塞：

```kotlin
private val searchFlightsTool = tool {
    name = "search_flights"
    // ...
    
    handler { params ->
        // 使用协程进行异步处理
        runBlocking {
            val flights = async { flightService.searchAsync(params) }.await()
            ToolResult(content = flights.toJson())
        }
    }
}
```

**2. 缓存策略**

对于频繁访问的数据，实现缓存机制：

```kotlin
@Service
class CachedFlightService(
    private val flightService: FlightService,
    private val cacheManager: CacheManager
) {
    
    @Cacheable(value = ["flights"], key = "#departure + '-' + #destination + '-' + #date")
    fun search(departure: String, destination: String, date: String): List<Flight> {
        return flightService.search(departure, destination, date)
    }
}
```

**3. 批量操作**

支持批量操作减少网络开销：

```kotlin
private val batchBookTool = tool {
    name = "batch_book_flights"
    description = "批量预订多个航班"
    
    inputSchema {
        property("bookings", Array<Any>::class) {
            description = "预订列表"
            required = true
        }
    }
    
    handler { params ->
        val bookings = params["bookings"] as List<Map<String, Any>>
        val results = bookings.map { booking ->
            try {
                bookingService.book(
                    flightId = booking["flightId"] as String,
                    passengerName = booking["passengerName"] as String,
                    passengerId = booking["passengerId"] as String
                )
            } catch (e: Exception) {
                BookingResult(success = false, error = e.message)
            }
        }
        
        ToolResult(content = results.toJson())
    }
}
```

### 安全考虑

**1. 输入验证**

所有输入参数都应该进行严格的验证：

```kotlin
private fun validateSearchParams(params: Map<String, Any>) {
    require(params.containsKey("departure")) { "缺少出发城市" }
    require(params.containsKey("destination")) { "缺少目的城市" }
    require(params.containsKey("date")) { "缺少出发日期" }
    
    val datePattern = Regex("\\d{4}-\\d{2}-\\d{2}")
    val date = params["date"] as String
    require(datePattern.matches(date)) { "日期格式不正确，应为YYYY-MM-DD" }
}
```

**2. 速率限制**

实现速率限制防止滥用：

```kotlin
@Configuration
class RateLimitConfig {
    
    @Bean
    fun rateLimiter(): RateLimiter {
        return RateLimiter.create(10.0) // 每秒最多10个请求
    }
}

class RateLimitedTravelServer(
    private val rateLimiter: RateLimiter
) : TravelMCPServer() {
    
    override fun callTool(request: CallToolRequest): CallToolResponse {
        if (!rateLimiter.tryAcquire()) {
            throw RateLimitExceededException("请求过于频繁，请稍后再试")
        }
        
        return super.callTool(request)
    }
}
```

**3. 敏感数据处理**

对于敏感数据（如身份证号、信用卡号），应该进行脱敏处理：

```kotlin
private fun maskSensitiveData(data: String): String {
    return when {
        data.matches(Regex("\\d{17}[\\dXx]")) -> {
            // 身份证号：显示前3位和后4位
            data.substring(0, 3) + "***********" + data.substring(14)
        }
        data.matches(Regex("\\d{16}")) -> {
            // 信用卡号：显示前4位和后4位
            data.substring(0, 4) + "********" + data.substring(12)
        }
        else -> data
    }
}
```

## 总结

MCP作为一个标准化的AI应用连接协议，通过Tools、Resources、Prompts三种核心功能模块，为AI应用与外部系统的集成提供了优雅的解决方案。其客户端-服务器架构设计实现了AI应用与外部系统的解耦，让服务提供商能够安全可控地暴露能力，同时让AI应用开发者能够专注于业务逻辑而非底层集成

通过Kotlin和LangChain4j的实现，我们可以快速构建功能完善的MCP服务器，并利用LangChain4j的AI能力增强工具的智能化水平。在实际应用中，需要遵循单一职责、最小权限、错误友好等设计原则，并关注性能优化和安全防护，才能构建出生产级别的MCP服务

随着AI应用的普及，MCP协议将在AI生态系统扮演越来越重要的角色，成为连接AI应用与外部世界的关键桥梁
