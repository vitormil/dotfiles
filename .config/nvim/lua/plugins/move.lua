return {
  "fedepujol/move.nvim",
  config = function()
    require('move').setup({
      line = {
        enable = true, -- Enables line movement
        indent = true  -- Toggles indentation
      },
      block = {
        enable = true, -- Enables block movement
        indent = true  -- Toggles indentation
      },
      word = {
        enable = false,
      },
      char = {
        enable = false,
      }
    })

    local opts = { noremap = true, silent = true }

    vim.keymap.set('n', '<C-j>', ':MoveLine(1)<CR>', opts)
    vim.keymap.set('n', '<C-k>', ':MoveLine(-1)<CR>', opts)
    vim.keymap.set('v', '<C-j>', ':MoveBlock(1)<CR>', opts)
    vim.keymap.set('v', '<C-k>', ':MoveBlock(-1)<CR>', opts)
  end,
}
