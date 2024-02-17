local float = require("nurrony.core.defaults").diagnostics_options.float

return {
  {
    "neovim/nvim-lspconfig",
    event = { "BufReadPre", "BufNewFile" },
    dependencies = {
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
    },
    opts = {
      -- LSP Server Settings
      servers = {
        -- cssls = {},
        -- html = {},
        -- jsonls = {},
        -- tailwindcss = {},
        tsserver = {
          -- cmd = {
          --   os.getenv("HOME") .. "/.local/share/nvim/mason/bin/typescript-language-server",
          --   "--stdio"
          -- },
          settings = {
            completions = {
              completeFunctionCalls = true,
            },
          },
        },
        -- volar = {},
        -- bashls = {
        --     filetypes = { "bash", "sh" },
        -- },
        lua_ls = {
          -- cmd = {
          --   os.getenv("HOME") .. "/.local/share/nvim/mason/bin/lua-language-server",
          -- },
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
      local capabilities =
          require("cmp_nvim_lsp").default_capabilities(vim.lsp.protocol.make_client_capabilities())

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

  -- install lsp tools and lsp servers
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
          -- "html",
          -- "cssls",
          -- "tailwindcss",
          -- "svelte",
          "lua_ls",
          -- "graphql",
          -- "emmet_ls",
          -- "prismals",
          -- "pyright",
        },
        -- auto-install configured servers (with lspconfig)
        automatic_installation = true, -- not the same as ensure_installed
      })

      mason_tool_installer.setup({
        ensure_installed = {
          "prettier", -- prettier formatter
          "stylua",   -- lua formatter
          -- "isort",    -- python formatter
          -- "black",    -- python formatter
          -- "pylint",   -- python linter
          "eslint_d", -- js linter
        },
      })
    end,
  },


  -- Format
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
          timeout_ms = 500,
        },
      })
    end,
  },
}
