<script setup>
// 友链数据 - 在此处添加/修改友链即可
const friends = [
  {
    name: 'myrica',
    desc: 'myrica的下午茶',
    avatar: 'https://avatars.githubusercontent.com/u/232033124?v=4',
    link: 'https://lishiyu2006.github.io/Blog/',
    tag: 'Ciallo～(∠・ω< )⌒★',
  },
  {
    name: 'ZroKei',
    desc: '摆烂大王',
    avatar: 'https://zrokei.github.io/logo.png',
    link: 'https://zrokei.github.io/',
    tag: '能找到工作吗？',
  },
  {
    name: 'Chillward',
    desc: '牢C爱好者，嵌入式高寿',
    avatar: 'https://chillward.github.io/uploads/avatar.png',
    link: 'https://chillward.github.io/',
    tag: '铁铁',
  },
  // 在此处继续追加友链对象，格式如下：
  // {
  //   name: '博客名称',
  //   desc: '一句话简介',
  //   avatar: 'https://xxx.com/avatar.png',  // 头像链接或本地路径
  //   link: 'https://xxx.com',               // 博客地址
  //   tag: '分类标签',                        // 可选
  // },
];
</script>

<template>
  <div class="fl-page">
    <div class="fl-header">
      <h1 class="fl-title">友情链接</h1>
      <p class="fl-subtitle">我喜欢这块小板板，我和我爱的人都在这里</p>
    </div>

    <div class="fl-grid">
      <a
        v-for="friend in friends"
        :key="friend.link"
        :href="friend.link"
        target="_blank"
        rel="noopener noreferrer"
        class="fl-card"
      >
        <div class="fl-card-inner">
          <div class="fl-avatar-wrap">
            <img
              :src="friend.avatar"
              :alt="friend.name"
              class="fl-avatar"
              @error="(e) => (e.target.src = 'https://api.dicebear.com/7.x/bottts/svg?seed=' + friend.name)"
            />
          </div>
          <div class="fl-info">
            <span class="fl-name">{{ friend.name }}</span>
            <span v-if="friend.tag" class="fl-tag">{{ friend.tag }}</span>
            <p class="fl-desc">{{ friend.desc }}</p>
          </div>
          <div class="fl-arrow">↗</div>
        </div>
      </a>
    </div>

    <div class="fl-apply">
      <div class="fl-apply-inner">
        <span class="fl-apply-title">申请友链？</span>
        <p class="fl-apply-desc">
          欢迎互换友链，请在
          <a href="https://github.com/CoteNite" target="_blank" rel="noopener">GitHub</a>
          提 Issue 或直接联系我，附上博客地址、名称、简介和头像链接即可 ☕
        </p>
      </div>
    </div>
  </div>
</template>

<style scoped>
.fl-page {
  max-width: 900px;
  margin: 0 auto;
  padding: 40px 24px 80px;
}

/* 页头 */
.fl-header {
  text-align: center;
  margin-bottom: 48px;
}

.fl-title {
  font-size: 2.2rem;
  font-weight: 800;
  line-height: 1.4;
  letter-spacing: -0.02em;
  background: linear-gradient(135deg, var(--vp-c-brand-1), var(--vp-c-brand-2, #a78bfa));
  -webkit-background-clip: text;
  -webkit-text-fill-color: transparent;
  background-clip: text;
  margin-bottom: 8px;

}

.fl-subtitle {
  color: var(--vp-c-text-2);
  font-size: 0.95rem;
}

/* 卡片网格 */
.fl-grid {
  display: grid;
  grid-template-columns: repeat(auto-fill, minmax(260px, 1fr));
  gap: 20px;
  margin-bottom: 48px;
}

.fl-card {
  display: block;
  text-decoration: none;
  border-radius: 14px;
  border: 1px solid var(--vp-c-divider);
  background: var(--vp-c-bg-soft);
  transition: transform 0.22s ease, box-shadow 0.22s ease, border-color 0.22s ease;
  overflow: hidden;
  position: relative;
}

.fl-card:hover {
  transform: translateY(-4px);
  box-shadow: 0 12px 32px rgba(0, 0, 0, 0.12);
  border-color: var(--vp-c-brand-1);
}

.fl-card-inner {
  display: flex;
  align-items: flex-start;
  gap: 14px;
  padding: 20px;
  position: relative;
}

/* 头像 */
.fl-avatar-wrap {
  flex-shrink: 0;
  width: 56px;
  height: 56px;
  border-radius: 50%;
  overflow: hidden;
  border: 2px solid var(--vp-c-divider);
  transition: border-color 0.22s ease;
}

.fl-card:hover .fl-avatar-wrap {
  border-color: var(--vp-c-brand-1);
}

.fl-avatar {
  width: 100%;
  height: 100%;
  object-fit: cover;
  transition: transform 0.4s ease;
}

.fl-card:hover .fl-avatar {
  transform: scale(1.08) rotate(5deg);
}

/* 文字信息 */
.fl-info {
  flex: 1;
  min-width: 0;
  display: flex;
  flex-direction: column;
  gap: 4px;
}

.fl-name {
  font-weight: 700;
  font-size: 1rem;
  color: var(--vp-c-text-1);
  line-height: 1.3;
  white-space: nowrap;
  overflow: hidden;
  text-overflow: ellipsis;
}

.fl-tag {
  display: inline-block;
  font-size: 0.68rem;
  padding: 1px 7px;
  border-radius: 20px;
  background: var(--vp-c-brand-soft);
  color: var(--vp-c-brand-1);
  width: fit-content;
  font-weight: 600;
  letter-spacing: 0.02em;
}

.fl-desc {
  font-size: 0.82rem;
  color: var(--vp-c-text-2);
  line-height: 1.5;
  margin: 0;
  display: -webkit-box;
  -webkit-line-clamp: 2;
  -webkit-box-orient: vertical;
  overflow: hidden;
}

/* 跳转箭头 */
.fl-arrow {
  position: absolute;
  top: 14px;
  right: 16px;
  font-size: 0.9rem;
  color: var(--vp-c-text-3);
  opacity: 0;
  transform: translate(-4px, 4px);
  transition: opacity 0.22s ease, transform 0.22s ease;
}

.fl-card:hover .fl-arrow {
  opacity: 1;
  transform: translate(0, 0);
}

/* 申请友链区 */
.fl-apply {
  border-radius: 14px;
  border: 1px dashed var(--vp-c-divider);
  background: var(--vp-c-bg-soft);
  padding: 28px 32px;
}

.fl-apply-inner {
  display: flex;
  flex-direction: column;
  gap: 8px;
  text-align: center;
}

.fl-apply-title {
  font-size: 1.1rem;
  font-weight: 700;
  color: var(--vp-c-text-1);
}

.fl-apply-desc {
  font-size: 0.88rem;
  color: var(--vp-c-text-2);
  margin: 0;
  line-height: 1.7;
}

.fl-apply-desc a {
  color: var(--vp-c-brand-1);
  text-decoration: none;
  font-weight: 600;
}

.fl-apply-desc a:hover {
  text-decoration: underline;
}

/* 响应式 */
@media (max-width: 640px) {
  .fl-title {
    font-size: 1.7rem;
  }

  .fl-grid {
    grid-template-columns: 1fr;
  }

  .fl-apply {
    padding: 20px 16px;
  }
}
</style>
