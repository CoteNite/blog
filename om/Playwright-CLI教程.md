# Playwright-cli 交互式浏览器自动化教程

## 简介与安装

### 什么是 Playwright-cli？

Playwright-cli 是一个命令行工具，为 Playwright 提供交互式界面。它允许开发者通过命令行直接与浏览器进行交互，适合快速原型开发、自动化任务和调试。

### 安装

```bash
# 通过 npx 直接运行（推荐）
npx --no-install playwright-cli --version

# 全局安装
npm install -g @playwright/cli@latest
```

安装后，主要命令为 `playwright-cli`（全局安装）或 `npx playwright-cli`（本地运行）。

---

## 核心概念

### Snapshot（快照）

Snapshot 是 playwright-cli 的核心概念。每次执行命令后，工具会生成当前浏览器状态的快照，包含页面 URL、标题以及所有可交互元素的引用（ref）。

```bash
playwright-cli open https://example.com
# 输出:
# ### Page
# - Page URL: https://example.com/
# - Page Title: Example Domain
# ### Snapshot
# [Snapshot](.playwright-cli/page-2026-02-14T19-22-42-679Z.yml)
```

### Ref 引用

Snapshot 中的每个元素都有一个 ref 标识符（如 `e1`、`e3`），用于后续操作：

```
e1 [textbox "Email"]
e2 [textbox "Password"]
e3 [button "Sign In"]
e4 [link "Forgot password?"]
```

### Raw 输出模式

使用 `--raw` 参数可以获取纯输出，便于与其他工具集成：

```bash
playwright-cli --raw snapshot > before.yml
playwright-cli click e5
playwright-cli --raw snapshot > after.yml
diff before.yml after.yml
```

---

## 基础交互操作

### 打开浏览器与导航

```bash
# 打开空白浏览器
playwright-cli open

# 打开并导航到指定页面
playwright-cli open https://example.com/

# 直接导航（等同于 open）
playwright-cli goto https://example.com/
```

### 元素交互

```bash
# 点击元素
playwright-cli click e15

# 双击
playwright-cli dblclick e7

# 悬停
playwright-cli hover e4

# 拖拽
playwright-cli drag e2 e8

# 选择下拉选项
playwright-cli select e9 "option-value"

# 文件上传
playwright-cli upload ./document.pdf

# 勾选/取消勾选复选框
playwright-cli check e12
playwright-cli uncheck e12
```

### 表单操作

```bash
# 填充文本框
playwright-cli fill e5 "user@example.com"

# 填充并提交（自动按 Enter）
playwright-cli fill e5 "user@example.com" --submit

# 输入文本（逐字输入，适合需要触发输入事件的情况）
playwright-cli type "search query"
```

### 键盘操作

```bash
# 按键
playwright-cli press Enter
playwright-cli press ArrowDown

# 键盘按住/释放
playwright-cli keydown Shift
playwright-cli keyup Shift
```

### 鼠标操作

```bash
# 移动鼠标
playwright-cli mousemove 150 300

# 鼠标按下/释放
playwright-cli mousedown
playwright-cli mousedown right
playwright-cli mouseup
playwright-cli mouseup right

# 滚动鼠标滚轮
playwright-cli mousewheel 0 100
```

### 快照与截图

```bash
# 拍摄快照
playwright-cli snapshot

# 保存到指定文件
playwright-cli snapshot --filename=after-click.yaml

# 对特定元素拍摄快照
playwright-cli snapshot "#main"

# 限制快照深度
playwright-cli snapshot --depth=4

# 截图
playwright-cli screenshot
playwright-cli screenshot e5
playwright-cli screenshot --filename=page.png

# 导出 PDF
playwright-cli pdf --filename=page.pdf
```

### 对话框处理

```bash
# 接受对话框
playwright-cli dialog-accept
playwright-cli dialog-accept "confirmation text"

# 关闭对话框
playwright-cli dialog-dismiss
```

### 窗口与视口

```bash
# 调整视口大小
playwright-cli resize 1920 1080
```

---

## 元素定位策略

### 使用 Ref（推荐）

默认使用 Snapshot 中的 ref：

```bash
playwright-cli snapshot
playwright-cli click e15
```

### CSS 选择器

```bash
# CSS 选择器
playwright-cli click "#main > button.submit"

# ID 选择器
playwright-cli fill "#email" "user@example.com"

# 类选择器
playwright-cli click ".btn-primary"
```

### Playwright Locator

