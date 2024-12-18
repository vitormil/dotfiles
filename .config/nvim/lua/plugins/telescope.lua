-- Telescope
-- https://github.com/nvim-telescope/telescope.nvim
return {
  {
    'nvim-telescope/telescope.nvim',
    dependencies = {
      'nvim-lua/plenary.nvim',
      'smartpde/telescope-recent-files',
    },
    config = function ()
      local builtin = require('telescope.builtin')
      local previewers = require("telescope.previewers")

      vim.keymap.set('n', '<leader>ff', builtin.find_files, { desc = 'Telescope find files' })
      vim.keymap.set('n', '<leader>fg', builtin.live_grep, { desc = 'Telescope live grep' })
      vim.keymap.set('n', '<leader>fb', builtin.buffers, { desc = 'Telescope buffers' })
      vim.keymap.set('n', '<leader>fh', builtin.help_tags, { desc = 'Telescope help tags' })

      vim.keymap.set('n', '<C-p>', builtin.find_files, { desc = 'Telescope find files' })

      vim.api.nvim_set_keymap('n', '<Leader>fF', ':lua require"telescope.builtin".find_files({ hidden = true })<CR>', {noremap = true, silent = true})

      vim.api.nvim_set_keymap("n", "<Leader>rf",
        [[<cmd>lua require('telescope').extensions.recent_files.pick()<CR>]],
        {noremap = true, silent = true})

    end,
  },
  {
    'nvim-telescope/telescope-ui-select.nvim',
    config = function ()
      require("telescope").setup {
        extensions = {
          ["ui-select"] = {
            require("telescope.themes").get_dropdown {
            }
          }
        }
      }
      require("telescope").load_extension("ui-select")
    end
  }
}
