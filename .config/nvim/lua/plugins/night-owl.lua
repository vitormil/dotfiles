return {
  "vitormil/night-owl.nvim",
  config = function ()
    require("night-owl").setup({
    })
    vim.cmd("colorscheme night-owl")
  end
}
