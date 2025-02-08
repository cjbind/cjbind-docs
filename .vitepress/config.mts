import { defineConfig } from 'vitepress'
import type { DefaultTheme } from 'vitepress'
import cangjie from './cangjie.tmLanguage.json'

const GUIDES: DefaultTheme.NavItemWithLink[] = [
  { text: '快速开始', link: '/guide/' },
]

export default defineConfig({
  title: "cjbind",
  lang: "zh-CN",
  description: "自动生成仓颉到 C 库的 FFI 绑定代码",
  markdown: {
    theme: {
      light: 'vitesse-light',
      dark: 'vitesse-dark',
    },
    shikiSetup: async (shiki) => {
      await shiki.loadLanguage(cangjie)
    }
  },

  themeConfig: {
    siteTitle: 'cjbind',
    nav: [
      {
        text: '指南',
        items: [
          {
            items: GUIDES,
          },
        ],
      },
    ],

    sidebar: {
      '/': [
        {
          text: '指南',
          items: GUIDES,
        },
      ],
    },

    editLink: {
      pattern: 'https://github.com/cjbind/cjbind-docs/edit/master/:path',
      text: '在 GitHub 上编辑本页',
    },
    search: {
      provider: 'local',
      options: {
        translations: {
          button: {
            buttonText: '搜索文档',
            buttonAriaLabel: '搜索文档',
          },
          modal: {
            noResultsText: '无法找到相关结果',
            resetButtonTitle: '清除查询条件',
            footer: {
              selectText: '选择',
              navigateText: '切换',
              closeText: '关闭',
            },
          },
        },
      },
    },

    socialLinks: [
      { icon: 'github', link: 'https://github.com/cjbind/cjbin' },
    ],

    footer: {
      message: '以 MIT 许可证发布',
      copyright: '版权所有 © 2024 - 现在 Zxilly',
    },

    docFooter: {
      prev: '上一页',
      next: '下一页',
    },

    outline: {
      label: '目录',
      level: 'deep'
    },

    langMenuLabel: '多语言',
    returnToTopLabel: '回到顶部',
    sidebarMenuLabel: '菜单',
    darkModeSwitchLabel: '主题',
    lightModeSwitchTitle: '切换到浅色模式',
    darkModeSwitchTitle: '切换到深色模式',
  },
  lastUpdated: true,
  cleanUrls: true,
})
