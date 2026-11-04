-- Plugin configurations ported from .vimrc

-- Better whitespace configuration  
vim.g.better_whitespace_enabled = 1
vim.g.strip_whitespace_on_save = 1
vim.g.strip_whitespace_confirm = 0
vim.g.show_spaces_that_precede_tabs = 1

-- Vim-move configuration
vim.g.move_key_modifier = 'C'

-- Theme configuration
vim.cmd("colorscheme PaperColor")

-- Vim-test configuration
vim.g['test#ruby#rspec#options'] = '--format documentation'

-- Vim-rubocop configuration
vim.g.vimrubocop_keymap = 0

-- Load all packages
vim.cmd("packloadall")