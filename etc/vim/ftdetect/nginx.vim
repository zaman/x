autocmd BufNewFile,BufRead $HOME/\(*/\|\)etc/nginx/*,*/etc/\(nginx\)/*
      \ if &ft =~# '^\%(conf\|modula2\|nroff\)$' |
      \   set ft=nginx |
      \ else |
      \   setf nginx |
      \ endif
