local float = require("nurrony.core.defaults").diagnostics_options.float
return {
  -- Language server configuration
  {
    "neovim/nvim-lspconfig",
    event = { "BufReadPre", "BufNewFile" },
    dependencies = {
      "mason.nvim",
      "williamboman/mason-lspconfig.nvim",
      {
        --TODO: enable inline hint with 0.10 release
        "ray-x/lsp_signature.nvim",
        opts = {
          bind = true,
          max_height = float.max_height,
          max_width = float.max_width,
          handler_opts = {
            border = float.border,
          },
        },
      },
      {
        "folke/neodev.nvim",
        ft = "lua",
        opts = { pathStrict = true, library = { plugins = { "nvim-dap-ui" }, types = true } },
      },
      { "folke/neoconf.nvim", cmd = "Neoconf", config = false, dependencies = { "nvim-lspconfig" } },
    },
    opts = {
      -- LSP Server Settings
      servers = {
        cssls = {},
        html = {},
        eslint = {},
        jsonls = {},
        yamlls = {},
        emmet_ls = {
          filetypes = {
            "css",
            "html",
            "sass",
            "scss",
            "less",
            "javascriptreact",
            "typescriptreact",
          },
        },
        dockerls = {},
        tsserver = {},
        terraformls = {},
        bashls = { filetypes = { "bash", "sh" } },
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
              format = {
                enable = false,
              },
            },
          },
        },
        docker_compose_language_service = {},

        -- tailwindcss = {},
        -- volar = {},
        -- nushell = {},
        -- phan = {},
        -- phpactor = {},
        -- clangd = {
        --     cmd = {
        --         "clangd",
        --         "--query-driver=/usr/bin/clang++",
        --         "--clang-tidy",
        --         "-j=5",
        --         "--malloc-trim",
        --         "--offset-encoding=utf-16",
        --     },
        --     filetypes = { "c", "cpp" }, -- we don't want objective-c and objective-cpp!
        -- },
        -- zls = {},
        -- rust_analyzer = {
        --     settings = {
        --         ["rust-analyzer"] = {
        --             check = {
        --                 command = "clippy",
        --                 features = "all",
        --             },
        --         },
        --     },
        -- },
        -- jedi_language_server = {},
      },
      -- you can do any additional lsp server setup here
      setup = {
        lua_ls = function(server, opts)
          require("lspconfig")[server].setup(opts)
        end,
        -- example to setup with typescript.nvim
        -- tsserver = function(_, opts)
        --   require("typescript").setup({ server = opts })
        -- end,
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

      local function setup(server, server_config)
        if opts.setup[server] then
          if opts.setup[server](server, server_config) then
            return
          end
        end
        require("lspconfig")[server].setup(server_config)
      end

      local servers = opts.servers
      local capabilities = require("cmp_nvim_lsp").default_capabilities(vim.lsp.protocol.make_client_capabilities())

      for server, _ in pairs(servers) do
        local server_config = vim.tbl_deep_extend("force", {
          capabilities = vim.deepcopy(capabilities),
          on_attach = on_attach,
        }, servers[server] or {})

        setup(server, server_config)
      end
    end,
  },

  -- mason to automate necessary formater, linters and lsp related tools
  {
    "williamboman/mason.nvim",
    cmd = "Mason",
    keys = { { "<leader>cm", "<cmd>Mason<cr>", desc = "Mason" } },
    build = ":MasonUpdate",
    dependencies = {
      "williamboman/mason-lspconfig.nvim",
      "WhoIsSethDaniel/mason-tool-installer.nvim",
    },
    config = function()
      -- import mason
      local mason = require("mason")

      -- import mason-lspconfig
      local mason_lspconfig = require("mason-lspconfig")

      local mason_tool_installer = require("mason-tool-installer")

      -- enable mason and configure icons
      mason.setup({
        PATH = "prepend",
        ui = {
          icons = {
            package_installed = "✓",
            package_pending = "➜",
            package_uninstalled = "✗",
          },
        },
      })

      mason_lspconfig.setup({
        -- list of servers for mason to install
        ensure_installed = {
          "tsserver",
          "emmet_ls",
          "pyright",
          "lua_ls",
          "bashls",
          "terraformls",
          "cssls",
          "html",
          "jsonls",
          "eslint",
          "yamlls",
          "dockerls",
          "docker_compose_language_service",
        },
        -- auto-install configured servers (with lspconfig)
        automatic_installation = true, -- not the same as ensure_installed
      })

      mason_tool_installer.setup({
        ensure_installed = {
          "shfmt", -- shell formatter
          "prettier", -- prettier formatter
          "stylua", -- lua formatter
          "isort", -- python formatter
          "black", -- python formatter
          "pylint", -- python linter
          "eslint_d", -- js linter
          "tflint", -- terraform linter
          "yamllint", -- yaml lister
          "cfn-lint", -- cloudformation linter
          "editorconfig-checker", -- editorconfig config checker
        },
      })
    end,
  },

  --  configure formatters
  {
    "stevearc/conform.nvim",
    lazy = true,
    event = { "BufReadPre", "BufNewFile" }, -- to disable, comment this out
    config = function()
      local conform = require("conform")

      conform.setup({
        formatters_by_ft = {
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
        },
        format_on_save = {
          lsp_fallback = true,
          async = false,
          timeout_ms = 1000,
        },
      })

      vim.keymap.set({ "n", "v" }, "<leader>mp", function()
        conform.format({
          lsp_fallback = true,
          async = false,
          timeout_ms = 1000,
        })
      end, { desc = "Format file or range (in visual mode)" })
    end,
  },
}
