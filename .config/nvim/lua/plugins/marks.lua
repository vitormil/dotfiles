return {
  "chentoast/marks.nvim",
  event = "VeryLazy",
  opts = {},
  config = function()
    require'marks'.setup {
      default_mappings = false,
      mappings = {
        toggle = "mm",
        next = "]a",
        prev = false -- pass false to disable only this default mapping
      }
    }

    vim.keymap.set("n", "ml", ":MarksListAll<CR>", { desc = "[Marks] List" })
  end,
}
