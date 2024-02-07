return {
  "numToStr/Comment.nvim",
  event = { "BufNewFile", "BufReadPost" },
  keys = {
    { "gc", mode = { "n", "v", "i", "t" }, false },
  },
  config = function(_, opts)
    require("Comment").setup(opts)
  end,
}