```bash
# Role locator
playwright-cli click "getByRole('button', { name: 'Submit' })"

# Test ID
playwright-cli click "getByTestId('submit-button')"

# 文本内容
playwright-cli click "getByText('Learn More')"

# 占位符
playwright-cli fill "getByPlaceholder('Enter email')" "test@example.com"
```

### 属性检查

当 Snapshot 无法显示元素属性时：

```bash
# 获取元素 ID
playwright-cli eval "el => el.id" e7

# 获取所有 CSS 类
playwright-cli eval "el => el.className" e7

# 获取 data-testid 属性
playwright-cli eval "el => el.getAttribute('data-testid')" e7

# 获取 aria-label
playwright-cli eval "el => el.getAttribute('aria-label')" e7

# 获取计算样式
playwright-cli eval "el => getComputedStyle(el).display" e7
```

---

## 导航与浏览器控制

### 页面导航

```bash
# 后退
playwright-cli go-back

# 前进
playwright-cli go-forward

# 刷新
playwright-cli reload
```

### 浏览器生命周期

```bash
# 关闭浏览器
playwright-cli close

# 关闭所有浏览器
playwright-cli close-all

# 强制终止所有浏览器进程
playwright-cli kill-all

# 删除用户数据
playwright-cli delete-data
```

---

## 6. 存储管理

### Storage State（完整状态）

保存和恢复完整的浏览器状态：

```bash
# 保存到自动生成的文件
playwright-cli state-save

# 保存到指定文件
playwright-cli state-save auth.json

# 加载状态
playwright-cli state-load auth.json
```

**典型工作流：登录并保存状态**

```bash
# Step 1: 登录并保存状态
playwright-cli open https://app.example.com/login
playwright-cli fill e1 "user@example.com"
playwright-cli fill e2 "password123"
playwright-cli click e3
playwright-cli state-save auth.json

# Step 2: 后续使用保存的状态
playwright-cli state-load auth.json
playwright-cli open https://app.example.com/dashboard
# 已经登录！
```

### Cookies

```bash
# 列出所有 cookies
playwright-cli cookie-list

# 按域名过滤
playwright-cli cookie-list --domain=example.com

# 获取特定 cookie
playwright-cli cookie-get session_id

# 设置 cookie
playwright-cli cookie-set session abc123
playwright-cli cookie-set session abc123 --domain=example.com --httpOnly --secure

# 删除 cookie
playwright-cli cookie-delete session_id

# 清除所有 cookies
playwright-cli cookie-clear
```

### LocalStorage

```bash
# 列出所有 localStorage 项
playwright-cli localstorage-list

# 获取值
playwright-cli localstorage-get token

# 设置值
playwright-cli localstorage-set theme dark

# 设置 JSON 值
playwright-cli localstorage-set user_settings '{"theme":"dark"}'

# 删除项
playwright-cli localstorage-delete token

# 清除所有 localStorage
playwright-cli localstorage-clear
```

### SessionStorage

```bash
# 列出所有 sessionStorage 项
playwright-cli sessionstorage-list

# 获取值
playwright-cli sessionstorage-get step

# 设置值
playwright-cli sessionstorage-set step 3

# 删除项
playwright-cli sessionstorage-delete step

# 清除所有 sessionStorage
playwright-cli sessionstorage-clear
```

---

## 7. 网络拦截与Mock

### 基础路由命令

```bash
# Mock 资源返回 404
playwright-cli route "**/*.jpg" --status=404

# Mock API 返回 JSON
playwright-cli route "**/api/users" --body='[{"id":1,"name":"Alice"}]' --content-type=application/json

# Mock 并添加自定义头
playwright-cli route "**/api/data" --body='{"ok":true}' --header="X-Custom: value"

# 列出活跃路由
playwright-cli route-list

# 移除路由
playwright-cli unroute "**/*.jpg"
playwright-cli unroute  # 移除所有
```

### URL 匹配模式

```
**/api/users           # 精确路径匹配
**/api/*/details       # 路径中的通配符
**/*.{png,jpg,jpeg}    # 文件扩展名匹配
**/search?q=*          # 查询参数匹配
```

### 高级 Mock（使用 run-code）

**根据请求条件返回不同响应：**

```bash
playwright-cli run-code "async page => {
  await page.route('**/api/login', route => {
    const body = route.request().postDataJSON();
    if (body.username === 'admin') {
      route.fulfill({ body: JSON.stringify({ token: 'mock-token' }) });
    } else {
      route.fulfill({ status: 401, body: JSON.stringify({ error: 'Invalid' }) });
    }
  });
}"
```

