local Config = require("nurrony.core.configs")

return {
  {
    "xiyaowong/transparent.nvim",
    lazy = false,
    config = true,
    opts = function()
      --- set transparent completion menu
      -- run :EnableTransparent for transparency
      vim.opt.pumblend = 0
      return {
        extra_groups = {
          "Pmenu",
          "Float",
          "NormalFloat",    -- plugins which have float panel such as Lazy, Mason, LspInfo
          "NvimTreeNormal", -- NvimTree
        },
      }
    end,
  },
  -- catppuccin colorscheme
  {
    "catppuccin/nvim",
    name = "catppuccin",
    lazy = false,
    opts = {
      flavour = "mocha", -- latte, frappe, macchiato, mocha
      background = {
        -- :h background
        light = "latte",
        dark = "mocha",
      },
      transparent_background = Config.transparent,
      show_end_of_buffer = false, -- show the '~' characters after the end of buffers
      term_colors = true,
      dim_inactive = {
        enabled = true,
        shade = "dark",
        percentage = 0.15,
      },
      no_italic = false, -- Force no italic
      no_bold = false,   -- Force no bold
      styles = {
        comments = { "italic" },
        conditionals = { "italic" },
        loops = {},
        functions = {},
        keywords = {},
        strings = {},
        variables = {},
        numbers = {},
        booleans = {},
        properties = {},
        types = {},
        operators = {},
      },
      color_overrides = {},
      -- custom_highlights = function(colors) -- Global highlight, will be replaced with custom_highlights if exists
      --     return {
      --         -- Comment = { fg = colors.peach, style = { "italic" } },
      --         -- ["@field"] = { fg = colors.blue },
      --     }
      -- end,
      -- For more plugins integrations (https://github.com/catppuccin/nvim#integrations)
      integrations = {
        cmp = true,
        gitsigns = true,
        nvimtree = true,
        neotree = true,
        telescope = true,
        notify = true,
        hop = true,
        markdown = true,
        noice = true,
        treesitter = true,
        symbols_outline = true,
        lsp_trouble = true,
        which_key = true,
        indent_blankline = {
          enabled = true,
          colored_indent_levels = false,
        },
        native_lsp = {
          enabled = true,
          virtual_text = {
            errors = { "italic" },
            hints = { "italic" },
            warnings = { "italic" },
            information = { "italic" },
          },
          underlines = {
            errors = { "undercurl" },
            hints = { "undercurl" },
            warnings = { "undercurl" },
            information = { "undercurl" },
          },
        },
      },
    },
    config = function(_, opts)
      require("catppuccin").setup(opts)
      vim.cmd.colorscheme("catppuccin-mocha")
    end,
  },
}
