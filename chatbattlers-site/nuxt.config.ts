// https://nuxt.com/docs/api/configuration/nuxt-config
export default defineNuxtConfig({
  ssr: true,
  nitro: {
    static: true,
  },
  
  devtools: { enabled: true },
  modules: [
    '@nuxt/content',
    "@nuxt/image",
    "@nuxtjs/google-fonts",
    "@nuxtjs/tailwindcss",
    "@nuxtjs/device"
  ],

  routeRules: {
    '/': { prerender: true }
  },

  app: {
    head: {
      title: "ChatBattlers"
    }
  },

  content: {
    contentHead: false
  },

  googleFonts: {
    families: {
      'Josefin+Sans': true,
    }
  },

  compatibilityDate: '2024-08-13',
})