**修改真实响应：**

```bash
playwright-cli run-code "async page => {
  await page.route('**/api/user', async route => {
    const response = await route.fetch();
    const json = await response.json();
    json.isPremium = true;
    await route.fulfill({ response, json });
  });
}"
```

**模拟网络失败：**

```bash
playwright-cli run-code "async page => {
  await page.route('**/api/offline', route => route.abort('internetdisconnected'));
}"
```

**添加延迟响应：**

```bash
playwright-cli run-code "async page => {
  await page.route('**/api/slow', async route => {
    await new Promise(r => setTimeout(r, 3000));
    route.fulfill({ body: JSON.stringify({ data: 'loaded' }) });
  });
}"
```

---

## 8. 多标签页管理

```bash
# 列出所有标签页
playwright-cli tab-list

# 打开新标签页
playwright-cli tab-new
playwright-cli tab-new https://example.com/page

# 关闭标签页
playwright-cli tab-close      # 关闭当前
playwright-cli tab-close 2   # 关闭指定索引

# 选择标签页
playwright-cli tab-select 0
```

**示例：多标签页工作流**

```bash
playwright-cli open https://example.com
playwright-cli tab-new https://example.com/other
playwright-cli tab-list
playwright-cli tab-select 0
playwright-cli snapshot
playwright-cli close
```

---

## 9. 浏览器会话管理

### 命名会话

使用 `-s` 参数创建隔离的浏览器会话：

```bash
# 会话 1: 认证流程
playwright-cli -s=auth open https://app.example.com/login

# 会话 2: 公开浏览（独立 cookies、storage）
playwright-cli -s=public open https://example.com

# 各会话命令相互隔离
playwright-cli -s=auth fill e1 "user@example.com"
playwright-cli -s=public snapshot
```

### 会话隔离属性

每个会话独立拥有：

- Cookies
- LocalStorage / SessionStorage
- IndexedDB
- Cache
- 浏览历史
- 打开的标签页

### 会话命令

```bash
# 列出所有会话
playwright-cli list

# 关闭会话
playwright-cli close              # 关闭默认会话
playwright-cli -s=mysession close # 关闭指定会话

# 关闭所有会话
playwright-cli close-all

# 强制终止所有进程
playwright-cli kill-all

# 删除会话用户数据
playwright-cli -s=mysession delete-data
```

### 持久化配置文件

```bash
# 使用持久化 profile（自动保存到磁盘）
playwright-cli open https://example.com --persistent

# 使用自定义 profile 目录
playwright-cli open https://example.com --profile=/path/to/profile
```

### 附加到运行中的浏览器

```bash
# 通过 channel 附加到 Chrome
playwright-cli attach --cdp=chrome

# 通过 channel 附加到 Edge
playwright-cli attach --cdp=msedge

# 通过 CDP 端点附加
playwright-cli attach --cdp=http://localhost:9222

# 通过扩展附加
playwright-cli attach --extension
```

### 浏览器选择

```bash
playwright-cli open --browser=chrome
playwright-cli open --browser=firefox
playwright-cli open --browser=webkit
playwright-cli open --browser=msedge
```

---

## 10. 自定义代码执行

`run-code` 命令允许执行任意 Playwright 代码，处理 CLI 未覆盖的高级场景。

### 基本语法

```bash
playwright-cli run-code "async page => {
  // 你的 Playwright 代码
  // 可通过 page.context() 访问浏览器上下文
}"
```

### 地理位置模拟

```bash
# 授予地理位置权限并设置位置
playwright-cli run-code "async page => {
  await page.context().grantPermissions(['geolocation']);
  await page.context().setGeolocation({ latitude: 37.7749, longitude: -122.4194 });
}"
```

### 媒体模拟

```bash
# 模拟深色模式
playwright-cli run-code "async page => {
  await page.emulateMedia({ colorScheme: 'dark' });
}"

# 模拟减少动画
playwright-cli run-code "async page => {
  await page.emulateMedia({ reducedMotion: 'reduce' });
}"
```

### 等待策略

```bash
# 等待网络空闲
playwright-cli run-code "async page => {
  await page.waitForLoadState('networkidle');
}"

# 等待特定元素
playwright-cli run-code "async page => {
  await page.locator('.loading').waitFor({ state: 'hidden' });
}"

# 等待函数返回 true
playwright-cli run-code "async page => {
  await page.waitForFunction(() => window.appReady === true);
}"
```

