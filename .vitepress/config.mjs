import { defineConfig } from 'vitepress'
import timeline from "vitepress-markdown-timeline";
import {generateSidebar, withSidebar} from 'vitepress-sidebar';

const base='/blog/blog/'

const vitePressConfigs = {
  base,
  lastUpdated:true,
  title: "CoteNite的咖啡屋",
  description: "我的想学习小站",
  head:[
    ['link', { rel: 'icon', href: `${base}/header1.png`}]
  ],
  themeConfig: {
    // https://vitepress.dev/reference/default-theme-config
    siteTitle: "今天也要来杯咖啡吗☕",
    search: {
      provider: 'local',
      options:{
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
      { text: '<strong>常用技术</strong>', link: '/skill/1.SQL语句（基础理论篇）' },
      { text: '<strong>日穿八股</strong>', link: '/basic/' },
      { text: '<strong>干翻100</strong>', link: '/hot100/1-50' },
      { text: '<strong>算竟败犬</strong>', link: '/algorithm/1.前言' },
      { text: '<strong>主页</strong>', link: '/' },
    ],
    socialLinks: [
      { icon: 'github', link: 'https://github.com/CoteNite' }
    ],

    footer:{
      message: 'Released under the MIT License.',
      copyright: 'Copyright © 2024-present CoteNite'
    }
  },
  markdown:{
    config: (md) => {
      md.renderer.rules.heading_close = (tokens, idx, options, env, slf) => {
        md.use(timeline);
        let htmlResult = slf.renderToken(tokens, idx, options);
        if (tokens[idx].tag === 'h1') htmlResult += `<ArticleMetadata />`;
        return htmlResult;
      }
    }
  },
  sidebar: generateSidebar({
    useTitleFromFileHeading: true,
    collapsed: false, //折叠组关闭
    collapseDepth: 2, //折叠组2级菜单
  })
};


// https://vitepress.dev/reference/site-config
export default defineConfig(withSidebar(vitePressConfigs,[
    {
      documentRootPath: '',
      scanStartPath: 'hot100',
      basePath: '/hot100/',
      resolvePath: '/hot100/',
      rootGroupText:'怒刷100😡',
      removePrefixAfterOrdering: true, //删除前缀，必须与prefixSeparator一起使用
      prefixSeparator: '.', //删除前缀的符号
    },
  {
    documentRootPath: '',
    scanStartPath: 'skill',
    basePath: '/skill/',
    resolvePath: '/skill/',
    rootGroupText:'Java常用技术栈',
    removePrefixAfterOrdering: true, //删除前缀，必须与prefixSeparator一起使用
    prefixSeparator: '.', //删除前缀的符号
  },
  {

    documentRootPath: '',
    scanStartPath: 'basic',
    basePath: '/basic/',
    resolvePath: '/basic/',
    rootGroupText:'日穿八股',
    removePrefixAfterOrdering: true, //删除前缀，必须与prefixSeparator一起使用
    prefixSeparator: '.', //删除前缀的符号
  },
  {
    documentRootPath: '',
    scanStartPath: 'algorithm',
    basePath: '/algorithm/',
    resolvePath: '/algorithm/',
    rootGroupText:'算竟败犬の故事',
    removePrefixAfterOrdering: true, //删除前缀，必须与prefixSeparator一起使用
    prefixSeparator: '.', //删除前缀的符号
  },
    ])
);
