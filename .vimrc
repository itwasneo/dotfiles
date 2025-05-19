set nocompatible
set number
set relativenumber
set autoindent
set smartindent
set tabstop=4
set shiftwidth=4
set mouse=a
set incsearch
set ignorecase
set smartcase

if has('clipboard')
	set clipboard=unnamedplus
endif

set grepprg=rg\ --vimgrep

syntax on

"Kotlin: Use kotlinc to compile the current file
autocmd FileType kotlin setlocal makeprg=kotlinc\ %

" autocmd QuickFixCmdPost [^l]* rightbelow vertical 60copen
autocmd QuickFixCmdPost [^l]* if empty(getqflist()) | cclose | else | rightbelow vertical 60copen | endif

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
