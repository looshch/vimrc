" auto-load vim-plug on vim start
if empty(glob('~/.local/share/nvim/site/autoload/plug.vim'))
  silent !curl -fLo ~/.local/share/nvim/site/autoload/plug.vim --create-dirs
    \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  " using ‘--sync’ to block untill all plugins get installed
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

" plugins; Yarn and ripgrep are required
call plug#begin('~/.nvim/plugged')
  " color scheme
  Plug 'morhetz/gruvbox'
  " file browser
  Plug 'preservim/nerdtree'
  " file search
  Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
  Plug 'junegunn/fzf.vim'
  " language server
  Plug 'neoclide/coc.nvim'
  " comment code out
  Plug 'tpope/vim-commentary'
call plug#end()

" color scheme
colorscheme gruvbox
set termguicolors

" show line number and relative one to current one
set number relativenumber
" each tab stops after 4 chars and tab indents by 4 spaces
set tabstop=4 softtabstop=4
" copy indentation of selected
" text on pasting, take into consideration file extension while indenting, round
" indentation to nearest multiple of shiftwidth
set copyindent smartindent shiftround
" indentation level in columns for indenting tools
set shiftwidth=4
" show cursor line
set cursorline
" keep current column if there is no symbol on it
set virtualedit=all
" highlight matching brackets when cursor is over them
set showmatch
" don’t wrap lines
set nowrap
" ‘J’ don’t produce additional space
set nojoinspaces
" ignore case while searching, stop ignoring case while search query includes
" capitals
set ignorecase smartcase
" open new windows on right and below
set splitright splitbelow
" don’t justify windows width and height on split
set noequalalways
" keep undo history after quitting Neovim, disable swap files
set undofile noswapfile
" rerender only at end of macro
set lazyredraw
" set system clipboard as default register
set clipboard+=unnamedplus
" time to wait till mapping completion
set timeoutlen=150
" time before all plugins ruled by this setting take actions after typing
set updatetime=50
" preferred number of lines before horizontal edges while scrolling
set scrolloff=7
" display full path to opened file, modification and readonly flags, column number
set statusline=\ %F%m%r\ Column:\ %v
" display tab number and file name in tab line
set tabline=%!TabLine()

" tabs with order number instead of windows number
function TabLine()
  let s = ''
  for i in range(tabpagenr('$'))
    " highlight tab name and modification flag only, show tab number
    let s .= '%* ' . (i + 1) . ' '
    " highlight opened tab name
    let s .= ((i + 1) == tabpagenr() ? '%#TabLineSel#' : '%#TabLine#')
    let buflist = tabpagebuflist(i + 1)
    let winnr = tabpagewinnr(i + 1)
    let file = bufname(buflist[winnr - 1])
    " if last tab active buffer is NERDTree, choose other buffer
    if file =~ 'NERD_tree_'
      let file = bufname(buflist[winnr - 2])
    endif
    " reduce /a/b.c to b.c
    let file = fnamemodify(file, ':t')
    let s .= file
    " add modification flag for opened tab
    let s .= (i + 1 == tabpagenr()  ? '%m' : '')
  endfor
  let s .= '%T%#TabLineFill#%='
  return s
endfunction

" put cursor on last known position on open
autocmd BufReadPost * if line('''"') > 1 && line('''"') <= line('$') | exe 'normal! g''"' | endif
" auto-trim whitespaces on save
autocmd BufWritePre * %s/\s\+$//e
" format Go files after saving
autocmd BufWritePost *.go :silent execute ':call CocAction(''format'')'

" each tab stops after even number of chars
" tab indents by 2 spaces
" use spaces instead of tabs
" indentation level in columns for indenting tools
autocmd Filetype javascript,typescript,html,css,scss,sass set tabstop=2 softtabstop=2 expandtab shiftwidth=2
" ‘lll’ and space produce console.log( )
autocmd Filetype javascript,typescript,html,css,scss,sass iabbrev lll console.log(
" ‘W’ command saves file with sudo
command! W execute 'w !sudo tee % > /dev/null' <bar> edit!

" <leader> set to space key
let mapleader=' '

" navigate between windows
nmap <C-h> <C-w>h
nmap <C-j> <C-w>j
nmap <C-k> <C-w>k
nmap <C-l> <C-w>l
" resize windows
nmap <silent> <leader>= :vertical resize +15<cr>
nmap <silent> <leader>+ :resize +5<cr>
nmap <silent> <leader>- :vertical resize -15<cr>
nmap <silent> <leader>_ :resize -5<cr>
" navigate between tabs
nmap L gt
nmap H gT
nmap <leader>1 1gt
nmap <leader>2 2gt
nmap <leader>3 3gt
nmap <leader>4 4gt
nmap <leader>5 5gt
nmap <leader>6 6gt
nmap <leader>7 7gt
nmap <leader>8 8gt
nmap <leader>9 9gt
" clear search
nmap <silent> ? :let @/=''<cr>
" play ‘q’ macro
nmap Q @q

" NERDTree
" quit vim if window on left is NERDTree
autocmd BufEnter * if (winnr('$') == 1 && exists('b:NERDTree') && b:NERDTree.isTabTree()) | q | endif
" NERDTree window size equals to 70 symbols
let NERDTreeWinSize=70
" remove help text
let NERDTreeMinimalUI=1
" show hidden files
let NERDTreeShowHidden=1
" show relative line number
let NERDTreeShowLineNumbers=1
" toggle NERDTree (file [b]rowser)
nmap <silent> <leader>b :NERDTreeToggle<cr>
" [l]ocate current file in NERDTree
nmap <silent> <leader>l :NERDTreeFind<cr>

" fzf-vim
" force Rg search by content only
command! -bang -nargs=* Rg
                      \ call fzf#vim#grep('rg --column --line-number --hidden --smart-case '.shellescape(<q-args>),
                                        \ 1,
                                        \ fzf#vim#with_preview({'options': '--delimiter : --nth 4.. -e'}),
                                        \ <bang>0)
" file search by [t]ontent
nmap <silent> <leader>t :Rg<cr>
" file search by [n]ame
nmap <silent> <leader>n :GFiles<cr>

" CoC
let g:coc_global_extensions=[ 'coc-pairs',
                            \ 'coc-json',
                            \ 'coc-sh',
                            \ 'coc-go',
                            \ 'coc-sql',
                            \ 'coc-emmet',
                            \ 'coc-html',
                            \ 'coc-html-css-support',
                            \ 'coc-css',
                            \ 'coc-cssmodules',
                            \ 'coc-svg',
                            \ 'coc-tsserver',
                            \ 'coc-angular' ]
" trigger autocompletion on Enter
inoremap <expr> <cr> pumvisible() ? "\<C-y>" : "\<C-g>u\<cr>"
" select first autocomplete entry and format code
inoremap <silent><expr> <cr> pumvisible() ? coc#_select_confirm() : "\<C-g>u\<cr>\<C-r>=coc#on_enter()\<cr>"
" code [a]ction (imports, infer type, etc.)
nmap <silent> <leader>a <Plug>(coc-codeaction)
" show symbol [r]eferences
nmap <leader>r <Plug>(coc-references)
" jump to [i]mplementation in new tab
nmap <silent> <leader>i :call CocAction('jumpImplementation', 'tab drop')<cr>
" jump to [d]efinition in new tab
nmap <silent> <leader>d :call CocAction('jumpDefinition', 'tab drop')<cr>
" [r]ename symbol
nmap <leader>R <Plug>(coc-rename)

" vim-commentary. Toggle line [c]ommenting
nmap <leader>c gc
vmap <leader>c gc
