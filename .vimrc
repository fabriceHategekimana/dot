" ___  _             _           
"|  _ \| |_   _  __ _(_)_ __  ___ 
"| |_) | | | | |/ _` | | '_ \/ __|
"|  __/| | |_| | (_| | | | | \__ \
"|_|   |_|\__,_|\__, |_|_| |_|___/
"               |___/             
 
call plug#begin('~/.vim/plugged')

Plug 'vimwiki/vimwiki'
Plug 'https://github.com/wikitopian/hardmode.git'
Plug 'https://github.com/ptzz/lf.vim.git'
Plug 'artur-shaik/vim-javacomplete2'
Plug 'vim-scripts/AutoComplPop'
Plug 'majutsushi/tagbar'

call plug#end()

" ____  _        _               _ _            
"/ ___|| |_ __ _| |_ _   _ ___  | (_)_ __   ___ 
"\___ \| __/ _` | __| | | / __| | | | '_ \ / _ \
" ___) | || (_| | |_| |_| \__ \ | | | | | |  __/
"|____/ \__\__,_|\__|\__,_|___/ |_|_|_| |_|\___|
"Code pour le status line
set statusline=
set statusline+=%#Cursor#\ VIM\ \ 
set statusline+=%#Normal#%{(mode()=='n')?'\ \ NORMAL\ ':''}
set statusline+=%#PmenuThumb#%{(mode()=='i')?'\ \ INSERT\ ':''}
set statusline+=%#TabLineFill#%{(mode()=='r')?'\ \ REPLACE\ ':''}
set statusline+=%#SpellRare#%{(mode()=='v')?'\ \ VISUAL\ ':''}
set statusline+=%#LineNr#\ %n\    " buffer number
set statusline+=%#Visual#         " colour
set statusline+=%#CursorIM#       " colour
set statusline+=%R                " readonly flag
set statusline+=%M                " modified [+] flag
set statusline+=%#Cursor#         " colour
set statusline+=%#CursorLine#     " colour
set statusline+=\ %t\             " short file name
set statusline+=%=                " right align
set statusline+=%#LineNr#         " colour
set statusline+=\ %3l:%-2c\       " line + column
set statusline+=%#Normal#\ %Y\    " file type
set statusline+=%#Cursor#         " colour
set statusline+=%3p%%\            " percentage

"          _   _   _                 
" ___  ___| |_| |_(_)_ __   __ _ ___ 
"/ __|/ _ \ __| __| | '_ \ / _` / __|
"\__ \  __/ |_| |_| | | | | (_| \__ \
"|___/\___|\__|\__|_|_| |_|\__, |___/
"                          |___/     
let mapleader="à"
color elflord
"Quelque définitions claires et simples pour le code en général
"set relativenumber
set laststatus=2
set complete+=kspell 
set path+=**
set cursorline
set wildmenu
set splitbelow
set splitright
set ignorecase
set smartcase
set incsearch "pour que vimwiki n'ait pas trop de problème
set cindent shiftwidth=4
set number
set matchpairs+=<:>
set timeoutlen=500
set virtualedit=onemore
set noswapfile "empècher la génération de swapfile"
filetype plugin indent on
"create quickly and easely a odp file with selected musii vimwiki
let g:vimwiki_list = [{'path': '~/', 'ext':'.md', 'index':'note', 'syntax':'markdown'},
			\{'path': '~/cours/genie_logiciel/note/', 'ext':'.md', 'index':'note', 'syntax':'markdown'},
			\{'path': '~/cours/concurrence/note/', 'ext':'.md', 'index':'note', 'syntax':'markdown'}]
" _____                 _   _                 
"|  ___|   _ _ __   ___| |_(_) ___  _ __  ___ 
"| |_ | | | | '_ \ / __| __| |/ _ \| '_ \/ __|
"|  _|| |_| | | | | (__| |_| | (_) | | | \__ \
"|_|   \__,_|_| |_|\___|\__|_|\___/|_| |_|___/
                                             
"liste de fonction
function RenameFunction(newName)
	execute "%s/\\<".@"."\\>/".a:newName."/g"
endfunction

function SearchFunction(pattern)
	execute "silent vimgrep/\\<".a:pattern."\\>/i ** | copen"
endfunction

function SearchFunction2()
	execute "silent vimgrep/\\<".@"."\\>/i ** | copen"
endfunction

function NeloParsing()
    	"ISOLER LES TITRES ET LES NOTES"
	"g/tooltip\sa-h\stext-nowrap\|item-rate/.w! >> extraction.txt
	"isoler le contenu sans les balises autour
	"%s/\(<[^>]*>\)\([^<]*\)\(<\/[^>]*>\)/\2/g
	"retirer les espaces en trop à gauche
	"%s/\(\D*\)\(\d.*\)/\2/g
endfunction

	
function! MkFiles(fichier)
	execute "!cp ~/note/template/".a:fichier.".".a:fichier." ." 
	execute "tabnew ".a:fichier.".".a:fichier
endfunction

function! GetProjectPath()
	let pwd= system("pwd")
	let tab= split(pwd, "/")	
	return tab[0]."/".tab[1]."/".tab[2]."/".tab[3]
endfunction

function! GetProjectName()
	let pwd= system("pwd")
	let tab= split(pwd, "/")	
	return tab[3]
endfunction

function! Note()
	execute "tabnew ~/note/note_".g:extention.".md"
endfunction

function! CtagsFunction(...)
    execute "!ctags -R *"
endfunction

function! InsertToTextObject(type, ...)
    let sel_save = &selection
    let &selection = "inclusive"
    let reg_save = @@

    if a:0  " Invoked from Visual mode, use gv command.
        silent exe "normal! gv"
    else
        silent exe "normal! `["
    endif

    startinsert

    let &selection = sel_save
    let @@ = reg_save
endfunction

function! DoubleQuoteOperator(type)
    let sel_save = &selection
    let &selection = "inclusive"
    normal! `>a"
    let &selection = sel_save
endfunction

function! AppendToTextObject(type, ...)
    let sel_save = &selection
    let &selection = "inclusive"
    let reg_save = @@

    if a:0
        silent exe "normal! `>"
        call feedkeys('a', 'n')
    elseif a:type == 'line'
        silent exe "normal! ']"
        call feedkeys('A', 'n')
    else
        silent exe "normal! `]"
        call feedkeys('a', 'n')
    endif

    let &selection = sel_save
    let @@ = reg_save
endfunction


"----------------------------------C--------------------------------

function! RunC()
	!gcc % -o main && ./main
endfunction

function! RunCPart()
	!cat % | grep include >> RunCPart.c && echo "int main(int argc, char *argv[]){" >> RunCPart.c
	call writefile(split(@","\n"), 'RunCPart.c', "a")
	!echo "}" >> RunCPart.c && gcc RunCPart.c -o main && ./main
	!rm RunCPart.c
endfunction

function! CLike()
	let g:extention= "c"
	set nospell
	"Raccourci pour le langage c
	"Commentaires
	xnoremap <buffer> éc :normal I//<CR>
	xnoremap <buffer> éd :normal ^xx<CR>
	nnoremap <buffer> édc ^xx
	"Snippets
	nnoremap <buffer> éc ^i//<Esc>$<CR>
	inoremap <buffer> for for(int i= 0; i < n; i++){<CR><CR>}<Up>
	inoremap <buffer> for<CR> for
	inoremap <buffer> if if(){<CR><CR>}<Esc>2<Up>t)a
	inoremap <buffer> if<CR> if
	inoremap <buffer> else	else{<CR><CR>}<Up>
	inoremap <buffer> print printf("");<Left><Left><Left>
	inoremap <buffer> print<CR> printf("%d", );<Left><Left>
	inoremap <buffer> print<CR><CR> printf("%s", );<Left><Left>
	nnoremap <buffer> ép oprintf("%s\n", );<Esc>hi
	nnoremap <buffer> ésp oprintf("\n");<Esc>4hi
	inoremap <buffer> function! int<Space>(_){<CR><CR>}<Up><Up><Esc>f(i
	"Compilation et débugage
	nnoremap <buffer> <F5> :call RunC()<CR>
	xnoremap <buffer> <F5> y:call RunCPart()<CR>
	nnoremap <buffer> <F6> :! gcc *.c -o main && ./main<CR>
	nnoremap <buffer> <F9> :! bash ~/sh/mkc.sh
endfunction

"----------------------------------C++--------------------------------

function! RunCpp3(type)
	let filepath = expand('%:p:h')
	let parentname = expand('%:p:h:t')
	let nomunique = expand('%:t:r')
	if a:type == "normal"
		execute "terminal g++ ".expand('%') " -o ".expand('%:r')." -std=c++11 -pthread"
		execute "terminal ./".nomunique
	elseif a:type == "mpi"
		execute "terminal mpiCC ".bufname('%')." -o ".nomunique." -std=c++11"
		execute "terminal mpirun -np ".g:parallele." --oversubscribe ./".expand('%:t:r')
	elseif a:type == "part"
		!cat % | grep include >> RunCppPart.cpp && echo "int main(int argc, char **argv){" >> RunCppPart.cpp && sed -i '1d' RunCppPart.cpp 
		call writefile(split(@","\n"), 'RunCppPart.cpp', "a")
		!echo "}" >> RunCppPart.cpp && g++ RunCppPart.cpp && ./a.out
		terminal g++ RunCppPart.cpp
		terminal ./a.out
		!rm RunCppPart.cpp
	endif
endfunction

function! CppLike()
	set nospell
	let g:extention= "cpp"
	let g:extention_supplementaire= "hpp"
	"Définition d'une variable global pour changer le nombre de processus parallèles
	let g:parallele= 1
	
	nnoremap <buffer> éc I//<Esc>$<CR>
	xnoremap <buffer> éc :normal I//<CR>
	nnoremap <buffer> éd ^xx
	xnoremap <buffer> éd :normal ^xx<CR>
	inoremap <buffer> print	std::cout<Space><<<Space><Space><<<Space>std::endl;<Esc>2F<Space>i
	inoreabbrev <buffer> ok Okay
	inoreabbrev <buffer> vector std::vector<><Space>(,<Right>;<Esc>F<a
	inoreabbrev <buffer> list std::list<int><Space>
	inoreabbrev <buffer> for for(auto i: v<Right>{<CR><CR><Up>
	inoreabbrev <buffer> forr for({<CR><CR><Up><Up><Left><Left>
	inoreabbrev <buffer> forrr for(int i= 0; i < n; i++<Right>{<CR><CR><Right><Up>
	inoreabbrev <buffer> if if(<Right>{<CR><CR><Esc>2<Up>ta
	inoreabbrev <buffer> while while(<Right>{<CR><CR><Esc>2<Up>ta
	inoreabbrev <buffer> else	else{<CR><CR><Up>
	inoremap <buffer> function! int<Space>({<CR><CR>}<Up><Up><Esc>f(i
	inoreabbrev <buffer> recv MPI_Status<Space>status;<CR>MPI_Recv(&, sizeof(int, MPI_INT, i, 0, MPI_COMM_WORLD, &status;<Esc>F&a
	inoreabbrev <buffer> vrecv MPI_Status<Space>status;<CR>MPI_Recv(v.data(, v.size(, MPI_INT, i, 0, MPI_COMM_WORLD, &status;<Esc>
	inoreabbrev <buffer> send MPI_Send(&, sizeof(int, MPI_INT, i, 0, MPI_COMM_WORLD;<Esc>F&a
	inoreabbrev <buffer> vsend MPI_Send(v.data(, v.size(, MPI_INT, i, 0, MPI_COMM_WORLD;<Esc>
	inoreabbrev <buffer> barri MPI_Barrier(MPI_COMM_WORLD;<CR>double<Space>start<space>=<space>MPI_Wtime(;
	inoreabbrev <buffer> end end<Space>=<Space>MPI_Wtime(;<CR><CR>if(myRank==0<Space>std::cout<Space><<<Space>"temps<Space>de<Space>l'operation<Space>:<Space>"<Space><<<Space>end-start<Space><<<Space>"[s]"<Space><<<Space>std::endl;<Esc>

	"SNIPPETS
	inoreabbrev <buffer> smain <Esc>:r<Space>~/note/snippet/cpp.cpp<CR>
	inoreabbrev <buffer> smainmpi <Esc>:r<Space>~/note/snippet/cpp_mpi.cpp<CR>
	nnoremap <buffer> <F4> :call RunCpp3("normal")<CR>
	xnoremap <buffer> <F5> y:call RunCpp3("part")<CR>
	nnoremap <buffer> <F5> :call RunCpp3("mpi")<CR>
	nnoremap <buffer> <F6> :let g:parallele= 
	nnoremap <buffer> <F9> :call MkFiles("cpp")<CR>
	inoremap <buffer> <C-d> <Esc>/_<CR>s
endfunction

"----------------------------------JAVA--------------------------------

command -nargs=* -complete=dir New call NewFunction(<f-args>)
command -nargs=1 -complete=dir GRename cfdo! %s//<args>/g | cclose | update

function! NewFunction(type, name, ...)
    	echom "package= ".a:0

    	if a:0 == 0
	    let package=""
	else
	    let package=a:1
	endif

	"Le plugin lf fait des effets de bord sur la variable g:app
	let g:inter=g:app

	if a:type == "class"
		tabnew ~/note/snippet/java/Class.java
		execute "%s/Class/".a:name."/g"
	elseif a:type == "abstract"
		tabnew ~/note/snippet/java/AbstractClass.java
		execute "%s/AbstractClass/".a:name."/g"
	elseif a:type == "interface"
		tabnew ~/note/snippet/java/Interface.java
		execute "%s/Interface/".a:name."/g"
	elseif a:type == "package"
	    	execute "!mkdir ".g:app."/".a:name
	endif

	if a:type != "package"
	    let g:app=g:inter
	    execute "saveas ".g:app."/".package.a:name.".java"
	endif
endfunction

function! Java()
	set nospell
	let g:extention= "java"
	let g:app=expand("%:p:h")
	let g:JavaComplete_IgnoreErrorMsg=1
	"Quand je quitte le mode insert, JavaComplete se charge de faire des
	"Déplace le curseur à la prochaine fonction
	nnoremap <buffer> énf /\(public\<Bar>private\)\ \(static\ \)\=\w\+\ \w\+(<CR>
	nnoremap <buffer> énF :/\(public\<Bar>private\) \(static \)\=\w\+ \w\+(/normal! f(B<CR>
	"Déplace le curseur à la prochaine variable
	nnoremap <buffer> énv /\w\+\(\.\w\+\)\=\(\w\+\)\=\(;\<Bar>\ =[^;]\+;\)<CR>
	"Operator pending maping qui cible la prochaine variable"
	onoremap nv :<C-U>call search('=')<Space><Bar><Space>normal! llvt;<CR>
	"Operator pending maping qui cible la prochaine variable"
	onoremap nc :<C-U>call search('//')<Space><Bar><Space>normal! llv$h<CR>
	"Debug le code java
	nnoremap <buffer> <F4> :terminal ++close ++shell cd %:p:h && jdb %:t:r<CR>
	"Compile et execute le code
	nnoremap <buffer> <F5> :terminal ++shell find . -type f -name "*.class" -delete && javac %:p:h:r/*.java && java %<CR>
	"Permet de créer des fichiers java
	nnoremap <buffer> <F6> :New<Space>
	"Permet de créer des fonctions java
	nmap écf G:call search('}','b')<CR>ofunction<Space>

	"Commente une ligne
	nnoremap <buffer> éc ^i//<Esc>
	"Commente des lignes
	xnoremap <buffer> éc :normal I//<CR>
	"Enlève le commentaire sur une ligne"
	nnoremap <buffer> éd ^xx<Esc>
	"Enlève le commentaire sur une sélection de ligne"
	xnoremap <buffer> éd :normal ^xx<CR>

	"Pseudo snippet pour le print
	inoremap <buffer> print System.out.println();<Esc><Left>i
	"Pseudo snippet pour faire une fonciton
	inoreabbrev <buffer> function public void (){<CR>}<Esc><Up>$Tda
	"Pseudo snippet pour faire un if
	inoreabbrev <buffer> if if(){<CR>}<Esc><Up>t)a
	"Pseudo snippet pour faire un else
	inoreabbrev <buffer> else	else{<CR>}<Up>
	"Pseudo snippet pour faire un try
	inoreabbrev <buffer> try try{<CR>}<CR>catch(InterruptedException e){<CR>System.out.println("Erreur");<CR>}<Esc><Up><Up><Up><Up>
	"Pseudo snippet pour faire un while
	inoreabbrev <buffer> while while(){<CR>}<Esc><Up>t)a
	"Pseudo snippet pour faire un fore
	inoreabbrev <buffer> for for(int i= 0; i<len; i++){<CR>}<Up>
endfunction	

"----------------------------------SCALA--------------------------------
function! Scala()
	set nospell
	let gextention="scala"
	set makeprg=scalac\ %
	set efm=%f:%l:%m
	nnoremap <F5> :terminal scala %:p:t:r<CR>
endfunction

"----------------------------------PYTHON--------------------------------

function! RunPython3(type)
	if a:type == "normal"
		set makeprg=python3\ %
	elseif a:type == "part"
		!cat % | grep import >> RunPythonPart.py | clear
		call writefile(split(@","\n"), 'RunPythonPart.py', "a")
		set makeprg=python3\ RunPythonPart.py
		"!rm RunPythonPart.py
	endif
	make 
	if a:type == "part"
		!rm RunPythonPart.py
	endif
	set makeprg=make\ 
	cope
endfunction

function! Python()
	set nospell
	let g:extention="py"
	let g:linePonctuation="$"
	set makeprg=python3\ %
	set efm=%A\ \ File\ \"%f\"\\,\ line\ %l\\,\ in%.%#,%Z%m
	
	"Raccourci pour le langage python
	nnoremap <buffer> éc ^i#<Esc><CR>
	xnoremap <buffer> éc :normal I#<CR>
	xnoremap <buffer> éd :normal ^x<CR>
	nnoremap <buffer> éd ^x 
	inoremap <buffer> print print()<Left>
	inoremap <buffer> printg print("")<Left><Left>
	inoreabbrev <buffer> class class<Space>():<CR><CR>def<Space>__init__(self):<CR>#code<Up><Up><Up><Left><Left><Left>
	inoreabbrev <buffer> for for<Space>i<Space>in<Space>:<Left>

	inoremap <buffer> def<Space> def ():<Esc>F(i
	nnoremap <buffer> <silent> <F4> :vert terminal python3 -i %<CR>
	nnoremap <buffer> <silent> <F5> :call RunPython3("normal")<CR>
	xnoremap <buffer> <silent> <F5> y:call RunPython3("part")<CR>
	nnoremap <buffer> <F6> :terminal python3 -m pdb %<CR>
	command  -nargs=1 Doc :!python3 -m pydoc <args>

	"numpy shortcuts
	inoremap <buffer> npa np.array([])<Left><Left>
	inoremap <buffer> npdo np.dot(,_)<Left><Left><Left>
	inoremap <buffer> npde np.linalg.det()<Left>
endfunction


"----------------------------------OCTAVE--------------------------------


function! RunOctave()
	let @o= system("octave ".bufname('%')) 
	echo @o
	echom "octave!"
endfunction

function! OctaveLike()
	set nospell
	let g:extention= "octave"
	"Raccourci pour le langage octave
	nnoremap <buffer> éc ^i%<Esc><CR>
	nnoremap <buffer> édc ^x 
	nnoremap <buffer> <F4> :!octave --no-gui<CR>
	nnoremap <buffer> <F5> :terminal octave %<CR>
endfunction


"----------------------------------latex--------------------------------

function! Latex()
	set spell
	set spelllang=fr_ch
	let g:extention="tex"
	nnoremap <buffer> éé i\<Esc>
	nnoremap <buffer> és o\section{}<Esc>i
	nnoremap <buffer> éss o\subsection{}<Esc>i
	nnoremap <buffer> éi i\textit{}<Esc>i
	nnoremap <buffer> éb i\textbf{}<Esc>i
	nnoremap <buffer> éc i\textsf{}<Esc>i
	nnoremap <buffer> éii o\includegraphics[scale=1.2]{image}
	inoremap <CR> \\<CR> 
	nnoremap <buffer> <F5> :execute ":!pdflatex ".bufname("%")." && zathura ".expand('%:r').".pdf" <CR>
endfunction

"------------------------------------BASH-------------------------------------
function! RunBashPart()
	call writefile(split(@","\n"), 'RunBashPart.sh', "a")
	!chmod +x RunBashPart.sh
	!./RunBashPart.sh
	!rm RunBashPart.sh
endfunction

function! Sh()
	set nospell
	let g:extention="sh"
	nnoremap <buffer> éc ^i#<Esc><CR>
	xnoremap <buffer> éc :normal I#<CR>
	nnoremap <buffer> éd ^x 
	xnoremap <buffer> éd :normal ^x<CR>
	inoremap <buffer> [ [<Space><Space>]<Left><Left>
	inoreabbrev <buffer> elif elif<Space>[<Space>];<Space>then<CR><Up><Right><Right>
	inoreabbrev <buffer> if <Esc>:r<Space>~/note/snippet/bash/if.sh<CR>
	inoreabbrev <buffer> function! (){<CR><CR>}<Up><Up>
	nnoremap <buffer> <F5> :!./%<CR>
	xnoremap <buffer> <F5> y:call RunBashPart()<CR>
endfunction


"-----------------------------------MYSQL---------------------------------------


function! RunSql()
	let contenu= system("cat ".bufname("%"))
	execute ":!mysql -u user -pd367*WGa! -e '".contenu."'"
endfunction

function! Sql()
	set nospell
	nnoremap <buffer> éc ^i/*<Esc>A*/<Esc>
	nnoremap <buffer> éd ^xx$xx
	nnoremap <buffer> <F4> :!mysql -u user -pd367*WGa!<CR>
	nnoremap <buffer> <F5> :call RunSql()<CR>
endfunction


"------------------------------------------MARKDOWN-------------------------------------
"

function! Chant()
	execute ":normal! Vy"
	execute ":tabnew ../txt/".@"
endfunction

function! Imagerie()
	if ! filereadable("imagerie_numerique.md")
		execute ":! cp ~/note/imagerie_numerique.md ."
	endif
	execute ":! pandoc imagerie_numerique.md ".bufname("%")." ~/note/imagerie_numerique.yaml -o ".expand("%:r").".pdf && zathura ".expand("%:r").".pdf"
endfunction

function! Markdown()
	"Markdown commands
	let g:extention="markdown"
	set nospell
	set spelllang=fr_ch,en_us
	"mode normal
	nnoremap <buffer> ét :call MarkdownTitre()<CR>
	nnoremap <buffer> éru <Plug>VimwikiRenumberList 
	nnoremap <buffer> éta :VimwikiTable<CR>
	nnoremap <buffer> éb I**<Esc>A**<Esc>
	xnoremap <buffer> éb di****<Esc>2<Left>p
	nnoremap <buffer> éco i``````<Left><Left><Left><CR><CR><Up>
	nnoremap <buffer> éim i![](../../images/num.png)<Esc>^<Right>a
	nnoremap <buffer> ém Bi`<Esc>Ea`<Esc>
	xnoremap <buffer> ém di``<Esc><Left>p
	nnoremap <buffer> <C-P> :!. ~/sh/cs.sh<CR>
	nnoremap <buffer> éd ^2xt]lxD:s/_/\ /g<CR>

	inoremap <buffer> ééb ****<Left><Left>
	inoremap <buffer> ééit __<Left>
	inoremap <buffer> ééti #<Space>
	inoremap <buffer> ééco ``````<Left><Left><Left><CR><CR><Up>
	inoremap <buffer> éém ``<Left>
	inoremap <buffer> ééta <Esc>:call MarkdownLigne()<CR>
	inoremap <buffer> ééd \begin{tikzpicture}<CR><CR>\end{tikzpicture}
	inoremap <buffer> ééim ![](../../images/num.png)<Esc>^<Right>a
	inoremap <buffer> éér \rectangle{nom}{x}{y}
	inoremap <buffer> ééff \fleche{nom1}{nom2}{label}
	inoremap <buffer> ééfff \flechel{nom1}{nom2}{label}{angleIn}{angleOut}
	nnoremap <buffer> <F4> :call LinkImage()<CR>
	nnoremap <buffer> <F5> :!bash ~/sh/compmd %<Space>
	nnoremap <buffer> <F6> :call Imagerie()<CR>
	xnoremap <buffer> <F8> y:call AddTask()<CR>
endfunction

"---------------------------------------PROLOG-------------------------------------

function! Prolog()
	set nospell
	let g:extention="pl"
	nnoremap <buffer> éc I%<Esc>
	nnoremap <buffer> <F4> :!swipl<CR>
	nnoremap <buffer> <F5> :terminal swipl %<CR>
endfunction

"---------------------------------------PHP-------------------------------------

function! RunPhp()
	let nomunique = expand('%:r')
	execute ":!php ".bufname('%')
endfunction

function! Php()
	set nospell
	let g:extention="php"
	"mode normal
	nnoremap <buffer> php i<?php<CR><CR>><Up>
	nnoremap <buffer> <F5> :call RunPhp()<CR>
	nnoremap <buffer> <F5> :!chromium http://localhost/login.html<CR>
	nnoremap <buffer> éc ^i//<Esc>

	"mode insertinon
	inoremap <buffer> echo echo "\n";<Left><Left><Left><Left>
	inoremap <buffer> function! function (){<CR><CR>}<Up><Up><Esc>A<Left><Left><Left>
	inoremap <buffer> elseif elseif(){<CR><CR>}<Up><Up><Esc>A<Left><Left>
	inoremap <buffer> if if(){<CR><CR>}<Up><Up><Esc>A<Left><Left>
	inoremap <buffer> else else{<CR><CR>}<Up>
	inoremap <buffer> post $_POST['']<Left><Left>
endfunction! 

"             _            
"  __ _ _   _| |_ _ __ ___ 
" / _` | | | | __| '__/ _ \
"| (_| | |_| | |_| | |  __/
" \__,_|\__,_|\__|_|  \___|
                          
function! NoteWindow()
	let g:note= 0
	nnoremap <buffer> <F2> :wq<CR>
endfunction

function! Projet()
	nnoremap <Enter> :call GoToProject()<CR>
endfunction

"------------------------------------ARM----------------------
"
function! RunARM()
	let @o= system("arm-linux-gnueabi-gcc ".bufname('%')."&& qemu-arm -L /usr/arm-linux-gnueabi a.out") 
	echo @o
endfunction

function! ARM()
	let g:extention="s"
	nnoremap <buffer> <F5> :call RunARM()<CR>
	nnoremap <buffer> éti I//----------a----------//<Esc>Ta<Left>s
	nnoremap <buffer> éc A<Tab>//
	nnoremap <buffer> éwo gg<Down>o:<Tab>.word<tab>
	nnoremap <buffer> éby gg<Down>o:<Tab>.byte<tab>
	nnoremap <buffer> éin gg<Down>o:<Tab>.int<tab>
	nnoremap <buffer> élo gg<Down>o:<Tab>.long<tab>
	nnoremap <buffer> ést gg<Down>o:<Tab>.string<tab>
	nnoremap <buffer> éas gg<Down>o:<Tab>.asciz<tab>""<Left>
	inoremap <buffer> function! :<Tab>stmfd<Tab>sp!,{r4-r11}<CR><Tab>ldmfd<Tab>sp!,{r4-r11}<CR><Tab>mov<Tab>pc,lr<Esc><Up><Up>I
	inoremap <buffer> print ldr<Tab>r0,=<CR><Tab>bl<Tab>printf<Esc><Up>A
endfunction

function! Nodejs()
	set nospell
	nnoremap <buffer> <F5> :!node %<CR>
endfunction

"------------------------------------BASIC----------------------
"
function! RunBasic()
	execute "!soffice macro:///standard.".expand('%:t:r').".main"
endfunction

function! Basic()
	inoremap <buffer> " &quot;&quot;<Left><Left><Left><Left><Left><Left>
	inoremap <buffer> & &amp;
	nnoremap <buffer> <F5> :call RunBasic()<CR>
	nnoremap <buffer> éc Irem <Esc>
endfunction

function! LinkImage()
	execute ":normal! ^d$"
	let formated= substitute(@", " ", "_", "g")
	execute ":normal! i![".formated."](../../images/".formated.".png)"
	execute ":! ~/sh/myimport vim ".formated
endfunction

function! MakeSpace()
	execute ":normal! ^d$"
	let formated= substitute(@", "_", " ", "g")
	execute ":normal! i".formated
endfunction

function! Myformat()
	execute ":normal! ^d$"
	let formated= substitute(@", "_", " ", "g")
	execute ":normal! i".formated
endfunction

"----------------------R-----------------------------

function! RLike()
	let g:extention="r"
	nnoremap <buffer> <F5> :call RunARM()<CR>
	inoremap <buffer> matrix matrix(a,<Space>byrow=TRUE,<Space>ncol=)<Left>
	inoremap <buffer> dataframe data.frame()<Left>
	inoremap <buffer> ** %*%

	nnoremap <buffer> éc I#<Esc>
	xnoremap <buffer> éc :normal! I#<CR>
	xnoremap <buffer> éd :normal! ^x<CR>

	inoremap <buffer> print print()<Left>
	inoremap <buffer> while while(){<CR><CR>}<Up><Up><Esc>t{i
	inoremap <buffer> function! <-function(){<CR><CR>}<Up><Up><Esc>I
	inoremap <buffer> if if(){<CR><CR>}<Esc>2<Up>t)a
	inoremap <buffer> else else{<CR><CR>}<Up>
	inoremap <buffer> return return()<Left>

	nnoremap <buffer> <F4> :!R<CR>
	nnoremap <buffer> <F5> :!Rscript %<CR>
	nnoremap <buffer> <F6> :!Rscript % | !less<Esc>
endfunction

"----------------------MAKEFILE-----------------------------

function! MakefileFunction()
	if ! filereadable("Makefile")
		!cp ~/note/Makefile .
	endif
	tabnew Makefile
endfunction

function! Makefile()
    nnoremap <buffer> én jo:<Left>
endfunction

function! Programme()
	let g:extention="programme"
	nnoremap <buffer> <F5> :call RunARM()<CR>
	call Markdown()
	nnoremap <buffer> éé :!gedit %<CR>
	nnoremap <buffer> éy :!chromium https://www.youtube.com/&<CR>
	nnoremap <buffer> éc :call Chant()<CR>
endfunction

function! CI()
	inoreabbrev <buffer> af afficher;<Left>
	inoreabbrev <buffer> boucle boucle<CR>{<CR><CR><Up><Up><Up><Esc>A
	inoreabbrev <buffer> inv inv;<Left>
	inoreabbrev <buffer> racine racine;<Left>
	inoreabbrev <buffer> aff aff_ral;<Esc>
endfunction

function! Vimrc()
	let g:extention="vimrc"
	nnoremap éc I"<Esc>
endfunction

"  ____                                          _     
" / ___|___  _ __ ___  _ __ ___   __ _ _ __   __| |___ 
"| |   / _ \| '_ ` _ \| '_ ` _ \ / _` | '_ \ / _` / __|
"| |__| (_) | | | | | | | | | | | (_| | | | | (_| \__ \
" \____\___/|_| |_| |_|_| |_| |_|\__,_|_| |_|\__,_|___/
                                                      

"commandes en command mode
command! -nargs=1 CpL :<args>t.<CR>
command! So :so $MYVIMRC
command! Store !firefox https://vimawesome.com/ &
command! -nargs=* -complete=help Help :tab help <args>
command! Makefile :call MakefileFunction()<CR>
command! -nargs=* Ctags :call CtagsFunction(<f-args>)<CR>
command! Pdf :!cs
command! Vimscript :!firefox https://learnvimscriptthehardway.stevelosh.com/ &
command! -nargs=1 Add normal! dd/<args>p
command! Todo e todo.md
command! -nargs=1 Rename call RenameFunction(<f-args>)
command! -nargs=1 Search call SearchFunction(<f-args>)
"command -nargs=1 Look vimgrep /<args>/j ../../cours/txt/*.txt<Space><Bar><Space>copen

"  ____ _       _           _                               _             
" / ___| | ___ | |__   __ _| |  _ __ ___   __ _ _ __  _ __ (_)_ __   __ _ 
"| |  _| |/ _ \| '_ \ / _` | | | '_ ` _ \ / _` | '_ \| '_ \| | '_ \ / _` |
"| |_| | | (_) | |_) | (_| | | | | | | | | (_| | |_) | |_) | | | | | (_| |
" \____|_|\___/|_.__/ \__,_|_| |_| |_| |_|\__,_| .__/| .__/|_|_| |_|\__, |
                                              "|_|   |_|            |___/ 
"Actions pour les plugins et les touches F1-F12
let g:vimrc_window= 0
nnoremap cp <Esc>:CpL<Space>
nnoremap <F1> :tabnew ~/.vimrc<CR>
nnoremap <F2> :call Note()<CR>
nnoremap <F3> :! ~/sh/mymake 
"pour faire une capture d'écran qui va directement dans le dossier images existant
xnoremap éspa :call MakeSpace()<CR>
nnoremap <F7> :make<Space>
set pastetoggle=<F8>
nnoremap <F9> :so $VIMRUNTIME/syntax/hitest.vim<CR>
nnoremap <F10> :!gedit %<CR>
nnoremap <F12> :!clear<CR>
nnoremap <Space> .
nnoremap èè :call MakefileFunction()<CR>
inoremap " ""<Left>
inoremap "" "<Esc>
inoremap """  "<Esc>A"<Esc>
inoremap ( ()<Left>
inoremap (( (<Esc>
inoremap (((  (<Esc>A)<Esc>
inoremap { {}<Left> 
inoremap {{ {<Esc> 
inoremap {{{ {<Esc>A}<Esc> 
inoremap [ []<left>
inoremap [[ [<Esc>
inoremap [[[ [<Esc>A]<Esc> 

"Mes raccourci pour le code en général
nnoremap édb :cope<CR>
nnoremap éct :Ctags
nnoremap ! :!
inoremap <C-S> <Right>
nnoremap éns /"<CR>
inoremap <C-C> <Esc>
nnoremap étb :TagbarToggle<CR>

"pour 'keep title'. cela suprime tout sauf les titres du fichier txt qu'on a
"extait d'un pdf
nnoremap ékt :g!//d<CR>

"Rename est là pour renommer le mot sur lequel on est (portée du fichier actuel)
nnoremap <buffer> érn yiw:Rename<Space>
"Rename est là pour renommer le mot sur lequel on est (portée du projet actuel)
nnoremap <buffer> égrn yiw:let<Space>@/=@"<CR>:call<Space>SearchFunction2()<Space><Bar><Space>GRename<Space>
"search est là pour chercher le mot sur lequel on est dans plusieurs fichier
nnoremap <buffer> ésr yiw:Search<Space>

"Navigation avec lf
nnoremap vp :vsplit .<CR>
nnoremap sp :split .<CR>
nnoremap tn :LfNewTab<CR>

"Mouvements spéciaux
nnoremap <C-K> {
nnoremap <C-J> }

"pendig opperator (g@)
nnoremap éa :set opfunc=MyAppendOperator<CR>
nnoremap éq :set opfunc=DoubleQuoteOperator<CR>g@
nmap <silent> éi :set opfunc=InsertToTextObject<CR>g@
vmap <silent> éi :<C-U>call InsertToTextObject(visualmode(), 1)<CR>
nmap <silent> éa :set opfunc=AppendToTextObject<CR>g@
vmap <silent> éa :<C-U>call AppendToTextObject(visualmode(), 1)<CR>

"Mouvement en mode pending operator
onoremap lp :normal t)vF,<CR>
onoremap n" :<C-U>normal f"lvt"<CR>
onoremap n' :<C-U>normal f'lvt'<CR>
onoremap ip) :<C-U>call search('(','b')<Space><Bar><Space>normal! lvi)<CR>
onoremap ip] :<C-U>call search('[','b')<Space><Bar><Space>normal! lvi]<CR>
onoremap ip} :<C-U>call search('{','b')<Space><Bar><Space>normal! lvi}<CR>
onoremap in) :<C-U>call search('(')<Space><Bar><Space>normal! lvi)<CR>
onoremap in] :<C-U>call search('[')<Space><Bar><Space>normal! lvi]<CR>
onoremap in} :<C-U>call search('{')<Space><Bar><Space>normal! lvi}<CR>
onoremap pv :<C-U>call search('=','b')<Space><Bar><Space>normal! llv$h<CR>
onoremap nv :<C-U>call search('=')<Space><Bar><Space>normal! llv$h<CR>
onoremap ps :<C-U>call search('"','b')<Space><Bar><Space>normal! lvt"<CR>
onoremap ns :<C-U>call search('"')<Space><Bar><Space>normal! lvt"<CR>
onoremap ips :<C-U>call search("'",'b')<Space><Bar><Space>normal! lvt'<CR>
onoremap ins :<C-U>call search("'")<Space><Bar><Space>normal! lvt'<CR>

"    _         _                                                      _     
"   / \  _   _| |_ ___   ___ ___  _ __ ___  _ __ ___   __ _ _ __   __| |___ 
"  / _ \| | | | __/ _ \ / __/ _ \| '_ ` _ \| '_ ` _ \ / _` | '_ \ / _` / __|
" / ___ \ |_| | || (_) | (_| (_) | | | | | | | | | | | (_| | | | | (_| \__ \
"/_/   \_\__,_|\__\___/ \___\___/|_| |_| |_|_| |_| |_|\__,_|_| |_|\__,_|___/
                                                                           

"autocommande
augroup programmation
    autocmd!
    autocmd FileType r call RLike()
    autocmd FileType c call CLike()
    autocmd FileType cpp call CppLike()
    autocmd FileType java call Java()
    autocmd FileType javascript call Nodejs()
    autocmd FileType,BufNewFile python call Python()
    autocmd FileType,BufNewFile octave call OctaveLike()
    autocmd FileType tex call Latex()
    autocmd FileType,BufNewFile sh call Sh()
    autocmd FileType,BufNewFile sql call Sql()
    autocmd FileType markdown call Markdown()
    autocmd BufReadPre,BufNewFile *.m call OctaveLike()
    autocmd BufReadPre,BufNewFile *.pl call Prolog()
    autocmd BufReadPre,BufNewFile *.php call Php()
    autocmd BufReadPre,BufNewFile note_* call NoteWindow()
    autocmd BufRead,BufNewFile /tmp/* call Project()
    autocmd BufReadPre,BufNewFile *.s call ARM()
    autocmd BufReadPre,BufNewFile *.xba call Basic()
    autocmd BufReadPre,BufNewFile ~/Documents/Répertoire/note/* call Programme()
    autocmd BufReadPre,BufNewFile ~/.vimrc call Vimrc()
    autocmd BufReadPre,BufNewFile *.ci call CI()
    "autocmd VimEnter * NERDTree
    autocmd FileType java setlocal omnifunc=javacomplete#Complete
    autocmd FileType scala call Scala()
    autocmd BufReadPre,BufNewFile Makefile call Makefile()
augroup END
