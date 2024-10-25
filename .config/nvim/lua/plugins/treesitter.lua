-- Treesitter
-- https://github.com/nvim-treesitter/nvim-treesitter
return {
  "nvim-treesitter/nvim-treesitter",
  build = ":TSUpdate",
  dependencies = {
    "andreshazard/vim-freemarker",
  },
  config = function()
    local configs = require("nvim-treesitter.configs")
    configs.setup({
      ensure_installed = { "c", "lua", "vim", "vimdoc", "query", "ruby", "heex", "javascript", "html" },
      auto_install = true,
      sync_install = false,
      highlight = { enable = true },
      indent = { enable = true },
    })
  end,
}
