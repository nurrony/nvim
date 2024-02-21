return {
  -- snippets
  {
    "L3MON4D3/LuaSnip",
    lazy = true,
    dependencies = {
      { "saadparwaiz1/cmp_luasnip", lazy = true }, -- luasnip completion source for nvim-cmp
      {
        "rafamadriz/friendly-snippets",
        lazy = true,
        config = function()
          require("luasnip.loaders.from_vscode").lazy_load()
        end,
      },
    },
  },
  -- completion engine
  {
    "hrsh7th/nvim-cmp",
    event = { "BufReadPost", "BufNewFile" }, -- load cmp
    -- these dependencies will only be loaded when cmp loads
    -- dependencies are always lazy-loaded unless specified otherwise
    dependencies = {
      -- Autocompletion plugin
      -- Completion Sources --
      { "hrsh7th/cmp-path", lazy = true }, -- nvim-cmp source for path
      { "hrsh7th/cmp-buffer", lazy = true }, -- nvim-cmp source for buffer words
      { "hrsh7th/cmp-cmdline", lazy = true }, --nvim-cmp source for vim's cmdline.
      { "hrsh7th/cmp-nvim-lsp", lazy = true }, -- nvim-cmp source for neovim builtin LSP client
      { "hrsh7th/cmp-nvim-lua", lazy = true }, -- nvim-cmp source for nvim lua
      { "onsails/lspkind.nvim", lazy = true }, -- vs-code like pictograms
      -- { "hrsh7th/cmp-emoji", lazy = true }, -- nvim-cmp source for emoji
    },
    opts = function()
      local has_words_before = function()
        local line, col = unpack(vim.api.nvim_win_get_cursor(0))
        return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
      end

      local cmp = require("cmp")
      local luasnip = require("luasnip")
      local lspkind = require("lspkind")
      local diagnostics_options = require("nurrony.core.defaults").diagnostics_options

      return {
        snippet = {
          expand = function(args)
            -- For `luasnip` user.
            luasnip.lsp_expand(args.body)
          end,
        },
        window = {
          completion = {
            scrollbar = true,
            border = diagnostics_options.float.border,
            winhighlight = "FloatBorder:None,CursorLine:PmenuSel,Normal:None,Search:None,ScrollbarHandle:None",
          },
          documentation = {
            scrollbar = false,
            border = diagnostics_options.float.border,
            max_height = diagnostics_options.float.max_height,
            winhighlight = "FloatBorder:None,CursorLine:PmenuSel,Normal:None,Search:None",
          },
        },
        formatting = {
          expandable_indicator = true,
          format = lspkind.cmp_format({
            maxwidth = 50,
            mode = "symbol_text",
            ellipsis_char = "...",
            symbol_map = {
              Copilot = "",
            },
          }),
        },
        mapping = cmp.mapping.preset.insert({
          ["<C-u>"] = cmp.mapping.scroll_docs(4), -- scroll up preview
          ["<C-d>"] = cmp.mapping.scroll_docs(-4), -- scroll down preview
          ["<C-Space>"] = cmp.mapping.complete({ TriggerOnly = "triggerOnly" }),
          ["<C-e>"] = cmp.mapping({ i = cmp.mapping.abort(), c = cmp.mapping.close() }),
          ["<CR>"] = cmp.mapping.confirm({ select = true }),
          ["<Tab>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
              cmp.select_next_item()
            elseif luasnip.expand_or_jumpable() then
              luasnip.expand_or_jump()
            elseif has_words_before() then
              cmp.complete()
            else
              -- The fallback function sends a already mapped key. In this case, it's probably `<Tab>`.
              fallback()
            end
          end, { "i", "s" }),
          ["<S-Tab>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
              cmp.select_prev_item()
            elseif luasnip.jumpable(-1) then
              luasnip.jump(-1)
            else
              fallback()
            end
          end, { "i", "s" }),
        }),
        sources = cmp.config.sources({
          { name = "nvim_lua" },
          { name = "nvim_lsp" }, -- lsp
          { name = "path", max_item_count = 3 }, -- file system path
          { name = "buffer", max_item_count = 5 }, -- text within current buffer
          { name = "luasnip", max_item_count = 3 }, -- snippets
          -- { name = "emoji" },
          -- { name = "neorg" },
        }),
        -- experimental = {
        --   ghost_text = true,
        -- },
      }
    end,
    config = function(_, opts)
      local cmp = require("cmp")
      cmp.setup(opts)

      -- Use buffer source for `/` and `?` (if you enabled `native_menu`, this won't work anymore).
      cmp.setup.cmdline({ "/", "?" }, {
        mapping = cmp.mapping.preset.cmdline(),
        sources = {
          { name = "buffer" },
        },
      })

      -- Use cmdline & path source for ':' (if you enabled `native_menu`, this won't work anymore).
      cmp.setup.cmdline(":", {
        mapping = cmp.mapping.preset.cmdline(),
        sources = {
          { name = "path" },
          { name = "cmdline" },
        },
      })
    end,
  },
}
