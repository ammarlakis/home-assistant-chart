# Version bump helper for the homeassistant chart

# Usage:
#   just bump            # defaults to patch
#   just bump patch
#   just bump minor
#   just bump major

bump type='patch':
    helm-docs
    prettier charts/homeassistant/README.md -w
    git add charts/homeassistant/README.md
    ./scripts/bump-version.sh {{type}}
