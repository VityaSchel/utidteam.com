/** @type {import('next').NextConfig} */
const nextConfig = {
  experimental: {
    appDir: true,
  },
  i18n: {
    locales: ['ru', 'en'],
    defaultLocale: 'ru'
  }
}

module.exports = nextConfig
