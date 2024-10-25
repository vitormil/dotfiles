-- Catppuccin
-- https://github.com/catppuccin/nvim
return {
  "catppuccin/nvim",
  enabled = true,
  name = "catppuccin",
  priority = 1000,
  config = function()
    require("catppuccin").setup {
        custom_highlights = function(colors)
            return {
                -- change current line color
                -- CursorLine = { bg = colors.bg_highlight },
                CursorLineNr = { fg = '#ffeb95' },
                NonText = { fg = '#333543' },
                Whitespace = { fg = '#333543' },
            }
        end
    }

    vim.cmd.colorscheme("catppuccin")
  end,
}
