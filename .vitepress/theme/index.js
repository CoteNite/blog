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
import FriendLink from "./components/FriendLink.vue"
import AboutMe from "./components/AboutMe.vue";
import SnowWrapper from './components/SnowWrapper.vue'
import "vitepress-markdown-timeline/dist/theme/index.css";
import mediumZoom from 'medium-zoom';
import { onMounted, watch, nextTick } from 'vue';
import { useRoute } from 'vitepress';
import { h } from "vue";
import mermaid from "mermaid";

export default {
    extends: DefaultTheme,
    setup() {
        onMounted(() => {
            mermaid.initialize({ startOnLoad: false })
            mediumZoom('.mermaid svg', { background: 'var(--vp-c-bg)' });
        })
        const route = useRoute();
        const initZoom = () => {
            mediumZoom('.main img', { background: 'var(--vp-c-bg)' });
        };
        onMounted(() => {
            initZoom();
        });
        watch(
            () => route.path,
            () => nextTick(() => initZoom())
        );
    },
    enhanceApp({ app, router }) {
        if (inBrowser) {
            router.onAfterRouteChanged = () => {
                busuanzi.fetch()
            }
        }
        app.component('update', update)
        app.component('ArticleMetadata', ArticleMetadata)
        app.component('FriendLink', FriendLink)
        app.component('AboutMe', AboutMe)
    },
    Layout() {
        return h(DefaultTheme.Layout, null, {
            'doc-footer-before': () => h(backtotop),
            'layout-bottom': () => [
                h(bsz),
                h(SnowWrapper)
            ],
            'home-hero-image': () => h(header)
        })
    }
}
