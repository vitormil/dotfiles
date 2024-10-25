return {
  "stevearc/conform.nvim",
  event = { "BufReadPre", "BufNewFile" },
  config = function()
    local conform = require("conform")

    conform.setup({
      formatters_by_ft = {
        lua = { "stylua" },
        svelte = { { "prettierd", "prettier", stop_after_first = true } },
        astro = { { "prettierd", "prettier", stop_after_first = true } },
        javascript = { { "prettierd", "prettier", stop_after_first = true } },
        typescript = { { "prettierd", "prettier", stop_after_first = true } },
        javascriptreact = { { "prettierd", "prettier", stop_after_first = true } },
        typescriptreact = { { "prettierd", "prettier", stop_after_first = true } },
        json = { { "prettierd", "prettier", stop_after_first = true } },
        graphql = { { "prettierd", "prettier", stop_after_first = true } },
        java = { "google-java-format" },
        kotlin = { "ktlint" },
        ruby = { "rubocop" },
        markdown = { { "prettierd", "prettier", stop_after_first = true } },
        erb = { "htmlbeautifier" },
        html = { "htmlbeautifier" },
        bash = { "beautysh" },
        proto = { "buf" },
        rust = { "rustfmt" },
        yaml = { "yamlfix" },
        toml = { "taplo" },
        css = { { "prettierd", "prettier", stop_after_first = true } },
        scss = { { "prettierd", "prettier", stop_after_first = true } },
        sh = { "shellcheck" },
        go = { "gofmt" },
      },
    })

    vim.keymap.set({ "n", "v" }, "<leader>l", function()
      conform.format({
        lsp_fallback = true,
        async = false,
        timeout_ms = 1000,
      })
    end, { desc = "Format file or range (in visual mode)" })
  end,
  };
