" Eklenti tercihleri

" Bazı eklentiler kullanıcı tercihlerini yüklenmeden sonra alıyor.  Bu tür
" eklentilerin kullanıcı tercihlerini bu dosyada tutuyoruz.  DİKKAT!  Önce
" eklentinin varlığını denetlemelisiniz.  Aksi halde hata olacaktır.

" Bu dizin ve üstünde bir inşa dosyası (öntanımlı Makefile) var mı?
function! s:has_buildfile(...)
	let buildfile = (a:0 != "" ? a:0 : "Makefile")
	let found = findfile(buildfile, escape(expand("%:p:h"), ' ~|!"$%&()=?{[]}+*#'."'") . ";")
	" Ev dizinindeki çöp dosyaları dikkate alma.
	return found != "" && found != $HOME . "/" . buildfile
endfunction

" Go geliştirme ortamı bilgilerini topla
function! s:goinfo()
	for ext in [6, 8, 5]
		let compiler = ext . 'g'
		if executable(compiler)
			return { 'ext': ext, 'compiler': compiler, 'linker': ext . 'l' }
		endif
	endfor
	return {}
endfunction

" Go için ön hazırlık.
if !exists('s:goinfo')
	let s:goinfo = s:goinfo()
endif

if exists("g:loaded_syntastic_plugin")
	sign define SyntasticError text=―▶ texthl=Search
	sign define SyntasticWarning text=>> texthl=Warning
	let g:syntastic_enable_signs=1
	set statusline+=%#warningmsg#
	set statusline+=%{SyntasticStatuslineFlag()}
	set statusline+=%*

	if !empty(s:goinfo)
		" Önce mevcut go eklentisini yükle (üzerine yazacağız)
		runtime! syntax_checkers/go.vim

		" Syntastic ile gelen işlevi değiştir, sadece 64 bit için çalışıyor.
		function! SyntaxCheckers_go_GetLocList()
			let makeprg = s:goinfo['compiler'] . ' -o /dev/null '. shellescape(expand('%'))
			let errorformat = '%E%f:%l: %m'

			return SyntasticMake({ 'makeprg': makeprg, 'errorformat': errorformat })
		endfunction
		" Fakat Go projelerinde Syntastic'i iptal etmek yerine en azından basit
		" sözdizimi denetimi yap.
		function! s:simple_syntax_check_on_go_projects()
			if ! executable('govet')
				SyntasticDisable
				return
			endif
			function! SyntaxCheckers_go_GetLocList()
				let makeprg = 'govet ' . shellescape(expand('%'))
				let errorformat =  '%Egovet: %s: %f:%l:%v: %m'
				return SyntasticMake({ 'makeprg': makeprg, 'errorformat': errorformat })
			endfunction
		endfunction
		autocmd FileType go if s:has_buildfile() | call s:simple_syntax_check_on_go_projects() | endif
	endif

	" Statik tipli bazı dillerde geliştirilen projelerde Syntastic
	" eklentisini etkisizleştir, aksi halde (önceden derlenmesi gereken
	" kaynak dosyaların varlğından dolayı) gürültü oluyor.
	autocmd FileType c,cpp if s:has_buildfile() | SyntasticDisable | endif

endif

if exists("g:loaded_SingleCompile")
	if !empty(s:goinfo)
		if has('unix')
			call SingleCompile#SetTemplate('go', 'command', s:goinfo['compiler'])
			call SingleCompile#SetTemplate('go', 'run', 'clear; ' . s:goinfo['linker'] . ' -o %< %<.' . s:goinfo['ext'] . ' && ./%<')
		endif
	endif

	function! MakeOrSingleCompile()
		if s:has_buildfile()
			make
		else
			SCCompile
		endif
	endfunction

	function! MakeRunOrSingleCompileRun()
		if s:has_buildfile()
			let prog = expand("%<")
			lmake
			if filereadable(prog)
				execute '!clear && ./' . prog
			endif
		else
			SCCompileRun
		endif
	endfunction

	if ! hasmapto("<F9>")
		nmap <F9> :call MakeOrSingleCompile()<cr>
	endif
	if ! hasmapto("<F10>")
		nmap <F10> :call MakeRunOrSingleCompileRun()<cr>
	endif
endif

if exists("g:loaded_yaifa")
	function! s:unload_yaifa_on_blank_files()
		let i = 1
		while i <= 10
			if getline(i) =~ '\S'
				return
			endif
			let i += 1
		endwhile
		au! YAIFA
	endfunction
	au FileType * call s:unload_yaifa_on_blank_files()
endif

if exists("colors_name") && colors_name == "tir_black"
	hi StatusLineNC guifg=black guibg=#202020 ctermfg=234 ctermbg=245
endif
