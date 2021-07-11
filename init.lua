-- known issues: Angular LS,
--               CSS completion,
--               having several LSs working in parallel on same buffer,
--               treesitter glitches sometimes,
--
-- for Neovim v0.5+ only

local cmd = vim.cmd
local set = vim.opt
local fn = vim.fn
local map = vim.api.nvim_set_keymap
local execute = vim.api.nvim_command
local callbacks = vim.lsp.callbacks

-- auto load plugins manager on Neovim start; ripgrep is required
local packer_path = fn.stdpath('data')..'/site/pack/packer/start/packer.nvim'
if fn.empty(fn.glob(packer_path)) > 0 then
  fn.system({ 'git', 'clone', 'https://github.com/wbthomason/packer.nvim', packer_path })
  execute'packadd packer.nvim'
end
-- plugins
require'packer'.startup(function()
  -- plugins manager
  use 'wbthomason/packer.nvim'
  -- syntax highlighting
  use { 'nvim-treesitter/nvim-treesitter', run = ':TSUpdate' }
  -- color scheme
  use 'sainnhe/sonokai'
  -- icons
  use 'kyazdani42/nvim-web-devicons'
  -- file browser
  use 'kyazdani42/nvim-tree.lua'
  -- file search
  use 'junegunn/fzf'
  use 'junegunn/fzf.vim'
  -- LSP configurator
  use 'neovim/nvim-lspconfig'
  -- auto completion
  use 'hrsh7th/nvim-compe'
  -- snippets
  use 'SirVer/ultisnips'
  use 'honza/vim-snippets'
  -- auto pairs
  use {
    'windwp/nvim-autopairs',
    config = function()
      require('nvim-autopairs').setup()
    end,
  }
  -- auto change corresponding HTML tag
  use 'AndrewRadev/tagalong.vim'
  -- comment code out
  use 'tpope/vim-commentary'
end)
-- compile plugins on ‘plugins.lua’ updates
cmd'autocmd BufWritePost plugins.lua source <afile> | PackerCompile'

require'nvim-treesitter.configs'.setup{
  -- install language parsers for maintained ones
  ensure_installed = "maintained",
  -- enable syntax highlighting
  highlight = {
    enable = true,
  },
}

cmd'colorscheme sonokai'
set.termguicolors = true
-- show line number
set.number = true
-- show relative line number to current one
set.relativenumber = true
-- tab stops after 4 chars
set.tabstop = 4
-- tab indents by 4 spaces
set.softtabstop = 4
-- indentation level in columns for indenting tools
set.shiftwidth = 4
-- copy indentation of selected text on pasting
set.copyindent = true
-- take into consideration file extension while indenting
set.smartindent = true
-- round indentation to nearest multiple of shiftwidth
set.shiftround = true
-- show cursor line
set.cursorline = true
-- keep current column if there is no symbol on it
set.virtualedit = 'all'
-- highlight matching brackets when cursor is over them
set.showmatch = true
-- don’t wrap lines
set.wrap = false
-- ‘J’ don’t produce additional space
set.joinspaces = false
-- ignore case while searching
set.ignorecase = true
-- stop ignoring case while search query includes capitals
set.smartcase = true
-- open new windows on right
set.splitright = true
-- open new windows on below
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
set.statusline = ' %F%m%r Column: %v'
-- display tab number, file name and modification flag in tab line
function tabline()
  local s = ''
  for i = 1, fn.tabpagenr('$') do
    local buflist = fn.tabpagebuflist(i)
    local winnr = fn.tabpagewinnr(i)
    local file = fn.bufname(buflist[winnr])
    -- highlight tab names
    s = i == fn.tabpagenr() and s .. '%#TabLineSel#' or s .. '%#TabLine#'
    -- tab number
    s = s .. ' ' .. i .. ' '
    -- tab name is file name
    s = s .. fn.fnamemodify(file, ':t')
    -- modification indicator
    if i == fn.tabpagenr() then
      s = s .. ' %m'
    end
    s = s .. ' '
  end
  s = s .. '%#TabLineFill#'
  return s
end
set.tabline = '%!v:lua.tabline()'

-- auto-trim whitespaces on save
cmd'autocmd BufWritePre * %s/\\s\\+$//e'
-- put cursor on last known position on open
cmd'autocmd BufReadPost * if line("\'\\"") > 1 && line("\'\\"") <= line("$") | exe "normal! g\'\\"" | endif'
-- each tab stops after even number of chars
-- tab indents by 2 spaces
-- use spaces instead of tabs
-- indentation level in columns for indenting tools
cmd'autocmd Filetype javascript,typescript,html,css,scss,sass,less set tabstop=2 softtabstop=2 expandtab shiftwidth=2'

