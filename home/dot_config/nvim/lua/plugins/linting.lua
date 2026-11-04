return {
  {
    "mfussenegger/nvim-lint",
    config = function()
      local lint = require("lint")
      
      lint.linters_by_ft = {
        javascript = { "eslint" },
        typescript = { "eslint" },
        ruby = { "rubocop" },
        vue = { "eslint" },
      }

      -- Auto-lint on save and when entering buffer
      vim.api.nvim_create_autocmd({ "BufWritePost", "BufReadPost", "InsertLeave" }, {
        callback = function()
          lint.try_lint()
        end,
      })
    end,
  },
  {
    "stevearc/conform.nvim",
    config = function()
      require("conform").setup({
        formatters_by_ft = {
          javascript = { "prettier" },
          typescript = { "prettier" },
          vue = { "prettier" },
          ruby = { "rubocop" },
          json = { "prettier" },
          yaml = { "prettier" },
          markdown = { "prettier" },
        },
        format_on_save = {
          timeout_ms = 500,
          lsp_fallback = true,
        },
      })
    end,
  },
}