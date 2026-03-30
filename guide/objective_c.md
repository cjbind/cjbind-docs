# Objective-C 绑定

`cjbind` 可以通过 `--objc` 选项解析 Objective-C 头文件，并生成适用于仓颉的绑定代码。

## 基本用法

最简单的用法如下：

```bash
$ cjbind --objc Foundation/NSString.h
```

如果还需要传递 SDK 路径、framework 搜索路径或其他 clang 参数，可以继续放在 `--` 之后：

```bash
$ cjbind --objc UIKit/UIView.h -- -isysroot /path/to/SDK -F/path/to/Frameworks
```

## 支持的声明

Objective-C 模式主要面向头文件中的接口声明，典型包括：

- `@interface`
- `@protocol`
- category
- 实例方法与类方法
- 属性
- block 参数
- 可空性信息
- 轻量级泛型的名称注释

生成结果会根据声明类型输出 class、interface、extend，以及对应的方法和属性定义。

## 代码生成模式

`--objc-codegen-mode` 提供两种模式。

### runtime

`runtime` 是默认模式。它会生成基于 Objective-C Runtime 的封装代码，通过 `objc_msgSend`、`objc_getClass`、`sel_registerName` 等运行时函数完成调用。

这种模式更接近“直接桥接调用”，适合已经明确运行时环境、并希望把 Objective-C API 作为普通仓颉封装使用的场景。

```bash
$ cjbind --objc --objc-codegen-mode runtime Foundation/NSString.h
```

### compiler

`compiler` 模式会生成带 `@ObjCMirror`、`@ForeignName`、`@ObjCInit`、`@ObjCOptional` 等注解的声明，更适合对接仓颉侧的 Objective-C 互操作能力。

```bash
$ cjbind --objc --objc-codegen-mode compiler Foundation/NSString.h
```

如果你希望生成的方法自带默认返回值桩体，方便先通过编译，可以配合 `--objc-generate-definitions`：

```bash
$ cjbind --objc --objc-codegen-mode compiler --objc-generate-definitions Foundation/NSString.h
```

## 使用建议

- 优先把系统头搜索路径和 framework 路径完整传给 clang，否则很多 Objective-C 类型无法正确解析。
- 如果目标是直接通过 Runtime 调用，优先使用 `runtime` 模式。
- 如果目标是生成更接近声明式的仓颉互操作代码，优先使用 `compiler` 模式。
- 对涉及对象所有权、生命周期或特殊 ABI 的接口，建议人工审查生成结果。

## 相关限制

Objective-C 模式能覆盖常见声明生成，但它不负责推断框架层面的高级语义。关于生命周期、特殊消息发送约定等边界情况，请同时参考 [已知限制](/guide/limitation)。
