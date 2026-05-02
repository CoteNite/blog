<template>
  <div class="mermaid-container" @click="openModal">
    <!-- 原生的 Mermaid 渲染内容会被放在这里 -->
    <slot />
  </div>

  <!-- 放大显示的模态框 -->
  <div v-if="isModalOpen" class="modal" @click="closeModal">
    <div class="modal-content" @click.stop>
      <span class="close" @click="closeModal">&times;</span>
      <div v-html="modalContent"></div>
    </div>
  </div>
</template>

<script setup>
import { ref, onMounted } from 'vue'

const isModalOpen = ref(false)
const modalContent = ref('')

const openModal = (e) => {
  // 获取点击的那个 svg
  const svg = e.currentTarget.querySelector('svg')
  if (svg) {
    modalContent.value = svg.outerHTML
    isModalOpen.value = true
  }
}

const closeModal = () => {
  isModalOpen.value = false
}
</script>

<style scoped>
.mermaid-container {
  cursor: pointer;
  transition: transform 0.2s;
}
.mermaid-container:hover {
  outline: 2px solid var(--vp-c-brand);
}

.modal {
  position: fixed;
  top: 0;
  left: 0;
  width: 100%;
  height: 100%;
  background-color: rgba(0, 0, 0, 0.8);
  display: flex;
  justify-content: center;
  align-items: center;
  z-index: 9999;
}

.modal-content {
  position: relative;
  background-color: white;
  padding: 20px;
  border-radius: 8px;
  max-width: 90%;
  max-height: 90%;
  overflow: auto;
}

.close {
  position: absolute;
  top: 10px;
  right: 15px;
  font-size: 24px;
  cursor: pointer;
  color: black;
}
</style>
