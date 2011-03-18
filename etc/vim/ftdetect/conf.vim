autocmd BufNewFile,BufRead $HOME/\(*/\|\)etc/nginx/*,*/etc/\(nginx\)/*
      \ if &ft =~# '^\%(nroff\|modula2\)$' |
      \   set ft=conf |
      \ else |
      \   setf conf |
      \ endif |
      \ set syntax=nginx
