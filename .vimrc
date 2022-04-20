syntax on
filetype plugin on
set encoding=utf-8
set nocp
set exrc
set secure
set noerrorbells
set tabstop=4
set shiftwidth=4
set softtabstop=4
set smartindent
set expandtab
set nu
set relativenumber
set nowrap
set ignorecase
set smartcase
set noswapfile
set nobackup
set undodir=~/.vim/undo
set undofile
set incsearch
set nohlsearch
set scrolloff=4
set signcolumn=yes
set updatetime=250

let mapleader = " "
nnoremap <C-s> :w<CR>
noremap <C-w>t :vert ter ++close<CR> <C-w>L
autocmd BufLeave * if &buftype == 'terminal' | silent! :wincmd q | endif

" ALE
let g:ale_disable_lsp = 1
let g:ale_completion_enabled = 0
let g:ale_sign_error = 'e'
let g:ale_sign_warning = 'w'
let g:ale_sign_info = 'i'
let g:ale_sign_style_warning = 'w'
let g:ale_linters = { 'cs': ['OmniSharp'] }

" GITGUTTER
let g:gitgutter_terminal_reports_focus = 0

call plug#begin('~/.vim/plugged')
Plug 'arcticicestudio/nord-vim'

Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'

Plug 'tpope/vim-fugitive'
Plug 'airblade/vim-gitgutter'

Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'

Plug 'jiangmiao/auto-pairs'
Plug 'tpope/vim-commentary'

Plug 'dense-analysis/ale'
Plug 'OmniSharp/omnisharp-vim'
Plug 'neoclide/coc.nvim', {'branch': 'release'}

Plug 'elzr/vim-json'

call plug#end()

" FZF
nnoremap <C-p> :GFiles<CR>
nnoremap <C-f> :Rg 
nmap <buffer> <Leader>f :Tags<CR>
let g:fzf_layout = {
 \ 'window': {
 \      'width': 1.0,
 \       'height': 0.50,
 \       'relative': v:true,
 \       'yoffset': 1.0,
 \       'border': 'top'
 \       }
 \   }
let g:fzf_preview_window = ['right']


command! -bang -nargs=* Rg
  \ call fzf#vim#grep(
  \ 'rg '
  \ . '--line-number '
  \ . '--no-heading '
  \ . '--color=always '
  \ . '--colors=match:fg:green '
  \ . '--colors=line:fg:blue '
  \ . '--colors=column:fg:white '
  \ . '--colors=path:fg:cyan '
  \ . '--smart-case '
  \ . '-- '.shellescape(<q-args>), 1,
  \   fzf#vim#with_preview(), <bang>0)

" AIRLINE
let g:airline_theme = 'nord'
let g:airline_unicode_fonts = 1
let g:airline#extensions#whitespace#enabled = 0
let g:airline#extensions#ale#enabled = 1
let g:airline_symbols = {}
let g:airline_symbols.branch = 'שׂ'
let g:airline_symbols.linenr = ' ln: '
let g:airline_symbols.colnr = ' col: '
let g:airline_symbols.maxlinenr = ''
let g:airline_symbols.notexists = '?'
let g:airline_symbols.dirty = '!'

" COMMENTARY
noremap <leader>c :Commentary<CR>

" NETRW
nnoremap <leader>e :Explore<CR>
let g:netrw_banner = 0

" OmniSharp
let g:OmniSharp_selector_ui = 'fzf'

" COC
" apt install clang clangd
" python3 -m pip install mypy python-language-server pyls-mypy
" autocmd BufWritePost *.cpp,*.h,*.c silent !ctags -R " autowrite ctags...
let g:clang_library_path = '/usr/lib/llvm-13/lib/libclang.so.1'
inoremap <expr> <Tab> pumvisible() ? "\<C-n>" : "\<Tab>"
inoremap <expr> <S-Tab> pumvisible() ? "\<C-p>" : "\<S-Tab>"
nmap <silent> <leader>g <Plug>(coc-definition)
nmap <silent> <leader>d :call <SID>show_documentation()<CR>

function! s:show_documentation()
  if (index(['vim','help'], &filetype) >= 0)
    execute 'h '.expand('<cword>')
  elseif (coc#rpc#ready())
    call CocActionAsync('doHover')
  else
    execute '!' . &keywordprg . " " . expand('<cword>')
  endif
endfunction

" Highlight the symbol and its references when holding the cursor.
autocmd CursorHold * silent call CocActionAsync('highlight')

function! FancyScreenDown()
    let l:start_line = line('.')
    normal! L
    let l:end_line = line('.')
    if start_line == end_line
        normal! zt
    endif
endfunction
nnoremap <silent> L :call FancyScreenDown()<CR>

function! FancyScreenUp()
    let l:start_line = line('.')
    normal! H
    let l:end_line = line('.')
    if start_line == end_line
        normal! zb
    endif
endfunction
nnoremap <silent> H :call FancyScreenUp()<CR>

function! TrimWhitespace()
    let l:line = line('.')
    let l:save = winsaveview()
    if expand('%:t:r') != ".vimrc"
        keeppatterns %s/\s\+$//e
        call setcharpos('.', [0, l:line, 1, 0])
    endif
    call winrestview(l:save)
endfunction
autocmd BufWritePre * :call TrimWhitespace()

" Specific Mappings
function! NetrwMapping()
    nmap <buffer> h -^
    nmap <buffer> l <CR>
    nmap <buffer> I gh
endfunction

augroup netrw_mapping
    autocmd!
    autocmd filetype netrw call NetrwMapping()
augroup END


function! CSMapping()
    nmap <buffer> <leader>g :OmniSharpGotoDefinition<CR>
    nmap <buffer> <leader>d :OmniSharpDocumentation<CR>
    nmap <buffer> <leader>a :OmniSharpCodeActions<CR>
endfunction

augroup cs_mapping
    autocmd!
    autocmd filetype cs call CSMapping()
augroup END

" Theme is not set so yu don't get an error when first opening VIM.
" This is important in install scripts.
" To set the Nordtheme, add the following line: 'colorscheme nord'
