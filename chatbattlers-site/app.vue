<template>
  <div class="bg-sky-950">
    <OverlayScrollbarsComponent v-if="$device.isDesktop" style="max-height: 100vh" ref="scrollComponent" :options="{overflow: { x: 'hidden', y: 'scroll'}}">
      <NuxtPage />
    </OverlayScrollbarsComponent>
    <NuxtPage v-else />
  </div>
</template>

<script>
import 'overlayscrollbars/overlayscrollbars.css';
import { OverlayScrollbarsComponent } from 'overlayscrollbars-vue';
export default {
  components: {OverlayScrollbarsComponent}
}
</script>