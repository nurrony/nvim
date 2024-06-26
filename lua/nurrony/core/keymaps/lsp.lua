local autocmd = vim.api.nvim_create_autocmd -- create autocmd
local Utils = require("nurrony.core.utils")
local map = Utils.map
local augroup = Utils.augroup

-- map the following keys after the language server attaches to a buffer
-- See `:help vim.lsp.*` for doc mentation on any of the below functions
-- :lua =vim.lsp.get_active_clients()[1].server_capabilities to get capabilities of lsp attached to buffer
Utils.on_attach(function(client, bufnr)
  local opts = { buffer = bufnr }

  -- capabilitiies: hover
  if client.server_capabilities.hoverProvider then
    map("n", "K", function()
      vim.lsp.buf.hover()
    end, opts, "Hover Info")
  end

  -- capabilitiies: signatureHelpProvider
  if client.server_capabilities.signatureHelpProvider then
    map("n", "gK", vim.lsp.buf.signature_help, opts, "signature help")
  end

  -- capabilities: declarationProvider
  if client.server_capabilities.declarationProvider then
    map("n", "gD", vim.lsp.buf.declaration, opts, "goto declaration")
  end

  -- capabilitiies: completionProvider
  if client.server_capabilities.completionProvider then
    vim.bo[bufnr].omnifunc = "v:lua.vim.lsp.omnifunc"
  end

  -- capabilitiies: definitionProvider
  if client.server_capabilities.definitionProvider then
    vim.bo[bufnr].tagfunc = "v:lua.vim.lsp.tagfunc"
    map("n", "gd", function()
      if Utils.has("lspsaga.nvim") then
        vim.cmd([[Lspsaga goto_definition]])
      else
        -- vim.lsp.buf.definition()
        require("telescope.builtin").lsp_definitions({ reuse_win = true })
      end
    end, opts, "goto definition")

    if Utils.has("lspsaga.nvim") then
      map("n", "<leader>pd", function()
        vim.cmd([[Lspsaga peek_definition]])
      end, opts, "peek definition")
    end
  end

  -- capabilitiies: typeDefinitionProvider
  if client.server_capabilities.typeDefinitionProvider then
    map("n", "gy", function()
      if Utils.has("lspsaga.nvim") then
        vim.cmd([[Lspsaga goto_type_definition]])
      else
        -- vim.lsp.buf.type_definition()
        require("telescope.builtin").lsp_type_definitions({ reuse_win = true })
      end
    end, opts, "goto type definition")

    if Utils.has("lspsaga.nvim") then
      map("n", "<leader>pt", function()
        vim.cmd([[Lspsaga peek_type_definition]])
      end, opts, "peek type definition")
    end
  end

  -- capabilitiies: implementationProvider
  if client.server_capabilities.implementationProvider then
    map("n", "gI", function()
      if Utils.has("lspsaga.nvim") then
        vim.cmd([[Lspsaga finder imp+def]])
      else
        -- vim.lsp.buf.implementation()
        require("telescope.builtin").lsp_implementations({ reuse_win = true })
      end
    end, opts, "goto implementation")
  end

  -- capabilitiies: referencesProvider
  if client.server_capabilities.referencesProvider then
    map("n", "gr", function()
      if Utils.has("lspsaga.nvim") then
        vim.cmd([[Lspsaga finder ref]])
      else
        vim.cmd([[Telescope lsp_references]])
        -- vim.lsp.buf.references({})
      end
    end, opts, "goto type references")
  end

  -- capabilitiies: documentHighlightProvider
  if client.server_capabilities.documentHighlightProvider then
    vim.api.nvim_set_hl(0, "LspReferenceRead", {
      link = "DiffText",
    })
    vim.api.nvim_set_hl(0, "LspReferenceText", {
      link = "IncSearch",
    })
    vim.api.nvim_set_hl(0, "LspRefDiffTexterenceWrite", {
      link = "WildMenu",
    })
    local doc_highlight = augroup("lsp_document_highlight")
    local enable_highlight = function()
      autocmd({ "CursorHold", "CursorHoldI" }, {
        group = doc_highlight,
        buffer = bufnr,
        callback = vim.lsp.buf.document_highlight,
      })
      autocmd("CursorMoved", {
        group = doc_highlight,
        buffer = bufnr,
        callback = vim.lsp.buf.clear_references,
      })
    end
    local disable_highlight = function()
      vim.lsp.buf.clear_references()
      vim.api.nvim_clear_autocmds({
        buffer = bufnr,
        group = doc_highlight,
      })
    end
    map("n", "<leader>uh", function()
      Utils.toggle("highlight", {}, { enable_highlight, disable_highlight })
      vim.b[vim.fn.bufnr()]["highlight"]()
    end, opts, "toggle document highlight")
  end

  -- if client.server_capabilities.documentSymbolProvider then
  --   -- vim.lsp.buf.document_symbol
  --   map("n", "gs", function()
  --     require("telescope.builtin").lsp_document_symbols({ reuse_win = true })
  --   end, opts, "document symbols")
  -- end

  -- if client.server_capabilities.workspaceSymbolProvider then
  --   -- vim.lsp.buf.document_symbol
  --   map("n", "gS", function()
  --     require("telescope.builtin").lsp_workspace_symbols({ reuse_win = true })
  --   end, opts, "workspace symbols")
  -- end

  if client.server_capabilities.codeActionProvider then
    map({ "n", "v" }, "<leader>ca", function()
      if Utils.has("lspsaga.nvim") then
        vim.cmd([[Lspsaga code_action]])
      else
        vim.lsp.buf.code_action()
      end
    end, opts, "code action")

    map({ "n", "v" }, "<leader>cA", function()
      vim.lsp.buf.code_action({
        context = {
          only = {
            "source",
          },
          diagnostics = {},
        },
      })
    end, opts, "source action")
  end

  if client.server_capabilities.documentFormattingProvider then
    -- toggle autoformat
    map("n", "<leader>uf", function()
      Utils.toggle("autoformat", { global = true })
      autocmd("BufWritePre", {
        group = augroup("LspFormat"),
        callback = function()
          if vim.g["autoformat"] then
            require("conform").format({
              async = false,
              timeout_ms = 500,
              lsp_fallback = true,
            })
          end
        end,
      })
    end, opts, "toggle autoformat")

    map({ "n" }, "<leader>cf", function()
      require("conform").format({
        async = false,
        timeout_ms = 500,
        lsp_fallback = true,
      })
    end, opts, "format code")
  end

  if client.server_capabilities.renameProvider then
    map("n", "<leader>rn", function()
      vim.lsp.buf.rename()
    end, opts, "rename symbol")

    if Utils.has("lspsaga.nvim") then
      map("n", "<leader>rnw", function()
        vim.cmd([[Lspsaga project_replace]])
      end, opts, "rename across workspace")
    end
  end

  if client.server_capabilities.callHierarchyProvider then
    map("n", "<leader>ci", function()
      if Utils.has("lspsaga.nvim") then
        vim.cmd([[Lspsaga incoming_calls]])
      else
        vim.lsp.buf.incoming_calls()
      end
    end, opts, "incoming calls")
    map("n", "<leader>co", function()
      if Utils.has("lspsaga.nvim") then
        vim.cmd([[Lspsaga outgoing_calls]])
      else
        vim.lsp.buf.outgoing_calls()
      end
    end, opts, "outgoing calls")
  end
  if client.server_capabilities.workspaceSymbolProvider then
    map("n", "<leader>ws", vim.lsp.buf.workspace_symbol, opts, "list workspace symbols")
  end

  -- diagnostics
  map("n", "]d", Utils.diagnostic_goto(true), { desc = "Next Diagnostic" })
  map("n", "[d", Utils.diagnostic_goto(false), { desc = "Prev Diagnostic" })
  map("n", "]e", Utils.diagnostic_goto(true, "ERROR"), { desc = "Next Error" })
  map("n", "[e", Utils.diagnostic_goto(false, "ERROR"), { desc = "Prev Error" })
  map("n", "]w", Utils.diagnostic_goto(true, "WARN"), { desc = "Next Warning" })
  map("n", "[w", Utils.diagnostic_goto(false, "WARN"), { desc = "Prev Warning" })

  map("n", "<leader>wf", function()
    vim.print(vim.lsp.buf.list_workspace_folders())
  end, opts, "list workspace folders")

  map("n", "<leader>rd", function()
    print("Language server " .. (vim.lsp.buf.server_ready() and "is ready" or "is not ready"))
  end, opts, "check if lsp is ready")
end)
