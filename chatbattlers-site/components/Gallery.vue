<template>
    <div id="carousel_container" class="flex justify-items-center items-center px-5 lg:px-[25%] mx-auto">
        <button @click="prev" :class="{'visible': hasPrev, 'invisible': !hasPrev}" class="text-wolfsecondary font-super-boys text-7xl md:text-9xl shadowstroked"><</button>
        <VueHorizontal responsive :button="false" ref="gallery" @scroll-debounce="onScroll">
            <div v-for="i in images" class="w-full px-5 pb-2">
                <img :src="i" class="w-full" />
            </div>
        </VueHorizontal>
        <button @click="next" :class="{'visible': hasNext, 'invisible': !hasNext}" class="text-wolfsecondary font-super-boys text-7xl md:text-9xl shadowstroked">></button>
    </div>
</template>

<script>
import VueHorizontal from "vue-horizontal";
export default {
    components: {VueHorizontal},
    data() {
        return {
            images: [],
            hasPrev: false,
            hasNext: true,
        };
    },

    mounted() {
        const imgs = import.meta.glob('/public/carousel/*.{png,jpg,jpeg,PNG,JPEG}', { eager: true, query: '?url', import: 'default'})
        for (const img in imgs) {
            this.images.push(img.substring(7))
        }
    },

    methods: {
        prev(e) {
            this.$refs.gallery.prev(e)
        },
        next(e) {
            this.$refs.gallery.next(e)
        },
        onScroll({hasPrev, hasNext}) {
            this.hasPrev = hasPrev
            this.hasNext = hasNext
            //console.log(hasPrev, hasNext)
        },
    }
}
</script>

<style scoped>
.shadowstroked {
    -webkit-text-stroke: 1px #00AAFF;
    text-shadow: #00AAFF 1px 1px 1px;
}
</style>