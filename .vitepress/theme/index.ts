import DefaultTheme from 'vitepress/theme'
import type { EnhanceAppContext } from 'vitepress'
import { onMounted } from 'vue'

function handleLocaleRedirect(router: EnhanceAppContext['router']) {
  const hasVisited = localStorage.getItem('locale-redirect')
  if (hasVisited) return

  const currentPath = window.location.pathname

  if (currentPath.startsWith('/en/')) {
    localStorage.setItem('locale-redirect', 'true')
    return
  }

  const browserLang = navigator.language || navigator.languages?.[0]

  if (!browserLang || !browserLang.toLowerCase().startsWith('zh')) {
    localStorage.setItem('locale-redirect', 'true')
    const newPath = currentPath === '/' ? '/en/' : `/en${currentPath}`
    router.go(newPath)
  } else {
    localStorage.setItem('locale-redirect', 'true')
  }
}

export default {
  extends: DefaultTheme,
  enhanceApp({ router }: EnhanceAppContext) {
    if (typeof window === 'undefined') return

    onMounted(() => {
      handleLocaleRedirect(router)
    })
  }
}
