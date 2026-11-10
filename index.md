---
title: "仓颉 C 与 Objective-C FFI 绑定生成器"
description: "使用 cjbind 从 C 和 Objective-C 头文件生成仓颉 FFI 绑定。了解安装、Zstandard 示例、命令行选项与 ABI 限制，减少手写绑定代码。"
layout: home

hero:
  name: "cjbind"
  tagline: 自动生成 C 库到仓颉的 FFI 绑定代码
  actions:
    - theme: brand
      text: 文档
      link: /guide/

features:
  - title: "自动化绑定生成"
    icon: ⚡
    details: 通过解析 C 头文件自动生成 FFI 绑定代码，消除手工编写胶水代码
  - title: "跨平台兼容"
    icon: 🌐
    details: Windows/Linux/macOS 的 ABI 自动兼容，支持 x64/ARM 架构，确保多平台适配
  - title: "内存安全保障"
    icon: 🛡️
    details: 编译时类型检查 + 自动化内存布局生成
---

