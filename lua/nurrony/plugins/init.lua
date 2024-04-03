return {
  { "nvim-lua/plenary.nvim", lazy = true }, -- common functions library for other plugins
  { "MunifTanjim/nui.nvim", lazy = true }, -- better vim.notify
  { "nvim-tree/nvim-web-devicons", lazy = true }, -- add nerdfont devicons supports
  -- seamless integration with tmux
  {
    "christoomey/vim-tmux-navigator",
    cmd = { "TmuxNavigateLeft", "TmuxNavigateDown", "TmuxNavigateUp", "TmuxNavigateRight", "TmuxNavigatePrevious" },
    keys = {
      { "<C-k>", "<cmd><C-U>TmuxNavigateUp<cr>", desc = "Navigate to up" },
      { "<C-h>", "<cmd><C-U>TmuxNavigateLeft<cr>", desc = "Navigate to left" },
      { "<C-j>", "<cmd><C-U>TmuxNavigateDown<cr>", desc = "Navigate to down" },
      { "<C-l>", "<cmd><C-U>TmuxNavigateRight<cr>", desc = "Navigate to right" },
      { "<C-\\>", "<cmd><C-U>TmuxNavigatePrevious<cr>", desc = "Navigate to previous" },
    },
  },
}
