-- Catppuccin
-- https://github.com/catppuccin/nvim
return {
  "catppuccin/nvim",
  name = "catppuccin",
  priority = 1000,
  config = function()
    vim.api.nvim_set_hl(0, "CursorLineNr", { fg = "yellow" })
    vim.api.nvim_set_hl(0, "LineNr", { fg = "yellow" })
    vim.cmd.colorscheme("catppuccin")
  end,
}
