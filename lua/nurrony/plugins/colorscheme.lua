return {
  'embark-theme/vim',
  name = 'embark',
  -- 'Rigellute/shades-of-purple.vim',
  lazy = false,
  priority = 1000,
  opts = {},
  config = function()
    vim.cmd([[colorscheme embark]])
  end,
}
