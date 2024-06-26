-- Load editor options
require("nurrony.core.options")

local Configs = require("nurrony.core.configs")
local utils = require("nurrony.core.utils")
local diagnostics_options = Configs.diagnostics_options

-- Load editor syntax, autocmds and keymaps
utils.lazy_load({ "nurrony.core.syntax", "nurrony.core.autocmds", "nurrony.core.keymaps" })

-- configure floating window
vim.diagnostic.config(diagnostics_options)

-- setup borders for handlers
vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, {
  border = diagnostics_options.float.border,
})

-- signatureHelp
vim.lsp.handlers["textDocument/signatureHelp"] = vim.lsp.with(vim.lsp.handlers.signature_help, {
  border = diagnostics_options.float.border,
})

-- configure diagnostics signs
for name, icon in pairs(Configs.icons.diagnostics) do
  name = "DiagnosticSign" .. name
  vim.fn.sign_define(name, { text = icon, texthl = name, numhl = "" })
end
