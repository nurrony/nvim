local Util = require("nurrony.core.utils")
local Config = require("nurrony.core.configs")

--TODO: use immediately invoked function expression for vimgrep_arguments .ie
--(fn()statement end)()
--HACK: move mappings from previous configuration here
--https://github.com/nvim-telescope/telescope.nvim/blob/master/lua/telescope/builtin/__files.lua
--HELP: telescope nvim
local function is_git_repo()
  local result = vim.fn.system("git rev-parse --is-inside-work-tree")
  if vim.v.shell_error == 0 and result:find("true") then
    return true
  else
    return false
  end
end

-- this will return a function that calls telescope.
-- for `files`, git_files or find_files will be chosen depending on .git
local telescope_builtin = function(builtin, opts)
  local params = { builtin = builtin, opts = opts or {} }

  return function()
    builtin = params.builtin
    opts = params.opts
    if builtin == "files" then
      if is_git_repo() then
        opts.show_untracked = true
        builtin = "git_files"
      else
        builtin = "find_files"
      end
      -- live_grep_from_project_git_root
      -- TODO: test with and without the `get_git_root`
    elseif builtin == "live_grep" then
      local function get_git_root()
        local dot_git_path = vim.fn.finddir(".git", ".;")
        return vim.fn.fnamemodify(dot_git_path, ":h")
      end

      if is_git_repo() then
        opts.cwd = get_git_root()
      end
    end
    require("telescope.builtin")[builtin](opts)
  end
end

