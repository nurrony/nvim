-- which-key
return {
  "folke/which-key.nvim",
  event = "VeryLazy",
  opts = {
    spec = {
      {
        mode = { "n", "v" },
        { "<leader><tab>", group = "tabs" },
        { "<leader>b", group = "buffer/BufferLine" },
        { "<leader>c", group = "code" },
        { "<leader>d", group = "debugger" },
        { "<leader>f", group = "file/find" },
        { "<leader>g", group = "git" },
        { "<leader>gh", group = " gitsigns/hop" },
        { "<leader>s", group = "search" },
        { "<leader>sn", group = "󰛰 noice" },
        { "<leader>u", group = "ui/toggle" },
        { "<leader>w", group = "windows" },
        { "<leader>x", group = "diagnostics/quickfix" },
        { "[", group = "󰒮 prev" },
        { "]", group = "󰒭 next" },
        { "g", group = "󱋿 goto" },
        { "gz", group = "󱃗 surround" },
        { "z", group = " folds" },
      },
    },
    icons = {
      breadcrumb = "",
      separator = " ",
      group = "",
    },
    layout = {
      height = { min = 4, max = 20 }, -- min and max height of the columns
      width = { min = 20, max = 45 }, -- min and max width of the columns
      spacing = 2, -- spacing between columns
      align = "left", -- align columns left, center or right
    },
    show_help = false,
    plugins = {
      marks = true, -- shows a list of your marks on ' and `
      registers = true, -- shows your registers on " in NORMAL or <C-r> in INSERT mode
      -- the presets plugin, adds help for a bunch of default keybindings in Neovim
      -- No actual key bindings are created
      spelling = {
        enabled = true, -- enabling this will show WhichKey when pressing z= to select spelling suggestions
        suggestions = 20, -- how many suggestions should be shown in the list?
      },
      presets = {
        operators = true, -- adds help for operators like d, y, ...
        motions = true, -- adds help for motions
        text_objects = true, -- help for text objects triggered after entering an operator
        windows = true, -- default bindings on <c-w>
        nav = true, -- misc bindings to work with windows
        z = true, -- bindings for folds, spelling and others prefixed with z
        g = true, -- bindings for prefixed with g
      },
    },
    -- add operators that will trigger motion and text object completion
    -- to enable all native operators, set the preset / operators plugin above
    operators = { gc = "Comments" },
    motions = { count = true },
  },
}
