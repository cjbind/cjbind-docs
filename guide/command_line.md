# 命令行用法

如果已经按照 [安装](/guide/install) 中的说明安装了 `cjbind`，并且可以通过 `cjbind --version` 命令查看版本号，那么你可以使用 `cjbind` 命令来生成 FFI 绑定代码。

`cjbind` 命令接收一个 C 或 C++ 头文件路径作为输入，并可选地指定生成绑定的输出文件路径。如果未提供输出文件路径，绑定代码将输出到 `stdout`。

如果我们要从名为 `library.h` 的 C 头文件生成 Rust FFI 绑定，并将其放入 `cjbind_ffi.cj` 文件中，可以这样调用 `cjbind`：

```bash
$ cjbind library.h -o cjbind_ffi.cj
```

要查看更详细的帮助信息，请传递 `--help` 参数：

```bash
$ cjbind --help
自动生成仓颉到 C 库的 FFI 绑定代码。

用法：cjbind <OPTIONS> <HEADER> -- <CLANG_ARGS>

参数：
    <HEADER>    C 头文件路径
    [CLANG_ARGS]...     会被直接传递给 clang 的参数

选项：
    -o, --output        <OUTPUT> 把生成的绑定输出到文件
    -p, --package       <PACKAGE> 指定生成的包名
    -V, --version       显示版本号并退出
    -h, --help          显示帮助信息
```