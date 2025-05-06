import DefaultTheme from 'vitepress/theme'
import './style/index.css'
import './style/custom.css';
import { inBrowser } from 'vitepress'
import busuanzi from 'busuanzi.pure.js'
import bsz from "./components/bsz.vue"
import update from "./components/update.vue"
import ArticleMetadata from "./components/ArticleMetadata.vue"
import backtotop from "./components/backtotop.vue"
import header from "./components/header.vue"
import MyLayout from './components/MyLayout.vue'
import "vitepress-markdown-timeline/dist/theme/index.css";
import mediumZoom from 'medium-zoom';
import { onMounted, watch, nextTick } from 'vue';
import { useRoute } from 'vitepress';
import {h} from "vue";
import mermaid from "mermaid";


export default {
    extends: DefaultTheme,
    setup() {
        onMounted(() => {
            // 初始化 Mermaid
            mermaid.initialize({ startOnLoad: false })

            // 初始化 medium-zoom，尝试对 Mermaid SVG 进行缩放
            // 注意：这可能需要根据 Mermaid 生成的具体 SVG 结构进行调整
            // Mermaid 生成的 SVG 可能会被包裹在 <div class="mermaid"> 中
            mediumZoom('.mermaid svg', { background: 'var(--vp-c-bg)' });
        })
        const route = useRoute();
        const initZoom = () => {
            // mediumZoom('[data-zoomable]', { background: 'var(--vp-c-bg)' }); // 默认
            mediumZoom('.main img', { background: 'var(--vp-c-bg)' }); // 不显式添加{data-zoomable}的情况下为所有图像启用此功能
        };
        onMounted(() => {
            initZoom();
        });
        watch(
            () => route.path,
            () => nextTick(() => initZoom())
        );
    },
    enhanceApp({app,router}) {
        if (inBrowser) {
            router.onAfterRouteChanged = () => {
                busuanzi.fetch()
            }
        }
        app.component('update' , update)
        app.component('ArticleMetadata' , ArticleMetadata)
    },
    Layout() {
        return h(DefaultTheme.Layout, null, {
            'doc-footer-before': () => h(backtotop), // 使用doc-footer-before插槽
            'layout-bottom': () => h(bsz),
            'home-hero-image':()=>h(header)
        })
    }
}
