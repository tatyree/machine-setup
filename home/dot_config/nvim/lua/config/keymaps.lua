-- Key mappings (Janus-style)

local keymap = vim.keymap.set

-- Format entire file
keymap("n", "<leader>fef", "gg=G``", { desc = "Format entire file" })

-- Neo-tree mappings (Janus NERDTree equivalents)
keymap("n", "<leader>n", ":Neotree toggle<CR>", { desc = "Toggle Neo-tree" })
keymap("n", "<leader>r", ":Neotree reveal<CR>", { desc = "Find current file in Neo-tree" })
keymap("n", "<C-o>", ":Neotree focus<CR>", { desc = "Focus Neo-tree with current file" })

-- Window navigation (Janus-style Ctrl+hjkl)
keymap("n", "<C-h>", "<C-w>h", { desc = "Move to left window" })
keymap("n", "<C-j>", "<C-w>j", { desc = "Move to below window" })
keymap("n", "<C-k>", "<C-w>k", { desc = "Move to above window" })
keymap("n", "<C-l>", "<C-w>l", { desc = "Move to right window" })

-- Window splits (Janus-style)
keymap("n", "<leader>hs", ":split<CR>", { desc = "Horizontal split" })
keymap("n", "<leader>vs", ":vsplit<CR>", { desc = "Vertical split" })
keymap("n", "<leader>=", "<C-w>=", { desc = "Equalize window sizes" })

-- Buffer navigation (Janus-style)
keymap("n", "<leader>]", ":bnext<CR>", { desc = "Next buffer" })
keymap("n", "<leader>[", ":bprevious<CR>", { desc = "Previous buffer" })

-- Clear search highlight (Janus: ,hl)
keymap("n", "<leader>hl", ":nohlsearch<CR>", { desc = "Clear search highlight" })

-- Telescope mappings
keymap("n", "<leader>ff", "<cmd>Telescope find_files<cr>", { desc = "Find files" })
keymap("n", "<leader>fg", "<cmd>Telescope live_grep<cr>", { desc = "Live grep" })
keymap("n", "<leader>fb", "<cmd>Telescope buffers<cr>", { desc = "Find buffers" })
keymap("n", "<leader>fh", "<cmd>Telescope help_tags<cr>", { desc = "Help tags" })
keymap("n", "<Leader>f", "<cmd>Telescope live_grep<cr>", { desc = "Search with live grep" })

-- CtrlP-style mapping for muscle memory
keymap("n", "<C-p>", "<cmd>Telescope find_files<cr>", { desc = "Find files (CtrlP style)" })

-- Display current time
keymap("n", "<F2>", ":echo 'Current time is ' . strftime('%c')<CR>", { desc = "Show current time" })

-- Vim-test mappings
keymap("n", "<leader>tn", ":TestNearest<CR>", { silent = true, desc = "Test nearest" })
keymap("n", "<leader>tf", ":TestFile<CR>", { silent = true, desc = "Test file" })
keymap("n", "<leader>ts", ":TestSuite<CR>", { silent = true, desc = "Test suite" })
keymap("n", "<leader>tl", ":TestLast<CR>", { silent = true, desc = "Test last" })
keymap("n", "<leader>tv", ":TestVisit<CR>", { silent = true, desc = "Test visit" })

-- Git mappings
keymap("n", "<leader>gb", ":Git blame<CR>", { desc = "Git blame" })
keymap("n", "<leader>gq", ":Git<CR>", { desc = "Git status" })
keymap("n", "<leader>gd", ":Git diff<CR>", { desc = "Git diff" })
keymap("n", "<leader>gl", ":Git log<CR>", { desc = "Git log" })
keymap("n", "<leader>gc", ":Git commit -v<CR>", { desc = "Git commit" })
keymap("n", "<leader>gv", ":Git commit -av<CR>", { desc = "Git commit all" })
keymap("n", "<leader>gp", ":Git push<CR>", { desc = "Git push" })

-- RuboCop mapping
keymap("n", "<Leader>rc", ":RuboCop -a<CR>", { desc = "Run RuboCop with auto-correct" })

-- Undotree mapping
keymap("n", "<leader>u", ":UndotreeToggle<CR>", { desc = "Toggle undo tree" })