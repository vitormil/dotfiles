return {
  'lukas-reineke/indent-blankline.nvim',
  enabled = true,
  main = 'ibl',
  opts = {
    indent = { char = '│' },
  },
  config = function ()
    require("ibl").setup {
      scope = { enabled = false },
    }
  end
}
