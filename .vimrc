call plug#begin('~/.vim/plugged')

Plug 'https://github.com/keith/swift.vim.git'
Plug 'https://github.com/scrooloose/nerdtree.git'
Plug 'vimwiki/vimwiki'
Plug 'https://github.com/wikitopian/hardmode.git'
Plug 'https://github.com/ptzz/lf.vim.git'
Plug 'artur-shaik/vim-javacomplete2'

call plug#end()

"Code pour le status line
set statusline=
set statusline+=%#Cursor#\ VIM\ \ 
set statusline+=%#Normal#%{(mode()=='n')?'\ \ NORMAL\ ':''}
set statusline+=%#PmenuThumb#%{(mode()=='i')?'\ \ INSERT\ ':''}
set statusline+=%#TabLineFill#%{(mode()=='r')?'\ \ REPLACE\ ':''}
set statusline+=%#SpellRare#%{(mode()=='v')?'\ \ VISUAL\ ':''}
set statusline+=%#LineNr#\ %n\           " buffer number
set statusline+=%#Visual#       " colour
set statusline+=%#CursorIM#     " colour
set statusline+=%R                        " readonly flag
set statusline+=%M                        " modified [+] flag
set statusline+=%#Cursor#               " colour
set statusline+=%#CursorLine#     " colour
set statusline+=\ %t\                   " short file name
set statusline+=%=                          " right align
set statusline+=%#LineNr#   " colour
set statusline+=\ %3l:%-2c\         " line + column
set statusline+=%#Normal#\ %Y\                   " file type
set statusline+=%#Cursor#       " colour
set statusline+=%3p%%\                " percentage

let mapleader="à"
color elflord
set laststatus=2
if !has('gui_running')
	  set t_Co=256
endif

let g:CurrentFileExplorer= 1

filetype plugin on
set omnifunc=syntaxComplete#Complete
set complete+=kspell 

"Quelque définitions claires et simples pour le code en général
"set relativenumber
set path+=**
set cursorline
set wildmenu
set splitbelow
set splitright
set ignorecase
set smartcase
set incsearch
"pour que vimwiki n'ait pas trop de problème
set nocompatible
set cindent shiftwidth=8
set number
filetype indent on
"syntax on

"create quickly and easely a odp file with selected musii vimwiki
let wiki_1 = {}
let wiki_1.path = '~/'
let wiki_1.syntax = 'markdown'
let wiki_1.ext = '.md'

let g:vimwiki_list = [wiki_1]

"liste de fonction

function ShowColor()
	so $VIMRUNTIME/syntax/hitest.vim
endfunction

function FileExplorer()
	let g:CurrentFileExplorer= 1-g:CurrentFileExplorer	
	echom g:CurrentFileExplorer
	if g:CurrentFileExplorer == 1
		let g:NERDTreeHijackNetrw = 1 
		let g:lf_replace_netrw = 0 
	else
		let g:NERDTreeHijackNetrw = 0 
		let g:lf_replace_netrw = 1 
	endif
endfunction

function MkFiles(fichier)
	execute "!cp ~/note/template/".a:fichier.".".a:fichier." ." 
	execute "tabnew ".a:fichier.".".a:fichier
endfunction

function GetProjectPath()
	let pwd= system("pwd")
	let tab= split(pwd, "/")	
	return tab[0]."/".tab[1]."/".tab[2]."/".tab[3]
endfunction

function GetProjectName()
	let pwd= system("pwd")
	let tab= split(pwd, "/")	
	return tab[3]
endfunction

function Note()
	execute "tabnew ~/note/note_".g:extention.".md"
endfunction

function Ctags()
	execute "!ctags *.".g:extention." *.".g:extention_supplementaire
endfunction


"----------------------------------C--------------------------------

function RunC()
	!gcc % -o main && ./main
endfunction