### Iframe 操作

```bash
playwright-cli run-code "async page => {
  const frame = page.locator('iframe#my-iframe').contentFrame();
  await frame.locator('button').click();
}"
```

### 剪贴板

```bash
# 读取剪贴板
playwright-cli run-code "async page => {
  await page.context().grantPermissions(['clipboard-read']);
  return await page.evaluate(() => navigator.clipboard.readText());
}"

# 写入剪贴板
playwright-cli run-code "async page => {
  await page.evaluate(text => navigator.clipboard.writeText(text), 'Hello!');
}"
```

### JavaScript 执行

```bash
# 执行并返回结果
playwright-cli run-code "async page => {
  return await page.evaluate(() => ({
    userAgent: navigator.userAgent,
    language: navigator.language
  }));
}"
```

### 复杂工作流

```bash
# 登录并保存状态
playwright-cli run-code "async page => {
  await page.goto('https://example.com/login');
  await page.getByRole('textbox', { name: 'Email' }).fill('user@example.com');
  await page.getByRole('textbox', { name: 'Password' }).fill('secret');
  await page.getByRole('button', { name: 'Sign in' }).click();
  await page.waitForURL('**/dashboard');
  await page.context().storageState({ path: 'auth.json' });
  return 'Login successful';
}"

# 从多个页面抓取数据
playwright-cli run-code "async page => {
  const results = [];
  for (let i = 1; i <= 3; i++) {
    await page.goto(\`https://example.com/page/\${i}\`);
    const items = await page.locator('.item').allTextContents();
    results.push(...items);
  }
  return results;
}"
```

---

## 11. 测试代码生成

Playwright-cli 的一个强大功能是自动生成测试代码。

### 工作原理

每次执行操作时，工具会在输出中显示对应的 Playwright TypeScript 代码：

```bash
playwright-cli open https://example.com/login
playwright-cli snapshot
# 输出: e1 [textbox "Email"], e2 [textbox "Password"], e3 [button "Sign In"]

playwright-cli fill e1 "user@example.com"
# 输出: await page.getByRole('textbox', { name: 'Email' }).fill('user@example.com');

playwright-cli fill e2 "password123"
# 输出: await page.getByRole('textbox', { name: 'Password' }).fill('password123');

playwright-cli click e3
# 输出: await page.getByRole('button', { name: 'Sign In' }).click();
```

### 构建测试文件

将生成的代码整合到 Playwright 测试中：

```typescript
import { test, expect } from '@playwright/test';

test('login flow', async ({ page }) => {
  await page.goto('https://example.com/login');
  await page.getByRole('textbox', { name: 'Email' }).fill('user@example.com');
  await page.getByRole('textbox', { name: 'Password' }).fill('password123');
  await page.getByRole('button', { name: 'Sign In' }).click();

  // 添加断言
  await expect(page).toHaveURL(/.*dashboard/);
});
```

### 最佳实践

1. **使用语义化 Locator**：生成的代码优先使用 role-based locators，更稳定
2. **先探索再记录**：先用 snapshot 了解页面结构
3. **手动添加断言**：生成的代码只包含操作，不包含断言

---

## 12. 调试与追踪

### 控制台输出

```bash
# 监听控制台消息
playwright-cli console

# 只显示警告
playwright-cli console warning

# 显示网络请求
playwright-cli network
```

### 追踪录制

追踪记录详细的执行过程，包括 DOM 快照、截图、网络活动和控制台日志。

```bash
# 开始录制
playwright-cli tracing-start

# 执行操作
playwright-cli open https://example.com
playwright-cli click e1
playwright-cli fill e2 "test"

# 停止录制
playwright-cli tracing-stop
```

**追踪文件结构：**

- `trace-{timestamp}.trace` - 主追踪文件，包含所有操作日志
- `trace-{timestamp}.network` - 网络活动日志
- `resources/` - 缓存的资源文件

### 调试 Playwright 测试

```bash
# 运行测试并进入调试模式
PLAYWRIGHT_HTML_OPEN=never npx playwright test --debug=cli

# 等待调试指令输出，其中包含会话名称
# ...
# ... debugging instructions for "tw-abcdef" session ...
# ...

# 附加到测试会话
playwright-cli attach tw-abcdef
```

测试会在开始时暂停，使用 CLI 探索页面找到问题后，停止后台测试运行并重新执行验证修复。

---

## 13. 视频录制

### 基础录制

