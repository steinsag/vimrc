" vimrc files by Sebastian Stein <seb.kde@hpfsc.de> - http://sebstein.hpfsc.de/
"
" parts based on vim setup by Sven Guckes: http://guckes.net/
"
" license: public domain

" UTF8: http://stackoverflow.com/questions/5477565/how-to-setup-vim-properly-for-editing-in-utf-8
if has("multi_byte")
  if &termencoding == ""
    let &termencoding = &encoding
  endif
  set encoding=utf-8                     " better default than latin1
  setglobal fileencoding=utf-8           " change default file encoding when writing new files
endif

" unter xterm und anderne Konsolen funktionieren die Ende und Pos1 Taste nur
" mit diesen mappings
map OF <End>
map OH <Home>
imap OF <End>
imap OH <Home>

" alle Fenster schliessen und nur 1 neues Fenster offen haben
map ## :new<CR>:only<CR>

" Tastenkuerzel zum Beenden
map qq :quit<CR>

" Quote Paragraph
map ,qp vip:s/^/> /<CR>
vmap ,qp    :s/^/> /<CR>
map ,dp vip:s/^> //<CR>
vmap ,dp    :s/^> //<CR>
nmap  ,## vip:s/^/#<space>/<CR>
vmap  ,##    :s/^/#<space>/<CR>
nmap  ,%% vip:s/^/%<space>/<CR>
vmap  ,%%    :s/^/%<space>/<CR>

" aktuelle Zeile und Spalte farblich hervorheben
set cursorline
set cursorcolumn
hi cursorline cterm=NONE ctermbg=darkred ctermfg=white guibg=darkred guifg=white
hi cursorcolumn cterm=NONE ctermbg=darkred ctermfg=white guibg=darkred guifg=white

" ,dqs = delete quoted sig
"        goto end-of-buffer, search-backwards for a quoted sigdashes
"        line, ie "^> -- $", and delete unto end-of-paragraph:
map ,dqs G?^> -- $<CR>d}

" Signatur am Ende loeschen
map ,ds G?^-- $<CR>d}

" Signatur anhaengen
nmap ,as :r!agrep -d "^-- $" '' ~/Mail/.signaturen<S-Left><S-Left><right>

" Zeitstring einfuegen, unterstreichen und neuen Aufzaehlungspunkt setzen
map ,adt O<ESC>CYdatetime <CR><ESC>a=<ESC>22.o<CR><CR><CR><ESC>kk0C<TAB>* 

" zeigt Dateibrowser an
map ,fb <ESC>:topleft split .<CR> " Teilung horizontal
map ,Fb <ESC>:vertical topleft split .<CR> " Teilung vertikal

" mit set list kann man Zeichen sichtbar machen, hiermit eingestellt welche
set listchars=tab:»·,trail:·,eol:$

" We use a vim
set nocompatible

" keine Backupdateien benutzen
set nobackup

" wir benutzen einen schwarzen Hintergrund
set background=dark

" mit Backspace geht jetzt: indent,eol,start
set backspace=2

" digraph: Umlaute auch über o<Backspace>: ergibt ö
set nodigraph

" auch Pfeiltasten während Insert zulassen
set esckeys

" dadurch wird angezeigt, was auf eine Suche passt
set incsearch

" alle Zeichen, auf die Suchpattern passt, werden hervorgehoben
" deaktivieren ueber set nohls
set hlsearch

" comments default: sr:/*,mb:*,el:*/,://,b:#,:%,:XCOMM,n:>,fb:-
set comments=b:#,:%,fb:-,n:>,n:)

" Höhe des Hilfefensters nicht vorgeben
set helpheight=0

" Gross/Kleinschreibung bei Suche _nicht_ beachten
set ignorecase

" zu den normalen Buchstaben noch - . und @ hinzufuegen
set iskeyword=@,48-57,_,192-255,-,.,:,/,@-@

" Dateityperkennung aktivieren
filetype on

" in letzter Zeile einer Datei kann automatische Anweisungen fuer vim stehen
set modeline
set modelines=1

" immer anzeigen, wieviele Zeilen geändert wurden
set report=0

" This will switch colors ON
if has("syntax")
	syntax on
endif

" with 2 backslashes you can activate vim-tags now
map \\ <c-]>

" Fenster maximieren
map <c-w>m :resize 50+<CR> " bei horizontaler Teilung
map <c-w>M :vertical resize 50+<CR> " bei vertikaler Teilung

" setting tab to 3 chars
set tabstop=3
set noexpandtab

" activating statusbar always
set laststatus=2

" Zeilenumbruch nach Zeichen 79
set textwidth=79

" show the cursor position all the time
set ruler

" show matching brackets
set showmatch

" automatically save before commands like :next or :make
set autowrite

" Show (partial) command in status line.
set showcmd

" aktuellen Modus anzeigen
set showmode

" folgende Dateien bei Autovervollstaendigung erstmal nicht beachten
set suffixes=.bak,~,.swp,.o,.info,.aux,.log,.dvi,.bbl,.blg,.brf,.cb,.ind,.idx,.ilg,.inx,.out,.toc,.swp,.tar,.pdf,.lof,.lot,.eps,.ps,.jpg,.gif,.eps,.bmp,.class,.bz2,.glo,.aux,.bbl,.dvi,.rtf,.gls,.ist

" Bewegungskommandos gehen automatisch auf naechster Zeile weiter
set whichwrap=<,>,h,l,[,]

