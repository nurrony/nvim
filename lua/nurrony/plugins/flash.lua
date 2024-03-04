-- Flash enhances the built-in search functionality by showing labels
-- at the end of each match, letting you quickly jump to a specific location.
return {
  "folke/flash.nvim",
  event = "VeryLazy",
  opts = {
    jump = { pos = "end", },
    modes = {
      char = {
        -- highlight = {
        --   matches = false,
        -- },
        -- autohide = true,
        jump_labels = function(motion)
          -- never show jump labels by default
          -- return false
          -- Always show jump labels for ftFT
          return vim.v.count == 0 and motion:find("[ftFT]")
          -- Show jump labels for ftFT in operator-pending mode
          -- return vim.v.count == 0 and motion:find("[ftFT]") and vim.fn.mode(true):find("o")
        end,
      },
    },
    prompt = {
      enabled = true,
      prefix = { { " 󰉂 ", "FlashPromptIcon" } },
    },
  },
  keys = {
    { "f", mode = { "n", "x", "o" } },
    { "F", mode = { "n", "x", "o" } },
    { "t", mode = { "n", "x", "o" } },
    { "T", mode = { "n", "x", "o" } },
    {
      "s",
      mode = { "n", "x", "o" },
      function()
        require("flash").jump()
      end,
      desc = "Flash",
    },
    {
      "S",
      mode = { "n", "o", "x" },
      function()
        require("flash").treesitter()
      end,
      desc = "Flash Treesitter",
    },
    {
      "R",
      mode = { "o", "x" },
      function()
        require("flash").treesitter_search()
      end,
      desc = "Treesitter Search",
    },
  },
}
