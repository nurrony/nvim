return {
  transparent = false,
  -- icons used by other plugins
  icons = {
    diagnostics = {
      Error = "󰅚 ", --🅴," ""󰢃 "
      Warn = "󰀪 ", --🆆," "
      Hint = "󰌶", --🅸," " "󰛩 "
      Info = " ", --🅷," ","󰗡 "
    },
    debugger = {
      Stopped = { " ", "DiagnosticWarn", "DapStoppedLine" }, --▶️breakpoints
      Breakpoint = " ",
      BreakpointCondition = " ", --conditional breakpoints
      BreakpointRejected = { " ", "DiagnosticError" },
      LogPoint = ".>", --log points
    },
    git = {
      add = { text = "│" }, --" ","▎"
      change = { text = "!" }, --" ",
      delete = { text = "_" }, --" ",""
      topdelete = { text = "‾" },
      changedelete = { text = "~" },
      untracked = { text = "┆" },
    },
    kinds = {
      Array = " ",
      Boolean = "󰨙 ",
      Class = " ",
      Codeium = "󰘦 ",
      Color = " ",
      Control = " ",
      Collapsed = " ",
      Constant = "󰏿 ",
      Constructor = " ",
      Copilot = " ",
      Enum = " ",
      EnumMember = " ",
      Event = " ",
      Field = " ",
      File = " ",
      Folder = " ",
      Function = "󰊕 ",
      Interface = " ",
      Key = " ",
      Keyword = " ",
      Method = "󰊕 ",
      Module = " ",
      Namespace = "󰦮 ",
      Null = " ",
      Number = "󰎠 ",
      Object = " ",
      Operator = " ",
      Package = " ",
      Property = " ",
      Reference = " ",
      Snippet = " ",
      String = " ",
      Struct = "󰆼 ",
      TabNine = "󰏚 ",
      Text = " ",
      TypeParameter = " ",
      Unit = " ",
      Value = " ",
      Variable = "󰀫 ",
    },
  },

  kind_filter = {
    default = {
      "Class",
      "Constructor",
      "Enum",
      "Field",
      "Function",
      "Interface",
      "Method",
      "Module",
      "Namespace",
      "Package",
      "Property",
      "Struct",
      "Trait",
    },
    markdown = false,
    help = false,
    -- you can specify a different filter for each filetype
    lua = {
      "Class",
      "Constructor",
      "Enum",
      "Field",
      "Function",
      "Interface",
      "Method",
      "Module",
      "Namespace",
      -- "Package", -- remove package since luals uses it for control flow structures
      "Property",
      "Struct",
      "Trait",
    },
  },
  -- options from nvim_open_win()| vim.diagnostic.open_float()
  -- | vim.lsp.util.open_floating_preview()| vim.diagnostic.config()
  ---@type table
  diagnostics_options = {
    -- virtual_text = true,
    -- open_float = false,
    -- virtual_text = {
    --   severity = { min = vim.diagnostic.severity.WARN, max = vim.diagnostic.severity.ERROR },
    --   source = "if_many",
    --   spacing = 4,
    --   prefix = "●",
    -- },
    float = {
      --nvim_open_win() options
      relative = "cursor",
      -- "single": A single line box.
      -- "double": A double line box.
      -- "rounded": Like "single", but with rounded corners "╭"
      -- "solid": Adds padding by a single whitespace cell.
      -- "shadow": A drop shadow effect by blending with the
      -- "none": No border (default).
      border = "rounded",
      -- vim.lsp.util.open_floating_preview()
      max_width = math.floor(vim.o.columns * 0.84),
      max_height = math.floor(vim.o.lines * 0.6),
      close_events = { "BufLeave", "CursorMoved", "InsertEnter", "FocusLost" },
      focusable = false,
      zindex = 3,
      focus = false,
      -- vim.diagnostic.open_float()
      source = "if_many",
      severity_sort = true,
    },
    update_in_insert = false,
    -- This affects the order in which signs and virtual text are displayed
    severity_sort = true,
  },
}
