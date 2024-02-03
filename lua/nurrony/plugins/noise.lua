
return {
  "folke/noice.nvim",
  event = "VeryLazy",
  dependencies = {
    'stevearc/dressing.nvim',
    {
      "rcarriga/nvim-notify",
      lazy = true,
      keys = {
        {
          "<leader>un",
          function()
              require("notify").dismiss({ silent = true, pending = true })
          end,
          desc = "Clear notifications",
        },
      },
      opts = { timeout = 3000 },
    },
  },
  opts = {
    lsp = {
      progress = {
        enabled = true,
        -- Lsp Progress is formatted using the builtins for lsp_progress. See config.format.builtin
        -- See the section on formatting for more details on how to customize.
        --- @type NoiceFormat|string
        format = "lsp_progress",
        --- @type NoiceFormat|string
        format_done = "lsp_progress_done",
        throttle = 1000 / 30, -- frequency to update lsp progress message
        view = "mini",
      },
      override = {
        -- override the default lsp markdown formatter with Noice
        ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
        -- override the lsp markdown formatter with Noice
        ["vim.lsp.util.stylize_markdown"] = true,
        -- override cmp documentation with Noice (needs the other options to work)
        ["cmp.entry.get_documentation"] = true,
      },
      --NOTE: install parsers for markdown and markdown_inline to see markdown documentation
      hover = {
        enabled = true,
      },
      signature = {
        enabled = false,
      },
      message = {
        enabled = true, -- Messages shown by lsp servers
      },
    },
    health = {
      checker = false, -- Disable if you don't want health checks to run
    },
    presets = {
      -- you can enable a preset by setting it to true, or a table that will override the preset config
      -- you can also add custom presets that you can enable/disable with enabled=true
      bottom_search = false, -- use a classic bottom cmdline for search
      command_palette = true, -- position the cmdline and popupmenu together
      long_message_to_split = false, -- long messages will be sent to a split
      inc_rename = false, -- enables an input dialog for inc-rename.nvim
      lsp_doc_border = false, -- add a border to hover docs and signature help
    },
  },
}
