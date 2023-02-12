import Link from 'next/link'
import Image from 'next/image'
import styles from './styles.module.scss'
import RuFlag from './flags/ru.png'
import EnFlag from './flags/en.png'
import cx from 'classnames'

export default function LanguageSwitcher({ activeLang }: { activeLang: string }) {
  const size = 30
  return (
    <div className={styles.switch}>
      <Link href='/ru' className={cx({ [styles.active]: activeLang === 'ru' })}>
        <Image src={RuFlag} width={size} height={size} alt='Русский язык (Russian language)' /> 
      </Link>
      <Link href='/en' className={cx({ [styles.active]: activeLang === 'en' })}>
        <Image src={EnFlag} width={size} height={size} alt='English language (английский язык)' />
      </Link>
    </div>
  )
}