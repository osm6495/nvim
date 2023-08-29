for _, source in ipairs {
  "astronvim.bootstrap",
  "astronvim.options",
  "astronvim.lazy",
  "astronvim.autocmds",
  "astronvim.mappings",
} do
  local status_ok, fault = pcall(require, source)
  if not status_ok then vim.api.nvim_err_writeln("Failed to load " .. source .. "\n\n" .. fault) end
end

if astronvim.default_colorscheme then
  if not pcall(vim.cmd.colorscheme, astronvim.default_colorscheme) then
    require("astronvim.utils").notify(
      "Error setting up colorscheme: " .. astronvim.default_colorscheme,
      vim.log.levels.ERROR
    )
  end
end

local uname = vim.loop.os_uname()
_G.OS = uname.sysname
_G.IS_LINUX = OS == 'Linux'
_G.IS_WSL = IS_LINUX and uname.release:find 'Microsoft' and true or false

if IS_WSL then
  vim.g.clipboard = {
      name = 'WslClipboard',
      copy = {
          ['+'] = 'clip.exe',
          ['*'] = 'clip.exe',
      },
      paste = {
          ['+'] = 'powershell.exe -c [Console]::Out.Write($(Get-Clipboard -Raw).tostring():gsub("\\r", ""))',
          ['*'] = 'powershell.exe -c [Console]::Out.Write($(Get-Clipboard -Raw).tostring():gsub("\\r", ""))',
      },
      cache_enabled = 0,
  }
end

require("astronvim.utils").conditional_func(astronvim.user_opts("polish", nil, false), true)
