let mapleader=","
"movement keys
let g:C_Ctrl_j = 'off'
let g:IMAP_JumpForward = 'off'
imap <C-space> <Plug>IMAP_JumpForward
noremap <C-j> <C-w>j
noremap <C-k> <C-w>k
noremap <C-h> <C-w>h
noremap <C-l> <C-w>l

"auto resize split windows on terminal resize
au VimResized * wincmd =

"tell grep to ignore binaries (-I)
set grepprg=grep\ -nI\ $*\ /dev/null

set nocompatible
"set autoindent
set expandtab
"set cindent
set tabstop=4
set shiftwidth=4
set softtabstop=4

"syntax colouring
syntax enable 
set mouse=a

"auto indenting enable
filetype indent on

"ftplugin enable
filetype plugin on


"xml syntax folding
let g:xml_syntax_folding=1
au FileType xml setlocal foldmethod=syntax



"toggle search highlight
"map <silent> <F2> :set invhlsearch<CR>

"paste mode buttons
"toggle with F3, unset and insert with S-i 
"and set and insert with Ins
:set pastetoggle=<F3>
nmap <S-i> :set nopaste<CR>i
nmap <Ins> :set paste<CR>i

nnoremap <F4> :call ToggleMouse()<CR>
nnoremap <F5> :set cursorcolumn! cursorline!<CR>
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
"set nocompatible
"let g:C_Ctrl_j =0 
"autocmd FileType * nmap <silent><C-j> <C-e>
"nmap <silent><C-k> <C-y>

"omnifunc autocomplete
"autocmd FileType python set omnifunc=pythoncomplete#Complete
"autocmd FileType javascript set omnifunc=javascriptcomplete#CompleteJS
"autocmd FileType html set omnifunc=htmlcomplete#CompleteTags
"autocmd FileType css set omnifunc=csscomplete#CompleteCSS
"autocmd FileType xml set omnifunc=xmlcomplete#CompleteTags
"autocmd FileType php set omnifunc=phpcomplete#CompletePHP
"autocmd FileType c set omnifunc=ccomplete#Complete

"Yank current selection into system clipboard
"Yank current line into system clipboard (if nothing is selected)

vmap <C-c> "+y     
"nmap <C-c> "+Y     
nmap <C-n> <C-q>
nmap <C-v> "+p


"au FileType haskell,vhdl,ada let b:comment_leader = '-- '
"au FileType vim let b:comment_leader = '" '
"au FileType c,cpp,java let b:comment_leader = '// '
"au FileType sh,make let b:comment_leader = '# '
"au FileType tex let b:comment_leader = '% '
"noremap <silent> ,c :<C-B>sil <C-E>s/^/<C-R>=escape(b:comment_leader,'\/')<CR>/<CR>:noh<CR>
"noremap <silent> ,u :<C-B>sil <C-E>s/^\V<C-R>=escape(b:comment_leader,'\/')<CR>//e<CR>:noh<CR>
" for VHDL taglist
"let g:tlist_vhdl_settings   = 'vhdl;d:package declarations;b:package bodies;e:entities;a:architecture specifications;t:type declarations;p:processes;f:functions;r:procedures'

"latexsuite settings
"filetype plugin indent on
"set grepprg=grep\ -nH\ $*
"let g:tex_flavor = \"latex"
"let g:Tex_CompileRule_pdf = 'pdflatex --synctex=1 -interaction=nonstopmode $*'
"let g:Tex_DefaultTargetFormat = 'pdf'
"let g:Tex_ViewRule_pdf = 'evince'
"autocmd FileType tex set makeprg=make
"let g:Tex_UseMakefile = 1
"nmap \ll \ll :cclose

"required for omnicompletion?
"set runtimepath=~/.vim,$VIM/vimfiles,$VIMRUNTIME,$VIM/vimfiles/after,~/.vim/after

"latex auto compile on save
"au BufWritePost *.tex silent call Tex_CompileLatex()
"au BufWritePost *.tex silent !pkill -USR1 xdvi.bin

