# Quick Start

This tutorial demonstrates how to use the cjbind tool to generate Cangjie FFI bindings for the Zstandard (zstd) library and illustrates the cross-language calling process through practical examples.

> Zstandard (zstd) is an open-source real-time data compression algorithm developed by Facebook, featuring the following core characteristics:
> 1. **High Performance**: Supports multi-threaded compression, significantly outperforming zlib in both compression and decompression speeds
> 2. **Scalable Compression Ratio**: Offers 22 preset levels ranging from ultra-fast mode to extremely high compression ratio mode
> 3. **Dictionary Compression**: Supports training custom dictionaries to enhance compression efficiency for specific datasets
> 4. **Format Compatibility**: Supports RFC 8478 standard format with forward/backward version compatibility

## Prerequisites
1. Ensure Cangjie SDK is installed with properly configured environment variables
2. Install Zstandard development library:

```shell
# Ubuntu/Debian
sudo apt-get install libzstd-dev

# CentOS/RHEL
sudo yum install libzstd-devel
```

## Step 1: Generate Binding Code
```shell
cjbind -p zstd -o zstd_bind.cj /usr/include/zstd.h -- -I/usr/include
```

Parameter explanation:
- `-p zstd`: Specifies the package name as zstd
- `/usr/include/zstd.h`: Path to zstd main header file
- `-I/usr/include`: Header file search path passed to clang
- `-o`: Specifies output file

## Step 2: Create Cangjie Project
Configure `cjpm.toml` to add dependencies:
```toml
[ffi.c]
zstd = { path = "/usr/lib/x86_64-linux-gnu/" }  # Adjust according to actual library path
```

Project structure:
```
.
├── cjpm.toml
└── src/
    ├── main.cj
    └── zstd_bind.cj  # Generated binding file

```

## Step 3: Write Code

```cangjie
// src/main.cj

func main() -> Int {
    unsafe {
        println("ZSTD version: ${ZSTD_versionNumber()}")
    }
    return 0
}
```

## Step 4: Compile and Run

```shell
cjpm build && cjpm run
```

Expected output:

```
ZSTD version: 10507
```

## Troubleshooting

1. **Library not found at runtime**:

Configure `LD_LIBRARY_PATH` to include zstd library path:

```shell
export LD_LIBRARY_PATH=/usr/local/lib:$LD_LIBRARY_PATH
```

2. **Header file parsing failed**:

Explicitly specify clang include path:

```shell
cjbind zstd.h -- -I/usr/local/include/zstd
```

Through this tutorial, you have mastered the core workflow of using cjbind for C library bindings. For more advanced usage, please refer to the C interoperability chapter in the official Cangjie documentation.
