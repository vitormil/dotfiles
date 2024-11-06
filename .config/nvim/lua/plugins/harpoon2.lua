return {
  "ThePrimeagen/harpoon",
  branch = "harpoon2",
  dependencies = { "nvim-lua/plenary.nvim" },
  config = function ()
    local harpoon = require("harpoon")
    local extensions = require("harpoon.extensions");

    harpoon:setup()

    vim.keymap.set("n", "<C-a>", function() harpoon:list():add() end, { desc = 'Harpoon Add' })
    vim.keymap.set("n", "<C-e>", function() harpoon.ui:toggle_quick_menu(harpoon:list()) end, { desc = 'Harpoon Window' })

    vim.keymap.set("n", "[qq", function() harpoon:list():clear() end, { desc = 'Harpoon Clear' })

    vim.keymap.set("n", "[1", function() harpoon:list():select(1) end, { desc = 'Harpoon Buffer 1' })
    vim.keymap.set("n", "[2", function() harpoon:list():select(2) end, { desc = 'Harpoon Buffer 2' })
    vim.keymap.set("n", "[3", function() harpoon:list():select(3) end, { desc = 'Harpoon Buffer 3' })
    vim.keymap.set("n", "[4", function() harpoon:list():select(4) end, { desc = 'Harpoon Buffer 4' })
    vim.keymap.set("n", "[5", function() harpoon:list():select(5) end, { desc = 'Harpoon Buffer 5' })
    vim.keymap.set("n", "[6", function() harpoon:list():select(6) end, { desc = 'Harpoon Buffer 6' })
    vim.keymap.set("n", "[7", function() harpoon:list():select(7) end, { desc = 'Harpoon Buffer 7' })
    vim.keymap.set("n", "[8", function() harpoon:list():select(8) end, { desc = 'Harpoon Buffer 8' })
    vim.keymap.set("n", "[9", function() harpoon:list():select(9) end, { desc = 'Harpoon Buffer 9' })

    vim.keymap.set("n", "[h", function() harpoon:list():prev() end, { desc = 'Harpoon Prev' })
    vim.keymap.set("n", "]h", function() harpoon:list():next() end, { desc = 'Harpoon Next' })

    harpoon:extend(extensions.builtins.navigate_with_number());
    harpoon:extend({
      UI_CREATE = function(cx)
        vim.keymap.set("n", "<C-v>", function()
          harpoon.ui:select_menu_item({ vsplit = true })
        end, { buffer = cx.bufnr })

        vim.keymap.set("n", "<C-x>", function()
          harpoon.ui:select_menu_item({ split = true })
        end, { buffer = cx.bufnr })

        vim.keymap.set("n", "<C-t>", function()
          harpoon.ui:select_menu_item({ tabedit = true })
        end, { buffer = cx.bufnr })
      end,
    })
  end
}
