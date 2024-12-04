<template>
    <div class="bg-neutral-900">
        <ul class="flex justify-center flex-wrap">
            <li class="btn-footerlink"><NuxtLink to="/ChatBattlers-Privacy-Policy.pdf" external>Privacy Policy</NuxtLink></li>
            <li class="btn-footerlink"><NuxtLink to="/ChatBattlers-EULA.pdf" external>EULA</NuxtLink></li>
            <li class="btn-footerlink"><NuxtLink to="https://x.com/thesiriuswolf" external>Twitter</NuxtLink></li>
            <li class="btn-footerlink"><NuxtLink to="/" external>Steam</NuxtLink></li>
            <li class="btn-footerlink"><NuxtLink to="https://discord.gg/BRbP2eYUTp" external>Discord</NuxtLink></li>
            <li class="btn-footerlink"><NuxtLink to="https://www.twitch.tv/siriuswolf" external>Twitch</NuxtLink></li>
        </ul>
    </div>
</template>

<style>
.btn-footerlink {
    @apply py-2 px-5 text-neutral-400 font-semibold text-nowrap hover:text-neutral-300;
}
</style>