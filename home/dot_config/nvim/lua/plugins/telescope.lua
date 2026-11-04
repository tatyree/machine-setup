return {
  "nvim-telescope/telescope.nvim",
  tag = "0.1.6",
  dependencies = { 
    "nvim-lua/plenary.nvim",
    {
      "nvim-telescope/telescope-fzf-native.nvim",
      build = "make",
    },
  },
  config = function()
    require("telescope").setup({
      defaults = {
        mappings = {
          i = {
            ["<C-n>"] = "move_selection_next",
            ["<C-p>"] = "move_selection_previous",
          },
        },
        file_ignore_patterns = {
          "%.git/",
          "build/",
          "DS_Store",
          "node_modules/",
          "dist/",
          "target/",
          "tmp/",
          "%.firebase/",
          "public/",
          "%.next/",
          "screenshots/",
          "typescript/",
        },
      },
      pickers = {
        find_files = {
          theme = "dropdown",
        },
        live_grep = {
          theme = "dropdown",
        },
        buffers = {
          theme = "dropdown",
        },
      },
    })

    -- Load extensions
    require("telescope").load_extension("fzf")
  end,
}