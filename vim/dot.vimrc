" syntax and auto indenting
syntax on
set bg=dark
set autoindent
set nomodeline

" since autoindent and paste don't mix
" rather bind a key to toggle pasting
set pastetoggle=<F12>

" use :set list to show invisibles
set listchars=eol:$,tab:>-,trail:~,extends:>,precedes:<
" show trailing whitespace
highlight TrailingWhitespace ctermbg=red guibg=red
match TrailingWhitespace /\s\+$/

" whitespace handling
set smartindent
set tabstop=4
set softtabstop=4
set shiftwidth=4
" rather spaces than tabs
set expandtab

" php syntax check
au BufWritePost *.php !php -l %

"" puppet handling
" set filetype to puppet
au BufRead,BufNewFile *.pp setfiletype puppet
" before writing, remove trailing whitespace
au BufWritePre *.pp :%s/\s\+$//e
" after writing, parse file for validation
au BufWritePost *.pp !puppet parser validate %
