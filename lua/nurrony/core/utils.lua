local M = {}

function _G.dump(...)
  vim.print(...)
end

function M.reload_all()
  for name, _ in pairs(package.loaded) do
    if
        name:match("^lazy")
        or name:match("^mapping")
        or name:match("^plugrc")
        or name:match("^ui")
        or name:match("^editor")
        or name:match("^plugins")
        or name:match("^syntax")
        or name:match("^terminal")
        or name:match("^utils")
    then
      package.loaded[name] = nil
    end
  end

  dofile(vim.env.MYVIMRC)
end

function M.reload_one(module)
  for name, _ in pairs(package.loaded) do
    if name:match("^" .. module) then
      package.loaded[name] = nil
      require(name)
      return
    end
  end
end

--{ "git", "rg", { "fd", "fdfind" }, "lazygit" }
M.check_if_cmd_exist = function(cmds)
  local result = {}
  for _, cmd in ipairs(cmds) do
    local name = type(cmd) == "string" and cmd or vim.inspect(cmd)
    local commands = type(cmd) == "string" and { cmd } or cmd
    ---@cast commands string[]
    local found = false
    for _, c in ipairs(commands) do
      if vim.fn.executable(c) == 1 then
        name = c
        found = true
      end
      result[name] = { found }
    end
  end
  return result
end

---@param editor_variable? {global: boolean}
---@param values? {[1]:any, [2]:any}
---@param option string
function M.toggle(option, editor_variable, values)
  if values then
    if not editor_variable then
      if vim.deep_equal(vim.opt_local[option]:get(), values[1]) then
        vim.opt_local[option] = values[2]
      else
        vim.opt_local[option] = values[1]
      end
      vim.notify(
        "set editor option " .. option .. " to " .. tostring(vim.opt_local[option]:get()),
        vim.log.levels.INFO,
        { title = "toggle editor option" }
      )
    else
      if not editor_variable.global then
        local bufnr = vim.api.nvim_get_current_buf()
        if vim.b[bufnr][option] == values[1] then
          vim.b[bufnr][option] = values[2]
        else
          --if option is unset or nil
          vim.b[bufnr][option] = values[1]
        end
        --:h debug.getinfo() or lua_getinfo() to get information about a function
        vim.notify("set option " .. option .. " to " .. tostring(vim.b[bufnr][option]), vim.log.levels.INFO, {
          title = "toggle local option",
        })
      else
        if vim.g[option] == values[1] then
          vim.g[option] = values[2]
        else
          --if option is unset or nil
          vim.g[option] = values[1]
        end
        vim.notify("set global option " .. option .. " to " .. tostring(vim.g[option]), vim.log.levels.INFO, {
          title = "toggle global option",
        })
      end
    end
  else
    if not editor_variable then
      vim.opt_local[option] = not vim.opt_local[option]:get()
      vim.notify(
        "set editor option " .. option .. " to " .. tostring(vim.opt_local[option]:get()),
        vim.log.levels.INFO,
        {
          title = "toggle editor option",
        }
      )
    else
      if not editor_variable.global then
        local bufnr = vim.api.nvim_get_current_buf()
        vim.b[bufnr][option] = not vim.b[bufnr][option] and true or false
        vim.notify("set option " .. option .. " to " .. tostring(vim.b[bufnr][option]), vim.log.levels.INFO, {
          title = "toggle local option",
        })
      else
        vim.g[option] = not vim.g[option]
        vim.notify("set global option " .. option .. " to " .. tostring(vim.g[option]), vim.log.levels.INFO, {
          title = "toggle global option",
        })
      end
    end
  end
end

---@param fn fun()
function M.on_very_lazy(fn)
  vim.api.nvim_create_autocmd("User", {
    group = vim.api.nvim_create_augroup("Lazy", { clear = true }),
    pattern = "VeryLazy",
    callback = function()
      fn()
    end,
  })
end

---@param modules string[]
--modules like "autocmds" | "options" | "keymaps"
M.lazy_load = function(modules)
  -- when no file is opened at startup
  if vim.fn.argc(-1) == 0 then
    -- autocmds and keymaps can wait to load
    -- always load lazyvim, then user file
    M.on_very_lazy(function()
      for i = 1, #modules do
        require(modules[i])
      end
    end)
  else
    -- load them now so they affect the opened buffers
    for i = 1, #modules do
      require(modules[i])
    end
  end
end

