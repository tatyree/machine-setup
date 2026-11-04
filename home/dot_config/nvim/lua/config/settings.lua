-- Settings modeled after carlhuda/janus defaults

-- File handling settings
vim.opt.backupdir = { ".backup/", vim.fn.expand("~/.backup/"), "/tmp//" }
vim.opt.directory = { ".swp/", vim.fn.expand("~/.swp/"), "/tmp//" }
vim.opt.undodir = { ".undo/", vim.fn.expand("~/.undo/"), "/tmp//" }
vim.opt.undofile = true

-- UI settings
vim.opt.number = true
vim.opt.ruler = true
vim.opt.background = "dark"
vim.opt.encoding = "utf-8"
vim.opt.laststatus = 2
vim.opt.scrolloff = 3
vim.opt.showmatch = true
vim.opt.cursorline = true

-- Line wrapping (Janus-style: wrap with visual indicators)
vim.opt.wrap = true
vim.opt.linebreak = true
vim.opt.showbreak = "↪ "

-- Search settings
vim.opt.hlsearch = true
vim.opt.incsearch = true
vim.opt.ignorecase = true
vim.opt.smartcase = true

-- Tab/indent defaults (Janus: 2-space soft tabs)
vim.opt.tabstop = 2
vim.opt.softtabstop = 2
vim.opt.shiftwidth = 2
vim.opt.expandtab = true
vim.opt.smartindent = true
vim.opt.autoindent = true

-- Buffer and window behavior
vim.opt.hidden = true
vim.opt.splitbelow = true
vim.opt.splitright = true
vim.opt.mouse = "a"

-- Wildmenu (command-line completion)
vim.opt.wildmenu = true
vim.opt.wildmode = { "list:longest", "full" }
vim.opt.wildignore:append({ "*.o", "*.obj", ".git", "*.rbc", "*.class", ".svn", "vendor/gems/*" })

-- Completion settings
vim.opt.complete:append("kspell")

-- Enable filetype plugins and indentation
vim.cmd("filetype plugin indent on")

-- Spell checking for markdown and text files
vim.api.nvim_create_augroup("SpellCheck", { clear = true })
vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
  group = "SpellCheck",
  pattern = { "*.md", "*.txt" },
  command = "setlocal spell"
})

-- Vue syntax sync
vim.api.nvim_create_autocmd("FileType", {
  pattern = "vue",
  command = "syntax sync fromstart"
})

-- Ruby dispatch setting
vim.api.nvim_create_autocmd("FileType", {
  pattern = "ruby", 
  callback = function()
    vim.b.dispatch = "bin/rake"
  end
})

-- Load matchit.vim
vim.cmd("runtime macros/matchit.vim")