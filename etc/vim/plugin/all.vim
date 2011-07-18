" Tüm kipler
augroup alledit
	" Daima düzenlenen dosyanın bulunduğu dizine geç.
	autocmd BufEnter * lcd %:p:h

	" Dosyayı düzenlerken kursörü en son bilinen konuma al.
	autocmd BufReadPost *
		\ if line("'\"") > 0 && line("'\"") <= line("$") |
		\	execute "normal g`\"" |
		\ endif

	" Öntanımlı stil.
	set tabstop=8 softtabstop=8 shiftwidth=8 noexpandtab

	" Aşağıdaki kelimeleri daima renklendir.
	autocmd BufRead,BufNewFile * syntax keyword Todo TODO XXX FIXME

	" Listele biçimle.
	function! FormatList(...)
		let mode = (a:0 > 0) ? a:1 : &ft

		execute 'autocmd FileType ' . mode . ' setlocal ' .
				\ 'formatoptions+=tcqn ' .
				\ 'comments-=mb:* comments-=fb:- comments+=fb:-,fb:+,fb:*,fb::'
		execute 'autocmd FileType ' . mode . ' setl ' .
			\ 'formatlistpat=^\\s*\\(\\(\\d\\+\\\|[a-zA-Z]\\)[\\].)]\\s*\\\\|\\[\\w\\+\\][:]*\\s\\+\\)'
	endfunction
	for ft in ['text', 'mail', 'git', 'svn', 'markdown', 'rst', 'debchangelog']
		call FormatList(ft)
	endfor

	" .vimrc düzenlendiğinde tekrar yükle.
	autocmd! BufWritePost .vimrc source ~/.vimrc

	if &term != 'builtin-gui'
		let &titleold = substitute(getcwd(), '^' . $HOME, '~', '')
		set title
	endif

	" Uçbirim coğullayıcıda çalışıyorsak pencere başlığını düzenlenen dosya olarak ayarla
	" ve konsol kipinde çalışmayan bazı tuş kombinasyonlarını tanımla.
	if &term =~ 'screen'
		execute "set title titlestring=%y\\ %f | set t_ts=\<ESC>k t_fs=\<ESC>\\"
		imap [B <c-down>
		imap [A <c-up>
		imap [C <c-right>
		imap [D <c-left>
	endif
augroup END

