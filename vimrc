" wersja oryginalna (silk)
call pathogen#runtime_append_all_bundles() 
filetype off
filetype plugin indent on

set nocompatible    " chcemy vim'a a nie vi

set modelines=2

set backspace=indent,eol,start  " BS kasuje wciecia, konce lini i cos tam jeszcze ;)

set mouse=a                     " oczywisice myszka jest uzyteczna

set confirm                     " Ask for confirmation rather then refuse certain commands
set smartindent                  " always set smartindenting on
set autoindent
set nobackup                    " do not keep a backup file, use versions instead
set history=50                  " keep 50 lines of command line history
set ruler                       " show the cursor position all the time
set showcmd                     " display incomplete commands
set incsearch                   " do incremental searching
set noexpandtab                   " spacje zamiast tabow
set shiftwidth=4                " dlugosc wciec
set tabstop=4                   " ile znakow ma tab
set softtabstop=4               " BS traktuje 4 spacje jak tab
set scrolloff=3                 " ile linni przed koncem ekranu zaczynamy przewijanie = ile lini przed/po aktualniej zawsze widac
"set listchars=tab:>-                " wyswietlaj tabulatory, w formacie ">---"
"set list                         wlacza to wyzej, mozna wywalic, to nie bedzie wyswietlac
" set showbreak=>>                "  String to put at the start of lines that have been wrapped
set nowrap                      " nie zawijaj wierszy
set number                      " numery wierszy z lewej
set showmatch                   " When a bracket is inserted, briefly jump to the matching one
set foldenable                  " umozlwia zwijanie (folding)
set splitbelow                  "  Create new window below current one
set previewheight=6                 " wysokosc okienka do podgladu
set title                       " wstawia nazwe edytowanego pliku do nazwy okna (xterm, putty, etc.)

set lazyredraw                  "  Don't update screen while executing macros
set laststatus=2                "  Always show statusbar

set formatoptions-=l
set shortmess+=I

set rulerformat=%l,%c%V%=#%n\ %3p%%         " Content of the ruler string
set switchbuf=useopen,split  " Method of opening file in quickfix


syntax on                       " wlacza kolorowanie skladni
set hlsearch                    " wlacza kolorowanie przy szukaniu
"colorscheme elflord             " schemat kolorkow, jest tez duzo innych

" wlacza automatyczne robienie wciec na podstawie typu pliku

" dla plikow tekstowych wlacza zawijanie wiersz po 78 znaku
autocmd FileType text setlocal textwidth=78

" nie pamietam :)
autocmd BufReadPost *
    \ if line("'\"") > 0 && line("'\"") <= line("$") |
    \   exe "normal g`\"" |
    \ endif

" laduje plugin Man - "K" uruchamia man dla wyrazu pod kursorem
source $VIMRUNTIME/ftplugin/man.vim

" ***************
"  Abbreviations
" ***************
"  Some C abbreviations
iab  Zmain  int main(int argc, char *argv[])<CR>{<CR>}<Up><CR><CR>return 0;<Up>
iab  Zinc  #include
iab  Zdef  #define
"  Some other abbreviations
iab  Zdate  <C-R>=strftime("%y%m%d")<CR>
iab  Ztime  <C-R>=strftime("%H:%M:%S")<CR>
iab  Zfilename <C-R>=expand("%:t:r")<CR>
iab  Zfilepath <C-R>=expand("%:p")<CR>
" ***************
"  Skroty
" ***************

" F11 wlacza i wylacza tryb paste

set pastetoggle=<F11>
set wmh=0
map <C-J> <C-W>j<C-W>_
map <C-K> <C-W>k<C-W>_
map <C-H> :tabprevious<CR>
imap <C-H> <ESC>:tabprevious<CR>
map <C-L> :tabnext<CR>
imap <C-L> <ESC>:tabnext<CR>
map <C-C> <C-W>c
"make + bledy
nmap <F5> :cnext<CR>
imap <F5> <ESC>:cnext<CR>
nmap <F6> :cprevious<CR>
imap <F6> <ESC>:cprevious<CR>
nmap <F7> :!php -l %<CR>
imap <F7> <ESC>:php -l %<CR>
" F8 uruchamia make w aktualnym katalogu
":command -nargs=* Make make <args> | cwindow 3
:command -nargs=* Make make<args>
map <F8> :Make -j4<CR>
map <silent> <F9> :NERDTreeToggle<CR>
imap <silent> <F9> <ESC>:NERDTreeToggle<CR>
map  <silent> <F10> :TlistToggle<CR>
imap <silent> <F10> <ESC>:TalistToggle<CR>
" nmap <F12> :call SwitchPaste()<CR>
" imap <F12> <ESC>:call SwitchPaste()<CR>
nmap <F12> :call SwitchMouse()<CR>
imap <F12> <ESC>:call SwitchMouse()<CR>
map <F4> :set nu! <CR>
map <F3> :set hls!<bar>set hls?<CR>
:map gf <C-W><C-F><C-W>_

" ***************
"  Funkcje
" ***************

" function used to switch mouse on and off
function SwitchMouse()
 if &mouse == "a"
  set mouse=
  echo "Mouse OFF"
 else
  set mouse=a
  echo "Mouse ON"
 endif
endfunction

