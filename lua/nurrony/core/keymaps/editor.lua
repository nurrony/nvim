local Util = require("nurrony.core.utils")
local map = Util.map

local opt = { noremap = true, silent = true }

vim.cmd([[ cabbrev ht tab help]]) --map("c","h","tab help")

map("n", "[q", vim.cmd.cprev, { desc = "Previous quickfix" })
map("n", "]q", vim.cmd.cnext, { desc = "Next quickfix" })

-- search visually selected region on current line
map("v", "//", [[y/\V<C-R>=escape(@",'/\')<CR><CR>]], opt)

-- Map jk to ESC
map({ "i", "v" }, "jk", "<ESC>", { remap = false, nowait = true })

map("n", "B", "m`0i<CR><ESC>``i", opt) -- J(join) B(BackJoin): move text after cursor to next line

-- keep pasting over the same thing, ie. delete content and paste something in it place
map("n", "<leader>p", [[m`0"_DP``]], opt, "keep pasting overwriting text")
map("v", "<leader>p", [[m`"_dP``]], opt, "keep pasting over the same thing")

-- delete content without clobbering registers
map({ "n", "v" }, "<leader>D", [["_d]], { remap = false }, "delete content without clobbering registers")

-- Switch CWD to the directory of the open buffer
map({ "n", "v", "o" }, "<leader>cd", "<cmd>cd %:p:h<cr>:pwd<cr>", opt, "switch to cwd")

-- Move to window using the <ctrl> hjkl keys
map("n", "<C-h>", "<C-w>h", { desc = "Go to left window", noremap = true })
map("n", "<C-j>", "<C-w>j", { desc = "Go to lower window", noremap = true })
map("n", "<C-k>", "<C-w>k", { desc = "Go to upper window", noremap = true })
map("n", "<C-l>", "<C-w>l", { desc = "Go to right window", noremap = true })

local mode = { "n", "v", "o" }

-- buffers
map("n", "<leader>bb", "<cmd>b#<cr>", { desc = "Switch to Previous Buffer" })
map("n", "<leader>`", "<cmd>b#<cr>", { desc = "Switch to Previous Buffer" })
map("n", "<leader>b1", "<cmd>bfirst<cr>", opt, "goto first buffer") -- move to the first buffer in the buffer list
map("n", "<leader>b9", "<cmd>blast<cr>", opt, "goto last buffer") -- move to the last buffer in the buffer list
map("n", "<leader>bd", "<cmd>bdelete<cr>", opt, "delete current buffer") -- Close the current buffer
map("n", "<leader>bo", "<cmd>%bdelete<bar>edit#<bar>bdelete#<cr>", opt) -- Close all buffers except current
map("n", "<leader>bn", "<cmd>enew | startinsert<cr>", { desc = "New File" }) -- new file

-- Useful mappings for managing tabs
map(mode, "<leader>t1", "<cmd>tabfirst<cr>", opt, "goto first tab")
map(mode, "<leader>t9", "<cmd>tablast<cr>", opt, "goto last tab")
map(mode, "<leader>td", "<cmd>tabclose<cr>", opt, "close tab")
map(mode, "<leader>tn", "<cmd>tabnew<cr>", opt, "new tab")
map(mode, "<leader>to", "<cmd>tabonly<cr>", opt, "close all tabs except current")
--TODO: tabmove should take an input
map(mode, "<leader>tm", "<cmd>tabmove<cr>", opt, "move tab")
map(mode, "<leader>]t", "<cmd>tabnext<cr>", opt, "goto next tab")
map(mode, "<leader>[t", "<cmd>tabprevious<cr>", opt, "goto previous tab")

-- tabs
map("n", "<leader><tab>l", "<cmd>tablast<cr>", { desc = "Last Tab" })
map("n", "<leader><tab>f", "<cmd>tabfirst<cr>", { desc = "First Tab" })
map("n", "<leader><tab><tab>", "<cmd>tabnew<cr>", { desc = "New Tab" })
map("n", "<leader><tab>]", "<cmd>tabnext<cr>", { desc = "Next Tab" })
map("n", "<leader><tab>d", "<cmd>tabclose<cr>", { desc = "Close Tab" })
map("n", "<leader><tab>[", "<cmd>tabprevious<cr>", { desc = "Previous Tab" })

-- Resize window using <ctrl> arrow keys
map("n", "<C-Up>", "<cmd>resize +2<cr>", { desc = "Increase window height" })
map("n", "<C-Down>", "<cmd>resize -2<cr>", { desc = "Decrease window height" })
map("n", "<C-Left>", "<cmd>vertical resize -2<cr>", { desc = "Decrease window width" })
map("n", "<C-Right>", "<cmd>vertical resize +2<cr>", { desc = "Increase window width" })

-- windows
map("n", "<leader>ww", "<C-W>p", { desc = "Other window" })
map("n", "<leader>wd", "<C-W>c", { desc = "Delete window" })
map("n", "<leader>w-", "<C-W>s", { desc = "Split window below" })
map("n", "<leader>w|", "<C-W>v", { desc = "Split window right" })
map("n", "<leader>-", "<C-W>s", { desc = "Split window below" })
map("n", "<leader>|", "<C-W>v", { desc = "Split window right" })
map("n", "<leader>=", "<C-W>=", { desc = "resize and make windows equal" })

-- Move Lines
map("n", "<A-Down>", "<cmd>m .+1<cr>==", { desc = "Move down" })
map("n", "<A-Up>", "<cmd>m .-2<cr>==", { desc = "Move up" })
map("i", "<A-Down>", "<esc><cmd>m .+1<cr>==gi", { desc = "Move down" })
map("i", "<A-Up>", "<esc><cmd>m .-2<cr>==gi", { desc = "Move up" })
map("v", "<A-Down>", ":m '>+1<cr>gv=gv", { desc = "Move down" })
map("v", "<A-Up>", ":m '<-2<cr>gv=gv", { desc = "Move up" })

-- save file
-- map({ "i", "x", "n", "s" }, "<C-s>", "<cmd>w<cr><esc>", { noremap = true, silent = true }, "Save file")
map({ "i", "x", "n", "s" }, "<M-s>", "<cmd>w<cr><esc>", { noremap = true, silent = true }, "Save file")

-- quit
map("n", "<leader>qq", function()
  vim.cmd([[qall]])
end, { desc = "Quit all" })

-- better up/down
map("n", "j", "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })
map("n", "k", "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })

-- Clear search with <esc>
map({ "i", "n" }, "<esc>", "<cmd>noh<cr><esc>", { desc = "Escape and clear hlsearch" })

-- lazy
map("n", "<leader>l", "<cmd>:Lazy<cr>", { desc = "󰒲 Lazy" })

-- toggle options
-- === Spell checking === "
--vim.cmd [[set spell!]] also works
map("n", "<leader>us", function()
  Util.toggle("spell")
end, { desc = "Toggle Spelling" })

map("n", "<leader>uw", function()
  Util.toggle("wrap")
end, { desc = "Toggle Word Wrap" })

map("n", "<leader>ul", function()
  Util.toggle("relativenumber")
  Util.toggle("number")
end, { desc = "Toggle Line Numbers" })

map("n", "<leader>uc", function()
  local disable_conceal = 0
  local enable_conceal = 3
  local conceallevel = vim.o.conceallevel > 0 and disable_conceal or enable_conceal

  local filetype = vim.filetype.match({ buf = 0 })

  if filetype == "norg" and Util.has("neorg") then
    Util.toggle("conceallevel", nil, { 0, conceallevel })
    vim.cmd([[Neorg toggle-concealer]])
  else
    Util.toggle("conceallevel", nil, { 0, conceallevel })
  end
end, { desc = "Toggle Conceal" })

map("n", "<leader>ue", function()
  Util.toggle("listchars", nil, {
    { tab = [[→→]], trail = "•", extends = "»", precedes = "«" },
    { tab = [[→→]], trail = "•", extends = "»", precedes = "«", eol = "↴" },
  })
end, { desc = "Toggle EOL" })

-- indent and outdent lines in visual mode
map("v", "<TAB>", "<S->>gv", { noremap = true, silent = true, desc = "indent line" })
map("v", "<S-TAB>", "<S-<>gv", { noremap = true, silent = true, desc = "outdent line" })
