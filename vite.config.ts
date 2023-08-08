import { fileURLToPath, URL } from 'node:url'

import { defineConfig } from 'vite'
import FullReload from "vite-plugin-full-reload"
import RubyPlugin from 'vite-plugin-ruby'
import StimulusHMR from 'vite-plugin-stimulus-hmr'

import vue from '@vitejs/plugin-vue'

export default defineConfig({
  clearScreen: false,
  plugins: [
    RubyPlugin(),
    StimulusHMR(),
    FullReload(["config/routes.rb", "app/views/**/*"], { delay: 300 }),
    vue()
  ],
  resolve: {
    alias: {
      '@': fileURLToPath(new URL('app/javascript/src', import.meta.url))
    }
  },
  server: {
    host: "192.168.10.10",
    watch: {
      usePolling: true,
    },
  },
})