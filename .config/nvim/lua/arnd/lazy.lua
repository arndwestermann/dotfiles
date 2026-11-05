local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

-- Ansible writes "minimal" here on servers. It lives outside ~/.config/nvim
-- because that is a symlink into the dotfiles checkout.
local profile = "full"
local profile_file = io.open(vim.fn.expand("~/.config/nvim-profile"))
if profile_file then
  profile = vim.trim(profile_file:read("*a"))
  profile_file:close()
end
local minimal = profile == "minimal"

-- import does not descend into subfolders, so dev/lsp needs its own entry.
local spec = { { import = "arnd.plugins" } }
if not minimal then
  vim.list_extend(spec, { { import = "arnd.plugins.dev" }, { import = "arnd.plugins.dev.lsp" } })
end

require("lazy").setup(spec, {
  -- lazy drops plugins it did not load from the lockfile. In the repo's copy
  -- that would leave the checkout dirty, and the dotfiles role's git task
  -- refuses to pull over local modifications.
  lockfile = minimal and vim.fn.stdpath("state") .. "/lazy-lock.json" or nil,
  checker = {
    enabled = true,
    notify = false,
  },
  change_detection = {
    notify = false
  }
})
