import Image from 'next/image'
import { Inter } from '@next/font/google'
import styles from './page.module.css'

const inter = Inter({ subsets: ['latin'] })

export default function Home() {
  return (
    <main className={styles.main}>
      <div>
        <p>UTID больше не существует, все проекты выпущенные нами останутся, как и сайт.</p>
        <p>В предыдущей версии сайта была галерея проектов, контакты для связи</p>
        <p>Вместо этого, вы можете найти все проекты и способы связи с главным разработчиком и лидером команды Виктором Щелочковым по ссылкам ниже:</p>
        <a href=""></a>
      </div>
    </main>
  )
}
