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
}
