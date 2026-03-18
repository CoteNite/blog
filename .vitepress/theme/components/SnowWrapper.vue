<script setup>
import Snow from './Snow.vue'
import { useData } from 'vitepress'

const { frontmatter } = useData()
</script>

<template>
  <Snow v-if="frontmatter.layout === 'home'" />
</template>
