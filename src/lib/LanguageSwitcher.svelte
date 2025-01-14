<script lang="ts">
  import RuFlag from './flags/ru.png'
  import EnFlag from './flags/en.png'

  let { activeLang } = $props();
  const size = 30
</script>

<div class="switch">
  <a href='/ru' class={{ "active": activeLang === 'ru' }}>
    <img src={RuFlag} width={size} height={size} alt='Русский язык (Russian language)' /> 
  </a>
  <a href='/en' class={{ "active": activeLang === 'en' }}>
    <img src={EnFlag} width={size} height={size} alt='English language (английский язык)' />
  </a>
</div>

<style lang="scss">
  .switch {
    display: flex;
    background-color: #747474;
    border-radius: 5px;
    width: fit-content;
    gap: 5px;
    padding: 5px 10px;

    a {
      display: flex;
      padding: 3px 12px;
      font-size: 6px;

      &.active {
        background-color: #aaa;
        border-radius: 5px;
      }
    }
  }
</style>