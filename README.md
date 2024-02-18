# Nur Rony's NeoVim Setup and Customization

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


## 📦 Goodies the box

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
  - ToggleTerm
  - Treesitter
  - Trouble
  - Which Key

### 🔖 Languages Servers

  - BASH
  - HTML
  - CSS
  - Lua
  - JSON
  - Yaml
  - Python
  - Javascript
  - Typescript
  - HashiCorp Language

### 🔧 Linters and Formatters
  - Prettier
  - ESlint
  - Shell Format
  - Shell Checker
  - Terraform Linter
  - CloudFormation Linter
  - Python Linter

### 🚧 DevOps
  - Docker
  - Terraform
  - Kubernetes
