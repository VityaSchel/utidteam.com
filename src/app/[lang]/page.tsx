import Image from 'next/image'
import { Rubik } from '@next/font/google'
import styles from './page.module.scss'
import cx from 'classnames'
import LanguageSwitcher from '../ui/LanguageSwitcher'
import Head from 'next/head'

const rubik = Rubik({ subsets: ['cyrillic', 'latin'], weight: ['400', '300'] })

export default async function Home({ params }: { params: { lang: string } }) {
  const { home } = await import(`./dictionaries/${params.lang}.json`)

  return (
    <main className={cx(styles.main, rubik.className)}>
      <div className={styles.info}>
        <span style={{ display: 'none' }}>https://github.com/VityaSchel/utidteam.com</span>
        <LanguageSwitcher activeLang={params.lang} />
        <p>{home.line1}</p>
        <p>{home.line2}</p>
        <p>{home.line3}</p>
        <div className={styles.links}>
          <a href='https://hloth.dev/portfolio' >{home.links.projects}</a>
          <a href='https://hloth.dev/me' >{home.links.contacts}</a>
        </div>
      </div>
    </main>
  )
}

export async function generateMetadata({ params }: { lang: string }) {
  const { home } = await import(`./dictionaries/${params.lang}.json`)

  return { 
    title: 'UTID Team',
    description: home.description,
    icons: {
      icon: '/favicon.ico'
    }
  }
}


export async function generateStaticParams() {
  return [{ lang: "ru" }, { lang: "en" }]
}