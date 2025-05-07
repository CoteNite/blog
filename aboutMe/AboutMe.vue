<script setup>
import {
  ApacheCassandraIcon,
  ApacheRocketMqIcon, CapacitorIcon,
  ElasticsearchIcon, ElectronIcon, InfluxDbIcon,
  JavaScriptIcon,
  KotlinIcon, MinIoIcon,
  MySqlIcon, Neo4jIcon, QuasarIcon, RedisIcon, RevueIcon,
  SpringIcon,
  TypeScriptIcon, VueDotjsIcon
} from "vue3-simple-icons";
</script>

<template>
  <div class="main">
    <div class="personal-info-card">
      <div class="avatar-container">
        <img
            src="../public/header1.png"
            alt="个人头像"
            class="avatar"
        />
      </div>
      <div class="info-container">
        <strong style="font-size: 45px">CoteNite</strong>
        <span style="margin-top: 25px">大学在读/全栈开发</span>
        <strong>主要使用的框架：SpringBoot/Quasar</strong>
        <span style="margin-top: 20px">趁着还有热情赶紧多做点喜欢的事情....</span>
        <span>想要做出来写能够被人喜欢的东西....</span>
        <s style="font-size: 13px">每天都是想要睡死过去的一天....</s>
      </div>
    </div>

    <div class=docs>
      <span>
        <strong>一部分学过的技术</strong>
        <s style="font-size: 13px">(有种点技能树的感觉,顺便占点位置...)</s>
      </span>
      <div style="display: flex">
        <strong>常用语言：</strong>
        <div style="display: flex;gap: 15px">
          <KotlinIcon/>
          <JavaScriptIcon/>
          <TypeScriptIcon/>
        </div>
      </div>
      <div style="display: flex">
        <strong>后端技术：</strong>
        <div style="display: flex;gap: 15px">
          <SpringIcon/>
          <MySqlIcon/>
          <RedisIcon/>
          <ApacheCassandraIcon/>
          <InfluxDbIcon/>
          <Neo4jIcon/>
          <ApacheRocketMqIcon/>
          <ElasticsearchIcon/>
          <MinIoIcon/>
        </div>
      </div>
      <div style="display: flex">
        <strong>前端技术：</strong>
        <div style="display: flex;gap: 15px">
          <VueDotjsIcon/>
          <QuasarIcon/>
          <ElectronIcon/>
          <CapacitorIcon/>
        </div>
      </div>
    </div>

    <div class="docs">
      <strong>最近主要在干的事：</strong>
      <div style="display: flex">
        <span>孩子也想有一份实习工作QwQ</span>
      </div>
    </div>
  </div>
</template>

<style scoped>
.main {
  display: flex;
  flex-direction: column;
  padding: 5% 10% 0 10%;
  text-align: center;
}


.personal-info-card {
  display: flex;
  align-items: center;
  width: 100%;
  height: 300px;
  box-shadow: 0 10px 30px 0 rgb(0 0 0 / 25%);
  background-color: transparent;
}

.avatar-container {
  flex: 0 0 30%;
  display: flex;
  justify-content: center;
  align-items: center;
}

.avatar {
  width: 50%;
  height: 50%;
  border-radius: 50%;
  object-fit: cover;
  transition: transform 0.6s ease-in-out;
}

.avatar:hover {
  transform: rotate(360deg);
}

.info-container {
  flex: 1;
  display: flex;
  flex-direction: column;
  gap: 5px;
  align-self: flex-start;
  text-align: left;
  padding-top: 3%;
}

.docs{
  display: flex;
  flex-direction: column;
  gap: 35px;
  width: 100%;
  margin-top: 40px;
}


</style>
