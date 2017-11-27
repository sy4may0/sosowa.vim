" Sosowa.vim
" Autoload script of sosowa.vim
" AUTHOR: sy4may0
" VERSION: 1.0

scriptencoding utf-8

let s:save_cpo = &cpo
set cpo&vim

let s:buf_name = '[sosowa] main_buf'

" Script
function! g:sosowa#open_main_page()
    echo "open_main_pageOOOOOOO"
    new `=s:buf_name`

endfunction


let &cpo = s:save_cpo
unlet s:save_cpo
