
# Install dependencies and set up database
bootstrap:
    npm install && just db-push

# Development server
dev:
    npx cross-env NODE_ENV=development just watch-desktop

# Build all components
build:
    just build-main & just build-preload & just build-renderer

# Compile production build
compile:
    npx cross-env MODE=production just build && npx cross-env NODE_ENV=production ts-node scripts/compile.ts

# Format code
format:
    npx prettier -w .

# Lint code
lint:
    npx eslint .

# Watch web version
watch-web:
    npx ts-node scripts/watchWeb.ts

# Watch desktop version
watch-desktop:
    npx ts-node scripts/watchDesktop.ts

# Build main process
build-main:
    cd main && npx tsc && npx vite build

# Build preload script
build-preload:
    cd preload && npx tsc && npx vite build

# Build renderer
build-renderer:
    cd renderer && npx tsc && npx vite build

# Generate Prisma client
db-generate:
    cd prisma && npx prisma generate

# Push database schema
db-push:
    cd prisma && npx prisma db push

# Update electron vendors
vendors-update:
    npx cross-env ELECTRON_RUN_AS_NODE=1 electron scripts/update-electron-vendors.mjs

# Package the app into tarball
package:
    #!/usr/bin/env bash
    mkdir -p releases
    VERSION=$(node -p "require('./package.json').version")
    tar -czf "releases/trpc-prisma-electron-${VERSION}-mac-arm64.tar.gz" -C dist/mac-arm64 trpc-prisma-electron.app
    SHA256=$(shasum -a 256 "releases/trpc-prisma-electron-${VERSION}-mac-arm64.tar.gz" | awk '{print $1}')
    echo "Package: releases/trpc-prisma-electron-${VERSION}-mac-arm64.tar.gz"
    echo "SHA256: ${SHA256}"

# Create GitHub release
publish-release:
    #!/usr/bin/env bash
    VERSION=$(node -p "require('./package.json').version")
    gh release create "v${VERSION}" \
        "releases/trpc-prisma-electron-${VERSION}-mac-arm64.tar.gz" \
        --title "v${VERSION}" \
        --notes "Release v${VERSION}
    
    ## Installation via Homebrew
    \`\`\`bash
    brew install --cask davidmcnamee/tap/electron-trpc-prisma
    \`\`\`"

# Bump version (patch)
version-patch push="false":
    npm version patch
    if [ "{{push}}" != "false" ]; then git push --tags; fi

# Bump version (minor)
version-minor push="false":
    npm version minor
    if [ "{{push}}" != "false" ]; then git push --tags; fi

# Bump version (major)  
version-major push="false":
    npm version major
    if [ "{{push}}" != "false" ]; then git push --tags; fi

# Full release: compile, version bump, package, and publish
release:
    if [ -n "$(git status --porcelain)" ]; then \
        echo "Error: Git working directory is not clean. Please commit or stash changes first."; \
        exit 1; \
    fi
    just compile
    just version-patch true
    just package
    just publish-release

postinstall:
    just vendors-update && just db-generate
