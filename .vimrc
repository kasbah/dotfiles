set nocompatible
set autoindent
"set expandtab
"set smartindent
set tabstop=2
set shiftwidth=2
set softtabstop=2

"syntax colouring
syntax enable 
set mouse=a

"auto indenting enable
filetype indent on

"toggle search highlight
"map <silent> <F2> :set invhlsearch<CR>

"paste mode buttons
"toggle with F3, unset and insert with S-i 
"and set and insert with Ins
:set pastetoggle=<F3>
nmap <S-i> :set nopaste<CR>i
nmap <Ins> :set paste<CR>i

nnoremap <F4> :call ToggleMouse()<CR>
function! ToggleMouse()
  if &mouse == 'a'
    set mouse=
    echo "Mouse usage disabled"
  else
    set mouse=a
    echo "Mouse usage enabled"
  endif
endfunction

" Only do this part when compiled with support for autocommands.

if has("autocmd")

  " Enable file type detection.
  " Use the default filetype settings, so that mail gets 'tw' set to 72,
  " 'cindent' is on in C files, etc.
  " Also load indent files, to automatically do language-dependent indenting.

  filetype plugin indent on

  " Put these in an autocmd group, so that we can delete them easily.
  augroup vimrcEx
  au!

  " For all text files set 'textwidth' to 78 characters.
  autocmd FileType text setlocal textwidth=78
 
  " When editing a file, always jump to the last known cursor position.
  " Don't do it when the position is invalid or when inside an event handler
  " (happens when dropping a file on gvim).
  " Also don't do it when the mark is in the first line, that is the default
  " position when opening a file.
  autocmd BufReadPost *
    \ if line("'\"") > 1 && line("'\"") <= line("$") |
    \   exe "normal! g`\"" |
    \ endif

  augroup END
endif " has("autocmd")

"toggle ignorecase for search
nmap <F2> :set ignorecase!<CR>:set ignorecase?<CR>
set smartcase

"search replace
"nmap <Bslash> :%s/

"glsl syntax highlighting
au BufNewFile,BufRead *.frag,*.vert,*.fp,*.vp,*.glsl setf glsl

" Ctrl-j/k deletes blank line below/above, and Alt-j/k inserts.
"nnoremap <silent><C-j> m`:silent +g/\m^\s*$/d<CR>``:noh<CR>
"nnoremap <silent><C-k> m`:silent -g/\m^\s*$/d<CR>``:noh<CR>
"nnoremap <silent><C-k> :set paste<CR>m`o<Esc>``:set nopaste<CR>
"nnoremap <silent><C-k> m`:silent -g/\m^\s*$/d<CR>``:noh<CR>
"scroll without moving cursor
set nocompatible
let g:C_Ctrl_j =0 
autocmd FileType * nmap <silent><C-j> <C-e>
nmap <silent><C-k> <C-y>

"omnifunc autocomplete
autocmd FileType python set omnifunc=pythoncomplete#Complete
autocmd FileType javascript set omnifunc=javascriptcomplete#CompleteJS
autocmd FileType html set omnifunc=htmlcomplete#CompleteTags
autocmd FileType css set omnifunc=csscomplete#CompleteCSS
autocmd FileType xml set omnifunc=xmlcomplete#CompleteTags
autocmd FileType php set omnifunc=phpcomplete#CompletePHP
autocmd FileType c set omnifunc=ccomplete#Complete

autocmd FileType tex set makeprg=make

vmap <C-c> "+y     " Yank current selection into system clipboard
nmap <C-c> "+Y     " Yank current line into system clipboard (if nothing is selected)
nmap <C-n> <C-q>
nmap <C-v> "+p

au FileType haskell,vhdl,ada let b:comment_leader = '-- '
au FileType vim let b:comment_leader = '" '
au FileType c,cpp,java let b:comment_leader = '// '
au FileType sh,make let b:comment_leader = '# '
au FileType tex let b:comment_leader = '% '
noremap <silent> ,c :<C-B>sil <C-E>s/^/<C-R>=escape(b:comment_leader,'\/')<CR>/<CR>:noh<CR>
noremap <silent> ,u :<C-B>sil <C-E>s/^\V<C-R>=escape(b:comment_leader,'\/')<CR>//e<CR>:noh<CR>
" for VHDL taglist
let g:tlist_vhdl_settings   = 'vhdl;d:package declarations;b:package bodies;e:entities;a:architecture specifications;t:type declarations;p:processes;f:functions;r:procedures'

filetype plugin indent on
set grepprg=grep\ -nH\ $*
let g:tex_flavor = "latex"

set runtimepath=~/.vim,$VIM/vimfiles,$VIMRUNTIME,$VIM/vimfiles/after,~/.vim/after

"latex auto compile on save
au BufWritePost *.tex silent call Tex_CompileLatex()
au BufWritePost *.tex silent !pkill -USR1 xdvi.bin

"yaml syntax
"au BufNewFile,BufRead *.yaml,*.yml so ~/.vim/syntax/yaml.vim
au BufNewFile,BufRead *.yaml,*.yml,*yaml.st set syntax=yaml

"pandoc syntax
au! Bufread,BufNewFile *.pdc,*.page,*.html.st    set filetype=pdc

"CTRL -Z
imap <C-z> <ESC> <C-z> 

"jquery syntax
au BufRead,BufNewFile jquery.*.js set ft=javascript syntax=jquery

"disable auto complete comments on next line
au FileType * set fo-=c fo-=o fo-=r

au BufRead,BufNewFile *.cg set ft=Cg

colorscheme wombat256

"Omnicompletion 

filetype plugin on
set ofu=syntaxcomplete#Complete

"ctags for system libraries
"set tags+=/usr/include/tags

"for switching
set hidden

"gf modifciations
"search recursively downwards from current pathwhite
set path+=./**
"rebind gF to create file
:nnoremap gF :edit <cfile><cr>

"expand tabs to spaces
set expandtab

"switch buffers with arrow keys
nmap <silent><Left> :bprevious <cr>
nmap <silent><Right> :bnext <cr>
nmap <silent><Down> <C-w>s :bprevious <cr>
nmap <silent><Up> <C-w>s :bnext <cr>