function RunCPart()
	!cat % | grep include >> RunCPart.c && echo "int main(int argc, char *argv[]){" >> RunCPart.c
	call writefile(split(@","\n"), 'RunCPart.c', "a")
	!echo "}" >> RunCPart.c && gcc RunCPart.c -o main && ./main
	!rm RunCPart.c
endfunction

function CLike()
	let g:extention= "c"
	set nospell
	"Raccourci pour le langage c, le java et le javascript
	nnoremap <buffer> ép oprintf("%s\n", );<Esc>hi
	nnoremap <buffer> ésp oprintf("\n");<Esc>4hi
	nnoremap <buffer> éc ^i//<Esc>$<CR>
	xnoremap <buffer> éc :normal I//<CR>
	xnoremap <buffer> éd :normal ^xx<CR>
	inoremap <buffer> for for(int i= 0; i < n; i++){<CR><CR>}<Up>
	inoremap <buffer> for<CR> for
	inoremap <buffer> if if(){<CR><CR>}<Esc>2<Up>t)a
	inoremap <buffer> if<CR> if
	inoremap <buffer> else	else{<CR><CR>}<Up>
	nnoremap <buffer> édc ^xx
	inoremap <buffer> print printf("");<Left><Left><Left>
	inoremap <buffer> print<CR> printf("%d", );<Left><Left>
	inoremap <buffer> print<CR><CR> printf("%s", );<Left><Left>
	inoremap <buffer> function int<Space>(_){<CR><CR>}<Up><Up><Esc>f(i
	nnoremap <buffer> <F2> :call Note()<CR>
	nnoremap <buffer> <F5> :call RunC()<CR>
	xnoremap <buffer> <F5> y:call RunCPart()<CR>
	nnoremap <buffer> <F6> :! gcc *.c -o main && ./main<CR>
	nnoremap <buffer> <F9> :! bash ~/sh/mkc.sh
endfunction

"----------------------------------C++--------------------------------

function RunCpp3(type)
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

function CppLike()
	set nospell
	let g:extention= "cpp"
	let g:extention_supplementaire= "hpp"
	"Définition d'une variable global pour changer le nombre de processus parallèles
	let g:parallele= 1
	"Raccourci pour le langage c, le java et le javascript
	nnoremap <buffer> éc I//<Esc>$<CR>
	xnoremap <buffer> éc :normal I//<CR>
	nnoremap <buffer> éd ^xx
	xnoremap <buffer> éd :normal ^xx<CR>
	inoremap <buffer> print	std::cout<Space><<<Space><Space><<<Space>std::endl;<Esc>2F<Space>i
	iabbrev <buffer> ok Okay
	iabbrev <buffer> vector std::vector<><Space>(,<Right>;<Esc>F<a
	iabbrev <buffer> list std::list<int><Space>
	iabbrev <buffer> for for(auto i: v<Right>{<CR><CR><Up>
	iabbrev <buffer> forr for({<CR><CR><Up><Up><Left><Left>
	iabbrev <buffer> forrr for(int i= 0; i < n; i++<Right>{<CR><CR><Right><Up>
	iabbrev <buffer> if if(<Right>{<CR><CR><Esc>2<Up>ta
	iabbrev <buffer> while while(<Right>{<CR><CR><Esc>2<Up>ta
	iabbrev <buffer> else	else{<CR><CR><Up>
	inoremap <buffer> function int<Space>({<CR><CR>}<Up><Up><Esc>f(i
	iabbrev <buffer> recv MPI_Status<Space>status;<CR>MPI_Recv(&, sizeof(int, MPI_INT, i, 0, MPI_COMM_WORLD, &status;<Esc>F&a
	iabbrev <buffer> vrecv MPI_Status<Space>status;<CR>MPI_Recv(v.data(, v.size(, MPI_INT, i, 0, MPI_COMM_WORLD, &status;<Esc>
	iabbrev <buffer> send MPI_Send(&, sizeof(int, MPI_INT, i, 0, MPI_COMM_WORLD;<Esc>F&a
	iabbrev <buffer> vsend MPI_Send(v.data(, v.size(, MPI_INT, i, 0, MPI_COMM_WORLD;<Esc>
	iabbrev <buffer> barri MPI_Barrier(MPI_COMM_WORLD;<CR>double<Space>start<space>=<space>MPI_Wtime(;
	iabbrev <buffer> end end<Space>=<Space>MPI_Wtime(;<CR><CR>if(myRank==0<Space>std::cout<Space><<<Space>"temps<Space>de<Space>l'operation<Space>:<Space>"<Space><<<Space>end-start<Space><<<Space>"[s]"<Space><<<Space>std::endl;<Esc>

	"SNIPPETS
	iabbrev <buffer> smain <Esc>:r<Space>~/note/snippet/cpp.cpp<CR>
	iabbrev <buffer> smainmpi <Esc>:r<Space>~/note/snippet/cpp_mpi.cpp<CR>
	nnoremap <buffer> <F2> :call Note()<CR>
	nnoremap <buffer> <F4> :call RunCpp3("normal")<CR>
	xnoremap <buffer> <F5> y:call RunCpp3("part")<CR>
	nnoremap <buffer> <F5> :call RunCpp3("mpi")<CR>
	nnoremap <buffer> <F6> :let g:parallele= 
	nnoremap <buffer> <F9> :call MkFiles("cpp")<CR>
	inoremap <buffer> <C-d> <Esc>/_<CR>s
endfunction

"----------------------------------JAVA--------------------------------

function RunJava()
	let filepath = expand('%:p')
	let parentname = expand('%:p:h:t')
	let nomunique = expand('%:r')
	execute ":!javac *.java && java ".nomunique
endfunction

function Java()
	set nospell
	let g:extention= "java"
	nnoremap <buffer> <F2> :call Note()<CR>
	nnoremap <buffer> <F5> :call RunJava()<CR>
	nnoremap <buffer> <F9> :!bash ~/sh/mkjava.sh 
	nnoremap <buffer> éc ^i//<Esc>
	xnoremap <buffer> éc :normal I//<CR>
	nnoremap <buffer> éd ^xx<Esc>
	xnoremap <buffer> éd :normal ^xx<CR>
	inoremap <buffer> print System.out.println();<Esc><Left>i
	inoremap <buffer> function public void (){<CR><CR>}<Esc><Up><Up>$Tda
	inoremap <buffer> if if(){<CR><CR>}<Esc>2<Up>t)a
	inoremap <buffer> else	else{<CR><CR>}<Up>
	inoremap <buffer> try try{<CR><CR>}<CR>catch(InterruptedException e){<CR>System.out.println("Erreur");<CR>}<Esc><Up><Up><Up><Up>
	inoremap <buffer> while while(){<CR><CR>}<Esc><Up><Up>t)a
	inoremap <buffer> for for(int i= 0; i<len; i++){<CR><CR>}<Up>
endfunction	


"----------------------------------PYTHON--------------------------------

function RunPython3(type)
	if a:type == "normal"
		set makeprg=python3\ % | less
	elseif a:type == "interactive"
		set makeprg=python3\ -i %
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

function Python()
	set nospell
	let g:extention="py"
	
	"Raccourci pour le langage python
	nnoremap <buffer> éc ^i#<Esc><CR>
	xnoremap <buffer> éc :normal I#<CR>
	xnoremap <buffer> éd :normal ^x<CR>
	nnoremap <buffer> éd ^x 
	inoremap <buffer> print print()<Left>
	inoremap <buffer> printg print("")<Left><Left>
	iabbrev <buffer> class class<Space>():<CR><CR>def<Space>__init__(self):<CR>#code<Up><Up><Up><Left><Left><Left>
	iabbrev <buffer> for for<Space>i<Space>in<Space>:<Left>

	inoremap <buffer> def<Space> def ():<Esc>F(i
	nnoremap <buffer> <F2> :call Note()<CR>
	nnoremap <buffer> <silent> <F4> :call RunPython3("interactive")<CR>
	nnoremap <buffer> <silent> <F5> :call RunPython3("normal")<CR>
	xnoremap <buffer> <silent> <F5> y:call RunPython3("part")<CR>
	nnoremap <buffer> <F6> :!python3 -m pydoc 

	"numpy shortcuts
	inoremap <buffer> npa np.array([])<Left><Left>
	inoremap <buffer> npdo np.dot(,_)<Left><Left><Left>
	inoremap <buffer> npde np.linalg.det()<Left>
endfunction


"----------------------------------OCTAVE--------------------------------


function RunOctave()
	let @o= system("octave ".bufname('%')) 
	echo @o
	echom "octave!"
endfunction

function OctaveLike()
	set nospell
	let g:extention= "py"
	"Raccourci pour le langage octave
	nnoremap <buffer> éc ^i%<Esc><CR>
	nnoremap <buffer> édc ^x 
	nnoremap <buffer> <F2> :call Note()<CR>
	nnoremap <buffer> <F4> :!octave --no-gui<CR>
	nnoremap <buffer> <F5> :call RunOctave()<CR>
endfunction


"----------------------------------latex--------------------------------

function Latex()
	set spell
	set spelllang=fr_ch
	nnoremap <buffer> éé i\<Esc>
	nnoremap <buffer> és o\section{}<Esc>i
	nnoremap <buffer> éss o\subsection{}<Esc>i
	nnoremap <buffer> éi i\textit{}<Esc>i
	nnoremap <buffer> éb i\textbf{}<Esc>i
	nnoremap <buffer> éc i\textsf{}<Esc>i
	nnoremap <buffer> éii o\includegraphics[scale=1.2]{image}
	inoremap <CR> \\<CR> 
	nnoremap <buffer> <F2> :call Note("tex")<CR>
	nnoremap <buffer> <F5> :execute ":!pdflatex ".bufname("%")." && zathura ".expand('%:r').".pdf" <CR>
endfunctio

"------------------------------------BASH-------------------------------------
function RunBashPart()
	call writefile(split(@","\n"), 'RunBashPart.sh', "a")
	!chmod +x RunBashPart.sh
	!./RunBashPart.sh
	!rm RunBashPart.sh
endfunction

function Sh()
	set nospell
	let g:extention="sh"
	nnoremap <buffer> éc ^i#<Esc><CR>
	xnoremap <buffer> éc :normal I#<CR>
	nnoremap <buffer> éd ^x 
	xnoremap <buffer> éd :normal ^x<CR>
	nnoremap <buffer> <F2> :call Note("sh")<CR>
	inoremap <buffer> [ [<Space><Space>]<Left><Left>
	iabbrev <buffer> elif elif<Space>[<Space>];<Space>then<CR><Up><Right><Right>
	iabbrev <buffer> if <Esc>:r<Space>~/note/snippet/bash/if.sh<CR>
	iabbrev <buffer> function (){<CR><CR>}<Up><Up>
	nnoremap <buffer> <F5> :!./%<CR>
	xnoremap <buffer> <F5> y:call RunBashPart()<CR>
endfunction


"-----------------------------------MYSQL---------------------------------------


function RunSql()
	let contenu= system("cat ".bufname("%"))
	execute ":!mysql -u user -pd367*WGa! -e '".contenu."'"
endfunction

function Sql()
	set nospell
	nnoremap <buffer> éc ^i/*<Esc>A*/<Esc>
	nnoremap <buffer> éd ^xx$xx
	nnoremap <buffer> <F4> :!mysql -u user -pd367*WGa!<CR>
	nnoremap <buffer> <F5> :call RunSql()<CR>
endfunction


"------------------------------------------MARKDOWN-------------------------------------
"

function Chant()
	execute ":normal! Vy"
	execute ":tabnew ../txt/".@"
endfunction

function MarkdownLigne()
	execute ":normal! yyo"
	let tab= split(@", "	")
	for i in tab
		let n= len(i)
		let @a= "-"	
		execute ":normal! ".n."\"apa	"
	endfor
endfunction

function MarkdownTitre()
	normal yy
	let l= len(@")
	let ligne= ""
	let i= 0
	while i < l
		let ligne= ligne."="
		let i +=1
	endwhile
	execute "normal o".ligne
endfunction

function Imagerie()
	if ! filereadable("imagerie_numerique.md")
		execute ":! cp ~/note/imagerie_numerique.md ."
	endif
	execute ":! pandoc imagerie_numerique.md ".bufname("%")." ~/note/imagerie_numerique.yaml -o ".expand("%:r").".pdf && zathura ".expand("%:r").".pdf"
endfunction

function AddTask()
	"Formatage
	let formated= substitute(@", "'", " ", "g")
	let formated= substitute(formated, "-", "", "g")
	let lignes= split(formated, "\n")
	let projet= GetProjectName()
	"Exploration récursive
	for ligne in lignes
		execute ":!task add ".ligne." project:".projet."\n"
	endfor
endfunction

function Markdown()
	"Markdown commands
	let g:extention="markdown"
	set nospell
	set spelllang=fr_ch,en_us
	"mode normal
	nnoremap <buffer> ét :call MarkdownTitre()<CR>
	nnoremap <buffer> éta :VimwikiTable<CR>
	nnoremap <buffer> és <Esc>I##<Space><Esc>
	nnoremap <buffer> éss <Esc>I###<Space><Esc>
	nnoremap <buffer> ésss <Esc>I####<Space><Esc>
	nnoremap <buffer> éb I**<Esc>A**<Esc>
	xnoremap <buffer> éb di****<Esc>2<Left>p
	nnoremap <buffer> éco i``````<Left><Left><Left><CR><CR><Up>
	nnoremap <buffer> éim i![](../../images/num.png)<Esc>^<Right>a
	nnoremap <buffer> ém bi`<Esc>ea`<Esc>
	xnoremap <buffer> ém di``<Esc><Left>p
	nnoremap <buffer> <C-P> :!. ~/sh/cs.sh<CR>

	inoremap <buffer> ééb ****<Left><Left>
	inoremap <buffer> ééit __<Left>
	inoremap <buffer> ééti #<Space>
	inoremap <buffer> éés <Esc>I##<Space>
	inoremap <buffer> ééss <Esc>I###<Space>
	inoremap <buffer> éésss <Esc>I####<Space>
	inoremap <buffer> ééco ``````<Left><Left><Left><CR><CR><Up>
	inoremap <buffer> éém ``<Left>
	inoremap <buffer> ééta <Esc>:call MarkdownLigne()<CR>
	inoremap <buffer> ééd \begin{tikzpicture}<CR><CR>\end{tikzpicture}
	inoremap <buffer> ééim ![](../../images/num.png)<Esc>^<Right>a
	inoremap <buffer> éér \rectangle{nom}{x}{y}
	inoremap <buffer> ééff \fleche{nom1}{nom2}{label}
	inoremap <buffer> ééfff \flechel{nom1}{nom2}{label}{angleIn}{angleOut}
	nnoremap <buffer> <F2> :let note= Note("markdown")<CR>
	nnoremap <buffer> <F4> :call LinkImage()<CR>
	nnoremap <buffer> <F5> :!bash ~/sh/compmd %<Space>
	nnoremap <buffer> <F6> :call Imagerie()<CR>
	xnoremap <buffer> <F8> y:call AddTask()<CR>
endfunction

"---------------------------------------PROLOG-------------------------------------

function Swipl()
	set nospell
	nnoremap <buffer> éc I%<Esc>
	nnoremap <buffer> <F4> :!swipl<CR>
	nnoremap <buffer> <F5> :!swipl %<CR>
	nnoremap <buffer> <F2> :let note= Note("pl")<CR>
endfunction

"---------------------------------------PHP-------------------------------------

function RunPhp()
	let nomunique = expand('%:r')
	execute ":!php ".bufname('%')
endfunction

function Php()
	set nospell
	let g:extention="php"
	"mode normal
	nnoremap <buffer> php i<?php<CR><CR>><Up>
	nnoremap <buffer> <F5> :call RunPhp()<CR>
	nnoremap <buffer> <F5> :!chromium http://localhost/login.html<CR>
	nnoremap <buffer> éc ^i//<Esc>

	"mode insertinon
	inoremap <buffer> echo echo "\n";<Left><Left><Left><Left>
	inoremap <buffer> function function (){<CR><CR>}<Up><Up><Esc>A<Left><Left><Left>
	inoremap <buffer> elseif elseif(){<CR><CR>}<Up><Up><Esc>A<Left><Left>
	inoremap <buffer> if if(){<CR><CR>}<Up><Up><Esc>A<Left><Left>
	inoremap <buffer> else else{<CR><CR>}<Up>
	inoremap <buffer> post $_POST['']<Left><Left>
endfunction 

function NoteWindow()
	let g:note= 0
	nnoremap <buffer> <F2> :wq<CR>
endfunction

function GoToProject()
	execute ":normal! yiw"
	execute ":!tmux new-window && tmux send-keys -t 0 '. ~/sh/projet.sh".@"."' Enter"
endfunction

function Projet()
	nnoremap <Enter> :call GoToProject()<CR>
endfunction

"------------------------------------ARM----------------------
"
function RunARM()
	let @o= system("arm-linux-gnueabi-gcc ".bufname('%')."&& qemu-arm -L /usr/arm-linux-gnueabi a.out") 
	echo @o
endfunction

function ARM()
	let g:extention="s"
	nnoremap <buffer> <F5> :call RunARM()<CR>
	nnoremap <buffer> <F2> :call Note("s")<CR>
	nnoremap <buffer> éti I//----------a----------//<Esc>Ta<Left>s
	nnoremap <buffer> éc A<Tab>//
	nnoremap <buffer> éwo gg<Down>o:<Tab>.word<tab>
	nnoremap <buffer> éby gg<Down>o:<Tab>.byte<tab>
	nnoremap <buffer> éin gg<Down>o:<Tab>.int<tab>
	nnoremap <buffer> élo gg<Down>o:<Tab>.long<tab>
	nnoremap <buffer> ést gg<Down>o:<Tab>.string<tab>
	nnoremap <buffer> éas gg<Down>o:<Tab>.asciz<tab>""<Left>
	inoremap <buffer> function :<Tab>stmfd<Tab>sp!,{r4-r11}<CR><Tab>ldmfd<Tab>sp!,{r4-r11}<CR><Tab>mov<Tab>pc,lr<Esc><Up><Up>I
	inoremap <buffer> print ldr<Tab>r0,=<CR><Tab>bl<Tab>printf<Esc><Up>A
endfunction

function Nodejs()
	set nospell
	nnoremap <buffer> <F5> :!node %<CR>
endfunction

"------------------------------------BASIC----------------------
"
function RunBasic()
	execute "!soffice macro:///standard.".expand('%:t:r').".main"
endfunction

function Basic()
	inoremap <buffer> " &quot;&quot;<Left><Left><Left><Left><Left><Left>
	inoremap <buffer> & &amp;
	nnoremap <buffer> <F5> :call RunBasic()<CR>
	nnoremap <buffer> <F2> :call Note("basic")<CR>
	nnoremap <buffer> éc Irem <Esc>
endfunction

function LinkImage()
	execute ":normal! ^d$"
	let formated= substitute(@", " ", "_", "g")
	execute ":normal! i![".formated."](../../images/".formated.".png)"
	execute ":! ~/sh/myimport vim ".formated
endfunction

function MakeSpace()
	execute ":normal! ^d$"
	let formated= substitute(@", "_", " ", "g")
	execute ":normal! i".formated
endfunction

function Myformat()
	execute ":normal! ^d$"
	let formated= substitute(@", "_", " ", "g")
	execute ":normal! i".formated
endfunction

"----------------------R-----------------------------

function RLike()
	inoremap <buffer> matrix matrix(a,<Space>byrow=TRUE,<Space>ncol=)<Left>
	inoremap <buffer> dataframe data.frame()<Left>
	inoremap <buffer> ** %*%

	nnoremap <buffer> éc I#<Esc>
	xnoremap <buffer> éc :normal! I#<CR>
	xnoremap <buffer> éd :normal! ^x<CR>

	inoremap <buffer> print print()<Left>
	inoremap <buffer> while while(){<CR><CR>}<Up><Up><Esc>t{i
	inoremap <buffer> function <-function(){<CR><CR>}<Up><Up><Esc>I
	inoremap <buffer> if if(){<CR><CR>}<Esc>2<Up>t)a
	inoremap <buffer> else else{<CR><CR>}<Up>
	inoremap <buffer> return return()<Left>

	nnoremap <buffer> <F2> :call Note("r")<CR>
	nnoremap <buffer> <F4> :!R<CR>
	nnoremap <buffer> <F5> :!Rscript %<CR>
	nnoremap <buffer> <F6> :!Rscript % | less<Esc>
endfunction

function Makefile()
	mks!
	if ! filereadable("Makefile")
		!cp ~/note/Makefile .
	endif
	call Ctags()
	wall 
	so $MYVIMRC
endfunction

function Programme()
	call Markdown()
	nnoremap <buffer> <F2> :let note= Note("programme")<CR>
	nnoremap <buffer> éé :!gedit %<CR>
	nnoremap <buffer> éy :!chromium https://www.youtube.com/&<CR>
	nnoremap <buffer> éc :call Chant()<CR>
endfunction

function Vimrc()
	iabbrev <buffer> space <Space>
	iabbrev <buffer> cr <CR>
	iabbrev <buffer> right <Right>
	iabbrev <buffer> left <Left>
	iabbrev <buffer> up <Up>
	iabbrev <buffer> down <Down>
	iabbrev <buffer> esc <Esc>
endfunction

function CopyLine(num)
	execute a:num."t."
endfunction

function CI()
	iabbrev <buffer> af afficher;<Left>
	iabbrev <buffer> boucle boucle<CR>{<CR><CR><Up><Up><Up><Esc>A
	iabbrev <buffer> inv inv;<Left>
	iabbrev <buffer> racine racine;<Left>
	iabbrev <buffer> aff aff_ral;<Esc>
endfunction

"commandes en command mode
command -nargs=1 CpL :call CopyLine(<args>)<CR>
command So :so $MYVIMRC
nnoremap cp <Esc>:CpL<Space>

"autocommande
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
autocmd BufReadPre,BufNewFile *.pl call Swipl()
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

"Actions pour les plugins et les touches F1-F12
let g:vimrc_window= 0
nnoremap <F1> :tabnew ~/.vimrc<CR>
nnoremap <F3> :! ~/sh/mymake 
"pour faire une capture d'écran qui va directement dans le dossier images existant
xnoremap éspa :call MakeSpace()<CR>
nnoremap <F7> :make<Space>
set pastetoggle=<F8>
nnoremap <F9> :so $VIMRUNTIME/syntax/hitest.vim<CR>
nnoremap <F10> :!gedit %<CR>
nnoremap <F12> :!clear<CR>
nnoremap <Space> .
nnoremap èè :call Makefile()<CR>

function CollageMap()
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
endfunction

"Raccourci pour le code en général
let collage= 0
let g:note= 0
call CollageMap()
nnoremap édb :cope<CR>
nnoremap écta :call Ctags()<CR>
nnoremap vp :vsp .<CR>
nnoremap vs :sp .<CR>
nnoremap tn :LfNewTab<CR>

"Mouvements spéciaux
nnoremap <C-L> :tabn<CR>
nnoremap <C-H> :tabp<CR>
nnoremap <C-K> {
nnoremap <C-J> }
nnoremap <C-F> /

"Mouvement en mode pending operator
onoremap in( :<c-u>normal! f(vi(<CR>
onoremap lp :normal t)vF,<CR>

inoremap <C-C> <Esc>:w<CR>
inoremap <C-S> <Right>
inoremap <buffer> <C-L> <Esc>/_<CR>s
nnoremap <buffer> ég :!gedit %<CR>




"\e	<Esc>
"\t	<Tab>
"\r	<CR>
"\b	<BS>
"
"
"item	matches			equivalent ~
"\d	digit			[0-9]
"\D	non-digit		[^0-9]
"\x	hex digit		[0-9a-fA-F]
"\X	non-hex digit		[^0-9a-fA-F]
"\s	white space		[ 	]     (<Tab> and <Space>)
"\S	non-white characters	[^ 	]     (not <Tab> and <Space>)
"\l	lowercase alpha		[a-z]
"\L	non-lowercase alpha	[^a-z]
"\u	uppercase alpha		[A-Z]
"\U	non-uppercase alpha	[^A-Z]
"