return {
  -- fuzzy finder
  {
    "nvim-telescope/telescope.nvim",
    cmd = "Telescope",
    keys = {
      {
        "<leader>,",
        telescope_builtin("buffers", { show_all_buffers = true }),
        desc = "Switch Buffer",
      },
      {
        "<leader>fb",
        telescope_builtin("buffers", { sort_lastused = true }),
        desc = "Buffers",
      },
      {
        "<leader>:",
        telescope_builtin("command_history"),
        desc = "Command History",
      },
      -- find
      {
        "<leader><space>",
        telescope_builtin("files"),
        desc = "Find Files (root dir)",
      },
      {
        "<leader>ff",
        telescope_builtin("files"),
        desc = "Find Files (root dir)",
      },
      {
        "<leader>fr",
        telescope_builtin("oldfiles"),
        desc = "Recent",
      },
      -- git
      {
        "<leader>gc",
        telescope_builtin("git_commits"),
        desc = "commits",
      },
      {
        "<leader>gs",
        telescope_builtin("git_status"),
        desc = "status",
      },
      -- search
      {
        "<leader>sa",
        telescope_builtin("autocommands"),
        desc = "Auto Commands",
      },
      {
        "<leader>sb",
        telescope_builtin("current_buffer_fuzzy_find"),
        desc = "Buffer",
      },
      {
        "<leader>sc",
        telescope_builtin("command_history"),
        desc = "Command History",
      },
      {
        "<leader>sC",
        telescope_builtin("commands"),
        desc = "Commands",
      },
      {
        "<leader>/",
        telescope_builtin("live_grep"),
        desc = "Find in Files (Grep)",
      },
      {
        "<leader>sg",
        telescope_builtin("live_grep"),
        desc = "Grep (root dir)",
      },
      {
        "<leader>sh",
        telescope_builtin("help_tags"),
        desc = "Help Pages",
      },
      {
        "<leader>sH",
        telescope_builtin("highlights"),
        desc = "Search Highlight Groups",
      },
      {
        "<leader>sk",
        telescope_builtin("keymaps"),
        desc = "Key Maps",
      },
      {
        "<leader>sM",
        telescope_builtin("man_pages"),
        desc = "Man Pages",
      },
      {
        "<leader>sm",
        telescope_builtin("marks"),
        desc = "Jump to Mark",
      },
      {
        "<leader>so",
        telescope_builtin("vim_options"),
        desc = "Options",
      },
      {
        "<leader>sw",
        telescope_builtin("grep_string"),
        desc = "Word (root dir)",
      },
      {
        "<leader>uC",
        telescope_builtin("colorscheme", { enable_preview = true }),
        desc = "Colorscheme with preview",
      },
      {
        "<leader>ss",
        telescope_builtin("lsp_document_symbols"),
        desc = "List Symbols (current buffer)",
      },
      {
        "<leader>sS",
        telescope_builtin("lsp_workspace_symbols"),
        desc = "List Symbols (Workspace)",
      },
      {
        "<leader>sr",
        telescope_builtin("lsp_references"),
        desc = "List LSP references for word under the cursor",
      },
      {
        "<leader>R",
        telescope_builtin("resume"),
        desc = "Resume",
      },
      {
        "<leader>sd",
        telescope_builtin("diagnostics", { bufnr = 0 }),
        desc = "Lists Diagnostics for the current buffer",
      },
      {
        "<leader>sD",
        telescope_builtin("diagnostics"),
        desc = "Lists all Diagnostics for all open buffers",
      },
    },
    opts = function()
      local actions = require("telescope.actions")

      local open_with_trouble = function(...)
        return require("trouble.providers.telescope").open_with_trouble(...)
      end

      local open_selected_with_trouble = function(...)
        return require("trouble.providers.telescope").open_selected_with_trouble(...)
      end

      return {
        defaults = {
          prompt_prefix = " ",
          selection_caret = " ",
          file_ignore_patterns = {
            "%.jpg",
            "%.jpeg",
            "%.png",
            "%.otf",
            "%.ttf",
            "%.doc",
            "%.docx",
            "%.DS_Store",
            "%.git/",
            "%.mypy_cache/",
            "dist/",
            "build",
            "node_modules/",
            "site-packages/",
            "__pycache__/",
            "migrations/",
            "package-lock.json",
            "yarn.lock",
            "pnpm-lock.yaml",
          },
          -- open files in the first window that is an actual file.
          -- use the current window if no other window is available.
          get_selection_window = function()
            local wins = vim.api.nvim_list_wins()
            table.insert(wins, 1, vim.api.nvim_get_current_win())
            for _, win in ipairs(wins) do
              local buf = vim.api.nvim_win_get_buf(win)
              if vim.bo[buf].buftype == "" then
                return win
              end
            end
            return 0
          end,
          mappings = {
            i = {
              ["<c-t>"] = open_with_trouble,
              ["<a-t>"] = open_selected_with_trouble,
              ["<C-[>"] = actions.close,
              ["<a-i>"] = function()
                telescope_builtin("find_files", { no_ignore = true })()
              end,
              ["<a-h>"] = function()
                telescope_builtin("find_files", { hidden = true })()
              end,
              ["<C-Down>"] = function(...)
                return actions.cycle_history_next(...)
              end,
              ["<C-Up>"] = function(...)
                return actions.cycle_history_prev(...)
              end,
              ["<C-f>"] = function(...)
                return actions.preview_scrolling_down(...)
              end,
              ["<C-b>"] = function(...)
                return actions.preview_scrolling_up(...)
              end,
            },
            n = {
              ["q"] = function(...)
                return actions.close(...)
              end,
              ["<C-[>"] = actions.close,
            },
          },
          vimgrep_arguments = (function()
            if is_git_repo() then
              return {
                "git",
                "grep",
                "--full-name",
                "--line-number",
                "--column",
                "--extended-regexp",
                "--ignore-case",
                "--no-color",
                "--recursive",
                "--recurse-submodules",
                "-I",
              }
            else
              return {
                "grep",
                "--extended-regexp",
                "--color=never",
                "--with-filename",
                "--line-number",
                "-b", -- grep doesn't support a `--column` option :(
                "--ignore-case",
                "--recursive",
                "--no-messages",
                "--exclude-dir=*cache*",
                "--exclude-dir=*.git",
                "--exclude=.*",
                "--binary-files=without-match",
              }
            end
          end)(),
        },
        pickers = {
          find_files = {
            theme = "dropdown",
            previewer = false,
            hidden = true,
          },
          git_files = {
            theme = "dropdown",
            previewer = false,
            hidden = true,
          },
          oldfiles = {
            theme = "dropdown",
            previewer = false,
            hidden = true,
          },
          command_history = {
            theme = "dropdown",
            previewer = false,
            sort_lastused = true,
          },
          buffers = {
            theme = "dropdown",
            previewer = false,
            sort_mru = true,
            sort_lastused = true,
            ignore_current_buffer = true,
          },
        },
      }
    end,
  },
  -- Flash Telescope config
  {
    "nvim-telescope/telescope.nvim",
    optional = true,
    opts = function(_, opts)
      if not Util.has("flash.nvim") then
        return
      end
      local function flash(prompt_bufnr)
        require("flash").jump({
          pattern = "^",
          label = { after = { 0, 0 } },
          search = {
            mode = "search",
            exclude = {
              function(win)
                return vim.bo[vim.api.nvim_win_get_buf(win)].filetype ~= "TelescopeResults"
              end,
            },
          },
          action = function(match)
            local picker = require("telescope.actions.state").get_current_picker(prompt_bufnr)
            picker:set_selection(match.pos[1] - 1)
          end,
        })
      end
      opts.defaults = vim.tbl_deep_extend("force", opts.defaults or {}, {
        mappings = { n = { s = flash }, i = { ["<c-s>"] = flash } },
      })
    end,
  },
}
