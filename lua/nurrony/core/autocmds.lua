local autocmd = vim.api.nvim_create_autocmd -- create autocmd
local Util = require("nurrony.core.utils")
local Config = require("nurrony.core.configs")
local map = Util.map
local augroup = Util.augroup

-- disable ufo for certain file type
autocmd("FileType", {
  group = augroup("detach_ufo"),
  pattern = { "help", "alpha", "dashboard", "neo-tree", "Trouble", "lazy", "mason" },
  callback = function()
    require("ufo").detach()
  end,
})

-- resize splits if window got resized
autocmd({ "VimResized" }, {
  group = augroup("resize_splits"),
  callback = function()
    local current_tab = vim.fn.tabpagenr()
    vim.cmd("tabdo wincmd =")
    vim.cmd("tabnext " .. current_tab)
  end,
})

-- Fix conceallevel for json files
autocmd({ "FileType" }, {
  group = augroup("json_conceal"),
  pattern = { "json", "jsonc", "json5" },
  callback = function()
    vim.opt_local.conceallevel = 0
  end,
})

-- Check if we need to reload the file when it changed
autocmd({ "FocusGained", "TermClose", "TermLeave" }, {
  group = augroup("checktime"),
  callback = function()
    if vim.o.buftype ~= "nofile" then
      vim.cmd("checktime")
    end
  end,
})

-- define autocmd in a group so that you can clear it easily
autocmd({ "TermOpen" }, {
  group = augroup("Terminal"),
  pattern = { "*" },
  callback = function()
    vim.wo.number = false
    vim.wo.relativenumber = false
    vim.api.nvim_command("startinsert")
  end,
})

-- Highlight on yank
autocmd("TextYankPost", {
  group = augroup("highlight_yank"),
  callback = function()
    vim.highlight.on_yank()
  end,
})

-- go to the last known loc/position when opening a file/buffer
-- :h restore-position and :h restore-cursor
autocmd("BufReadPost", {
  group = augroup("restore cursor"),
  pattern = { "*" },
  callback = function()
    local mark = vim.api.nvim_buf_get_mark(0, '"')
    local lcount = vim.api.nvim_buf_line_count(0)
    if mark[1] >= 1 and mark[1] <= lcount then
      pcall(vim.api.nvim_win_set_cursor, 0, mark)
    end
  end,
})

-- close some filetypes with <q>
autocmd("FileType", {
  group = augroup("close_with_q"),
  pattern = {
    "qf",
    "help",
    "man",
    "query", -- :InspectTree
    "notify",
    "lspinfo",
    "undotree",
    "startuptime",
    "tsplayground",
    "spectre_panel",
    "PlenaryTestPopup",
  },
  callback = function(event)
    -- :help api-autocmd
    -- nvim_create_autocmd's callback receives a table argument with fields
    -- event = {id,event,group?,match,buf,file,data(arbituary data)}
    vim.bo[event.buf].buflisted = false
    map("n", "q", "<cmd>close<cr>", { buffer = event.buf, silent = true }, "close some filetype windows with <q>")
  end,
})

-- wrap and check for spell in text filetypes
autocmd("FileType", {
  group = augroup("wrap_spell"),
  pattern = { "gitcommit", "markdown", "norg" },
  callback = function()
    vim.opt_local.wrap = true
    vim.opt_local.spell = true
  end,
})

-- automatically show diagnostics on current line
autocmd({ "CursorHold" }, {
  callback = function()
    vim.diagnostic.open_float(nil, Config.diagnostics_options.float) -- uncomment this to enable floation report
  end,
})

-- Auto create dir when saving a file, in case some intermediate directory does not exist
autocmd({ "BufWritePre" }, {
  group = augroup("auto_create_dir"),
  callback = function(event)
    if event.match:match("^%w%w+://") then
      return
    end
    local file = vim.loop.fs_realpath(event.match) or event.match
    vim.fn.mkdir(vim.fn.fnamemodify(file, ":p:h"), "p")
  end,
})

-- Remove Trailing whitespaces in all files
autocmd({ "BufWritePre" }, { pattern = { "*" }, command = [[%s/\s\+$//e]] })

-- Remove Trailing windows carriage return in all files
if vim.fn.has("win64") == 1 or vim.fn.has("wsl") == 1 then
  autocmd({ "BufWritePre" }, { pattern = { "*" }, command = [[%s/\r$//e]] })
end
