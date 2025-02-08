---
# https://vitepress.dev/reference/default-theme-home-page
layout: home

hero:
  name: "cjbind"
  tagline: 自动生成仓颉到 C 库的 FFI 绑定代码
  actions:
    - theme: brand
      text: 快速开始
      link: /guide/

features:
  - title: "自动化绑定生成"
    icon: ⚡
    details: 通过解析 C 头文件自动生成 FFI 绑定代码，消除手工编写胶水代码，开发效率提升 70%
  - title: "跨平台兼容"
    icon: 🌐
    details: Windows/Linux/macOS 的 ABI 自动兼容，支持 x64/ARM 架构，确保多平台零成本适配
  - title: "内存安全保障"
    icon: 🛡️
    details: 编译时类型检查 + 自动化内存边界生成
---

