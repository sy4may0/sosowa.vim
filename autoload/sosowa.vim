" Sosowa.vim
" Autoload script of sosowa.vim
" AUTHOR: sy4may0
" VERSION: 1.0

scriptencoding utf-8

let s:save_cpo = &cpo
set cpo&vim

let s:buf_name = '[sosowa] main_buf'

let g:sosowa_py_path = fnamemodify(resolve(expand('<sfile>:p')),':h:h')
        \ . '/rplugin/python3/'
let g:sosowa_conf_path = fnamemodify(resolve(expand('<sfile>:p')),':h:h')
        \ . '/conf.json'

" Script
function! g:sosowa#open_main_page()
    call s:reset_window()
    new `=s:buf_name`
    let b:is_sosowa_buffer = 1919810

python3 << EOF
import vim
import sys
sys.path.insert(0, vim.eval('g:sosowa_py_path'))
from sosowa_scraper.sosowa_requester import sosowa_requester

sreq = sosowa_requester(vim.eval('g:sosowa_conf_path'))

EOF

endfunction

function! s:reset_window()
    for i in range(1, bufnr("$"))
        unlet! s:nt
        let s:nt = getbufvar(i, "is_sosowa_buffer")
        if empty(s:nt)
            continue
        endif

        bdelete i
    endfor

endfunction


let &cpo = s:save_cpo
unlet s:save_cpo