" auto H headers guarding in new files
function! s:insert_gates()
    let gatename = "__" . substitute(toupper(expand("%:t")), "\\.", "_", "g") . "__"
    execute "normal i#ifndef " . gatename
    execute "normal o#define " . gatename . "   "
    execute "normal 2o"
    execute "normal Go#endif /* " . gatename . " */"
    normal kk
endfunction
autocmd  BufNewFile *.{h,hpp} call <SID>insert_gates() 

" appropiate MAN pages
" if we are in C/C++ file set browsed man sections to useful for programmist,
" if we are in SH/CSH file - set sections to useful for script-writter
autocmd FileType c,cpp  let $MANSECT="2:3:7:4"
autocmd FileType sh,csh let $MANSECT="1:5:8:4"

set tags+=~/.vim/systags
set dictionary+=~/.vim/dictionary/tex_dict

" taken from Damien Conway, after OSCON2008 presentation
"""""""""""""""""""""""""""""""""""""""""""""""""""""""
"""""""""""""""""""""""""""""""""""""""""""""""""""""""



nnoremap v <C-V>
nnoremap <C-V> v

" Make BS/DEL work as expected in visual modes
vmap <BS> x

" Forward/back one file
"""""""""""""""""""""""""""""""""""""""""""""""""""""""

" Execute current paragraph or visual block as Vimmish commands...

vmap <silent> <C-E> :<C-U>'<,'>! cheddar<CR>
" map <C-M> :%! headache<CR>
map <silent> =e :call DemoCommand()<CR>
vmap <silent> =e :<C-U>call DemoCommand(1)<CR>

highlight WHITE_ON_RED    ctermfg=white  ctermbg=red

function! DemoCommand (...)
     " Cache current state info...
     let orig_buffer = getline('w0','w$')
     let orig_match  = matcharg(1)

     " Grab either visual blocj (if a:0) or else current para...
     if a:0
         let @@ = join(getline("'<","'>"), "\n")
     else
         silent normal vipy
     endif

     " Highlight the selected text using match #1...
     "match WHITE_ON_RED /\%V/
     redraw
     sleep 500m

     " Join up \-continued lines...
     execute substitute(@@, '\n\s*\\', ' ', 'g')

     " Redraw if screen got messed up...
     if getline('w0','w$') != orig_buffer
         redraw
         sleep 1000m
     endif

     " Restore previous match #1 state...
     "if strlen(orig_match[0])
     "    execute 'match ' . orig_match[0] . ' /' . orig_match[1] . '/'
     "else
     "    match none
     "endif
endfunction

""" smart TAB, completes code or indents code *****************

function! TabOrCompletion()
	let c = col('.') - 1
	if c==0 || getline('.')[c - 1] !~ '\k'
		return "\<TAB>"
	else
		return "\<C-N>"
	endif
endfunction

function! HelloWorld()
	return "hello world"
endfunction

"inoremap <expr> <TAB> TabOrCompletion()

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""


""" display help in tabs *****************

"augroup HelpInTabs
"	au!
"	au BufEnter *.txt if &buftype == 'help'
"	au BufEnter *.txt    normal ^WT
"	au BufEnter *.txt endif
"	au BufEnter *.txt cmap hhh helpg
"augroup END

"seems to doesn't work :((

"""""""""""""""""""""""""*****************

function! CommasToBullets()
perl <<END_PERL
	($line) = $curwin->Cursor;
	$curbuf->Append($line, map "\t* $_",
				map { /^\s*(.*?)\s*$/ ? $1 : $_ }
					split /,\s*/,
						$curbuf->Get($line));
	$curbuf->Delete($line);
END_PERL
endfunction

"function! SwitchNERDTree()
"	:NERDTreeToggle
"endfunction
"
"function! SwitchTagList()
"	:TlistToggle
"endfunction

nmap =b :call CommasToBullets()<CR><CR>

"http://cloudhead.io/2010/04/24/staying-the-hell-out-of-insert-mode/
inoremap kj <Esc>



set t_Co=256                                                                                                       
autocmd VimEnter * :GuiColorScheme dw_green

" omni completion
autocmd FileType c set omnifunc=ccomplete#Complete
autocmd FileType php set omnifunc=phpcomplete#CompletePHP

" file type specifics
au BufRead,BufNewFile *.go set filetype=go
autocmd BufNewFile  *.go	0r ~/.vim/skel/skeleton.go
autocmd BufRead,BufNewFile,BufEnter *.go source ~/.vim/ftype/go.vim

autocmd BufNewFile  *.py	0r ~/.vim/skel/skeleton.py
autocmd BufRead,BufNewFile,BufEnter *.py source ~/.vim/ftype/py.vim

autocmd BufNewFile  *.php	0r ~/.vim/skel/skeleton.php
autocmd BufRead,BufNewFile,BufEnter *.php source ~/.vim/ftype/php.vim

autocmd BufRead,BufNewFile,BufEnter *.c source ~/.vim/ftype/c.vim
autocmd BufRead,BufNewFile,BufEnter *.cc source ~/.vim/ftype/c.vim
autocmd BufRead,BufNewFile,BufEnter *.cpp source ~/.vim/ftype/c.vim
autocmd BufRead,BufNewFile,BufEnter *.h source ~/.vim/ftype/c.vim
autocmd BufRead,BufNewFile,BufEnter *.hpp source ~/.vim/ftype/c.vim

" reużywanie zakładek przy błędach
" set switchbuf=useopen,usetab,newtab






