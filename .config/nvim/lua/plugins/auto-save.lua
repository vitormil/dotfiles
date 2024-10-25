return {
  "okuuva/auto-save.nvim",
  version = '^1.0.0', -- see https://devhints.io/semver, alternatively use '*' to use the latest tagged release
  cmd = "ASToggle", -- optional for lazy loading on command
  event = { "InsertLeave", "TextChanged" }, -- optional for lazy loading on trigger events
  config = function()
    require("auto-save").setup({
      enabled = true,
      trigger_events = {
        immediate_save = { "BufLeave", "FocusLost" },
        defer_save = { "InsertLeave" },
        cancel_deferred_save = { "InsertEnter" },
      },
      condition = nil,
      write_all_buffers = false,
      noautocmd = false,
      lockmarks = false,
      debounce_delay = 0,
      debug = false,
    })

    local group = vim.api.nvim_create_augroup('autosave', {})

    vim.api.nvim_create_autocmd('User', {
        pattern = 'AutoSaveWritePost',
        group = group,
        callback = function(opts)
            if opts.data.saved_buffer ~= nil then
                local filename = vim.api.nvim_buf_get_name(opts.data.saved_buffer)
                print('AutoSaved ' .. filename .. ' at ' .. vim.fn.strftime('%H:%M:%S'))
            end
        end,
    })
  end,
}
