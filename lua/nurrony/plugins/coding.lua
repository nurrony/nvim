local float = require("nurrony.core.configs").diagnostics_options.float
local Util = require("nurrony.core.utils")

return {
  -- Detect tabstop and shiftwidth automatically
  { "tpope/vim-sleuth" },

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
      -- for any global capabilities
      capabilities = {},
      -- LSP Server Settings
      servers = {
        cssls = {},
        html = {},
        pyright = {},
        emmet_ls = {},
        bashls = { filetypes = { "bash", "sh" } },
        yamlls = {
          -- Have to add this for yamlls to understand that we support line folding
          capabilities = {
            textDocument = {
              foldingRange = {
                dynamicRegistration = false,
                lineFoldingOnly = true,
              },
            },
          },
          -- lazy-load schemastore when needed
          on_new_config = function(new_config)
            new_config.settings.yaml.schemas = vim.tbl_deep_extend(
              "force",
              new_config.settings.yaml.schemas or {},
              require("schemastore").yaml.schemas()
            )
          end,
          settings = {
            redhat = { telemetry = { enabled = false } },
            yaml = {
              keyOrdering = false,
              format = {
                enable = true,
              },
              validate = true,
              schemaStore = {
                -- Must disable built-in schemaStore support to use
                -- schemas from SchemaStore.nvim plugin
                enable = false,
                -- Avoid TypeError: Cannot read properties of undefined (reading 'length')
                url = "",
              },
            },
          },
        },
        jsonls = {
          -- lazy-load schemastore when needed
          on_new_config = function(new_config)
            new_config.settings.json.schemas = new_config.settings.json.schemas or {}
            vim.list_extend(new_config.settings.json.schemas, require("schemastore").json.schemas())
          end,
          settings = {
            json = {
              format = { enable = true },
              validate = { enable = true },
            },
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
        -- volar = {},
        -- tailwindcss = {},
      },
      -- you can do any additional lsp server setup here
      -- you can do any additional lsp server setup here
      -- return true if you don't want this server to be setup with lspconfig
      ---@type table<string, fun(server:string, opts: table):boolean?>
      setup = {
        lua_ls = function(server, opts)
          require("lspconfig")[server].setup(opts)
        end,
        yamlls = function()
          -- Neovim < 0.10 does not have dynamic registration for formatting
          if vim.fn.has("nvim-0.10") == 0 then
            require("nurrony.core.utils").on_attach(function(client, _)
              if client.name == "yamlls" then
                client.server_capabilities.documentFormattingProvider = true
              end
            end)
          end
        end,
        -- example to setup with typescript.nvim
        -- return true if you do not want to configure this
        -- tsserver = function(_, opts)
        --   require("typescript").setup({ server = opts })
        -- end,
      },
    },
    config = function(_, opts)
      if Util.has("neoconf.nvim") then
        local plugin = require("lazy.core.config").spec.plugins["neoconf.nvim"]
        require("neoconf").setup(require("lazy.core.plugin").values(plugin, "opts", false))
      end

      local on_attach = function(client, bufnr)
        _ = client
        _ = bufnr
        -- if vim.filetype.match({ buf = bufnr }) == "lua" then
        -- end
        require("lspconfig.ui.windows").default_options = {
          border = float.border,
        }
      end

      local function setup(server, server_config)
        if opts.setup[server] then
          if opts.setup[server](server, server_config) then
            return
          end
        end
        require("lspconfig")[server].setup(server_config)
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

      for server, _ in pairs(servers) do
        local server_config = vim.tbl_deep_extend("force", {
          capabilities = vim.deepcopy(capabilities),
          on_attach = on_attach,
        }, servers[server] or {})

        setup(server, server_config)
      end

      -- if Util.lsp.get_config("denols") and Util.lsp.get_config("tsserver") then
      --   local is_deno = require("lspconfig.util").root_pattern("deno.json", "deno.jsonc")
      --   Util.lsp.disable("tsserver", is_deno)
      --   Util.lsp.disable("denols", function(root_dir)
      --     return not is_deno(root_dir)
      --   end)
      -- end
    end,
  },

  -- to automate install lsp tools and servers
  {
    "williamboman/mason.nvim",
    cmd = "Mason",
    keys = { { "<leader>cm", "<cmd>Mason<cr>", desc = "Mason" } },
    build = ":MasonUpdate",
    dependencies = {
      "williamboman/mason-lspconfig.nvim",
      "WhoIsSethDaniel/mason-tool-installer.nvim",
    },
    opts = {
      attributes = {
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
      },
      servers = {
        ensure_installed = {
          "html",
          "cssls",
          "bashls",
          "jsonls",
          "yamlls",
          "lua_ls",
          "pyright",
          "emmet_ls",
          -- "tsserver",
          -- "terraformls",
          -- "jdtls",
          -- "tailwindcss",
          -- "svelte",
          -- "graphql",
          -- "prismals",
        },
        -- auto-install configured servers (with lspconfig)
        automatic_installation = true, -- not the same as ensure_installed
      },
      lsp_tools = {
        ensure_installed = {
          "stylua",   -- lua formatter
          "shfmt",    -- shell formatter
          -- "eslint_d", -- js linter
          "hadolint", -- docker linter
          "prettier", -- prettier formatter
          "isort",    -- python formatter
          "black",    -- python formatter
          "pylint",   -- python linter
          -- "js-debug-adapter",   -- js debugger
          -- "java-test",          -- java test
          -- "java-debug-adapter", -- java debugger
        },
      },
    },
    config = function(_, opts)
      -- import mason
      local mason = require("mason")
      mason.setup(opts.attributes)

      -- import mason-lspconfig
      local mason_lspconfig = require("mason-lspconfig")
      mason_lspconfig.setup(opts.servers)

      local mason_tool_installer = require("mason-tool-installer")
      mason_tool_installer.setup(opts.lsp_tools)
    end,
  },

  -- Format
  {
    "stevearc/conform.nvim",
    lazy = true,
    event = { "BufReadPre", "BufNewFile" }, -- to disable, comment this out
    opts = {
      formatters = {
        javascript = { "prettier" },
        typescript = { "prettier" },
        javascriptreact = { "prettier" },
        typescriptreact = { "prettier" },
        svelte = { "prettier" },
        css = { "prettier" },
        html = { "prettier" },
        json = { "prettier" },
        yaml = { "prettier" },
        markdown = { "prettier" },
        graphql = { "prettier" },
        lua = { "stylua" },
        python = { "isort", "black" },
        terraform = { "terraform_fmt" },
        tf = { "terraform_fmt" },
        ["terraform-vars"] = { "terraform_fmt" },
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
      linters = {
        python = { "pylint" },
        svelte = { "eslint_d" },
        dockerfile = { "hadolint" },
        javascript = { "eslint_d" },
        typescript = { "eslint_d" },
        tf = { "terraform_validate" },
        javascriptreact = { "eslint_d" },
        typescriptreact = { "eslint_d" },
        terraform = { "terraform_validate" },
      },
    },
    config = function(_, opts)
      local lint = require("lint")

      lint.linters_by_ft = opts.linters

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
      { "zP", function() require("ufo").peekFoldedLinesUnderCursor() end, desc = "Preview fold" },
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
      close_fold_kinds = { "imports", "comment" },
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

  -- yaml and json schema configuration
  {
    "b0o/SchemaStore.nvim",
    lazy = true,
    version = false, -- last release is way too old
  },
}
