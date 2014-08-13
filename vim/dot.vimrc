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

" use :set list to show invisibles
set listchars=eol:$,tab:>-,trail:~,extends:>,precedes:<
" show trailing whitespace
highlight TrailingWhitespace ctermbg=red guibg=red
match TrailingWhitespace /\s\+$/

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

" stop the "Can't open file for writing" rages
cnoremap sudow w !sudo tee % >/dev/null

"" syntax check wrapper
au BufWritePost * !~/.vimchk -f %

"" php handling
" before writing, remove trailing whitespace
au BufWritePre *.php :%s/\s\+$//e

"" puppet handling
" set filetype to puppet
au BufRead,BufNewFile *.pp setfiletype puppet
" alter whitespace handling
au FileType puppet setlocal tabstop=2 softtabstop=2 shiftwidth=2
" before writing, remove trailing whitespace
au BufWritePre *.pp :%s/\s\+$//e

"" python handling
" don't expand tabs in python plz
au Filetype python setlocal noexpandtab

"" yaml handling
" alter whitespace handling
au FileType yaml setlocal tabstop=2 softtabstop=2 shiftwidth=2
