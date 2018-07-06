import Vue from 'vue/dist/vue.esm';

// ヘッダー用のコンポーネントinclude
import Footer from '../components/footer.vue';

// フッター用のコンポーネントinclude
import Header from '../components/header.vue.erb';

import Loading from '../components/loading.vue';

window.topApp = new Vue({
  el: '#app',
  data() {
    return {
      requesting: false
    }
  },
  components: { 
    'app-footer': Footer,
    'app-header': Header,
    Loading
  }
});