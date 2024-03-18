local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"

if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable",
    lazypath,
  })
end
vim.opt.rtp:prepend(vim.env.LAZY or lazypath)

require("lazy").setup({
  spec = {
    -- { import = "nurrony.plugins.adapters.java" },
    { import = "nurrony.plugins.adapters.terraform" },
    { import = "nurrony.plugins.adapters.typescript" },
    { import = "nurrony.plugins" },
  },
  defaults = { lazy = true },
  install = { colorscheme = { "catppuccin" } },
  ui = {
    size = { width = 0.8, height = 0.8 },
    border = "rounded",
  },
  checker = { enabled = true, notify = false }, -- automatically check for plugin updates
  change_detection = {
    enabled = true,                             -- automatically check for config file changes and reload the uid
    notify = false,                             -- get a notification when changes are found
  },
  performance = {
    cache = {
      enabled = true,
    },
    rtp = {
      -- disable some rtp plugins
      disabled_plugins = {
        "2html_plugin",
        "tohtml",
        "gzip",
        "netrw",
        "netrwPlugin",
        "netrwSettings",
        "netrwFileHandlers",
        "tar",
        "tarPlugin",
        "rrhelper",
        "spellfile_plugin",
        "vimball",
        "vimballPlugin",
        "zip",
        "zipPlugin",
        "rplugin",
        "syntax",
        "synmenu",
        "optwin",
        "compiler",
        "bugreport",
        "ftplugin",
        "matchit",
        "tutor",
        "getscript",
        "getscriptPlugin",
        "logipat"
      },
    },
  },
})
