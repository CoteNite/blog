<script setup>

</script>

<template>
  <img
      class="VPImage image-src"
      src="../../../public/header1.png"
      alt=""
  >
</template>

<style scoped>

#VPContent>div>div.VPHero.has-image.VPHomeHero>div>div.image>div>img {
  animation: Updown .9s infinite alternate ease-in-out;
}

@keyframes Updown {
  0% {
    transform: translate(-50%, -50%);
  }
  100% {
    transform: translate(-50%, -46%);
  }
}
</style>
