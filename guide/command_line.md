# 命令行用法

如果已经按照 [安装](/guide/install) 中的说明安装了 `cjbind`，并且可以通过 `cjbind --version` 命令查看版本号，那么你可以使用 `cjbind` 命令来生成 FFI 绑定代码。

`cjbind` 命令接收一个或多个头文件路径作为输入，并可选地指定生成绑定的输出文件路径。如果未提供输出文件路径，绑定代码将输出到 `stdout`。

如果我们要从名为 `library.h` 的 C 头文件生成仓颉 FFI 绑定，并将其放入 `cjbind_ffi.cj` 文件中，可以这样调用 `cjbind`：

```bash
$ cjbind -o cjbind_ffi.cj library.h
```

如果需要同时传入多个头文件，那么最后一个头文件会作为主翻译单元，前面的头文件会通过 `-include` 方式加入：

```bash
$ cjbind base.h config.h api.h -- -I./include
```

如果要生成 Objective-C 绑定，可以启用 `--objc` 模式：

```bash
$ cjbind --objc Foundation/NSString.h
```

如果你希望生成适配仓颉 Objective-C 编译器接口的声明，可以进一步切换到 `compiler` 模式：

```bash
$ cjbind --objc --objc-codegen-mode compiler --objc-generate-definitions UIKit/UIView.h
```

关于 Objective-C 模式的支持范围、两种代码生成模式以及使用建议，可以继续阅读 [Objective-C 绑定](/guide/objective_c)。

要查看更详细的帮助信息，请传递 `--help` 参数：

```text
$ cjbind --help
自动生成仓颉到 C 库的 FFI 绑定代码。

用法：cjbind <OPTIONS> <HEADER> -- <CLANG_ARGS>

参数：
    <HEADER>          C 头文件路径
    [CLANG_ARGS]...   会被直接传递给 clang 的参数

选项：
        --no-enum-prefix                 生成枚举时，不使用枚举名称作为枚举值的前缀
        --no-detect-include-path         禁用自动 include 路径检测
        --no-comment                     不尝试生成代码中的注释
        --no-layout-test                 不生成布局测试代码
        --builtins                       生成内置定义的 bindings，如 __builtin_va_list
        --make-func-wrapper              生成 foreign 函数包装器以允许包外调用
        --func-wrapper-suffix <SUFFIX>   生成函数包装器时使用的后缀，默认为 _cjbindwrapper
        --auto-cstring                   把 char* 转换为 CString 而不是 CPointer<UInt8>
        --array-pointers-in-args         把数组 T arr[size] 转换为 VArray<T, $size> 而不是 CPointer<T>
        --make-cjstring                  把 C 字符串转换为仓颉的 String 而不是 VArray<UInt8>，这可能会导致二进制表示不一致
        --objc                           启用 Objective-C 绑定生成模式
        --objc-codegen-mode <MODE>       ObjC 代码生成模式：runtime（默认）或 compiler
        --objc-generate-definitions      在 compiler 模式下生成带默认返回值的方法桩体
        --default-enum-style <STYLE>     默认枚举生成风格：consts（默认）或 newtype
        --fit-macro-constants            根据值范围选择最小适配整数类型
    -o, --output <FILE>                  把生成的绑定输出到文件
    -p, --package <PACKAGE>              生成的绑定中的包名
    -v, --version                        显示版本号并退出
    -h, --help                           显示帮助信息
```

## 选项说明

- `--default-enum-style newtype`：把枚举生成为 `@C struct` 风格的新类型，而不是一组常量。
- `--fit-macro-constants`：生成宏常量时，不再统一使用 `Int64` / `UInt64`，而是按值范围尽量收缩到更合适的整数类型。
- `--objc`：启用 Objective-C 解析与代码生成。
- `--objc-codegen-mode runtime`：生成基于 `objc_msgSend` 的运行时封装，适合直接通过 Objective-C Runtime 调用。
- `--objc-codegen-mode compiler`：生成带 `@ObjCMirror` 等注解的声明，适合对接仓颉的 Objective-C 互操作能力。
- `--objc-generate-definitions`：仅在 `compiler` 模式下有意义，会为方法生成带默认返回值的桩体，方便先通过编译。
