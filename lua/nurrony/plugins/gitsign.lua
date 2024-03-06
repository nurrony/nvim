local Configs = require("nurrony.core.configs")
return {
  -- git signs
  {
    "lewis6991/gitsigns.nvim",
    event = { "BufReadPre", "BufNewFile" },
    enabled = vim.fn.executable "git" == 1,
    opts = {
      worktrees = vim.g.git_worktrees,
      signs = Configs.icons.git,
      signcolumn = true,         -- Toggle with `:Gitsigns toggle_signs`
      numhl = false,             -- Toggle with `:Gitsigns toggle_numhl`
      linehl = false,            -- Toggle with `:Gitsigns toggle_linehl`
      word_diff = false,         -- Toggle with `:Gitsigns toggle_word_diff`
      current_line_blame = true, -- Toggle with `:Gitsigns toggle_current_line_blame`
      -- Options passed to nvim_open_win
      preview_config = {
        border = Configs.diagnostics_options.float.border,
        style = "minimal",
        relative = "cursor",
        row = 0,
        col = 1,
      },
      --disable gitsigns using trouble for :Gitsigns setqflist or
      --:Gitsigns seqloclist by default if installed
      trouble = false,
      on_attach = function(bufnr)
        local gs = package.loaded.gitsigns

        local function map(mode, l, r, opts)
          opts = opts and vim.tbl_extend("force", opts, { buffer = bufnr }) or {}
          vim.keymap.set(mode, l, r, opts)
        end

        -- Navigation
        map("n", "]h", function()
          if vim.wo.diff then
            return "]c"
          end
          vim.schedule(function()
            gs.next_hunk()
          end)
          return "<Ignore>"
        end, { expr = true, desc = "next hunk" })

        map("n", "[h", function()
          if vim.wo.diff then
            return "[c"
          end
          vim.schedule(function()
            gs.prev_hunk()
          end)
          return "<Ignore>"
        end, { expr = true, desc = "previous hunk" })

        -- Actions
        map("n", "<leader>ghs", gs.stage_hunk, { desc = "stage hunks" })

        map("v", "<leader>ghs", function()
          gs.stage_hunk({ vim.fn.line("."), vim.fn.line("v") })
        end, { desc = "stage hunks" })

        map("n", "<leader>ghr", gs.reset_hunk, { desc = "reset hunks" })

        map("v", "<leader>ghr", function()
          gs.reset_hunk({ vim.fn.line("."), vim.fn.line("v") })
        end, { desc = "reset hunks" })

        map("n", "<leader>ghS", function()
          gs.stage_buffer()
        end, { desc = "stage buffer" })

        map("n", "<leader>ghu", function()
          gs.undo_stage_hunk()
        end, { desc = "unstage hunk" })

        map("n", "<leader>ghR", function()
          gs.reset_buffer()
        end, { desc = "reset buffer" })

        map("n", "<leader>ghp", function()
          gs.preview_hunk()
        end, { desc = "preview hunk" })

        map("n", "<leader>ghb", function()
          gs.blame_line({ full = true })
        end, { desc = "blame line" })

        map("n", "<leader>gtb", function()
          gs.toggle_current_line_blame()
        end, { desc = "toggle line blame" })

        map("n", "<leader>ghd", function()
          gs.diffthis()
        end, { desc = "diff this" })

        map("n", "<leader>ghD", function()
          gs.diffthis("~")
        end, { desc = "diff entire buffer" })

        map("n", "<leader>gtd", function()
          gs.toggle_deleted()
        end, { desc = "toggle deleted" })

        -- Text object
        map({ "o", "x" }, "ih", "<cmd><C-U>Gitsigns select_hunk<CR>", { desc = "select hunks" })
      end,
    },
  },
}
