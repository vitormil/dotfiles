return {
  {
    "tpope/vim-fugitive",
  },
  {
    "lewis6991/gitsigns.nvim",
    config = function()
      require("gitsigns").setup {
        current_line_blame = true,
        current_line_blame_opts = {
          virt_text = true,
          virt_text_pos = 'right_align', -- 'eol' | 'overlay' | 'right_align'
          delay = 0,
          ignore_whitespace = true,
          virt_text_priority = 100,
          use_focus = true,
        },
        preview_config = {
          border = "single",
          style = "minimal",
          relative = "cursor",
          row = 0,
          col = 1,
        },
      }

      vim.keymap.set("n", "[g", ":Gitsigns prev_hunk<CR>:Gitsigns preview_hunk_inline<CR>", { desc = "Previous Hunk" })
      vim.keymap.set("n", "]g", ":Gitsigns next_hunk<CR>:Gitsigns preview_hunk_inline<CR>", { desc = "Next Hunk" })

      vim.keymap.set("n", "<leader>gd", ":Gitsigns reset_hunk<CR>", { desc = "Git discard hunk" })
      vim.keymap.set("n", "<leader>gb", ":Gitsigns toggle_current_line_blame<CR>", {})
    end,
  },
}
