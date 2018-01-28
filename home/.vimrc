"--- plugins ---

call plug#begin()

" obligatory tpope section
Plug 'tpope/vim-sensible'
Plug 'tpope/vim-surround'
Plug 'tpope/vim-abolish'
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-vinegar'

Plug 'w0rp/ale'
Plug 'vimwiki/vimwiki'
Plug 'lervag/vimtex' , { 'on': 'TexToggle', 'for': ['tex', 'bib'] }
Plug 'itchyny/lightline.vim'
Plug 'airblade/vim-gitgutter'

" Colour schemes
Plug 'whatyouhide/vim-gotham'
Plug 'romainl/apprentice'
Plug 'junegunn/seoul256.vim'

call plug#end()

" --- end vim-plug ---

" --- useful settings ---
syntax enable
set copyindent autoindent
set smartcase smarttab expandtab
set splitright
set mouse=a
set incsearch hlsearch

"Absolute number for current line, relative for others
set relativenumber number

" avoid swap files etc. piling up everywhere
set dir=~/.vim_backups//
set backupdir=~/.vim_backups//

"colour scheme
set background=dark
let g:seoul256_background = 235
colo seoul256

" Highlight a column
set colorcolumn=80

" Tab settings
let shift_width = 2
let tab_stop = 2
let soft_tab_stop = 2
let &shiftwidth = shift_width
let &softtabstop = soft_tab_stop
" Sort out makefile tab requirements
augroup Maketabs
  " clear events -- not sure if this is necessary in this case?
  autocmd! Maketabs
  autocmd BufEnter ?akefile* set noexpandtab shiftwidth=8 softtabstop=0
  autocmd BufLeave ?akefile* set expandtab|let &shiftwidth=shift_width|let &softtabstop=soft_tab_stop
augroup END

" enable spell checking for tex files
autocmd FileType tex,wiki,txt,md setlocal spell spelllang=en_gb

"remove GUI cruft
if has('gui_running')
    :set guioptions =c
endif

"Makes mouse reporting work properly on wide screens
if has ('mouse_sgr')
    set ttymouse=sgr
endif

"Default font
if has("win32")
    set guifont=Courier\ New:h10:cANSI
    set bs=2
    syntax on
elseif has("gui_macvim")
    set guifont=Source\ Code\ Pro\ for\ Powerline
else
set guifont=Source\ Code\ Pro\ for\ Powerline
" set highlight Normal ctermbg=None " Makes terminal vim transparent in Linux
endif
"
" --- set plugin variables ---

" git branch information in lightline: taken from :h lightline example
let g:lightline = {
        \ 'active': {
        \   'left': [ [ 'mode', 'paste' ],
        \             [ 'gitbranch', 'readonly', 'filename', 'modified' ] ]
        \ },
        \ 'component_function': {
        \   'gitbranch': 'fugitive#head'
        \ },
        \ }

let g:lightline.colorscheme = 'seoul256'

let g:vimtex_quickfix_ignored_warnings = [
    \ 'Underfull',
    \ 'csquotes',
    \ 'Overfull',
    \ 'specifier changed to',
    \ '\float@addtolists',
  \ ]

let fortran_free_source=1
let g:ale_fortran_gcc_executable = 'gfortran'
let g:ale_fortran_gcc_options = '-Jmod -std=f2003 -fopenmp'
let g:ale_fortran_gcc_use_free_form = 1

" --- remappings ---

let mapleader = ","
nnoremap ; :
noremap <leader>qq :q!<cr>
noremap <leader>w :w!<cr>
noremap <leader>qw :wq<cr>
inoremap jj <Esc>
"Stops vim from 'jumping over' wrapped lines
nnoremap j gj
nnoremap k gk
nnoremap <leader><Space> :nohl<cr>

"easy switching of tabs
noremap <leader>tn :tabn<cr>
noremap <leader>tp :tabp<cr>
"Easy edit of .vimrc
noremap <leader>vrc :vsp! $MYVIMRC<cr>
"Press Ctrl-I to split lines:
nnoremap <C-I> i<cr><Esc>gk$
"file browser ease
nnoremap <leader>exp :Explore<cr>
nnoremap <leader>sx :Sex!<cr>
