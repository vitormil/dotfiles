-- https://github.com/leath-dub/snipe.nvim
return {
  "vitormil/snipe.nvim",
  config = function()
    local snipe = require("snipe")
    snipe.setup({
      hints = {
        -- Charaters to use for hints
        -- make sure they don't collide with the navigation keymaps
        -- If you remove `j` and `k` from below, you can navigate in the plugin
        -- dictionary = "sadflewcmpghio",
        dictionary = "asfghl;wertyuiop",
      },
      navigate = {
        cancel_snipe = "q",
        close_buffer = "d",
      },
      sort = "default",
    })

    vim.keymap.set(
      "n",
      "[w",
      snipe.create_buffer_menu_toggler({
        -- Limit the width of path buffer names
        max_path_width = 1,
      }),
      { desc = "[P]Snipe" }
    )
  end,
}
