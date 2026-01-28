# 安装

## 二进制安装

因为程序依赖 `libclang`，所以无法直接使用 `cjpm install` 安装。可以访问 [GitHub Release](https://github.com/cjbind/cjbind/releases) 下载自己系统对应的二进制文件。

下载后，你需要将 `cjbind` 可执行文件放到系统的 `PATH` 下，这样你就可以在终端中直接运行 `cjbind` 命令。

::: warning
因为仓颉当前不支持静态链接，因此运行 `cjbind` 时需要确保仓颉相关的环境变量已经配置好。
:::

::: warning
cjbind 要求系统 glibc 版本 **最低 2.34**；如果低于此版本，将无法运行。

- **主流发行版 glibc 版本：**
  - Ubuntu 24.04 LTS: 2.39
  - Debian 12 (Bookworm): 2.36
  - Fedora 40: 2.39
  - CentOS Stream 9 / RHEL 9: 2.34

:::

<details>
<summary>完整列表</summary>

| 发行版              | 版本          | glibc 版本 |
| ------------------- | ------------- | ---------- |
| Ubuntu              | 24.04 LTS     | 2.39       |
| Debian              | 12 (Bookworm) | 2.36       |
| Fedora              | 40            | 2.39       |
| CentOS Stream       | 9             | 2.34       |
| RHEL                | 9             | 2.34       |
| openSUSE Tumbleweed | 滚动更新      | 2.41       |
| Arch Linux          | 滚动更新      | 2.41       |
| AlmaLinux           | 9             | 2.34       |
| Rocky Linux         | 9             | 2.34       |
| OpenEuler           | 22.03         | 2.34       |

</details>

你可以通过运行 `cjbind --version` 来检查是否安装成功。

```bash
$ cjbind --version
cjbind 版本：	0.1.3
libclang 版本：	clang version 19.1.7 (git://code.qt.io/clang/llvm-project.git cd708029e0b2869e80abe31ddb175f7c35361f90)

Commit Hash：     7374546176c250363933f1dd06885a05eba371bc
Commit 时间：   2025-02-12 04:38:33 +0800
标签：          v0.1.3
洁净构建：    true
```

### 脚本安装

安装脚本默认安装**静态链接版本**（包含 LLVM，文件较大但无需额外依赖）。如果需要**动态链接版本**（文件较小但需要系统已安装 LLVM），可以使用 `--dynamic` 参数。

#### Linux/macOS

安装静态链接版本（默认）：

```shell
curl -fsSL https://cjbind.zxilly.dev/install.sh | bash
```

安装动态链接版本：

```shell
curl -fsSL https://cjbind.zxilly.dev/install.sh | bash -s -- --dynamic
```

使用镜像源加速下载：

```shell
# 静态链接版本
curl -fsSL https://cjbind.zxilly.dev/install.sh | bash -s -- --mirror

# 动态链接版本
curl -fsSL https://cjbind.zxilly.dev/install.sh | bash -s -- --dynamic --mirror
```

#### Windows

安装静态链接版本（默认）：

```powershell
irm https://cjbind.zxilly.dev/install.ps1 | iex
```

安装动态链接版本：

```powershell
& ([scriptblock]::Create((irm https://cjbind.zxilly.dev/install.ps1))) --dynamic
```

使用镜像源加速下载：

```powershell
# 静态链接版本
& ([scriptblock]::Create((irm https://cjbind.zxilly.dev/install.ps1))) --mirror

# 动态链接版本
& ([scriptblock]::Create((irm https://cjbind.zxilly.dev/install.ps1))) --dynamic --mirror
```

::: tip 版本选择
- **静态链接版本**：文件约 77-92 MB，包含完整的 LLVM，无需额外依赖，推荐使用
- **动态链接版本**：文件约 3-6 MB，需要系统已安装 LLVM，适合对文件大小敏感的场景
:::

## 源码安装

你可以查看 `cjbind` 源码中包含的 `DEVELOPMENT.md` 文件，里面包含了如何在本地构建 `cjbind` 和拉取依赖的详细步骤。