```bash
playwright-cli open
playwright-cli video-start demo.webm
playwright-cli video-chapter "Getting Started" --description="Opening homepage" --duration=2000
playwright-cli goto https://example.com
playwright-cli click e1
playwright-cli video-stop
```

### 高级录制（使用 run-code）

对于需要更精细控制的录制，使用 `run-code` 执行完整脚本：

```javascript
async page => {
  await page.screencast.start({ path: 'video.webm', size: { width: 1280, height: 800 } });
  await page.goto('https://demo.playwright.dev/todomvc');

  // 显示章节卡片
  await page.screencast.showChapter('Adding Todo Items', {
    description: 'We will add several items to the todo list.',
    duration: 2000,
  });

  // 执行操作
  await page.getByRole('textbox', { name: 'What needs to be done?' })
    .pressSequentially('Walk the dog', { delay: 60 });
  await page.getByRole('textbox', { name: 'What needs to be done?' }).press('Enter');
  await page.waitForTimeout(1000);

  // 显示叠加层
  const bounds = await page.getByText('Walk the dog').boundingBox();
  await page.screencast.showOverlay(\`
    <div style="position: absolute;
      top: \${bounds.y}px; left: \${bounds.x}px;
      width: \${bounds.width}px; height: \${bounds.height}px;
      border: 2px solid red;">
    </div>
  \`, { duration: 2000 });

  await page.screencast.stop();
}
```

**Overlay API 总结：**

| 方法 | 用途 |
|------|------|
| `page.screencast.showChapter()` | 全屏章节卡片，适合章节切换 |
| `page.screencast.showOverlay()` | 自定义 HTML 叠加层，用于标注、高亮 |
| `disposable.dispose()` | 移除叠加层 |
| `page.screencast.hideOverlays()` | 隐藏所有叠加层 |

---

## 14. 最佳实践

### 1. 语义化命名会话

```bash
# 推荐：清晰的用途
playwright-cli -s=github-auth open https://github.com
playwright-cli -s=docs-scrape open https://docs.example.com

# 避免：通用名称
playwright-cli -s=s1 open https://github.com
```

### 2. 及时清理资源

```bash
# 操作完成后关闭浏览器
playwright-cli -s=auth close
playwright-cli -s=scrape close

# 或一次性关闭所有
playwright-cli close-all

# 清理僵尸进程
playwright-cli kill-all
```

### 3. 清理旧追踪文件

```bash
# 删除 7 天前的追踪
find .playwright-cli/traces -mtime +7 -delete
```

### 4. 安全存储状态

- 永不提交包含认证 token 的存储状态文件
- 将 `*.auth-state.json` 加入 `.gitignore`
- 自动化完成后删除状态文件

### 5. 使用 run-code 处理复杂场景

CLI 命令适合简单操作，复杂场景使用 `run-code`：

```bash
# 适合 CLI：简单表单填充
playwright-cli fill e1 "user@example.com"
playwright-cli click e2

# 适合 run-code：条件逻辑、多个操作组合
playwright-cli run-code "async page => {
  await page.route('**/api/**', route => {
    if (route.request().url().includes('premium')) {
      route.fulfill({ body: JSON.stringify({ access: 'granted' }) });
    } else {
      route.abort();
    }
  });
}"
```

---

## 附录：常用命令速查表

| 类别 | 命令 |
|------|------|
| **打开/关闭** | `playwright-cli open [url]`, `playwright-cli close` |
| **交互** | `playwright-cli click <ref>`, `playwright-cli fill <ref> <text>`, `playwright-cli type <text>` |
| **导航** | `playwright-cli goto <url>`, `playwright-cli go-back`, `playwright-cli reload` |
| **快照** | `playwright-cli snapshot`, `playwright-cli screenshot` |
| **存储** | `playwright-cli state-save`, `playwright-cli state-load`, `playwright-cli cookie-*`, `playwright-cli localstorage-*` |
| **网络** | `playwright-cli route`, `playwright-cli route-list`, `playwright-cli unroute` |
| **标签页** | `playwright-cli tab-new`, `playwright-cli tab-list`, `playwright-cli tab-select` |
| **会话** | `playwright-cli -s=<name> open`, `playwright-cli list`, `playwright-cli close-all` |
| **调试** | `playwright-cli console`, `playwright-cli network`, `playwright-cli tracing-start/stop` |
| **录制** | `playwright-cli video-start`, `playwright-cli video-chapter`, `playwright-cli video-stop` |
