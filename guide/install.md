# 安装

## 二进制安装

因为程序依赖 `libclang`，所以无法直接使用 `cjpm install` 安装。可以访问 [GitHub Release](https://github.com/cjbind/cjbind/releases) 下载自己系统对应的二进制文件。

下载后，你需要将 `cjbind` 可执行文件放到系统的 `PATH` 下，这样你就可以在终端中直接运行 `cjbind` 命令。

::: warning
因为仓颉当前不支持静态链接，因此运行 `cjbind` 时需要确保仓颉相关的环境变量已经配置好。
:::

你可以通过运行 `cjbind --version` 来检查是否安装成功。

```bash
$ cjbind --version
cjbind 版本：	0.1.1

Commit Hash：	fab61819eb107bd5ed5f3ea0dfc9abedaf49db6f
Commit 时间： 2025-02-08 05:24:45 +0800
开发分支：	master
标签：	v0.1.1
洁净构建：	true
```

## 源码安装

你可以查看 `cjbind` 源码中包含的 `DEVELOPMENT.md` 文件，里面包含了如何在本地构建 `cjbind` 和拉取依赖的详细步骤。