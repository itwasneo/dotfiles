set nocompatible
set number
set relativenumber
set expandtab
set shiftwidth=4
set softtabstop=4
set tabstop=4
set mouse=a
set incsearch
set ignorecase
set smartcase
set laststatus=2
set clipboard=unnamedplus
set grepprg=rg\ --vimgrep
set termguicolors
set background=dark
colorscheme retrobox

syntax on

autocmd QuickFixCmdPost make cwindow

"Jump to the next quickfix error
nnoremap ]q :cnext<CR>

"Jump to the previous quickfix error
nnoremap [q :cprev<CR>

"Open the quickfix window
nnoremap <leader>qo :copen<CR>

"Close the quickfix window
nnoremap <leader>qc :cclose<CR>

"Changing space button to :
nnoremap <Space> :

" Ruff (for python)
let g:ruff_path = expand('$VIRTUAL_ENV') != '' ? expand('$VIRTUAL_ENV') . '/bin/ruff' : 'ruff'
" command! RuffLint execute '!' . g:ruff_path . ' check .'
command! RuffQuickfix execute 'write | cgetexpr system("' . g:ruff_path . ' check . --no-cache") | cwindow'
