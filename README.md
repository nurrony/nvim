# Nur Rony's NeoVim PDE

I now use NeoVim with Lazy Plugin Manager with bare minimal plugins and customization. It is blazing fast and easily customizable.

## ⚡️ Requirements

- [NeoVim](https://neovim.io/) >= 0.9.0 (needs to be built with LuaJIT)
- [Git](https://git-scm.com/) >= 2.19.0 (for partial clones support)
- A [Nerd-Font](https://www.nerdfonts.com/) (v3.0 or greater) (optional, but needed to display some icons)
- For telescope.nvim (optional)
  - live grep: [ripgrep](https://github.com/BurntSushi/ripgrep)
  - find files: [fd](https://github.com/sharkdp/fd)
- A terminal that support true color and undercurl:
  - [kitty](https://github.com/kovidgoyal/kitty) (Linux & Macos)
  - [wezterm](https://github.com/wez/wezterm) (Linux, Macos & Windows)
  - [alacritty](https://github.com/alacritty/alacritty) (Linux, Macos & Windows)
  - [iterm2](https://iterm2.com/) (Macos)

## 🛠️ Installation

### 🖥 Linux/MacOS

1. Make a backup of your current Neovim files:

```bash
# required
mv ~/.config/nvim{,.bak}

# optional but recommended
mv ~/.local/share/nvim{,.bak}
mv ~/.local/state/nvim{,.bak}
mv ~/.cache/nvim{,.bak}
```

2. Clone this repository

```sh
git clone https://github.com/nurrony/nvim ~/.config/nvim
```

3. Remove the `.git` folder, so you can add it to your own repo later

```sh
rm -rf ~/.config/nvim/.git
```

4. Start Neovim and let the magic happend :sparkles: :sparkles:

```sh
nvim
```

### 💻 Windows

Install with [PowerShell](https://github.com/PowerShell/PowerShell)

1. Make a backup of your current Neovim files:

```sh
# required
Move-Item $env:LOCALAPPDATA\nvim $env:LOCALAPPDATA\nvim.bak

# optional but recommended
Move-Item $env:LOCALAPPDATA\nvim-data $env:LOCALAPPDATA\nvim-data.bak
```

2. Clone this repository

```sh
git clone https://github.com/nurrony/nvim $env:LOCALAPPDATA\nvim
```

3. Remove the `.git` folder, so you can add it to your own repo later

```sh
Remove-Item $env:LOCALAPPDATA\nvim\.git -Recurse -Force
```

4. Start Neovim and let the magic happend :sparkles: :sparkles:

```sh
nvim
```

## 📦 Goodies in the box

These are the followings that comes out of the box

### 🔌 Plugins

- Lazy.vim - Package Manager
- Nvim Language Server Config
- Blankline
- Bufferline
- Mason
- Lint via nvim-lint
- Formatting via Conform
- Dressing
- Flash
- GitSign
- Lualine
- Mini Pairs
- Noice
- NvimTree
- Spectre
- Telescope
- UndoTree
- ToggleTerm
- Treesitter
- Trouble
- UFO (Folding)
- Which Key

### 🔖 Default Languages Servers

- BASH
- HTML
- CSS
- Lua


### 🔧 Linters and Formatters

- Prettier
- ESlint
- Shell Format
- Shell Checker
- Python Linter
- Terraform Linter
- CloudFormation Linter

### 🚧 DevOps

- Docker
- Terraform
- Kubernetes

## 🙏 Special Thanks to

This is not only the journey of making my **PDE (Personal Development Environment)**, through this I also learned Lua

### 👽 The Alphas

- [Folke](https://twitter.com/folke)
- [TJ DeVries](https://twitter.com/teej_dv)
- [ThePrimeagen](https://twitter.com/ThePrimeagen)

### Projects

- [LazyVim](https://github.com/LazyVim/LazyVim) contributors, especially The Awesome [Folke](https://twitter.com/folke)
- [AstroVim](https://astronvim.com/)
