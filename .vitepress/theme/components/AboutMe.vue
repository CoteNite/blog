<script setup>
import {
  // 语言
  KotlinIcon,
  JavaScriptIcon,
  TypeScriptIcon,
  PythonIcon,
  // 后端
  SpringIcon,
  MySqlIcon,
  RedisIcon,
  ApacheCassandraIcon,
  InfluxDbIcon,
  Neo4jIcon,
  ApacheRocketMqIcon,
  ElasticsearchIcon,
  MinIoIcon,
  DockerIcon,
  NginxIcon,
  GradleIcon,
  KubernetesIcon,
  // 前端
  VueDotjsIcon,
  QuasarIcon,
  ElectronIcon,
  CapacitorIcon,
  ViteIcon,
  GitIcon,
  LinuxIcon,
  NodeDotjsIcon,
} from "vue3-simple-icons";

const skillGroups = [
  {
    label: '常用语言',
    icons: [
      { component: KotlinIcon, name: 'Kotlin' },
      { component: JavaScriptIcon, name: 'JavaScript' },
      { component: TypeScriptIcon, name: 'TypeScript' },
      { component: PythonIcon, name: 'Python' },
    ],
  },
  {
    label: '后端技术',
    icons: [
      { component: SpringIcon, name: 'Spring' },
      { component: MySqlIcon, name: 'MySQL' },
      { component: RedisIcon, name: 'Redis' },
      { component: ApacheCassandraIcon, name: 'Cassandra' },
      { component: InfluxDbIcon, name: 'InfluxDB' },
      { component: Neo4jIcon, name: 'Neo4j' },
      { component: ApacheRocketMqIcon, name: 'RocketMQ' },
      { component: ElasticsearchIcon, name: 'Elasticsearch' },
      { component: MinIoIcon, name: 'MinIO' },
      { component: DockerIcon, name: 'Docker' },
      { component: NginxIcon, name: 'Nginx' },
      { component: KubernetesIcon, name: 'Kubernetes' },
      { component: GradleIcon, name: 'Gradle' },
    ],
  },
  {
    label: '前端技术',
    icons: [
      { component: VueDotjsIcon, name: 'Vue.js' },
      { component: QuasarIcon, name: 'Quasar' },
      { component: ElectronIcon, name: 'Electron' },
      { component: CapacitorIcon, name: 'Capacitor' },
      { component: ViteIcon, name: 'Vite' },
      { component: NodeDotjsIcon, name: 'Node.js' },
    ],
  },
  {
    label: '工具 & 环境',
    icons: [
      { component: GitIcon, name: 'Git' },
      { component: LinuxIcon, name: 'Linux' },
    ],
  },
];
</script>

<template>
  <div class="main">
    <div class="personal-info-card">
      <div class="avatar-container">
        <div class="avatar-ring">
          <img
              src="http://localhost:9000/blog/public/header1.png"
              alt="个人头像"
              class="avatar"
          />
        </div>
      </div>
      <div class="info-container">
        <strong class="name">CoteNite</strong>
        <span class="role">大学在读 · 全栈开发</span>
        <span class="motto">主要框架：SpringBoot / Vue / Compose</span>
        <span class="motto">趁着还有热情赶紧多做点喜欢的事情....</span>
        <span class="goal">想要做出来写能够被人喜欢的东西....</span>
        <s class="sleepy">每天都是想要睡死过去的一天....</s>
      </div>
    </div>

    <!-- 技术栈 -->
    <div class="docs skills-section">
      <div class="section-header">
        <strong style="margin-bottom: 10px">一部分学过的技术：</strong>
      </div>

      <div
        v-for="group in skillGroups"
        :key="group.label"
        class="skill-category"
      >
        <span class="category-label">{{ group.label }}：</span>
        <div class="skill-icons">
          <div
            v-for="icon in group.icons"
            :key="icon.name"
            class="icon-wrap"
            :title="icon.name"
          >
            <component :is="icon.component" />
            <span class="icon-name">{{ icon.name }}</span>
          </div>
        </div>
      </div>
    </div>

    <!-- 最近在做 -->
    <div class="docs recent-work-section">
      <strong>最近主要在干的事：</strong>
      <div class="recent-list">
        <div class="recent-item">大模型应用开发转型中</div>
      </div>
    </div>
  </div>
</template>

<style scoped>
.main {
  display: flex;
  flex-direction: column;
  padding: 5% 10% 5% 10%;
  text-align: center;
}

