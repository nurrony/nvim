--Enable the new |lua-loader| that byte-compiles and caches lua files.
vim.loader.enable()

-- setup editor options -> syntax -> autocmds -> mappings
require("nurrony.core")

-- bootstrap lazy.nvim
require("nurrony.lazy")