"yaml syntax
"au BufNewFile,BufRead *.yaml,*.yml so ~/.vim/syntax/yaml.vim
au BufNewFile,BufRead *.yaml,*.yml,*yaml.st set syntax=yaml

"pandoc syntax
au! Bufread,BufNewFile *.pdc  set filetype=pdc
"markdown syntax
"au! Bufread,BufNewFile .page,*.st    set filetype=mkd

"CTRL -Z
imap <C-z> <ESC> <C-z> 

"jquery syntax
au BufRead,BufNewFile jquery.*.js set ft=javascript syntax=jquery

"disable auto complete comments on next line
au FileType * set fo-=c fo-=o fo-=r

au BufRead,BufNewFile *.cg set ft=Cg


"Omnicompletion 

"filetype plugin on
"set ofu=syntaxcomplete#Complete
"set complete-=i

"ctags for system libraries
"set tags+=/usr/include/tags

"for switching
set hidden

"gf modifciations
"search recursively downwards from current pathwhite
"set path+=./**
"rebind gF to create file
nnoremap gF :edit <cfile><cr>
set background=dark
"let g:solarized_termcolors=256
colorscheme soruby
"colorscheme print_bw

nnoremap gl vi[:s/ /_/gf]i.wikiyi]u:edit <C-r><C-r>0<cr>
"nnoremap gl :edit <C-r><C-r>0<cr>

"expand tabs to spaces
"set expandtab

"switch buffers with arrow keys
nmap <silent><Left> :bprevious <cr>
nmap <silent><Right> :bnext <cr>
"nmap <silent><Down> <C-w>s :bprevious <cr>
"nmap <silent><Up> <C-w>s :bnext <cr>

"chuck syntax highlighting
au BufNewFile,BufRead *.ck          setf ck 

function! PrettyXML()
" save the filetype so we can restore it later
let l:origft = &ft
set ft=
" delete the xml header if it exists. This will
" permit us to surround the document with fake tags
" without creating invalid xml.
1s/<?xml .*?>//e
" insert fake tags around the entire document.
" This will permit us to pretty-format excerpts of
" XML that may contain multiple top-level elements.
0put ='<PrettyXML>'
$put ='</PrettyXML>'
silent %!xmllint --format -
" xmllint will insert an <?xml?> header. it's easy enough to delete
" if you don't want it.
" delete the fake tags
2d
$d
" restore the 'normal' indentation, which is one extra level
" too deep due to the extra tags we wrapped around the document.
silent %<
" back to home
1
" restore the filetype
exe "set ft=" . l:origft
endfunction
command! PrettyXML call PrettyXML()

"xmos xc syntax highlighting
au BufNewFile,BufRead *.xc setf xc

"creole syntax highlighting
au BufNewFile,BufRead *.wiki set syntax=creole
au BufNewFile,BufRead *.cr set syntax=creole

"arduino syntax highlighting
au BufNewFile,BufRead *.pde setf arduino
au BufNewFile,BufRead *.ino setf arduino

"graphviz dot language highlighting
au BufNewFile,BufRead *.gv setf dot

"invokes sudo 
command W w !sudo tee % > /dev/null

command HT hi Tab ctermbg=blue
command NHT hi Tab ctermbg=NONE

let g:ropevim_vim_completion=1
let g:ropevim_extended_complete=1

au FileType python inoremap <expr> <S-Space> '<C-r>=RopeCodeAssistInsertMode()<CR><C-r>=pumvisible() ? "\<lt>C-p>\<lt>Down>" : ""<CR>'

"FLTK treat as cpp
au BufNewFile,BufRead *.fl set ft=cpp

"python << EOF
"import os
"import sys
"import vim
"for p in sys.path:
"    if os.path.isdir(p):
"        vim.command(r"set path+=%s" % (p.replace(" ", r"\ ")))
"EOF

"swig syntax highlighting
au BufNewFile,BufRead *.i set filetype=swig
au BufNewFile,BufRead *.swg set filetype=swig

"use the anonymous register
"allowing y and p across vim instances
set clipboard=unnamed

call pathogen#infect()
