#!/usr/bin/env bash

set -euo pipefail

if [[ "${EUID}" -eq 0 ]]; then
  SUDO=()
else
  SUDO=(sudo)
fi

log() {
  printf '[setup] %s\n' "$1"
}

warn() {
  printf '[setup] warning: %s\n' "$1" >&2
}

require_cmd() {
  if ! command -v "$1" >/dev/null 2>&1; then
    printf 'Missing required command: %s\n' "$1" >&2
    exit 1
  fi
}

install_with_apt() {
  "${SUDO[@]}" apt-get update
  local packages=(
    neovim
    git
    curl
    ca-certificates
    build-essential
    unzip
    tar
    gzip
    xz-utils
    ripgrep
    fd-find
    nodejs
    npm
    python3
    python3-pip
    go
  )
  local pkg
  for pkg in "${packages[@]}"; do
    if ! "${SUDO[@]}" apt-get install -y "$pkg"; then
      warn "Skipping unavailable package: $pkg"
    fi
  done
}

install_with_dnf() {
  local packages=(
    neovim
    git
    curl
    ca-certificates
    gcc
    gcc-c++
    make
    unzip
    tar
    gzip
    xz
    ripgrep
    fd-find
    nodejs
    npm
    python3
    python3-pip
    golang
  )
  local pkg
  for pkg in "${packages[@]}"; do
    if ! "${SUDO[@]}" dnf install -y "$pkg"; then
      warn "Skipping unavailable package: $pkg"
    fi
  done
}

install_with_pacman() {
  "${SUDO[@]}" pacman -Sy --noconfirm
  local packages=(
    neovim
    git
    curl
    ca-certificates
    base-devel
    unzip
    tar
    gzip
    xz
    ripgrep
    fd
    nodejs
    npm
    python
    python-pip
    go
  )
  local pkg
  for pkg in "${packages[@]}"; do
    if ! "${SUDO[@]}" pacman -S --noconfirm "$pkg"; then
      warn "Skipping unavailable package: $pkg"
    fi
  done
}

install_packages() {
  if command -v apt-get >/dev/null 2>&1; then
    log "Installing Linux packages with apt"
    install_with_apt
    return
  fi

  if command -v dnf >/dev/null 2>&1; then
    log "Installing Linux packages with dnf"
    install_with_dnf
    return
  fi

  if command -v pacman >/dev/null 2>&1; then
    log "Installing Linux packages with pacman"
    install_with_pacman
    return
  fi

  printf 'Unsupported package manager. Supported: apt, dnf, pacman.\n' >&2
  exit 1
}

bootstrap_neovim() {
  local config_dir data_home state_home cache_home

  config_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
  data_home="${XDG_DATA_HOME:-$HOME/.local/share}"
  state_home="${XDG_STATE_HOME:-$HOME/.local/state}"
  cache_home="${XDG_CACHE_HOME:-$HOME/.cache}"

  log "Bootstrapping plugins, Treesitter parsers, and Mason tools"

  XDG_CONFIG_HOME="$(dirname "$config_dir")" \
  XDG_DATA_HOME="$data_home" \
  XDG_STATE_HOME="$state_home" \
  XDG_CACHE_HOME="$cache_home" \
  nvim --headless \
    "+Lazy! sync" \
    "+TSUpdateSync" \
    "+lua pcall(vim.cmd, 'MasonInstall clangd clang-format prettier stylua goimports black isort')" \
    "+qa"
}

main() {
  require_cmd bash
  install_packages
  require_cmd nvim
  bootstrap_neovim
  log "Linux setup complete"
}

main "$@"
