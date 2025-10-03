" -- functions -- "

"" toggle iwhite option in diffopt
function! ToggleIWhite()
  if &diffopt =~ "iwhite"
      set diffopt-=iwhite
  else
      set diffopt+=iwhite
  endif
endfunction

"" toggle displaying numbers and signs
function! ToggleGutter()
  set number!
  if &number == 1
    call UpdateDiffSigns()
  else
    sign unplace *
  endif
endfunction

"" base statusline color on editing mode
function! UpdateStatuslineColor(mode)
  " insert or replace mode
  if a:mode == 'i' || a:mode == 'r'
    hi statusline ctermbg=red ctermfg=black cterm=none
  else
    call ResetStatuslineColor()
  endif
endfunction

"" reset statusline color to default
function! ResetStatuslineColor()
  hi statusline ctermbg=black ctermfg=grey cterm=underline
endfunction

"" update diff signs
"" relevant parts stolen from vim-signify
function! UpdateDiffSigns()
  " check if file is tracked by git
  if !exists("g:sign_id")
    let l:discard = system(printf('git ls-files %s --error-unmatch', expand('%.p')))
    if v:shell_error != 0
      " mark we won't be using diff signs
      let g:no_diff_sign = 1
    endif
  endif

  " don't run git on every write if this file is not
  " tracked by git anyway
  if exists("g:no_diff_sign") && g:no_diff_sign == 1
    return
  endif

  " make sure the sign column is always shown
  execute printf('sign place %d line=%d name=ForceSignColumn file=%s', 999999, 1, expand('%.p'))
  " remove all other signs
  if exists("g:sign_id")
    while g:sign_id > 0
      let g:sign_id -= 1
      execute printf('sign unplace %d', g:sign_id)
    endwhile
  endif

  " place new signs
  let g:sign_id = 1
  let diff = system(printf('git diff --no-color --no-ext-diff -U0 -- %s', expand('%.p')))
  for line in filter(split(diff, '\n'), 'v:val =~ "^@@ "')
    let tokens = matchlist(line, '^@@ -\v(\d+),?(\d*) \+(\d+),?(\d*)')

    let old_line = str2nr(tokens[1])
    let new_line = str2nr(tokens[3])

    let old_count = empty(tokens[2]) ? 1 : str2nr(tokens[2])
    let new_count = empty(tokens[4]) ? 1 : str2nr(tokens[4])

    " 2 lines added:

    " @@ -5,0 +6,2 @@ this is line 5
    " +this is line 5
    " +this is line 5
    if (old_count == 0) && (new_count >= 1)
      let offset = 0
      while offset < new_count
        let line    = new_line + offset
        let offset += 1
        execute printf('sign place %d line=%d name=DiffAdd file=%s', g:sign_id, line, expand('%.p'))
        let g:sign_id += 1
      endwhile

    " 2 lines changed:

    " @@ -5,2 +5,2 @@ this is line 4
    " -this is line 5
    " -this is line 6
    " +this os line 5
    " +this os line 6
    elseif old_count == new_count
      let offset    = 0
      while offset < new_count
        let line    = new_line + offset
        let offset += 1
        execute printf('sign place %d line=%d name=DiffChange file=%s', g:sign_id, line, expand('%.p'))
        let g:sign_id += 1
      endwhile
    else

      " 2 lines changed; 2 lines removed:

      " @@ -5,4 +5,2 @@ this is line 4
      " -this is line 5
      " -this is line 6
      " -this is line 7
      " -this is line 8
      " +this os line 5
      " +this os line 6
      if old_count > new_count
        let offset    = 0
        while offset < new_count - 1
          let line    = new_line + offset
          let offset += 1
          execute printf('sign place %d line=%d name=DiffChange file=%s', g:sign_id, line, expand('%.p'))
          let g:sign_id += 1
        endwhile

      " lines changed and added:

      " @@ -5 +5,3 @@ this is line 4
      " -this is line 5
      " +this os line 5
      " +this is line 42
      " +this is line 666
      else
        let offset    = 0
        while offset < old_count
          let line    = new_line + offset
          let offset += 1
          execute printf('sign place %d line=%d name=DiffChange file=%s', g:sign_id, line, expand('%.p'))
          let g:sign_id += 1
        endwhile
        while offset < new_count
          let line    = new_line + offset
          let offset += 1
          execute printf('sign place %d line=%d name=DiffAdd file=%s', g:sign_id, line, expand('%.p'))
          let g:sign_id += 1
        endwhile
      endif
    endif
  endfor
