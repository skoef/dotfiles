" syntax and auto indenting
syntax on
set bg=dark
set autoindent
set nomodeline

" since autoindent and paste don't mix
" rather bind a key to toggle pasting
set pastetoggle=<F12>

" highlight current line
set cursorline
hi CursorLine cterm=NONE ctermbg=235 guibg=#262626

" show line/progress at bottom right
set ruler
set laststatus=2

" use :set list to show invisibles
set listchars=eol:$,tab:>-,trail:~,extends:>,precedes:<
" show trailing whitespace
highlight TrailingWhitespace ctermbg=red guibg=red
match TrailingWhitespace /\s\+$/
" add shortkey for toggling listchars
nnoremap <F11> :set list!<cr>

" enable 'smart' indenting
set smartindent
" don't mess with the hash
inoremap # X<BS>#

" whitespace handling
set tabstop=4
set softtabstop=4
set shiftwidth=4
" rather spaces than tabs
set expandtab
command Rtrim :%s/\s\+$//e

" please no mouse handling
set mouse=

" stop the "Can't open file for writing" rages
cnoremap sudow w !sudo tee % >/dev/null

"" on opening a file, set cursor to last known position
au BufReadPost * if line("'\"") | exe "'\"" | endif

"" syntax check wrapper
au BufWritePost * !~/.vimchk -f %

"" php handling
" before writing, remove trailing whitespace
au BufWritePre *.php :Rtrim

"" puppet handling
" set filetype to puppet
au BufRead,BufNewFile *.pp setfiletype puppet
" alter whitespace handling
au FileType puppet setlocal tabstop=2 softtabstop=2 shiftwidth=2
" before writing, remove trailing whitespace
au BufWritePre *.pp :Rtrim

"" python handling
" don't expand tabs in python plz
au Filetype python setlocal noexpandtab

"" yaml handling
" alter whitespace handling
" disabling cursorline is a major performance increase
au FileType yaml setlocal tabstop=2 softtabstop=2 shiftwidth=2 nocursorline

""" Makefile handling
" don't expand tabs in Makefiles plz
au FileType make setlocal noexpandtab
