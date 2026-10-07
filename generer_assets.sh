#!/usr/bin/env bash
# Assets du jeu en un clic (voir tools/generate_assets.py)
cd "$(dirname "$0")" && python3 tools/generate_assets.py "$@"
