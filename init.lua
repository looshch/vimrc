-- for Neovim v0.5+

local fn = vim.fn
local execute = vim.api.nvim_command
local cmd = vim.cmd
local set = vim.opt
local map = vim.api.nvim_set_keymap

-- auto load plugin manager; Node.js, Yarn (for front-end development) and ripgrep are required
local packer_path = fn.stdpath('data')..'/site/pack/packer/start/packer.nvim'
if fn.empty(fn.glob(packer_path)) > 0 then
  fn.system({ 'git', 'clone', 'https://github.com/wbthomason/packer.nvim', packer_path })
  execute'packadd packer.nvim'
end
-- plugins
require'packer'.startup(function()
  -- plugin manager
  use 'wbthomason/packer.nvim'
  -- syntax highlighting
  use {
    'nvim-treesitter/nvim-treesitter',
    run = ':TSUpdate',
  }
  -- color scheme
  use 'sainnhe/sonokai'
  -- icons
  use 'kyazdani42/nvim-web-devicons'
  -- file browser
  use 'kyazdani42/nvim-tree.lua'
  -- file search
  use 'junegunn/fzf'
  use 'junegunn/fzf.vim'
  -- language server
  use {
    'neoclide/coc.nvim',
    branch = 'release',
  }
  -- snippets
  use 'honza/vim-snippets'
  -- auto change corresponding HTML tag
  use 'AndrewRadev/tagalong.vim'
  -- comment code out
  use 'tpope/vim-commentary'
end)
-- compile plugins on ‘plugins.lua’ updates
cmd'autocmd BufWritePost plugins.lua source <afile> | PackerCompile'

cmd'colorscheme sonokai'
-- enable 24-bit colors
set.termguicolors = true
-- show line number
set.number = true
--                  relative to current one
set.relativenumber = true
-- tab equals to 4 chars
set.tabstop = 4
-- indentation level for indenting tools
set.shiftwidth = 4
-- do smart indent on new line
set.smartindent = true
-- round indentation to multiple of shiftwidth
set.shiftround = true
-- show cursor line
set.cursorline = true
-- keep current column if there is no symbol on it
set.virtualedit = 'all'
-- highlight matching brackets on hover
set.showmatch = true
-- don’t wrap lines
set.wrap = false
-- ‘J’ doesn’t produce additional space
set.joinspaces = false
-- ignore case while searching
set.ignorecase = true
-- stop ignoring case while search query includes capitals
set.smartcase = true
-- open new windows on right
set.splitright = true
--                  below
set.splitbelow = true
-- don’t justify windows width and height on split
set.equalalways = false
-- keep undo history after quitting Neovim
set.undofile = true
-- disable swap files
set.swapfile = false
-- rerender only at end of macro
set.lazyredraw = true
-- set system clipboard as default register
set.clipboard = set.clipboard + { 'unnamedplus' }
-- time to wait till mapping completion
set.timeoutlen = 150
-- time before all plugins ruled by this setting take actions after typing
set.updatetime = 50
-- preferred number of lines before horizontal edges while scrolling
set.scrolloff = 7
-- display full path to opened file, modification and readonly flags, column number
set.statusline = '%F%m%r Column: %v'
-- display tab number, file name and modification flag in tab line
function tabline()
  local s = ''
  for i = 1, fn.tabpagenr('$') do
    local buflist = fn.tabpagebuflist(i)
    local winnr = fn.tabpagewinnr(i)
    local file = fn.bufname(buflist[winnr])
    -- highlight tab names
    s = i == fn.tabpagenr() and s .. '%#TabLineSel#' or s .. '%#TabLine#'
    -- display tab number and file name as tab name
    s = s .. ' ' .. i .. ' ' .. fn.fnamemodify(file, ':t') .. ' '
  end
  s = s .. '%#TabLineFill#'
  return s
end
set.tabline = '%!v:lua.tabline()'

-- auto-trim whitespaces on save
cmd'autocmd BufWritePre * %s/\\s\\+$//e'
-- put cursor on last known position on open
cmd'autocmd BufReadPost * if line("\'\\"") > 1 && line("\'\\"") <= line("$") | exe "normal! g\'\\"" | endif'
-- comments support in JSON
cmd'autocmd FileType json syntax match Comment +\\/\\/.\\+$+'
-- each tab stops after even number of chars
-- tab indents by 2 spaces
-- use spaces instead of tabs
-- indentation level in columns for indenting tools
cmd'autocmd Filetype javascript,typescript,html,css,scss,sass,less set tabstop=2 softtabstop=2 expandtab shiftwidth=2'

