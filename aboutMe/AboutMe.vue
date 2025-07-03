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
        <strong class="name">CoteNite</strong>
        <span class="role">大学在读/全栈开发</span>
        <strong class="frameworks">主要使用的框架：SpringBoot/Quasar</strong>
        <span class="motto">趁着还有热情赶紧多做点喜欢的事情....</span>
        <span class="goal">想要做出来写能够被人喜欢的东西....</span>
        <s class="sleepy">每天都是想要睡死过去的一天....</s>
      </div>
    </div>

    <div class="docs skills-section">
      <span>
        <strong>一部分学过的技术</strong>
        <s class="sub-note">(有种点技能树的感觉,顺便占点位置...)</s>
      </span>
      <div class="skill-category">
        <strong>常用语言：</strong>
        <div class="skill-icons">
          <KotlinIcon/>
          <JavaScriptIcon/>
          <TypeScriptIcon/>
        </div>
      </div>
      <div class="skill-category">
        <strong>后端技术：</strong>
        <div class="skill-icons backend-icons">
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
      <div class="skill-category">
        <strong>前端技术：</strong>
        <div class="skill-icons frontend-icons">
          <VueDotjsIcon/>
          <QuasarIcon/>
          <ElectronIcon/>
          <CapacitorIcon/>
        </div>
      </div>
    </div>

    <div class="docs recent-work-section">
      <strong>最近主要在干的事：</strong>
      <div>
        <span>研究SpringAI如何配合Agent生成前端样式</span>
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
  border-radius: 8px;
}

.avatar-container {
  flex: 0 0 30%;
  display: flex;
  justify-content: center;
  align-items: center;
  padding: 20px;
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
  padding-right: 20px;
}

.name {
  font-size: 45px;
}

.role {
  margin-top: 25px;
}

.sleepy {
  font-size: 13px;
}

.docs {
  display: flex;
  flex-direction: column;
  gap: 35px;
  width: 100%;
  margin-top: 40px;
  text-align: left;
}

.skills-section .skill-category {
  display: flex;
  align-items: center;
  gap: 15px;
  flex-wrap: wrap;
}

.skills-section .skill-icons {
  display: flex;
  gap: 15px;
  flex-wrap: wrap;
}


@media (max-width: 768px) {
  .main {
    padding: 5% 5% 0 5%;
  }

  .personal-info-card {
    flex-direction: column;
    height: auto;
    padding: 20px 0;
    align-items: center;
  }

  .avatar-container {
    flex: none;
    width: 100%;
    padding: 10px;
  }

  .avatar {
    width: 100px;
    height: 100px;
  }

  .info-container {
    flex: none;
    width: 100%;
    align-self: center;
    text-align: center;
    padding: 10px;
    gap: 10px;
  }

  .name {
    font-size: 30px;
  }

  .role {
    margin-top: 10px;
  }

  .frameworks {
    font-size: 1em;
  }

  .motto, .goal, .sleepy {
    font-size: 0.9em;
  }


  .docs {
    margin-top: 30px;
    gap: 20px;
    text-align: center;
  }

  .skills-section .skill-category {
    flex-direction: column;
    align-items: center;
    gap: 10px;
  }

  .skills-section .skill-icons {
    justify-content: center;
    gap: 10px;
  }

  .skills-section .skill-icons svg {
    width: 24px;
    height: 24px;
  }


  .sub-note {
    font-size: 11px;
  }

  .recent-work-section strong {
    text-align: center;
    display: block;
  }
  .recent-work-section div {
    text-align: center;
  }
}
</style>
