-- better vim.ui
-- return {
--   "stevearc/dressing.nvim",
--   event = "VeryLazy",
--   lazy = true,
--   -- init = function()
--   --   ---@diagnostic disable-next-line: duplicate-set-field
--   --   vim.ui.select = function(...)
--   --     require("lazy").load({ plugins = { "dressing.nvim" } })
--   --     return vim.ui.select(...)
--   --   end
--   --   ---@diagnostic disable-next-line: duplicate-set-field
--   --   vim.ui.input = function(...)
--   --     require("lazy").load({ plugins = { "dressing.nvim" } })
--   --     return vim.ui.input(...)
--   --   end
--   -- end,

-- }

return { -- Better input/selection fields
  "stevearc/dressing.nvim",
  event = "VeryLazy",
  init = function()
    -- lazy load triggers
    ---@diagnostic disable-next-line: duplicate-set-field
    vim.ui.select = function(...)
      require("lazy").load { plugins = { "dressing.nvim" } }
      return vim.ui.select(...)
    end
    ---@diagnostic disable-next-line: duplicate-set-field
    vim.ui.input = function(...)
      require("lazy").load { plugins = { "dressing.nvim" } }
      return vim.ui.input(...)
    end
  end,
  opts = {
    input = {
      insert_only = false, -- = enable normal mode
      trim_prompt = true,
      border = vim.g.borderStyle,
      relative = "editor",
      title_pos = "left",
      prefer_width = 73, -- commit width + 1 for padding
      min_width = 0.4,
      max_width = 0.9,
      mappings = { n = { ["q"] = "Close" } },
    },
    select = {
      backend = { "telescope", "builtin" },
      trim_prompt = true,
      builtin = {
        mappings = { ["q"] = "Close" },
        show_numbers = false,
        border = vim.g.borderStyle,
        relative = "editor",
        max_width = 80,
        min_width = 20,
        max_height = 20,
        min_height = 3,
      },
      telescope = {
        layout_config = {
          horizontal = { width = { 0.8, max = 75 }, height = 0.55 },
        },
      },
      get_config = function(opts)
        -- for simple selections, use builtin selector instead of telescope
        if opts.kind == "codeaction" or opts.kind == "rule_selection" then
          return { backend = { "builtin" }, builtin = { relative = "cursor" } }
        elseif opts.kind == "make-selector" or opts.kind == "project-selector" then
          return { backend = { "builtin" } }
        end
      end,
    },
  },
}
