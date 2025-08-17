Based on: https://github.com/cawa-93/vite-electron-builder
The tRPC over IPC code is based on [the electron-trpc package](https://github.com/jsonnull/electron-trpc), adapted to support tRPC v10 by using [tRPC source](https://github.com/trpc/trpc/tree/next).

## Development

Install [just](https://just.systems/) if you haven't already.

```bash
# Install dependencies and setup database
just bootstrap

# Start development server
just dev
```

This starts a development watch process using `vite`:
- Hot reloads on changes to `renderer/`
- Reloads the web page on changes to `preload/`
- Fully reloads the Electron app on changes to `main/`

## Building

```bash
# Build for production
just compile
```

This uses the `electron-builder` programmatic API via `scripts/compile.ts`.

## Release

```bash
# Create a new release (builds, bumps version, packages, and publishes to GitHub)
just release
```

This will:
- Build the app (`just compile`)
- Bump the version (`just version-patch`)  
- Package it into a tarball (`just package`)
- Create a GitHub release (`just publish-release`)
- Output the SHA256 hash for Homebrew

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
