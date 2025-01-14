<script>
  import '../../app.css'
  import ru from '$lib/locales/ru.json'
  import en from '$lib/locales/en.json'
	import LanguageSwitcher from "$lib/LanguageSwitcher.svelte"
	import { page } from '$app/state'

  const { home } = $derived(page.params.lang === 'ru' ? ru : en)
</script>

<svelte:head>
  <title>UTID Team</title>
  <meta name="description" content="">
</svelte:head>
<main class="main">
  <div class="info">
    <span style="display: none">https://github.com/VityaSchel/utidteam.com</span>
    <LanguageSwitcher activeLang={page.params.lang} />
    <p>{home.line1}</p>
    <p>{home.line2}</p>
    <p>{home.line3}</p>
    <div class="links">
      <a href='https://hloth.dev/portfolio'>{home.links.projects}</a>
      <a href='https://hloth.dev/me'>{home.links.contacts}</a>
    </div>
  </div>
</main>

<style lang="scss">
  .main {
    color: #fff;
    display: flex;
    justify-content: center;
    align-items: center;
    min-height: 100%;
    font-size: 24px;
    width: 100%;

    .info {
      width: 80%;
      padding-right: 20%;
      transition: padding-right 2s ease-out;
      box-sizing: border-box;
      display: flex;
      flex-direction: column;
      gap: 45px;

      @media screen and (max-width: 768px) {
        padding-right: 0%;
      }
    }

    .links {
      display: flex;
      flex-direction: column;
      gap: 10px;
      font-size: 28px;

      a {
        color: #ddd;
        transition: color 125ms ease-in-out;
        font-weight: 300;
        text-decoration: none;
        display: block;

        &:hover {
          color: #fff;

          &::after {
            margin-left: 20px;
          }
        }

        &::after {
          content: '→';
          margin-left: 10px;
          transition: margin-left 125ms ease-in-out;
        }
      }
    }

    p {
      margin: 0;
    }
  }
</style>