---@param on_attach fun(client, bufnr)
function M.on_attach(on_attach)
  vim.api.nvim_create_autocmd("LspAttach", {
    callback = function(args)
      local bufnr = args.buf
      local client = vim.lsp.get_client_by_id(args.data.client_id)
      on_attach(client, bufnr)
    end,
  })
end

---@param plugin string
function M.has(plugin)
  if package.loaded["lazy"] then
    return require("lazy.core.config").plugins[plugin] ~= nil
  else
    local plugin_name = vim.split(plugin, ".", { plain = true, trimempty = true })
    return package.loaded[plugin_name[1]] ~= nil
  end
end

---@param description? string
---@param opt table
local function mdesc(opt, description)
  return vim.tbl_extend("force", opt, { desc = description })
end

-- Wrapper around vim.keymap.set that will
-- not create a keymap if a lazy key handler exists.
-- It will also set `silent` to true by default.
function M.map(modes, keyset, cmd, opts, desc)
  opts = opts or {}
  opts = mdesc(opts, desc)
  opts.silent = opts.silent ~= false
  if opts.remap and not vim.g.vscode then
    opts.remap = nil
  end
  vim.keymap.set(modes, keyset, cmd, opts)
end

M.augroup = function(name)
  return vim.api.nvim_create_augroup("nmr_" .. name, { clear = true })
end

function M.foldTextFormatter(virtText, lnum, endLnum, width, truncate)
  local hlgroup = "NonText"
  local newVirtText = {}
  local suffix = "  " .. tostring(endLnum - lnum)
  local sufWidth = vim.fn.strdisplaywidth(suffix)
  local targetWidth = width - sufWidth
  local curWidth = 0
  for _, chunk in ipairs(virtText) do
    local chunkText = chunk[1]
    local chunkWidth = vim.fn.strdisplaywidth(chunkText)
    if targetWidth > curWidth + chunkWidth then
      table.insert(newVirtText, chunk)
    else
      chunkText = truncate(chunkText, targetWidth - curWidth)
      local hlGroup = chunk[2]
      table.insert(newVirtText, { chunkText, hlGroup })
      chunkWidth = vim.fn.strdisplaywidth(chunkText)
      if curWidth + chunkWidth < targetWidth then
        suffix = suffix .. (" "):rep(targetWidth - curWidth - chunkWidth)
      end
      break
    end
    curWidth = curWidth + chunkWidth
  end
  table.insert(newVirtText, { suffix, hlgroup })
  return newVirtText
end

--- format folding text
---@param virtText table
---@param lnum number
---@param endLnum number
---@param width number
---@param truncate any
---@return table
function M.fold_text_formatter(virtText, lnum, endLnum, width, truncate)
  local newVirtText = {}
  local hlgroup = "NonText"
  local suffix = ("  %d "):format(endLnum - lnum) -- 󰁂
  local sufWidth = vim.fn.strdisplaywidth(suffix)
  local targetWidth = width - sufWidth
  local curWidth = 0
  for _, chunk in ipairs(virtText) do
    local chunkText = chunk[1]
    local chunkWidth = vim.fn.strdisplaywidth(chunkText)
    if targetWidth > curWidth + chunkWidth then
      table.insert(newVirtText, chunk)
    else
      chunkText = truncate(chunkText, targetWidth - curWidth)
      local hlGroup = chunk[2]
      table.insert(newVirtText, { chunkText, hlGroup })
      chunkWidth = vim.fn.strdisplaywidth(chunkText)
      -- str width returned from truncate() may less than 2nd argument, need padding
      if curWidth + chunkWidth < targetWidth then
        suffix = suffix .. (" "):rep(targetWidth - curWidth - chunkWidth)
      end
      break
    end
    curWidth = curWidth + chunkWidth
  end
  table.insert(newVirtText, { suffix, hlgroup })
  return newVirtText
end

--- navigate through diagnostic
---@param next boolean
---@param severity string | nil
function M.diagnostic_goto(next, severity)
  local go = next and vim.diagnostic.goto_next or vim.diagnostic.goto_prev
  severity = severity and vim.diagnostic.severity[severity] or nil
  return function()
    go({ severity = severity })
  end
end

---@param name string
function M.opts(name)
  local plugin = require("lazy.core.config").plugins[name]
  if not plugin then
    return {}
  end
  local Plugin = require("lazy.core.plugin")
  return Plugin.values(plugin, "opts", false)
end

return M
