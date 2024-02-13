-- Load editor options
require("nurrony.core.options")

local utils = require("nurrony.core.utils")
-- Load editor syntax, autocmds and keymaps
utils.lazy_load({ "nurrony.core.syntax", "nurrony.core.autocmds", "nurrony.core.keymaps" })

local diagnostics_options = require("nurrony.core.defaults").diagnostics_options

-- configure floating window
vim.diagnostic.config(diagnostics_options)

-- setup borders for handlers
vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, {
  border = diagnostics_options.float.border,
})
--
vim.lsp.handlers["textDocument/signatureHelp"] = vim.lsp.with(vim.lsp.handlers.signature_help, {
  border = diagnostics_options.float.border,
})

-- configure diagnostics signs
for name, icon in pairs(require("nurrony.core.defaults").icons.diagnostics) do
  name = "DiagnosticSign" .. name
  vim.fn.sign_define(name, { text = icon, texthl = name, numhl = "" })
end

-- configure debugger diagnostics signs
for name in pairs(require("nurrony.core.defaults").icons.debugger) do
  sign = type(sign) == "table" and sign or { sign }
  vim.fn.sign_define(
    "Dap" .. name,
    { text = sign[1], texthl = sign[2] or "DiagnosticInfo", linehl = sign[3], numhl = sign[3] }
  )
end
