" Eklenti tercihleri

" Bazı eklentiler kullanıcı tercihlerini yüklenme anındaki alıyor.  Bu
" tür eklentilerin kullanıcı tercihlerini bu dosyada tutuyoruz.

" Netrw tarihçe ve yerler dosyaları nereye yazılsın?
let g:netrw_home=$HOME

" Align eklentisinin kendine özel menü almasını engelle
let g:DrChipTopLvlMenu="Plugin."

" SuperTab eklentisinde kullanılan sekme tuşu Snipmate ile çakışıyor.
let g:SuperTabMappingForward  = '<c-down>'
let g:SuperTabMappingBackward = '<c-up>'

" exuberant-ctags paketi kurulu olmayabilir, taglist eklentisini sustur.
if !executable('ctags')
	let loaded_taglist = 'yes'
endif