endfunction

" -- settings -- "
" syntax and auto indenting
syntax on
set bg=dark
colorscheme slate
set autoindent
set nomodeline
" enable true color if available
if exists('+termguicolors')
  set termguicolors
endif

" easily find files
set path=**
set wildmenu
" open files in new tab
nmap <C-T> :tabfind<Space>

" since autoindent and paste don't mix
" rather bind a key to toggle pasting
set pastetoggle=<F12>

" show line numbers
set number
" add shortkey for toggling numbers
nnoremap <F9> :call ToggleGutter()<cr>

" highlight current line
set cursorline

" show line/progress at bottom right
set ruler
set laststatus=2

" show tab line, even on 1 tab
set showtabline=2
" set up easily moving through tabs
nnoremap < :tabp<cr>
nnoremap > :tabn<cr>

" use :set list to show invisibles
set listchars=eol:$,tab:>-,trail:~,extends:>,precedes:<
" show trailing whitespace
highlight TrailingWhitespace ctermbg=red guibg=red
match TrailingWhitespace /\s\+$/
" add shortkey for toggling listchars
nnoremap <F11> :set list!<cr>

" vimdiff options
if &diff
" add shortkey for diffupdate
  nnoremap <F5> :diffupdate<cr>
" add shortkey for toggling whitespace
  nnoremap <F12> :call ToggleIWhite()<cr>
endif

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

" 80 chars marker
set colorcolumn=80

" please no mouse handling
set mouse=

" stop the "Can't open file for writing" rages
cnoremap sudow w !sudo tee % >/dev/null

"" on opening a file, set cursor to last known position
au BufReadPost * if line("'\"") | exe "'\"" | endif

"" php config
" before writing, remove trailing whitespace
au BufWritePre *.php :Rtrim

"" puppet config
" set filetype to puppet
au BufRead,BufNewFile *.pp setfiletype puppet
" alter whitespace handling
au FileType puppet setlocal tabstop=2 softtabstop=2 shiftwidth=2
" before writing, remove trailing whitespace
au BufWritePre *.pp :Rtrim

"" python config
" don't expand tabs in python plz
au Filetype python setlocal noexpandtab

"" yaml config
" alter whitespace handling
" disabling cursorline is a major performance increase
au FileType yaml setlocal tabstop=2 softtabstop=2 shiftwidth=2 nocursorline

""" Makefile config
" don't expand tabs in Makefiles plz
au FileType make setlocal noexpandtab

au InsertEnter * call UpdateStatuslineColor(v:insertmode)
au InsertChange * call UpdateStatuslineColor(v:insertmode)
au InsertLeave * call ResetStatuslineColor()

" set to default colors when entering Vim
call ResetStatuslineColor()

" show signs for lines with git diffs
if has('signs') && ! &diff
  highlight SignColumn ctermbg=black
  highlight DiffAdd ctermfg=darkgreen ctermbg=black
  highlight DiffChange ctermfg=darkyellow ctermbg=black
  sign define DiffAdd text=+ texthl=DiffAdd linehl=
  sign define DiffChange text=! texthl=DiffChange linehl=

  " dummy sign to force sign column is always shown
  sign define ForceSignColumn

  " set diff signs
  call UpdateDiffSigns()
  " and update on write
  au BufWritePost * :call UpdateDiffSigns()
endif
