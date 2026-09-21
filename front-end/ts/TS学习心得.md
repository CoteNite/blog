# TS学习心得

随着AI时代的来临，Agent项目规模不断扩大，Py不适合工程的缺点也随之被放大，大厂的Agent项目转投使用ts作为Agent项目的开发语言，Langchain也推出了与py对应的ts版本，ts已经不仅限于前端项目，对于Agent开发也已成必要，浅谈一下ts学习上的一些心得

## tsconfig

创建ts项目后，我们会发现目录中存在一个tsconfig文件，该文件是ts的编译上下文，用于对ts编译器做一些配置，这也是和Java等语言差异比较大的地方，ts的编译器是可以通过一个专门的文件进行配置的

[tsconfig配置参数](https://juejin.cn/post/7077102548640858125)

上文提供了tsconfig中的配置参数，特别的大量，如果没有必要可以使用创建项目的时候自带的，或者使用我的另一篇文章中提供的配置

## 类型空间与值空间

ts区分了类型空间和值空间，类型空间就是用于声明类型的内容所在的空间，比如interface和type就属于类型空间，而let const var就属于值空间，值空间和类型空间的内容不能互相赋值

```ts
interface Foo{}  
type FooType = Foo;  //正确
const FooConst = Foo; //报错
```

这种对于类型空间和值空间的区分来源于ts在js的基础上引入了类型系统，为了将新引入的类型系统与原本的js隔离开，就做了这样的区分

值得注意的是，class和enum这两个关键的类型即存在于类型空间又存在于值空间，这是因为js原生就存在lass这关键字，而enum则是在最初就被定义为了要映射成js原生语言的语法，当将二者赋值给值空间变量时，class赋值的是其构造函数，enum赋值的是其运行时对象，而赋值给类型空间时，赋值的是对应者代表的类型

同时，ts准备了typeof关键字，允许开发者将一个值变量转换成一个类型变量赋值给一个类型属性，这一关键字用来沟通值空间和类型空间

## 模块

在一个ts文件中写下的代码会放在全局命名空间中，代码中的变量和函数可以被另一个文件直接使用，这样无疑是十分危险的

为了解决这个问题，ts继承了js的import和export关键字，ts编译器会搜索一个文件，当文件中出现了import或者export，他就会将这个文件视为一个模块，这样他内部的代码就只会出现在其自身的文件模块中，外部模块只能使用其export出的内容

这里有一些导入导出相关的语法

- 使用 `export` 关键字导出一个变量或类型

```
// foo.ts
export const someVar = 123;
export type someType = {
  foo: string;
};
```

- `export` 的写法除了上面这种，还有另外一种：

```ts
// foo.ts
const someVar = 123;
type someType = {
  type: string;
};

export { someVar, someType };
```

- 你也可以用重命名变量的方式导出：

```ts
// foo.ts
const someVar = 123;
export { someVar as aDifferentName };
```

- 使用 `import` 关键字导入一个变量或者是一个类型：

```ts
// bar.ts
import { someVar, someType } from './foo';
```

- 通过重命名的方式导入变量或者类型：

```ts
// bar.ts
import { someVar as aDifferentName } from './foo';
```

- 除了指定加载某个输出值，还可以使用整体加载，即用星号（*）指定一个对象，所有输出值都加载在这个对象上面：

```ts
// bar.ts
import * as foo from './foo';
// 你可以使用 `foo.someVar` 和 `foo.someType` 以及其他任何从 `foo` 导出的变量或者类型
```

- 只导入模块：

```ts
import 'core-js'; // 一个普通的 polyfill 库
```

- 从其他模块导入后整体导出：

```ts
export * from './foo';
```

- 从其他模块导入后，部分导出：

```ts
export { someVar } from './foo';
```

- 通过重命名，部分导出从另一个模块导入的项目：

```ts
export { someVar as aDifferentName } from './foo';
```

### 模块搜索机制

当我们导入一个文件，类似：

```ts
import foo from './foo';
```

当foo表示的是一个文件夹的时候，往往会先去找该文件夹下的index.ts文件,这也是为什么我们会常常在一个目录中看到index.ts这种命名的原因

具体的搜索顺序如下:

- **第一步：尝试直接当作文件匹配**
    - TS 检查硬盘上是否存在 `foo.ts`、`foo.d.ts` 或 `foo.js`。
- **第二步：尝试当作文件夹，找默认索引文件（Index）**
    - 如果 `foo` 是个文件夹，TS 会去找 `foo/index.ts`、`foo/index.d.ts` 或 `foo/index.js`。
- **第三步：尝试当作文件夹，读取 `package.json` 的 `types` 声明**
    - 如果 `foo` 是个文件夹且里面有 `package.json`，TS 会优先看里面有没有配置 `"types"`（或 `"typings"`）字段，例如：`"types": "dist/index.d.ts"`。
- **第四步：尝试当作文件夹，读取 `package.json` 的 `main` 入口**
    - 如果没有 `types` 字段，TS 会退而求其次读取 `"main"` 字段（如 `"main": "lib/index.js"`），并尝试推导其对应的 `.d.ts` 或 `.js` 文件。

### declare关键字

declare关键字用于为ts编译器声明一个已存在的实体,他相当于告诉编译器:"这个变量/函数/类/模块在运行环境中已经有了（例如由 `<script>` 标签导入、宿主环境注入或由原生 JS 库提供），你只需要对我做静态类型检查，**不要为它生成任何 JavaScript 代码**。"

**declare关键字会在转变为js代码的时候完全擦除**

对于declare关键字,我们一般会将其运用到一个.d.ts文件中,.d.ts文件是ts的类型声明文件,用于在不改变现有JavaScript 逻辑的前提下，为 JS 代码或资源提供静态类型描述与代码补全,.d.ts文件只会有类型空间的内容,用于向ts声明一些ts文件识别不了的js内容,**在 `.d.ts` 文件中**：绝大部分顶层声明（如 `const`、`function`、`class`）都**隐式带有 `declare`**，因此可以省略不写 `declare`

除了上面的功能外.declare用时候还承担为原生的 `window` 或 `ProcessEnv` 等扩展自定义属性的功能,这得益于ts的merge功能

```ts
declare global {
  interface Window {
    __INITIAL_DATA__: any;
  }
}

// 此时给 window 给赋值不会再报错
window.__INITIAL_DATA__ = { user: 'Alice' };
```

除此之外,ts还允许一个特殊的global.d.ts文件,用于声明一个全局可用的类型文件

**IMPORTANT:** .d.ts文件只适合用来沟通js和ts,为js代码补全类型空间,不适合用来声明类型,如果只是想要声明类型,那应该直接创建一个types.ts文件而不是types.d.ts文件


## TS中的特殊类型

除了常见的类型外，ts提供了六个特殊类型：any，null，undefined，never，void，unkown

- any：ts给类型系统流的后门，用于兼容所有的类型，任何的值都可以赋值给any，any可以赋值给除了never以外的所有值，可以调用任何方法（虽然没有IDE会丧失智能提示功能）（本质是ts不再对any类型的参数进行类型检验）

```ts
const a:any=1  
const c:string=a
```

- unkown:ts的顶类，用于表示任意值，不允许直接进行任何属性调用或方法操作，必须先经过类型收窄（如 `typeof`、`instanceof` 或断言）转换为具体类型后才能使用，也正因如此unkown会更加安全
- never：ts的底类，表示永远不可能发生的事情，比如必然抛出异常的函数或者存在死循环的函数
- void：表示一个函数没有返回值，不等价于undefined，undefined表示空值，void表示明确的无返回值
- undefined和null：原生JS的空值。在开启 `"strictNullChecks": true` 时，它们是独立的字面量类型，不能随意赋值给 `string` 或 `number` 等其他类型

针对undefined和null，运行时的差异是：

| **维度**                     | **undefined**                                  | **null**                                       |
| -------------------------- | ---------------------------------------------- | ---------------------------------------------- |
| **`typeof` 结果**            | `'undefined'`                                  | `'object'`（JavaScript 著名的历史 Bug）               |
| **转为数字 `Number()`**        | `NaN`                                          | `0`                                            |
| **`JSON.stringify()` 序列化** | 作为对象属性时**会被直接丢弃/忽略**                           | 被正常保留并序列化为 `"foo": null`                       |
| **宽松相等 `==`**              | `null == undefined` $\rightarrow$ **`true`**   | `null == undefined` $\rightarrow$ **`true`**   |
| **严格相等 `===`**             | `null === undefined` $\rightarrow$ **`false`** | `null === undefined` $\rightarrow$ **`false`** |

## 枚举

ts为js添加了枚举语法，我们来看一个ts的枚举案例以及其转译为js后的代码

```ts
enum Tristate {
  False,
  True,
  Unknown
}
```

```js
var Tristate;
(function(Tristate) {
  Tristate[(Tristate['False'] = 0)] = 'False';
  Tristate[(Tristate['True'] = 1)] = 'True';
  Tristate[(Tristate['Unknown'] = 2)] = 'Unknown';
})(Tristate || (Tristate = {}));
```

js代码中通过Tristatep['False']=0的方式将Tristate的False对象设置为了0，同时外部又将Tristate[0]='Flase'，因此enum中使用Tristate[0] === 'False'，Tristate['False'] === 0 Tristate.False === 0 这种做法我们可以认为key默认映射为了从0开始的number

在ts中，我们只允许enum的key映射为number或者string，针对string的映射，其对应的js如下

```ts
enum UserRoleEnum {
  ADMIN = '系统管理员',
  EDITOR = '内容编辑',
  VIEWER = '普通观察员',
}
```


```js
var UserRoleEnum;
(function (UserRoleEnum) {
    UserRoleEnum["ADMIN"] = "系统管理员";
    UserRoleEnum["EDITOR"] = "内容编辑";
    UserRoleEnum["VIEWER"] = "普通观察员";
})(UserRoleEnum || (UserRoleEnum = {}));
```

这时和number就没有关系了

### 常量枚举

```ts
enum Tristate {
  False,
  True,
  Unknown
}

const lie = Tristate.False;
```

最后一行代码转译为js时，会映射为

```js
let lie = Tristate.False
```

这违背了我们使用const的初心，为了解决这个问题，我们往往需要在enum前加const

```ts
enum Tristate {
  False,
  True,
  Unknown
}

const lie = Tristate.False;
```

这次转译后就变成了

```ts
let lie = 0;
```

## const、readonly、as const

在ts中存在这三个特别的关键字，我们细说一下他们的区别

- const：用于变量，表示当前变量不能被重新赋值
- readonly：用于属性，表示当前属性不可以被重新赋值

这里探讨一种特殊情况

```ts
const foo: {
  readonly bar: number;
} = {
  bar: 123
};

function iMutateFoo(foo: { bar: number }) {
  foo.bar = 456;
}

iMutateFoo(foo);
console.log(foo.bar); // 456


interface Foo {
  readonly bar: number;
}

let foo: Foo = {
  bar: 123
};

function iTakeFoo(foo: Foo) {
  foo.bar = 456; // Error: bar 属性只读
}

iTakeFoo(foo);
```

由于ts采取的是鸭子类型，且readonly在编译为js的时候会被完全擦除，这就导致我们将这个带有readonly修饰的类传递给一个没有readonly修饰的鸭子类型，我们发现是可以修改的，如果想要使用运行时也不被修改，则应该使用Object.freeze方法