-- <leader> is space
vim.g.mapleader = ' '
-- navigate between windows
map('n', '<c-h>', '<c-w>h', {})
map('n', '<c-j>', '<c-w>j', {})
map('n', '<c-k>', '<c-w>k', {})
map('n', '<c-l>', '<c-w>l', {})
-- change window width
map('n', '<leader>=', ':vertical resize +15<cr>', { silent = true })
map('n', '<leader>-', ':vertical resize -15<cr>', { silent = true })
--               height
map('n', '<leader>+', ':resize +5<cr>', { silent = true })
map('n', '<leader>_', ':resize -5<cr>', { silent = true })
-- navigate between tabs
map('n', 'L', 'gt', {})
map('n', 'H', 'gT', {})
map('n', '<leader>1', '1gt', {})
map('n', '<leader>2', '2gt', {})
map('n', '<leader>3', '3gt', {})
map('n', '<leader>4', '4gt', {})
map('n', '<leader>5', '5gt', {})
map('n', '<leader>6', '6gt', {})
map('n', '<leader>7', '7gt', {})
map('n', '<leader>8', '8gt', {})
map('n', '<leader>9', '9gt', {})
-- clear search
map('n', '?', ':let @/=""<cr>', { silent = true })
map('n', 'Q', '@q', {})
map('n', 'R', 'r', { noremap = true })
map('n', 'r', '<C-r>', { noremap = true })

-- nvim-treesitter
require'nvim-treesitter.configs'.setup{
  -- install maintained language parsers
  ensure_installed = 'maintained',
  -- enable syntax highlighting
  highlight = {
    enable = true,
    -- angular highlighting has quirks so HTML is disabled
    disable = { 'html' },
  },
}

-- nvim.tree
vim.g.nvim_tree_width = '25%'
-- highlight folders and file names
vim.g.nvim_tree_highlight_opened_files = 2
-- close file browser when it’s last window
vim.g.nvim_tree_auto_close = 1
-- show indent guides
vim.g.nvim_tree_indent_markers = 1
-- append slash to folder paths
vim.g.nvim_tree_add_trailing = 1
-- folders with one folder only are grouped
vim.g.nvim_tree_group_empty = 1
-- toggle file [b]rowser
map('n', '<leader>b', ':NvimTreeRefresh<cr> :NvimTreeToggle<cr> :set relativenumber<cr>', { silent = true })
-- [l]ocate current file in file browser
map('n', '<leader>l', ':NvimTreeRefresh<cr> :NvimTreeFindFile<cr> :set relativenumber<cr>', { silent = true })

-- fzf.vim
-- force Rg search by text only
cmd'command! -bang -nargs=* Rg call fzf#vim#grep("rg --column --line-number --hidden --smart-case ".shellescape(<q-args>), 1, fzf#vim#with_preview({"options": "--delimiter : --nth 4.. -e"}), <bang>0)'
-- file search by [t]ext
map('n', '<leader>t', ':Rg<cr>', { silent = true })
-- file search by [n]ame
map('n', '<leader>n', ':GFiles<cr>', { silent = true })

-- CoC
-- requirement
set.hidden = true
vim.g.coc_global_extensions = {
  'coc-sumneko-lua',
  'coc-pairs',
  'coc-json',
  'coc-sh',
  'coc-go',
  'coc-sql',
  'coc-snippets',
  'coc-emmet',
  'coc-html',
  'coc-htmlhint',
  'coc-html-css-support',
  'coc-css',
  'coc-cssmodules',
  'coc-svg',
  'coc-tsserver',
  'coc-angular',
}
-- trigger autocompletion on Enter
map('i', '<cr>', 'pumvisible() ? "<C-y>" : "<C-g>u<cr>"', { noremap = true, expr = true })
-- select first autocomplete entry and format code
map('i', '<cr>', 'pumvisible() ? coc#_select_confirm() : "<C-g>u<cr><C-r>=coc#on_enter()<cr>"', { silent = true, noremap = true, expr = true })
-- show [n]ext diagnostic
map('n', '<leader>N', '<Plug>(coc-diagnostic-next)', { silent = true })
-- show [p]revious diagnostic
map('n', '<leader>P', '<Plug>(coc-diagnostic-prev)', { silent = true })
-- show symbol [r]eferences
map('n', '<leader>r', '<Plug>(coc-references)', {})
-- jump to [i]mplementation in new tab
map('n', '<leader>i', ':call CocAction("jumpImplementation", "tab drop")<cr>', { silent = true })
-- jump to [d]efinition in new tab
map('n', '<leader>d', ':call CocAction("jumpDefinition", "tab drop")<cr>', { silent = true })
-- [f]ormat
map('x', '<leader>f', '<Plug>(coc-format-selected)', {})
-- code [a]ction (imports, infer type, etc.)
map('n', '<leader>a', '<Plug>(coc-codeaction)', { silent = true })
-- [r]ename symbol
map('n', '<leader>R', '<Plug>(coc-rename)', {})
-- highlight symbol occurrences
cmd'autocmd CursorHold * silent call CocActionAsync("highlight")'

-- vim-commentary. Toggle line [c]ommenting
map('n', '<leader>c', 'gc', {})
map('v', '<leader>c', 'gc', {})
