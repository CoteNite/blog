<script setup lang="ts">
import { onMounted, onUnmounted, ref } from 'vue'

const canvasRef = ref<HTMLCanvasElement | null>(null)
let animationId: number
let ctx: CanvasRenderingContext2D | null = null

interface Flake {
  x: number
  y: number
  r: number
  speed: number
  opacity: number
  drift: number
  driftSpeed: number
  driftAngle: number
}

const FLAKE_COUNT = 450
const flakes: Flake[] = []

function random(min: number, max: number) {
  return Math.random() * (max - min) + min
}

function createFlake(width: number, height: number, initialY = false): Flake {
  return {
    x: random(0, width),
    y: initialY ? random(-height, height) : random(-20, -2),
    r: random(1.5, 3.5),
    speed: random(0.2, 0.5),
    opacity: random(0.2, 0.85),
    drift: 0,
    driftSpeed: random(0.003, 0.012),
    driftAngle: random(0, Math.PI * 2),
  }
}

function init() {
  const canvas = canvasRef.value
  if (!canvas) return
  canvas.width = window.innerWidth
  canvas.height = window.innerHeight
  ctx = canvas.getContext('2d')
  flakes.length = 0
  for (let i = 0; i < FLAKE_COUNT; i++) {
    flakes.push(createFlake(canvas.width, canvas.height, true))
  }
}

function draw() {
  const canvas = canvasRef.value
  if (!canvas || !ctx) return
  ctx.clearRect(0, 0, canvas.width, canvas.height)
  for (const f of flakes) {
    ctx.beginPath()
    ctx.arc(f.x, f.y, f.r, 0, Math.PI * 2)
    ctx.fillStyle = `rgba(255, 255, 255, ${f.opacity})`
    ctx.fill()
  }
}

function update() {
  const canvas = canvasRef.value
  if (!canvas) return
  for (let i = 0; i < flakes.length; i++) {
    const f = flakes[i]
    f.driftAngle += f.driftSpeed
    f.x += Math.sin(f.driftAngle) * 0.5
    f.y += f.speed
    if (f.y > canvas.height + 10) {
      flakes[i] = createFlake(canvas.width, canvas.height, false)
    }
  }
}

function loop() {
  update()
  draw()
  animationId = requestAnimationFrame(loop)
}

function onResize() {
  const canvas = canvasRef.value
  if (!canvas) return
  canvas.width = window.innerWidth
  canvas.height = window.innerHeight
}

onMounted(() => {
  init()
  loop()
  window.addEventListener('resize', onResize)
})

onUnmounted(() => {
  cancelAnimationFrame(animationId)
  window.removeEventListener('resize', onResize)
})
</script>

<template>
  <canvas ref="canvasRef" class="snow-canvas" />
</template>

<style scoped>
.snow-canvas {
  position: fixed;
  top: 0;
  left: 0;
  width: 100vw;
  height: 100vh;
  pointer-events: none;
  z-index: 9998;
}
</style>
