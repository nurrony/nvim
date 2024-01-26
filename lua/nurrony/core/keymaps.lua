local mapkey = vim.keymap.set

-- better up/down
mapkey({ "n", "x" }, "j", "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })
mapkey({ "n", "x" }, "<Down>", "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })
mapkey({ "n", "x" }, "k", "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })
mapkey({ "n", "x" }, "<Up>", "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })

-- Move to window using the <ctrl> hjkl keys
mapkey("n", "<C-h>", "<C-w>h", { desc = "Go to left window", remap = true })
mapkey("n", "<C-j>", "<C-w>j", { desc = "Go to lower window", remap = true })
mapkey("n", "<C-k>", "<C-w>k", { desc = "Go to upper window", remap = true })
mapkey("n", "<C-l>", "<C-w>l", { desc = "Go to right window", remap = true })

-- Resize window using <ctrl> arrow keys
mapkey("n", "<C-Up>", "<cmd>resize +2<cr>", { desc = "Increase window height" })
mapkey("n", "<C-Down>", "<cmd>resize -2<cr>", { desc = "Decrease window height" })
mapkey("n", "<C-Left>", "<cmd>vertical resize -2<cr>", { desc = "Decrease window width" })
mapkey("n", "<C-Right>", "<cmd>vertical resize +2<cr>", { desc = "Increase window width" })

-- Move Lines
mapkey("n", "<A-j>", "<cmd>m .+1<cr>==", { desc = "Move down" })
mapkey("n", "<A-k>", "<cmd>m .-2<cr>==", { desc = "Move up" })
mapkey("i", "<A-j>", "<esc><cmd>m .+1<cr>==gi", { desc = "Move down" })
mapkey("i", "<A-k>", "<esc><cmd>m .-2<cr>==gi", { desc = "Move up" })
mapkey("v", "<A-j>", ":m '>+1<cr>gv=gv", { desc = "Move down" })
mapkey("v", "<A-k>", ":m '<-2<cr>gv=gv", { desc = "Move up" })

-- buffers
mapkey("n", "<S-h>", "<cmd>bprevious<cr>", { desc = "Prev buffer" })
mapkey("n", "<S-l>", "<cmd>bnext<cr>", { desc = "Next buffer" })
mapkey("n", "[b", "<cmd>bprevious<cr>", { desc = "Prev buffer" })
mapkey("n", "]b", "<cmd>bnext<cr>", { desc = "Next buffer" })
mapkey("n", "<leader>bb", "<cmd>e #<cr>", { desc = "Switch to Other Buffer" })
mapkey("n", "<leader>`", "<cmd>e #<cr>", { desc = "Switch to Other Buffer" })

-- Clear search with <esc>
mapkey({ "i", "n" }, "<esc>", "<cmd>noh<cr><esc>", { desc = "Escape and clear hlsearch" })

-- Clear search, diff update and redraw
-- taken from runtime/lua/_editor.lua
mapkey(
  "n",
  "<leader>ur",
  "<Cmd>nohlsearch<Bar>diffupdate<Bar>normal! <C-L><CR>",
  { desc = "Redraw / clear hlsearch / diff update" }
)

-- https://github.com/mhinz/vim-galore#saner-behavior-of-n-and-n
mapkey("n", "n", "'Nn'[v:searchforward].'zv'", { expr = true, desc = "Next search result" })
mapkey("x", "n", "'Nn'[v:searchforward]", { expr = true, desc = "Next search result" })
mapkey("o", "n", "'Nn'[v:searchforward]", { expr = true, desc = "Next search result" })
mapkey("n", "N", "'nN'[v:searchforward].'zv'", { expr = true, desc = "Prev search result" })
mapkey("x", "N", "'nN'[v:searchforward]", { expr = true, desc = "Prev search result" })
mapkey("o", "N", "'nN'[v:searchforward]", { expr = true, desc = "Prev search result" })

-- Add undo break-points
mapkey("i", ",", ",<c-g>u")
mapkey("i", ".", ".<c-g>u")
mapkey("i", ";", ";<c-g>u")

-- save file
mapkey({ "i", "x", "n", "s" }, "<C-s>", "<cmd>w<cr><esc>", { desc = "Save file" })

--keywordprg
mapkey("n", "<leader>K", "<cmd>norm! K<cr>", { desc = "Keywordprg" })

-- better indenting
mapkey("v", "<", "<gv")
mapkey("v", ">", ">gv")

-- lazy
mapkey("n", "<leader>l", "<cmd>Lazy<cr>", { desc = "Lazy" })

-- new file
mapkey("n", "<leader>fn", "<cmd>enew<cr>", { desc = "New File" })

mapkey("n", "<leader>xl", "<cmd>lopen<cr>", { desc = "Location List" })
mapkey("n", "<leader>xq", "<cmd>copen<cr>", { desc = "Quickfix List" })

mapkey("n", "[q", vim.cmd.cprev, { desc = "Previous quickfix" })
mapkey("n", "]q", vim.cmd.cnext, { desc = "Next quickfix" })

-- formatting
mapkey({ "n", "v" }, "<leader>cf", function()
  Util.format({ force = true })
end, { desc = "Format" })

-- diagnostic
local diagnostic_goto = function(next, severity)
  local go = next and vim.diagnostic.goto_next or vim.diagnostic.goto_prev
  severity = severity and vim.diagnostic.severity[severity] or nil
  return function()
    go({ severity = severity })
  end
end
mapkey("n", "<leader>cd", vim.diagnostic.open_float, { desc = "Line Diagnostics" })
mapkey("n", "]d", diagnostic_goto(true), { desc = "Next Diagnostic" })
mapkey("n", "[d", diagnostic_goto(false), { desc = "Prev Diagnostic" })
mapkey("n", "]e", diagnostic_goto(true, "ERROR"), { desc = "Next Error" })
mapkey("n", "[e", diagnostic_goto(false, "ERROR"), { desc = "Prev Error" })
mapkey("n", "]w", diagnostic_goto(true, "WARN"), { desc = "Next Warning" })
mapkey("n", "[w", diagnostic_goto(false, "WARN"), { desc = "Prev Warning" })

-- stylua: ignore start

-- toggle options
mapkey("n", "<leader>uf", function() Util.format.toggle() end, { desc = "Toggle auto format (global)" })
mapkey("n", "<leader>uF", function() Util.format.toggle(true) end, { desc = "Toggle auto format (buffer)" })
mapkey("n", "<leader>us", function() Util.toggle("spell") end, { desc = "Toggle Spelling" })
mapkey("n", "<leader>uw", function() Util.toggle("wrap") end, { desc = "Toggle Word Wrap" })
mapkey("n", "<leader>uL", function() Util.toggle("relativenumber") end, { desc = "Toggle Relative Line Numbers" })
mapkey("n", "<leader>ul", function() Util.toggle.number() end, { desc = "Toggle Line Numbers" })
mapkey("n", "<leader>ud", function() Util.toggle.diagnostics() end, { desc = "Toggle Diagnostics" })
local conceallevel = vim.o.conceallevel > 0 and vim.o.conceallevel or 3
mapkey("n", "<leader>uc", function() Util.toggle("conceallevel", false, {0, conceallevel}) end, { desc = "Toggle Conceal" })
if vim.lsp.buf.inlay_hint or vim.lsp.inlay_hint then
  mapkey( "n", "<leader>uh", function() Util.toggle.inlay_hints() end, { desc = "Toggle Inlay Hints" })
end
mapkey("n", "<leader>uT", function() if vim.b.ts_highlight then vim.treesitter.stop() else vim.treesitter.start() end end, { desc = "Toggle Treesitter Highlight" })
mapkey("n", "<leader>ub", function() Util.toggle("background", false, {"light", "dark"}) end, { desc = "Toggle Background" })

-- quit
mapkey("n", "<leader>qq", "<cmd>qa<cr>", { desc = "Quit all" })

-- highlights under cursor
mapkey("n", "<leader>ui", vim.show_pos, { desc = "Inspect Pos" })


-- windows
mapkey("n", "<leader>ww", "<C-W>p", { desc = "Other window", remap = true })
mapkey("n", "<leader>wd", "<C-W>c", { desc = "Delete window", remap = true })
mapkey("n", "<leader>w-", "<C-W>s", { desc = "Split window below", remap = true })
mapkey("n", "<leader>w|", "<C-W>v", { desc = "Split window right", remap = true })
mapkey("n", "<leader>-", "<C-W>s", { desc = "Split window below", remap = true })
mapkey("n", "<leader>|", "<C-W>v", { desc = "Split window right", remap = true })

-- tabs
mapkey("n", "<leader><tab>l", "<cmd>tablast<cr>", { desc = "Last Tab" })
mapkey("n", "<leader><tab>f", "<cmd>tabfirst<cr>", { desc = "First Tab" })
mapkey("n", "<leader><tab><tab>", "<cmd>tabnew<cr>", { desc = "New Tab" })
mapkey("n", "<leader><tab>]", "<cmd>tabnext<cr>", { desc = "Next Tab" })
mapkey("n", "<leader><tab>d", "<cmd>tabclose<cr>", { desc = "Close Tab" })
mapkey("n", "<leader><tab>[", "<cmd>tabprevious<cr>", { desc = "Previous Tab" })
