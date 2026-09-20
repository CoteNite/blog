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
        
    - 如果有，匹配成功！（“欢呼！”）
        
- **第三步：尝试当作文件夹，读取 `package.json` 的 `types` 声明**
    
    - 如果 `foo` 是个文件夹且里面有 `package.json`，TS 会优先看里面有没有配置 `"types"`（或 `"typings"`）字段，例如：`"types": "dist/index.d.ts"`。
        
    - 如果这个指定的声明文件存在，匹配成功！（“欢呼！”）
        
- **第四步：尝试当作文件夹，读取 `package.json` 的 `main` 入口**
    
    - 如果没有 `types` 字段，TS 会退而求其次读取 `"main"` 字段（如 `"main": "lib/index.js"`），并尝试推导其对应的 `.d.ts` 或 `.js` 文件。
        
    - 如果存在，匹配成功！（“欢呼！”）