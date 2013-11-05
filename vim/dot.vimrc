" nice colors
syntax on
set bg=dark
" easy coding prefs
set autoindent
set nomodeline

" since autoindent and paste don't mix
" rather bind a key to toggle pasting
set pastetoggle=<F12>

" use :set list to show invisibles
set listchars=eol:$,tab:>-,trail:~,extends:>,precedes:<

" whitespace prefs
set smartindent
set tabstop=4
set shiftwidth=4

" php syntax check
au BufWritePost *.php !php -l %
