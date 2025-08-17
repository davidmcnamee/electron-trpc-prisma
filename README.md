
## Installation via Homebrew

```bash
brew install --cask davidmcnamee/tap/electron-trpc-prisma
```

## Notes

The `resolve.alias` stuff in `vite.config.ts` files is needed because https://github.com/vitejs/vite/issues/6828

By default, the Content-Security-Policy allows inline `<style>` tags.
If you use a different method of applying CSS, change the relevant line in `renderer/index.html`.
eg:

```html
<meta
  http-equiv="Content-Security-Policy"
  content="default-src 'self'; script-src 'self'; style-src 'self'"
/>
```