/* ── 个人信息卡 ── */
.personal-info-card {
  display: flex;
  align-items: center;
  width: 100%;
  min-height: 280px;
  box-shadow: 0 10px 40px 0 rgb(0 0 0 / 18%);
  background-color: var(--vp-c-bg-soft);
  border-radius: 16px;
  border: 1px solid var(--vp-c-divider);
  overflow: hidden;
}

.avatar-container {
  flex: 0 0 28%;
  display: flex;
  justify-content: center;
  align-items: center;
  padding: 24px;
}

.avatar-ring {
  padding: 4px;
  border-radius: 50%;
  background: linear-gradient(135deg, var(--vp-c-brand-1), var(--vp-c-brand-2, #a78bfa));
}

.avatar {
  width: 140px;
  height: 140px;
  border-radius: 50%;
  object-fit: cover;
  display: block;
  border: 3px solid var(--vp-c-bg);
  transition: transform 0.6s ease-in-out;
}

.avatar:hover {
  transform: rotate(360deg);
}

.info-container {
  flex: 1;
  display: flex;
  flex-direction: column;
  gap: 6px;
  text-align: left;
  padding: 28px 24px 28px 0;
}

.name {
  font-size: 2.6rem;
  font-weight: 800;
  letter-spacing: -0.02em;
  line-height: 1.2;
}

.role,
.motto,
.goal,
.sleepy {
  font-size: 0.92rem;
  color: var(--vp-c-text-2);
}

.role {
  margin-top: 6px;
}

.sleepy {
  color: var(--vp-c-text-3);
}

/* ── 技术栈 ── */
.docs {
  display: flex;
  flex-direction: column;
  gap: 14px;
  width: 100%;
  margin-top: 24px;
  text-align: left;
}

.section-header {
  display: flex;
  align-items: baseline;
  gap: 10px;
  flex-wrap: wrap;
}

.section-header strong {
  font-size: 1.05rem;
}

.sub-note {
  font-size: 0.78rem;
  color: var(--vp-c-text-3);
}

.skill-category {
  display: flex;
  align-items: flex-start;
  gap: 6px;
  flex-wrap: wrap;
}

.category-label {
  font-weight: 700;
  font-size: 0.9rem;
  white-space: nowrap;
  padding-top: 6px;
  min-width: 80px;
}

.skill-icons {
  display: flex;
  gap: 12px;
  flex-wrap: wrap;
}

.icon-wrap {
  display: flex;
  flex-direction: column;
  align-items: center;
  gap: 4px;
  cursor: default;
  transition: transform 0.2s ease;
}

.icon-wrap:hover {
  transform: translateY(-3px);
}

.icon-wrap svg {
  width: 28px;
  height: 28px;
}

.icon-name {
  font-size: 0.6rem;
  color: var(--vp-c-text-3);
  white-space: nowrap;
}

/* ── 最近在做 ── */
.recent-list {
  display: flex;
  flex-direction: column;
  gap: 8px;
  margin-top: 4px;
}

.recent-item {
  font-size: 0.9rem;
  color: var(--vp-c-text-2);
  padding: 8px 14px;
  border-left: 3px solid var(--vp-c-brand-1);
  background: var(--vp-c-bg-soft);
  border-radius: 0 8px 8px 0;
}

/* ── 响应式 ── */
@media (max-width: 768px) {
  .main {
    padding: 5% 5% 5% 5%;
  }

  .personal-info-card {
    flex-direction: column;
    min-height: auto;
    padding: 24px 16px;
    align-items: center;
  }

  .avatar-container {
    flex: none;
    padding: 0 0 16px;
  }

  .avatar {
    width: 110px;
    height: 110px;
  }

  .info-container {
    flex: none;
    width: 100%;
    text-align: center;
    padding: 0;
    gap: 8px;
  }

  .name {
    font-size: 2rem;
  }

  .docs {
    margin-top: 20px;
    gap: 12px;
    text-align: center;
  }

  .section-header {
    justify-content: center;
  }

  .skill-category {
    flex-direction: column;
    align-items: center;
    gap: 10px;
  }

  .category-label {
    min-width: unset;
    padding-top: 0;
  }

  .skill-icons {
    justify-content: center;
  }

  .icon-wrap svg {
    width: 24px;
    height: 24px;
  }

  .recent-item {
    text-align: left;
  }
}
</style>
