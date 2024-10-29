-- Catppuccin
-- https://github.com/catppuccin/nvim
return {
  "catppuccin/nvim",
  enabled = true,
  name = "catppuccin",
  priority = 1000,
  config = function()
    require("catppuccin").setup {
      flavour = "mocha", -- latte, frappe, macchiato,
      custom_highlights = function(colors)
            return {
                CursorLineNr = { fg = '#F9E2AF' },
                NonText = { fg = '#333543' },
                Whitespace = { fg = '#333543' },
                IncSearch = { fg = '#333543', bg = '#FFDE7A' },
                Search = { fg = '#333543', bg = '#F9E2AF' },
            }
      end,
      color_overrides = {
        mocha = {
        },
      }
    }

    vim.cmd.colorscheme("catppuccin")
  end,
}
