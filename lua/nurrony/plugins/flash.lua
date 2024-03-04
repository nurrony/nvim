-- Flash enhances the built-in search functionality by showing labels
-- at the end of each match, letting you quickly jump to a specific location.
return {
  "folke/flash.nvim",
  event = "VeryLazy",
  opts = {
    prompt = {
      enabled = true,
      prefix = { { " 󰉂 ", "FlashPromptIcon" } },
    },
  },
  keys = {
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
