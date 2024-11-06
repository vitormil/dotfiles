return {
  "okuuva/auto-save.nvim",
  version = '^1.0.0', -- see https://devhints.io/semver, alternatively use '*' to use the latest tagged release
  cmd = "ASToggle",
  event = { "InsertLeave", "TextChanged" },
  config = function()
    require("auto-save").setup({
      enabled = true,
      trigger_events = {
        immediate_save = { "BufLeave", "FocusLost" },
        defer_save = { "InsertLeave" },
        cancel_deferred_save = { "InsertEnter" },
      },
      condition = function(buf)
        local fn = vim.fn
        local utils = require("auto-save.utils.data")

        -- auto-save for file types
        -- print('Filetype ' .. fn.getbufvar(buf, "&filetype"))

        if utils.not_in(fn.getbufvar(buf, "&filetype"), {'eruby', 'ruby', 'scss', 'html', 'txt', 'md'}) then
          return false
        end
        return true
      end,
      write_all_buffers = false,
      noautocmd = false,
      lockmarks = false,
      debounce_delay = 100,
      debug = false,
    })

    -- local group = vim.api.nvim_create_augroup('autosave', {})
    -- vim.api.nvim_create_autocmd('User', {
    --     pattern = 'AutoSaveWritePost',
    --     group = group,
    --     callback = function(opts)
    --         if opts.data.saved_buffer ~= nil then
    --             local filename = vim.api.nvim_buf_get_name(opts.data.saved_buffer)
    --             print('AutoSaved ' .. filename .. ' at ' .. vim.fn.strftime('%H:%M:%S'))
    --         end
    --     end,
    -- })
  end,
}
