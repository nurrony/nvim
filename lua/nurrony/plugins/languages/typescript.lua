local Util = require("nurrony.core.utils")

return {

  -- npm package
  {
    "vuki656/package-info.nvim",
    opts = {},
    lazy = true,
    ft = "json",
    config = function(_, opts)
      require('package-info').setup(opts)
    end,
    keys = {
      { "<leader>cnd", "<cmd>lua require('package-info').delete()<cr>",         desc = "Remove NPM Package" },
      { "<leader>cni", "<cmd>lua require('package-info').install()<cr>",        desc = "Install npm package" },
      { "<leader>cnc", "<cmd>lua require('package-info').change_version()<cr>", desc = "Change NPM Package" },
      { "<leader>cnt", "<cmd>lua require('package-info').toggle()<cr>",         desc = "Toggle NPM package versions" },
    },
  },

  -- add typescript to treesitter
  {
    "nvim-treesitter/nvim-treesitter",
    opts = function(_, opts)
      if type(opts.ensure_installed) == "table" then
        vim.list_extend(opts.ensure_installed, { "typescript", "tsx", "javascript" })
      end
    end,
  },

  -- correctly setup lspconfig
  {
    "neovim/nvim-lspconfig",
    dependencies = {
      {
        "williamboman/mason.nvim",
        opts = function(_, opts)
          opts.ensure_installed = opts.ensure_installed or {}
          table.insert(opts.ensure_installed, "typescript-language-server")
        end,
      },
    },
    opts = {
      -- make sure mason installs the server
      servers = {
        tsserver = {
          settings = {
            completions = {
              completeFunctionCalls = true,
            },
            -- specify some or all of the following settings if you want to adjust the default behavior
            javascript = {
              inlayHints = {
                includeInlayEnumMemberValueHints = true,
                includeInlayFunctionLikeReturnTypeHints = true,
                includeInlayFunctionParameterTypeHints = true,
                includeInlayParameterNameHints = "all", -- 'none' | 'literals' | 'all';
                includeInlayParameterNameHintsWhenArgumentMatchesName = true,
                includeInlayPropertyDeclarationTypeHints = true,
                includeInlayVariableTypeHints = true,
              },
            },
            typescript = {
              inlayHints = {
                includeInlayEnumMemberValueHints = true,
                includeInlayFunctionLikeReturnTypeHints = true,
                includeInlayFunctionParameterTypeHints = true,
                includeInlayParameterNameHints = "all", -- 'none' | 'literals' | 'all';
                includeInlayParameterNameHintsWhenArgumentMatchesName = true,
                includeInlayPropertyDeclarationTypeHints = true,
                includeInlayVariableTypeHints = true,
              },
            },
          },
        },
      },

      setup = {
        tsserver = function()
          Util.on_attach(function(client, _)
            if client.name == "tsserver" then
              -- update capabilities
              client.server_capabilities.documentFormattingProvider = false

              -- organize imports
              Util.map({ "n", "v" }, "<leader>co", function()
                vim.lsp.buf.code_action({
                  apply = true,
                  context = {
                    only = { "source.organizeImports.ts" },
                    diagnostics = {},
                  },
                })
              end, { noremap = true, silent = true }, "Organize Imports")

              -- remove unused imports
              Util.map({ "n", "v" }, "<leader>cR", function()
                vim.lsp.buf.code_action({
                  apply = true,
                  context = {
                    only = { "source.removeUnused.ts" },
                    diagnostics = {},
                  },
                })
              end, { noremap = true, silent = true }, "Remove Unused Imports")
            end
          end)
        end,
      },
    },
  },

  -- configure linter
  {
    "mfussenegger/nvim-lint",
    optional = true,
    dependencies = {
      -- make sure mason installs the linter
      {
        "williamboman/mason.nvim",
        opts = function(_, opts)
          opts.ensure_installed = opts.ensure_installed or {}
          table.insert(opts.ensure_installed, "eslint_d")
        end,
      },
    },
    opts = {
      linters_by_ft = {
        -- svelte = { "eslint_d" },
        javascript = { "eslint_d" },
        typescript = { "eslint_d" },
        javascriptreact = { "eslint_d" },
        typescriptreact = { "eslint_d" },
      },
    },
  },

  -- configure formatters
  {
    "stevearc/conform.nvim",
    dependencies = {
      -- make sure mason installs the formatters
      {
        "williamboman/mason.nvim",
        opts = function(_, opts)
          opts.ensure_installed = opts.ensure_installed or {}
          table.insert(opts.ensure_installed, "prettier")
        end,
      },
    },
    optional = true,
    opts = {
      formatters_by_ft = {
        -- svelte = { "prettier" },
        javascript = { "prettier" },
        typescript = { "prettier" },
        javascriptreact = { "prettier" },
        typescriptreact = { "prettier" },
      },
    },
  },

  -- add debugger for javascript, node, chrome and typescript
  {
    "mfussenegger/nvim-dap",
    optional = true,
    dependencies = {
      -- make sure mason installs the debugger
      {
        "williamboman/mason.nvim",
        opts = function(_, opts)
          opts.ensure_installed = opts.ensure_installed or {}
          table.insert(opts.ensure_installed, "js-debug-adapter")
        end,
      },
    },
    opts = function()
      local dap = require("dap")
      if not dap.adapters["pwa-node"] then
        require("dap").adapters["pwa-node"] = {
          type = "server",
          host = "localhost",
          port = "${port}",
          executable = {
            command = "node",
            -- 💀 Make sure to update this path to point to your installation
            args = {
              require("mason-registry").get_package("js-debug-adapter"):get_install_path()
              .. "/js-debug/src/dapDebugServer.js",
              "${port}",
            },
          },
        }
      end

      for _, language in ipairs({ "typescript", "javascript", "typescriptreact", "javascriptreact" }) do
        if not dap.configurations[language] then
          dap.configurations[language] = {
            {
              type = "pwa-node",
              request = "launch",
              name = "Launch file",
              program = "${file}",
              cwd = "${workspaceFolder}",
            },
            {
              type = "pwa-node",
              request = "attach",
              name = "Attach",
              processId = require("dap.utils").pick_process,
              cwd = "${workspaceFolder}",
            },
          }
        end
      end
    end,
  },
}
