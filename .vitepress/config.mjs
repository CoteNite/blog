import { defineConfig } from 'vitepress';
import timeline from "vitepress-markdown-timeline";
import {generateSidebar, withSidebar} from 'vitepress-sidebar';
import { withMermaid } from 'vitepress-plugin-mermaid';
import mathjax3 from 'markdown-it-mathjax3';
import {RssPlugin} from "vitepress-plugin-rss";

const base = '/blog/';

// 你的 MathJax 自定义元素列表
const customElements = [
  'mjx-container', 'mjx-assistive-mml', 'math', 'maction', 'maligngroup', 'malignmark', 'menclose', 'merror', 'mfenced', 'mfrac', 'mi', 'mlongdiv', 'mmultiscripts', 'mn', 'mo', 'mover', 'mpadded', 'mphantom', 'mroot', 'mrow', 'ms', 'mscarries', 'mscarry', 'mscarries', 'msgroup', 'mstack', 'mlongdiv', 'msline', 'mstack', 'mspace', 'msqrt', 'msrow', 'mstack', 'mstack', 'mstyle', 'msub', 'msup', 'msubsup', 'mtable', 'mtd', 'mtext', 'mtr', 'munder', 'munderover', 'semantics', 'math', 'mi', 'mn', 'mo', 'ms', 'mspace', 'mtext', 'menclose', 'merror', 'mfenced', 'mfrac', 'mpadded', 'mphantom', 'mroot', 'mrow', 'msqrt', 'mstyle', 'mmultiscripts', 'mover', 'mprescripts', 'msub', 'msubsup', 'msup', 'munder', 'munderover', 'none', 'maligngroup', 'malignmark', 'mtable', 'mtd', 'mtr', 'mlongdiv', 'mscarries', 'mscarry', 'msgroup', 'msline', 'msrow', 'mstack', 'maction', 'semantics', 'annotation', 'annotation-xml',
];

const baseUrl='https://cotenite.github.io'

const RSS = {
  title: 'CoteNite的咖啡屋',
  baseUrl,
  copyright: 'Copyright (c) 2025-present, 粥里有勺糖',
}

// 你的基础 VitePress 配置对象，不包含由 withSidebar 生成的 sidebar
const baseVitePressConfig = {
  base,
  lastUpdated: true,
  title: "CoteNite的咖啡屋",
  description: "我的想学习小站",
  head: [
    ['link', { rel: 'icon', href: `${base}/header1.png` }]
  ],
  // vite:{
  //   plugins: [RssPlugin(RSS)]
  // },
  themeConfig: {
    // https://vitepress.dev/reference/default-theme-config
    siteTitle: "今天也要来杯咖啡吗☕",
    search: {
      provider: 'local',
      options: {
        translations: {
          button: {
            buttonText: "哎，整点咖啡🤓☝🏻",
            buttonAriaLabel: "哎，整点咖啡🤓☝🏻",
          },
          modal: {
            noResultsText: "没有找到结果",
            resetButtonTitle: "清除搜索条件",
            footer: {
              selectText: "选择",
              navigateText: "切换",
              closeText: "关闭",
            },
          }
        }
      }
    },
    nav: [
      { text: '<strong>苦逼后端</strong>', link: '/back-end/0.前言' },
      { text: '<strong>快乐前端</strong>', link: '/front-end/1.前言' },
      { text: '<strong>红温运维</strong>', link: '/om/1.前言' },
      { text: '<strong>日穿八股</strong>', link: '/basic/1.前言' },
      { text: '<strong>干翻100</strong>', link: '/hot100/1.前言' },
      { text: '<strong>算竟败犬</strong>', link: '/algorithm/1.前言' },
      { text: '<strong>寥寥几笔</strong>', link: '/story/1.前言' },
      // { text: '<strong>圣诞快乐</strong>', link: '/圣诞' },
      { text: '<strong>友情链接</strong>', link: '/friends/' },
      { text: '<strong>关于我</strong>', link: '/aboutMe/aboutMe' },
      { text: '<strong>主页</strong>', link: '/' },
    ],
    socialLinks: [
      { icon: 'github', link: 'https://github.com/CoteNite' }
    ],
    // themeConfig.sidebar 将由 withSidebar 生成和添加
  },
  vue: {
    template: {
      compilerOptions: {
        isCustomElement: (tag) => customElements.includes(tag),
      },
    },
  },
  markdown: {
    config: (md) => {
      // 在这里全局应用 markdown-it 插件
      md.use(timeline);
      md.use(mathjax3);

      // 你的自定义 heading_close 规则，并保留原始规则
      const originalHeadingCloseRule = md.renderer.rules.heading_close;
      md.renderer.rules.heading_close = (tokens, idx, options, env, slf) => {
        let htmlResult = originalHeadingCloseRule
            ? originalHeadingCloseRule(tokens, idx, options, env, slf)
            : slf.renderToken(tokens, idx, options);
        if (tokens[idx].tag === 'h1') htmlResult += `<ArticleMetadata />`;
        return htmlResult;
      };
    }
  },
  sidebar: generateSidebar({

    useTitleFromFileHeading: true,

    collapsed: true, //折叠组关闭

    collapseDepth: 2, //折叠组2级菜单

  })
};