vim.g.mapleader = ' '
-- navigate between windows
map('n', '<c-h>', '<c-w>h', {})
map('n', '<c-j>', '<c-w>j', {})
map('n', '<c-k>', '<c-w>k', {})
map('n', '<c-l>', '<c-w>l', {})
-- resize windows
map('n', '<leader>=', ':vertical resize +15<cr>', { silent = true })
map('n', '<leader>-', ':vertical resize -15<cr>', { silent = true })
map('n', '<leader>+', ':resize +5<cr>', { silent = true })
map('n', '<leader>_', ':resize -5<cr>', { silent = true })
-- navigate between tabs
map('n', 'L', 'gt', {})
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
-- play ‘q’ (most used ad hoc) macro
map('n', 'Q', '@q', {})

-- nvim.tree
vim.g.nvim_tree_width = '25%'
vim.g.nvim_tree_highlight_opened_files = 2
vim.g.nvim_tree_auto_close = 1
vim.g.nvim_tree_indent_markers = 1
-- append slash to folder paths
vim.g.nvim_tree_add_trailing = 1
-- folders with one folder are grouped
vim.g.nvim_tree_group_empty = 1
-- toggle file [b]rowser
map('n', '<leader>b', ':NvimTreeRefresh<cr> :NvimTreeToggle<cr> :set relativenumber<cr>', { silent = true })
-- [l]ocate current file in file browser
map('n', '<leader>l', ':NvimTreeRefresh<cr> :NvimTreeFindFile<cr> :set relativenumber<cr>', { silent = true })

-- fzf.vim
-- force Rg search by content only
cmd'command! -bang -nargs=* Rg call fzf#vim#grep("rg --column --line-number --hidden --smart-case ".shellescape(<q-args>), 1, fzf#vim#with_preview({"options": "--delimiter : --nth 4.. -e"}), <bang>0)'
-- file search by [t]ext
map('n', '<leader>t', ':Rg<cr>', { silent = true })
-- file search by [n]ame
map('n', '<leader>n', ':GFiles<cr>', { silent = true })

-- nvim-lspconfig
-- language servers should be installed manually
-- gopls: go get golang.org/x/tools/gopls@latest
-- jsonls, html, cssls: npm i -g vscode-langservers-extracted
-- tsserver: npm i -g typescript-language-server
-- angularls: npm i -g @angular/language-server@[same version as your project]
--            && [in every project] npm i -g @angular/language-service@[same version as your project]
local nvim_lsp = require'lspconfig'
local on_attach = function(_, bufnr)
  local function buf_set_keymap(...) vim.api.nvim_buf_set_keymap(bufnr, ...) end
  local opts = { silent = true }
  -- code [a]ction (imports, infer type, etc.)
  buf_set_keymap('n', '<leader>a', ':lua vim.lsp.buf.code_action()<cr>', opts)
  -- show symbol [r]eferences
  buf_set_keymap('n', '<leader>r', ':lua vim.lsp.buf.references()<cr>', opts)
  -- jump to [i]mplementation in new tab
  buf_set_keymap('n', '<leader>i', ':lua vim.lsp.buf.implementation()<cr>', opts)
  -- jump to [d]efinition in new tab
  buf_set_keymap('n', '<leader>d', ':lua vim.lsp.buf.definition()<cr>', opts)
  -- [r]ename symbol
  buf_set_keymap('n', '<leader>R', ':lua vim.lsp.buf.rename()<cr>', opts)
end
local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities.textDocument.completion.completionItem.snippetSupport = true
local servers = { 'gopls', 'jsonls', 'html', 'cssls' }
for _, lsp in ipairs(servers) do
  nvim_lsp[lsp].setup{
    on_attach = on_attach,
    capabilites = capabilites,
  }
end
nvim_lsp['tsserver'].setup{
  filetypes = { 'javascript', 'typescript' },
  on_attach = on_attach,
  capabilites = capabilites,
}
nvim_lsp['angularls'].setup{
  filetypes = { 'html' },
  on_attach = on_attach,
  capabilites = capabilites,
}

-- nvim-compe
set.completeopt = 'menuone,noselect'
-- auto select first entry
require'compe'.setup{
  source = {
    path = true;
    buffer = true;
    nvim_lsp = true;
    ultisnips = true;
  },
}
map('i', '<CR>', 'compe#confirm(luaeval("require \'nvim-autopairs\'.autopairs_cr()"))', { expr = true })

-- ultisnips
-- also run `pip3 install neovim`
vim.g.python3_host_prog = '/usr/local/bin/python3'
cmd'autocmd Filetype css,scss,sass,less :UltiSnipsAddFiletypes css.scss.sass.less'

-- vim-commentary. Toggle line [c]ommenting
map('n', '<leader>c', 'gc', {})
map('v', '<leader>c', 'gc', {})
