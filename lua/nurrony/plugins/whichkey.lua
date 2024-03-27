-- which-key
return {
  "folke/which-key.nvim",
  event = "VeryLazy",
  opts = {
    icons = {
      breadcrumb = "",
      separator = " ",
      group = "",
    },
    layout = {
      height = { min = 4, max = 20 }, -- min and max height of the columns
      width = { min = 20, max = 45 }, -- min and max width of the columns
      spacing = 3,                    -- spacing between columns
      align = "left",                 -- align columns left, center or right
    },
    show_help = false,
    plugins = {
      marks = true,     -- shows a list of your marks on ' and `
      registers = true, -- shows your registers on " in NORMAL or <C-r> in INSERT mode
      -- the presets plugin, adds help for a bunch of default keybindings in Neovim
      -- No actual key bindings are created
      spelling = {
        enabled = true,   -- enabling this will show WhichKey when pressing z= to select spelling suggestions
        suggestions = 20, -- how many suggestions should be shown in the list?
      },
      presets = {
        operators = true,    -- adds help for operators like d, y, ...
        motions = true,      -- adds help for motions
        text_objects = true, -- help for text objects triggered after entering an operator
        windows = true,      -- default bindings on <c-w>
        nav = true,          -- misc bindings to work with windows
        z = true,            -- bindings for folds, spelling and others prefixed with z
        g = true,            -- bindings for prefixed with g
      },
    },
    -- add operators that will trigger motion and text object completion
    -- to enable all native operators, set the preset / operators plugin above
    operators = { gc = "Comments" },
    motions = { count = true },
  },
  config = function(_, opts)
    local keymaps = {
      mode              = { "n", "v" },
      ["<leader>g"]     = { name = "+git" },
      ["g"]             = { name = "+goto" },
      ["]"]             = { name = "+next" },
      ["["]             = { name = "+prev" },
      ["<leader><tab>"] = { name = "+tabs" },
      ["<leader>c"]     = { name = "+code" },
      ["z"]             = { name = "+folds" },
      ["<leader>sn"]    = { name = "+noice" },
      ["<leader>s"]     = { name = "+search" },
      ["<leader>w"]     = { name = "+windows" },
      ["gz"]            = { name = "+surround" },
      ["<leader>d"]     = { name = "+debugger" },
      ["<leader>f"]     = { name = "+file/find" },
      ["<leader>u"]     = { name = "+ui/toggle" },
      ["<leader>gh"]    = { name = "+gitsigns/hop" },
      ["<leader>q"]     = { name = "+quit/session" },
      ["<leader>b"]     = { name = "+buffer/BufferLine" },
      ["<leader>x"]     = { name = "+diagnostics/quickfix" },
    }

    local whichkey = require("which-key")
    whichkey.setup(opts)
    whichkey.register(keymaps)
  end,
}
