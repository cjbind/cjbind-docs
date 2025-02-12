# 快速开始

本教程将演示如何使用 cjbind 工具为 Zstandard (zstd) 库生成仓颉语言 FFI 绑定，并通过实际示例展示跨语言调用过程。

> Zstandard (zstd) 是由 Facebook 开发的开源实时数据压缩算法，具有以下核心特性：
> 1. **高性能**：支持多线程压缩，在压缩速度和解压速度上显著优于 zlib
> 2. **可扩展压缩比**：提供从超高速模式到极高压缩比模式的22个预设级别
> 3. **字典压缩**：支持训练自定义字典提升特定数据集的压缩效率
> 4. **格式兼容**：支持 RFC 8478 标准格式，具备前向/后向版本兼容性

## 准备工作
1. 确保已安装仓颉 SDK 并正确配置环境变量
2. 安装 Zstandard 开发库：

```shell
# Ubuntu/Debian
sudo apt-get install libzstd-dev

# CentOS/RHEL
sudo yum install libzstd-devel
```

## 步骤 1：生成绑定代码
```shell
cjbind -p zstd -o zstd_bind.cj /usr/include/zstd.h -- -I/usr/include
```

参数说明：
- `-p zstd`：指定生成的包名为 zstd
- `/usr/include/zstd.h`：zstd 主头文件路径
- `-I/usr/include`：传递给 clang 的头文件搜索路径
- `-o`：指定输出文件

## 步骤 2：创建仓颉项目
配置 `cjpm.toml` 添加依赖：
```toml
[ffi.c]
zstd = { path = "/usr/lib/x86_64-linux-gnu/" }  # 根据实际库路径调整
```

项目结构：
```
.
├── cjpm.toml
└── src/
    ├── main.cj
    └── zstd_bind.cj  # 生成的绑定文件

```

## 步骤 3：编写代码

```cangjie
// src/main.cj

func main() -> Int {
    unsafe {
        println("ZSTD版本号: ${ZSTD_versionNumber()}")
    }
    return 0
}
```

## 步骤 4：编译与运行

```shell
cjpm build && cjpm run
```

预期输出：

```
ZSTD版本号: 10507
```

## 常见问题排查

1. **运行时找不到库**：

配置 `LD_LIBRARY_PATH` 包含 zstd 库路径：

```shell
export LD_LIBRARY_PATH=/usr/local/lib:$LD_LIBRARY_PATH
```

2. **头文件解析失败**：

显式指定 clang 包含路径：

```shell
cjbind zstd.h -- -I/usr/local/include/zstd
```

通过本教程，您已经掌握了使用 cjbind 进行 C 库绑定的核心流程。更多高级用法可参考仓颉官方文档的 C 互操作章节。