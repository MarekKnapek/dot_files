#!/usr/bin/env bash
set -e
git fsck --unreachable --dangling --root --tags --full --strict --lost-found --progress --references
