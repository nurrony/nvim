local float = require("nurrony.core.configs").diagnostics_options.float
local Util = require("nurrony.core.utils")

return {
  -- Detect tabstop and shiftwidth automatically
  { "tpope/vim-sleuth" },

  -- visualizes the undo history and makes it easy to browse and switch between different undo branches
  {
    "mbbill/undotree",
    cmd = "UndotreeToggle",
    init = function()
      -- open right
      vim.g.undotree_WindowLayout = 3
    end,
    keys = {
      { "<leader>cu", "<cmd>UndotreeToggle<cr>", desc = "toggle undotree" }
    }
  },

  -- configure neovim
  {
    "neovim/nvim-lspconfig",
    event = { "BufReadPre", "BufNewFile" },
    keys = {
      { "<leader>cl", "<cmd>LspInfo<cr>", desc = "Lsp Info" },
    },
    dependencies = {
      "mason.nvim",
      "williamboman/mason-lspconfig.nvim",
      {
        --TODO: enable inline hint with 0.10 release
        "ray-x/lsp_signature.nvim",
        opts = {
          bind = true,
          hint_prefix = " ",
          hint_enable = false, -- enable it for single hint
          max_height = float.max_height,
          max_width = float.max_width,
          handler_opts = { border = float.border },
        },
      },
      {
        "folke/neodev.nvim",
        opts = { pathStrict = true, library = { plugins = { "nvim-dap-ui" }, types = true } },
      },
      {
        "antosha417/nvim-lsp-file-operations",
        config = true
      },
    },
    opts = {
      format = {
        formatting_options = nil,
        timeout_ms = nil,
      },
      -- for any global capabilities
      capabilities = {},
      -- LSP Server Settings
      servers = {
        cssls = {},
        html = {},
        emmet_ls = {},
        bashls = {
          filetypes = {
            "sh",
            "zsh",
            "bash",
          },
        },
        lua_ls = {
          settings = {
            Lua = {
              runtime = {
                -- LuaJIT in the case of Neovim
                version = "LuaJIT",
              },
              diagnostics = {
                -- Get the language server to recognize the `vim` global
                globals = { "vim" },
              },
              workspace = {
                -- Make the server aware of Neovim runtime files
                library = vim.api.nvim_get_runtime_file("", true),
                -- This feature causes the lsp to use the "environment emulation" feature to suggest
                -- applying a library/framework when a certain keyword or filename has been found
                checkThirdParty = false,
              },
              -- disable lua_ls default formater since I use stylua
              format = { enable = false },
              -- set telemetry false
              telemetry = { enable = false },
            },
          },
        },
      },
      -- you can do any additional lsp server setup here
      -- you can do any additional lsp server setup here
      -- return true if you don't want this server to be setup with lspconfig
      ---@type table<string, fun(server:string, opts: table):boolean?>
      setup = {
        lua_ls = function(server, opts)
          require("lspconfig")[server].setup(opts)
        end,
      },
    },
    config = function(_, opts)
      local on_attach = function(client, bufnr)
        _ = client
        _ = bufnr
        -- if vim.filetype.match({ buf = bufnr }) == "lua" then
        -- end
        require("lspconfig.ui.windows").default_options = {
          border = float.border,
        }
      end

      local servers = opts.servers
      local has_cmp, cmp_nvim_lsp = pcall(require, "cmp_nvim_lsp")
      local capabilities = vim.tbl_deep_extend(
        "force",
        {},
        vim.lsp.protocol.make_client_capabilities(),
        has_cmp and cmp_nvim_lsp.default_capabilities() or {},
        opts.capabilities or {}
      )

      local function setup(server)
        local server_opts = vim.tbl_deep_extend("force", {
          capabilities = vim.deepcopy(capabilities),
          on_attach = on_attach,
        }, servers[server] or {})

        if opts.setup[server] then
          if opts.setup[server](server, server_opts) then
            return
          end
        elseif opts.setup["*"] then
          if opts.setup["*"](server, server_opts) then
            return
          end
        end
        require("lspconfig")[server].setup(server_opts)
      end

      -- get all the servers that are available through mason-lspconfig
      local have_mason, mlsp = pcall(require, "mason-lspconfig")
      local all_mslp_servers = {}
      if have_mason then
        all_mslp_servers = vim.tbl_keys(require("mason-lspconfig.mappings.server").lspconfig_to_package)
      end

      local ensure_installed = {}
      for server, server_opts in pairs(servers) do
        if server_opts then
          server_opts = server_opts == true and {} or server_opts
          -- run manual setup if mason=false or if this is a server that cannot be installed with mason-lspconfig
          if server_opts.mason == false or not vim.tbl_contains(all_mslp_servers, server) then
            setup(server)
          else
            ensure_installed[#ensure_installed + 1] = server
          end
        end
      end

      if have_mason then
        mlsp.setup({ ensure_installed = ensure_installed, handlers = { setup } })
      end
    end,
  },

  -- to automate install lsp tools and servers
  {
    "williamboman/mason.nvim",
    cmd = "Mason",
    keys = { { "<leader>cm", "<cmd>Mason<cr>", desc = "Mason" } },
    build = ":MasonUpdate",
    opts = {
      PATH = "prepend",
      ui = {
        width = 0.8,
        height = 0.8,
        border = float.border,
        icons = {
          package_installed = "",
          package_pending = "",
          package_uninstalled = "",
        },
      },
      ensure_installed = {
        "shfmt",
        "stylua",
        "css-lsp",
        "prettier",
        "html-lsp",
        "emmet-lsp",
        "lua-language-server",
        "bash-language-server",
      },

    },
    config = function(_, opts)
      require("mason").setup(opts)
      local mr = require("mason-registry")
      mr:on("package:install:success", function()
        vim.defer_fn(function()
          -- trigger FileType event to possibly load this newly installed LSP server
          require("lazy.core.handler.event").trigger({
            event = "FileType",
            buf = vim.api.nvim_get_current_buf(),
          })
        end, 100)
      end)
      local function ensure_installed()
        for _, tool in ipairs(opts.ensure_installed) do
          local p = mr.get_package(tool)
          if not p:is_installed() then
            p:install()
          end
        end
      end
      if mr.refresh then
        mr.refresh(ensure_installed)
      else
        ensure_installed()
      end
    end,
  },

  -- Format
  {
    "stevearc/conform.nvim",
    lazy = true,
    event = { "BufReadPre", "BufNewFile" }, -- to disable, comment this out
    opts = {
      formatters = {
        lua = { "stylua" },
        css = { "prettier" },
        html = { "prettier" },
        json = { "prettier" },
        yaml = { "prettier" },
        markdown = { "prettier" },
      },
      format_on_save = {
        lsp_fallback = true,
        async = false,
        timeout_ms = 1000,
      },
    },
    config = function(_, opts)
      local conform = require("conform")
      conform.setup({
        formatters_by_ft = opts.formatters,
        format_on_save = opts.format_on_save,
      })
    end,
  },

  -- Lint
  {
    "mfussenegger/nvim-lint",
    lazy = true,
    event = { "BufReadPre", "BufNewFile" }, -- to disable, comment this out
    opts = {
      linters_by_ft = {
        html = { "prettier" },
        css = { "prettier" },
        markdown = { "prettier" }
      },
    },
    config = function(_, opts)
      local lint = require("lint")

      lint.linters_by_ft = opts.linters_by_ft

      local lint_augroup = vim.api.nvim_create_augroup("LspLint", { clear = true })

      vim.api.nvim_create_autocmd({ "BufEnter", "BufWritePost", "InsertLeave" }, {
        group = lint_augroup,
        callback = function()
          lint.try_lint()
        end,
      })

      -- bind key map
      Util.map("n", "<leader>cv", function()
        lint.try_lint()
      end, { desc = "vet/lint code" })
    end,
  },

  -- manage folding using ufo
  {
    "kevinhwang91/nvim-ufo",
    event = { "BufReadPost", "BufNewFile" },
    keys = {
      {
        "zP",
        function()
          require("ufo").peekFoldedLinesUnderCursor()
        end,
        desc = "Preview fold",
      },
    },
    dependencies = { "kevinhwang91/promise-async" },
    init = function()
      -- INFO fold commands usually change the foldlevel, which fixes folds, e.g.
      -- auto-closing them after leaving insert mode, however ufo does not seem to
      -- have equivalents for zr and zm because there is no saved fold level.
      -- Consequently, the vim-internal fold levels need to be disabled by setting
      -- them to 99
      -- These options were reccommended by nvim-ufo
      -- See: https://github.com/kevinhwang91/nvim-ufo#minimal-configuration
      vim.opt.foldcolumn = "0"
      vim.opt.foldlevel = 99
      vim.opt.foldlevelstart = 99
      vim.opt.foldenable = true
    end,
    opts = {
      provider_selector = function(_, ft, _)
        -- INFO some filetypes only allow indent, some only LSP, some only
        -- treesitter. However, ufo only accepts two kinds as priority,
        -- therefore making this function necessary :/
        local lspWithOutFolding = { "markdown", "sh", "css", "html", "python" }
        if vim.tbl_contains(lspWithOutFolding, ft) then
          return { "treesitter", "indent" }
        end
        return { "lsp", "indent" }
      end,
      -- when opening the buffer, close these fold kinds
      -- use `:UfoInspect` to get available fold kinds from the LSP
      close_fold_kinds_for_ft = { default = { "imports", "comment" } },
      open_fold_hl_timeout = 150,
      fold_virt_text_handler = Util.fold_text_formatter,
      preview = {
        win_config = {
          winblend = 0,
          border = float.border,
          winhighlight = "Normal:Folded",
        },
      },
    },
  },
}
