import Link from 'next/link'
import Image from 'next/image'
import styles from './styles.module.scss'
import RuFlag from './flags/ru.png'
import EnFlag from './flags/en.png'
import cx from 'classnames'
import { usePathname } from 'next/navigation'

export default function LanguageSwitcher({ activeLang: string }) {
  const path = usePathname()
  const locale = path?.[0]
  const size = 30
  return (
    <div className={styles.switch}>
      <Link locale='ru' href='/' className={cx({ [styles.active]: locale === 'ru' })}>
        <Image src={RuFlag} width={size} height={size} alt='Русский язык (Russian language)' /> 
      </Link>
      <Link locale='en' href='/' className={cx({ [styles.active]: locale === 'en' })}>
        <Image src={EnFlag} width={size} height={size} alt='English language (английский язык)' />
      </Link>
    </div>
  )
}