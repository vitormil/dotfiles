return {
  "arnamak/stay-centered.nvim",
  config = function()
    require("stay-centered").setup({
      enabled = false,
    })
    vim.keymap.set({ 'n', 'v' }, '<leader>sc', require('stay-centered').toggle, { desc = 'Toggle stay-centered.nvim' })
  end,
}
