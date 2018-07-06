<template>
  <div id="loading_container" v-show="requesting">

  </div>
</template>

<script>
  export default {
    props: { 
      requesting: Boolean
    }
  }
</script>


