import { defineConfig } from 'vitepress'
import cangjie from './cangjie.tmLanguage.json'

const zhGuides = [
  { text: '简介', link: '/guide/' },
  { text: '快速开始', link: '/guide/quick_start' },
  { text: '安装', link: '/guide/install' },
  { text: '命令行使用', link: '/guide/command_line' },
  { text: 'Objective-C 绑定', link: '/guide/objective_c' },
  { text: '已知限制', link: '/guide/limitation' },
]

const enGuides = [
  { text: 'Introduction', link: '/en/guide/' },
  { text: 'Quick Start', link: '/en/guide/quick_start' },
  { text: 'Installation', link: '/en/guide/install' },
  { text: 'Command Line', link: '/en/guide/command_line' },
  { text: 'Objective-C Bindings', link: '/en/guide/objective_c' },
  { text: 'Limitations', link: '/en/guide/limitation' },
]

export default defineConfig({
  title: "cjbind",
  description: "从 C 和 Objective-C 头文件生成仓颉 FFI 绑定代码",
  lang: 'zh-CN',

  transformPageData(pageData) {
    if (pageData.relativePath === '404.md') return
    const path = pageData.relativePath.replace(/index\.md$/, '').replace(/\.md$/, '')
    const chinesePath = path.replace(/^en\//, '')
    const origin = 'https://cjbind.zxilly.dev/'
    const canonical = origin + path
    const english = path.startsWith('en/')
    pageData.frontmatter.head ??= []
    pageData.frontmatter.head.push(
      ['link', { rel: 'canonical', href: canonical }],
      ['link', { rel: 'alternate', hreflang: 'zh-CN', href: origin + chinesePath }],
      ['link', { rel: 'alternate', hreflang: 'en-US', href: origin + 'en/' + chinesePath }],
      ['link', { rel: 'alternate', hreflang: 'x-default', href: origin + chinesePath }],
      ['meta', { property: 'og:type', content: 'website' }],
      ['meta', { property: 'og:site_name', content: 'cjbind' }],
      ['meta', { property: 'og:title', content: `${pageData.title} | cjbind` }],
      ['meta', { property: 'og:description', content: pageData.description }],
      ['meta', { property: 'og:url', content: canonical }],
      ['meta', { property: 'og:locale', content: english ? 'en_US' : 'zh_CN' }],
    )
  },

  locales: {
    root: {
      label: '简体中文',
      lang: 'zh-CN',
      themeConfig: {
        nav: [
          {
            text: '指南',
            items: [{ items: zhGuides }],
          },
        ],
        sidebar: {
          '/': [
            {
              text: '指南',
              items: zhGuides,
            },
          ],
        },
        editLink: {
          pattern: 'https://github.com/cjbind/cjbind-docs/edit/master/:path',
          text: '在 GitHub 上编辑本页',
        },
        footer: {
          message: '以 MIT 许可证发布',
          copyright: `版权所有 © 2024 - ${new Date().getFullYear()} Zxilly`,
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
        lastUpdated: {
          text: '上次更新于',
          formatOptions: {
            dateStyle: 'short',
            timeStyle: 'short',
            hour12: false,
            timeZone: 'Asia/Shanghai'
          }
        }
      }
    },
    en: {
      description: 'Generate Cangjie FFI bindings from C and Objective-C headers.',
      label: 'English',
      lang: 'en-US',
      link: '/en/',
      themeConfig: {
        nav: [
          {
            text: 'Guide',
            items: [{ items: enGuides }],
          },
        ],
        sidebar: {
          '/en/': [
            {
              text: 'Guide',
              items: enGuides,
            },
          ],
        },
        editLink: {
          pattern: 'https://github.com/cjbind/cjbind-docs/edit/master/:path',
          text: 'Edit this page on GitHub',
        },
        footer: {
          message: 'Released under the MIT License',
          copyright: `Copyright © 2024 - ${new Date().getFullYear()} Zxilly`,
        },
        docFooter: {
          prev: 'Previous',
          next: 'Next',
        },
        outline: {
          label: 'Table of Contents',
          level: 'deep'
        },
        lastUpdated: {
          text: 'Last updated',
          formatOptions: {
            dateStyle: 'short',
            timeStyle: 'short',
          }
        }
      }
    }
  },

  markdown: {
    theme: {
      light: 'vitesse-light',
      dark: 'vitesse-dark',
    },
    shikiSetup: async (shiki) => {
      await shiki.loadLanguage(cangjie)
    },
    container: {
      tipLabel: '提示',
      warningLabel: '警告',
      dangerLabel: '危险',
      infoLabel: '信息',
      detailsLabel: '详细信息'
    },
  },

  themeConfig: {
    siteTitle: 'cjbind',
    socialLinks: [
      { icon: 'github', link: 'https://github.com/cjbind/cjbind' },
    ],
    search: {
      provider: 'local',
      options: {
        locales: {
          root: {
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
          en: {
            translations: {
              button: {
                buttonText: 'Search',
                buttonAriaLabel: 'Search',
              },
              modal: {
                noResultsText: 'No results found',
                resetButtonTitle: 'Reset search',
                footer: {
                  selectText: 'Select',
                  navigateText: 'Navigate',
                  closeText: 'Close',
                },
              },
            },
          },
        },
      },
    },
  },

  head: [
    [
      'script',
      {
        defer: "true",
        src: 'https://trail.learningman.top/script.js',
        'data-website-id': 'ee8c2794-9441-4be4-8fb1-185cbda5c3a6',
        'data-domains': 'cjbind.zxilly.dev',
        'data-exclude-search': 'true',
        'data-exclude-hash': 'true',
      }
    ]
  ],
  sitemap: {
    hostname: 'https://cjbind.zxilly.dev',
  },
  srcExclude: ['README.md'],
  lastUpdated: true,
  cleanUrls: true,
})
