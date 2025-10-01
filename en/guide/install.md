# Installation

## Binary Installation

Because the program depends on `libclang`, it cannot be directly installed using `cjpm install`. You can visit [GitHub Release](https://github.com/cjbind/cjbind/releases) to download the binary file corresponding to your system.

After downloading, you need to place the `cjbind` executable in your system's `PATH`, so you can run the `cjbind` command directly in the terminal.

::: warning
Because Cangjie currently does not support static linking, running `cjbind` requires ensuring that Cangjie-related environment variables are properly configured.
:::

::: warning
cjbind requires a **minimum glibc version of 2.34**; if lower than this version, it will not run.

- **Mainstream distribution glibc versions:**
  - Ubuntu 24.04 LTS: 2.39
  - Debian 12 (Bookworm): 2.36
  - Fedora 40: 2.39
  - CentOS Stream 9 / RHEL 9: 2.34

:::

<details>
<summary>Complete list</summary>

| Distribution        | Version       | glibc Version |
| ------------------- | ------------- | ------------- |
| Ubuntu              | 24.04 LTS     | 2.39          |
| Debian              | 12 (Bookworm) | 2.36          |
| Fedora              | 40            | 2.39          |
| CentOS Stream       | 9             | 2.34          |
| RHEL                | 9             | 2.34          |
| openSUSE Tumbleweed | Rolling       | 2.41          |
| Arch Linux          | Rolling       | 2.41          |
| AlmaLinux           | 9             | 2.34          |
| Rocky Linux         | 9             | 2.34          |
| OpenEuler           | 22.03         | 2.34          |

</details>

You can check if the installation was successful by running `cjbind --version`.

```bash
$ cjbind --version
cjbind version:     0.1.3
libclang version:   clang version 19.1.7 (git://code.qt.io/clang/llvm-project.git cd708029e0b2869e80abe31ddb175f7c35361f90)

Commit Hash:     7374546176c250363933f1dd06885a05eba371bc
Commit Time:     2025-02-12 04:38:33 +0800
Tag:             v0.1.3
Clean Build:     true
```

### Script Installation

#### Linux/macOS

```shell
curl -fsSL https://cjbind.zxilly.dev/install.sh | bash
```

You can use mirror sources to accelerate download:

```shell
curl -fsSL https://cjbind.zxilly.dev/install.sh | bash -s -- --mirror
```

#### Windows

```powershell
irm https://cjbind.zxilly.dev/install.ps1 | iex
```

You can use mirror sources to accelerate download:

```powershell
& ([scriptblock]::Create((irm https://cjbind.zxilly.dev/install.ps1))) --mirror
```

## Source Installation

You can check the `DEVELOPMENT.md` file included in the `cjbind` source code, which contains detailed steps on how to build `cjbind` locally and pull dependencies.
