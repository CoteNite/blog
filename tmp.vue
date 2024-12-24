<script setup>

import {onMounted, ref} from "vue";

const rows = Array.from({ length: 10 }, (_, i) => i * 2 + 1);

const snowflakes = Array.from({ length: 50 }, () => ({
  left: Math.random() * 100,
  duration: Math.random() * 5 + 3,
  delay: Math.random() * 5,
}));

const generateSparkStyle = () => {
  const left = Math.random() * 100;
  const size = Math.random() * 3 + 2;
  const animationDuration = Math.random() * 1.5 + 1;
  const animationDelay = Math.random() * 0.5;
  const opacity = Math.random() * 0.5 + 0.5;

  return {
    left: `${left}%`,
    width: `${size}px`,
    height: `${size}px`,
    animationDuration: `${animationDuration}s`,
    animationDelay: `${animationDelay}s`,
    opacity: opacity,
  };
};

const isLoading = ref(true);

onMounted(() => {
  setTimeout(() => {
    isLoading.value = false;
  }, 1500);
});

</script>

<template>
  <div v-if="isLoading" class="loading-overlay">
    <div>
      <img src="/public/pictures/niluRun.gif" style="margin-top: 180px;width: 150px;height: 150px;">
    </div>

    <div style="margin-top: 15px;font-size: 17px;font-weight: bold">
      尼禄正在赶来的路上......
    </div>
  </div>


  <div v-else class="tree-container">
    <div
        v-for="(flake, index) in snowflakes"
        :key="index"
        class="snowflake"
        style="color: white"
        :style="{
        left: `${flake.left}%`,
        animationDuration: `${flake.duration}s`,
        animationDelay: `${flake.delay}s`
      }"
    >
      ❅
    </div>
    <div class="tree-wrapper">
      <div class="candles">
        <div v-for="(index) in 3" :key="index" class="candle">
          <div class="flame"/>
          <div class="spark" style="margin-left: -2px" v-for="n in 40" :key="n" :style="generateSparkStyle()"></div>

        </div>
      </div>

      <div class="tree-area">
        <div class="star">★</div>
        <div class="tree">
          <div v-for="(row, index) in rows" :key="index" class="tree-row">
            <span v-for="i in row" :key="i" class="tree-star">*</span>
          </div>
        </div>
        <div class="tree-trunk">
          <div style="display:flex;">
            <div class="trunk-line"></div>
            <div class="trunk-line"></div>
          </div>
          <div style="display:flex;">
            <div class="trunk-line"></div>
            <div class="trunk-line"></div>
          </div>
          <div style="display:flex;">
            <div class="trunk-line"></div>
            <div class="trunk-line"></div>
          </div>
        </div>
      </div>

      <div style="display: flex">
        <img src="/public/pictures/nilu.gif" style="margin-top: 180px;width: 150px;height: 150px;">
      </div>
    </div>
  </div>

</template>

<style scoped>


.loading-overlay {
  position: fixed;
  top: 0;
  left: 0;
  width: 100%;
  height: 100%;
  display: flex;
  flex-direction: column;
  justify-content: center;
  align-items: center;
  z-index: 9999;
  opacity: 1;
  transition: opacity 1s ease;
}



.tree-container {
  display: flex;
  justify-content: center;
  align-items: center;
  height: 100vh;
  margin-left: 90px;
}

.tree-wrapper {
  display: flex;
  align-items: center;
}

.tree-area {
  display: flex;
  flex-direction: column;
  align-items: center;
  margin: 0 20px;
}

.candle {
  width: 10px;
  height: 40px;
  background-color: #fff;
  border-radius: 5px;
  position: relative;
  margin: 10px 0;
}

.candles {
  margin-top: 220px;
  display: flex;
  gap: 20px;
  align-items: center;
  margin-right: 20px;
}



.snowflake {
  position: absolute;
  top: -18%;
  left: 0;
  color: white;
  font-size: 15px;
  opacity: 0.8;
  animation: snow linear infinite;
}

@keyframes snow {
  0% {
    transform: translateY(-100px);
    opacity: 1;
  }
  100% {
    transform: translateY(100vh);
    opacity: 0;
  }
}

.star {
  color: yellow;
  font-size: 24px;
  margin-bottom: 5px;
  animation: spin 3s linear infinite;
}

.tree {
  display: flex;
  color: green;
  flex-direction: column;
  align-items: center;
}

.tree-row {
  display: flex;
  justify-content: center;
  text-align: center;
  font-size: 18px;
  line-height: 20px;
  white-space: nowrap;
}

.tree-star {
  margin: 0 1px;
}

.tree-trunk {
  margin-top: 10px;
  display: flex;
  flex-direction: column;
  align-items: center;
}

.trunk-line {
  width: 6px;
  height: 10px;
  background-color: #815814;
  margin: 2px 0;
}

@keyframes spin {
  0% {
    transform: rotate(0deg);
  }
  100% {
    transform: rotate(360deg);
  }
}




.spark {
  position: absolute;
  bottom: 100%;
  width: 4px;
  height: 4px;
  background-color: yellow;
  border-radius: 50%;
  opacity: 0;
  animation: sparkAnimation 1.5s infinite;
}

@keyframes sparkAnimation {
  0% {
    transform: translateY(0) scale(1);
    opacity: 1;
  }
  50% {
    transform: translateY(-10px) scale(0.7);
    opacity: 0.8;
  }
  100% {
    transform: translateY(-20px) scale(0.3);
    opacity: 0;
  }
}
</style>