// 你的侧边栏扫描配置数组
const sidebarConfigs = [
  {
    documentRootPath: '',
    scanStartPath: 'hot100',
    basePath: '/hot100/',
    resolvePath: '/hot100/',
    rootGroupText: '怒刷100😡',
    removePrefixAfterOrdering: true,
    prefixSeparator: '.',
  },
  {
    documentRootPath: '',
    scanStartPath: 'front-end',
    basePath: '/front-end/',
    resolvePath: '/front-end/',
    rootGroupText: '快乐前端',
    removePrefixAfterOrdering: true,
    prefixSeparator: '.',
  },
  {
    documentRootPath: '',
    scanStartPath: 'back-end',
    basePath: '/back-end/',
    resolvePath: '/back-end/',
    rootGroupText: '苦逼后端',
    removePrefixAfterOrdering: true,
    prefixSeparator: '.',
  },
  {
    documentRootPath: '',
    scanStartPath: 'om',
    basePath: '/om/',
    resolvePath: '/om/',
    rootGroupText: '红温运维',
    removePrefixAfterOrdering: true,
    prefixSeparator: '.',
  },
  {
    documentRootPath: '',
    scanStartPath: 'basic',
    basePath: '/basic/',
    resolvePath: '/basic/',
    rootGroupText: '日穿八股',
    removePrefixAfterOrdering: true,
    prefixSeparator: '.',
  },
  {
    documentRootPath: '',
    scanStartPath: 'algorithm',
    basePath: '/algorithm/',
    resolvePath: '/algorithm/',
    rootGroupText: '算竟败犬の故事',
    removePrefixAfterOrdering: true,
    prefixSeparator: '.',
  },
  {
    documentRootPath: '',
    scanStartPath: 'story',
    basePath: '/story/',
    resolvePath: '/story/',
    rootGroupText: '随笔几则',
    removePrefixAfterOrdering: true,
    prefixSeparator: '.',
  },
];

// 使用 withSidebar 包装基础配置，生成包含侧边栏的配置对象
const configWithSidebar = withSidebar(baseVitePressConfig, sidebarConfigs);

// 使用 withMermaid 包装上一步的结果，并添加 mermaid 特定的配置
export default defineConfig(
    withMermaid({
      // 将包含侧边栏的配置对象展开
      ...configWithSidebar,

      // 添加 mermaid 特定的配置
      mermaid: {
        // refer https://mermaid.js.org/config/setup/modules/mermaidAPI.html#mermaidapi-configuration-defaults for options
        // 你的 Mermaid 配置...
      },
      mermaidPlugin: {
        class: "mermaid my-class", // set additional css classes for parent container
        // 你的 Mermaid 插件配置...
      },

      // 如果还有其他顶层配置需要添加，可以在这里继续添加
    })
);
