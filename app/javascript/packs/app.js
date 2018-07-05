import Vue from 'vue/dist/vue.esm';

// ヘッダー用のコンポーネントinclude
import Footer from '../components/footer.vue';

// フッター用のコンポーネントinclude
import Header from '../components/header.vue.erb';

new Vue({
  el: '#app',
  components: { 
    'app-footer': Footer,
    'app-header': Header
  }
});