" We know xterm-debian is a color terminal
if &term =~ "xterm-debian" || &term =~ "xterm-xfree86"
  set t_Co=16
  set t_Sf=[3%dm
  set t_Sb=[4%dm
endif

if has("autocmd")

" Set some sensible defaults for editing C-files
augroup cprog
  " Remove all cprog autocommands
  au!

  " When starting to edit a file:
  "   For *.c and *.h files set formatting of comments and set C-indenting on.
  "   For other files switch it off.
  "   Don't change the order, it's important that the line with * comes first.
  autocmd BufRead *       set formatoptions=tcql nocindent comments&
  autocmd BufRead *.c,*.h set formatoptions=croql cindent comments=sr:/*,mb:*,el:*/,://
augroup END

" Also, support editing of gzip-compressed files. DO NOT REMOVE THIS!
" This is also used when loading the compressed helpfiles.
augroup gzip
  " Remove all gzip autocommands
  au!

  " Enable editing of gzipped files
  "	  read:	set binary mode before reading the file
  "		uncompress text in buffer after reading
  "	 write:	compress file after writing
  "	append:	uncompress file, append, compress file
  autocmd BufReadPre,FileReadPre	*.gz set bin
  autocmd BufReadPre,FileReadPre	*.gz let ch_save = &ch|set ch=2
  autocmd BufReadPost,FileReadPost	*.gz '[,']!gunzip
  autocmd BufReadPost,FileReadPost	*.gz set nobin
  autocmd BufReadPost,FileReadPost	*.gz let &ch = ch_save|unlet ch_save
  autocmd BufReadPost,FileReadPost	*.gz execute ":doautocmd BufReadPost " . expand("%:r")

  autocmd BufWritePost,FileWritePost	*.gz !mv <afile> <afile>:r
  autocmd BufWritePost,FileWritePost	*.gz !gzip <afile>:r

  autocmd FileAppendPre			*.gz !gunzip <afile>
  autocmd FileAppendPre			*.gz !mv <afile>:r <afile>
  autocmd FileAppendPost		*.gz !mv <afile> <afile>:r
  autocmd FileAppendPost		*.gz !gzip <afile>:r
augroup END

augroup bzip2
  " Remove all bzip2 autocommands
  au!

  " Enable editing of bzipped files
  "       read: set binary mode before reading the file
  "             uncompress text in buffer after reading
  "      write: compress file after writing
  "     append: uncompress file, append, compress file
  autocmd BufReadPre,FileReadPre        *.bz2 set bin
  autocmd BufReadPre,FileReadPre        *.bz2 let ch_save = &ch|set ch=2
  autocmd BufReadPost,FileReadPost      *.bz2 |'[,']!bunzip2
  autocmd BufReadPost,FileReadPost      *.bz2 let &ch = ch_save|unlet ch_save
  autocmd BufReadPost,FileReadPost      *.bz2 execute ":doautocmd BufReadPost " . expand("%:r")

  autocmd BufWritePost,FileWritePost    *.bz2 !mv <afile> <afile>:r
  autocmd BufWritePost,FileWritePost    *.bz2 !bzip2 <afile>:r

  autocmd FileAppendPre                 *.bz2 !bunzip2 <afile>
  autocmd FileAppendPre                 *.bz2 !mv <afile>:r <afile>
  autocmd FileAppendPost                *.bz2 !mv <afile> <afile>:r
  autocmd FileAppendPost                *.bz2 !bzip2 -9 --repetitive-best <afile>:r
augroup END

endif " has ("autocmd")

if has("autocmd")
	" einige Tastaturmaps anlegen fuer HTML Dateien und PHP
	autocmd BufEnter *.php,*.php4,*.html,*.htm,*.js,*.shtml,*.phtml,*.sql runtime html.vim

	" fuer C Dateien einige spezielle Sachen beachten
	autocmd BufEnter *.c runtime c.vim

	" fuer C++ Dateien einige spezielle Sachen beachten
	autocmd BufEnter *.cpp,*.h,*.c++ runtime cpp.vim

	" fuer C# Dateien einige spezielle Sachen beachten
	autocmd BufEnter *.cs runtime cs.vim

	" einige Einstellungen fuer die Nutzung von vim aus slrn raus
	autocmd BufEnter ~/.followup,~/.article runtime slrn.vim
	
	" bei der Nutzung von mutt wollen wir auch ein extra Setup
	autocmd BufEnter /tmp/mutt* runtime mutt.vim

	" fuer tex gibt es natuerlich auch eine extra Datei
	autocmd BufEnter *.tex,*.bib runtime tex.vim

	" fuer Textdateien eine eigene Datei
	"autocmd BufEnter *.txt runtime txt.vim

	" XMI ist auch bloß XML
	autocmd BufEnter *.xmi set syn=xml

	" *.module sind PHP Dateien bei Drupal
	autocmd BufEnter *.module set syn=php

	" fuer Python Dateien einige spezielle Sachen beachten
	autocmd BufEnter *.py runtime py.vim

	" fuer JS Dateien einige spezielle Sachen beachten
	autocmd BufEnter *.js,*.json runtime js.vim

	" fuer Scala Dateien einige spezielle Sachen beachten
	autocmd BufEnter *.java,*.scala runtime scala.vim

	" fuer Ruby Dateien einige spezielle Sachen beachten
	autocmd BufEnter *.rb runtime rb.vim
endif " if has("autocmd")

" einige Abkuerzungen laden, die immer verfuegbar sein sollen
runtime abbreviations.vim
