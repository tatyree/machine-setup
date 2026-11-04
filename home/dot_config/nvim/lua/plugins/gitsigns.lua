-- gitsigns: Git gutter indicators (Janus had git diff markers in the gutter)
return {
  "lewis6991/gitsigns.nvim",
  event = "BufReadPre",
  opts = {
    signs = {
      add          = { text = "+" },
      change       = { text = "~" },
      delete       = { text = "_" },
      topdelete    = { text = "‾" },
      changedelete = { text = "~" },
    },
    on_attach = function(bufnr)
      local gs = package.loaded.gitsigns
      local function map(mode, l, r, opts)
        opts = opts or {}
        opts.buffer = bufnr
        vim.keymap.set(mode, l, r, opts)
      end
      -- Navigation between hunks (Janus unimpaired-style)
      map("n", "]c", function() gs.nav_hunk("next") end, { desc = "Next git hunk" })
      map("n", "[c", function() gs.nav_hunk("prev") end, { desc = "Previous git hunk" })
      -- Actions
      map("n", "<leader>hp", gs.preview_hunk, { desc = "Preview hunk" })
      map("n", "<leader>hr", gs.reset_hunk, { desc = "Reset hunk" })
      map("n", "<leader>hb", gs.blame_line, { desc = "Blame line" })
    end,
  },
}
