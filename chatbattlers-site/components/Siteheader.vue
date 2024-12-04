<template>
    <div class="contents">
        <img src="/img/header_nobg.png" class="w-full xl:hidden" />
        <img src="/img/header_desktop.png" class="w-full hidden xl:block" />
        <div class="text-wolfsecondary text-center text-6xl min-[800px]:text-8xl pt-2 pb-3 font-semibold outlined-text font-super-boys">
            Coming September
        </div>
        <div class="bg-wolfprimary sticky top-0 z-50 shadow-[1px_1px_1px_black]">
            <div class="flex place-content-center justify-evenly lg:max-w-[60%] m-auto">
                <NuxtLink to="/" external class="link-logo-container"><img src="/logos/steam-logo-white.svg" class="btn-logo" /></NuxtLink>
                <NuxtLink to="https://discord.gg/BRbP2eYUTp" external class="link-logo-container" ><img src="/logos/discord-mark-white.svg" class="btn-logo" /></NuxtLink>
                <NuxtLink to="https://www.twitch.tv/siriuswolf" external class="link-logo-container"><img src="/logos/glitch_flat_white.svg" class="btn-logo" /></NuxtLink>
            </div>
        </div>
    </div>
</template>

<style>
.link-logo-container {
    @apply flex py-1 ;
}
.btn-logo {
    @apply min-w-16 max-w-16 drop-shadow-[1px_1px_1px_black] hover:drop-shadow-[5px_5px_1px_#FFAA00] ;
}
.outlined-text {
    -webkit-text-stroke: 1px #00AAFF;
    text-shadow: #00AAFF 1px 1px 1px;
}
</style>