local Util = require "nurrony.core.utils"

return {
  -- correctly setup lspconfig
  {
    "neovim/nvim-lspconfig",
    opts = {
      -- make sure mason installs the server
      servers = {
        tsserver = {
          settings = {
            completions = {
              completeFunctionCalls = true,
            },
          },
        },
      },

      setup = {
        tsserver = function()
          Util.on_attach(function(client, _)
            if client.name == "tsserver" then
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
        end
      }
    },
  },

  -- add debugger for javascript, node, chrome and typescript
  {
    "mfussenegger/nvim-dap",
    optional = true,
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
