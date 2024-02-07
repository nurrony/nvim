return {
  "numToStr/Comment.nvim",
  event = { "BufNewFile", "BufReadPost" },
  config = function(_, opts)
    require("Comment").setup(opts)
  end,
}
