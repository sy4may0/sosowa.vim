" Sosowa.vim
" Autoload script of sosowa.vim
" AUTHOR: sy4may0
" VERSION: 1.0

scriptencoding utf-8

let s:save_cpo = &cpo
set cpo&vim

let s:buf_name_main = '[sosowa] main_buf'
let s:buf_name_article = '[sosowa] article_buf'

let g:sosowa_py_path = fnamemodify(resolve(expand('<sfile>:p')),':h:h')
        \ . '/rplugin/python3/'
let g:sosowa_conf_path = fnamemodify(resolve(expand('<sfile>:p')),':h:h')
        \ . '/conf.json'
let g:sosowa_current_page = -1

function! s:open_main_page()
python3 << EOF
import vim
import sys
sys.path.insert(0, vim.eval('g:sosowa_py_path'))
from sosowa_scraper.sosowa_requester import sosowa_requester

sosowa_sreq = sosowa_requester(vim.eval('g:sosowa_conf_path'))
sosowa_obj_page = int(vim.eval('g:sosowa_current_page'))

if sosowa_obj_page > sosowa_sreq.get_latest_page():
    print("No next page")
    vim.command("let g:sosowa_current_page = " + str(sosowa_sreq.get_latest_page()))
elif sosowa_obj_page == 0:
    print("No previous page")
    vim.command("let g:sosowa_current_page = 1")
elif sosowa_obj_page < 0:
    vim.command("let g:sosowa_current_page = " + str(sosowa_sreq.get_latest_page()))

sosowa_alist = sosowa_sreq.get_sosowa_product_list(int(vim.eval("g:sosowa_current_page"))) 

for sosowa_k in sosowa_alist.keys():
    vim.current.buffer.append(sosowa_alist[sosowa_k].title_tostring())
    vim.current.buffer.append(sosowa_alist[sosowa_k].detail_tostring())
    vim.current.buffer.append(sosowa_alist[sosowa_k].tag_tostring())

EOF
endfunction

" Script
function! g:sosowa#open_main_page(...)
    call s:reset_window()
    new `=s:buf_name_main`
    let b:is_sosowa_buffer = 1919810
    if a:0 >= 1
        let g:sosowa_current_page = a:1
    endif
    
    setlocal buftype=nowrite
    call s:open_main_page()
    setlocal readonly

    nnoremap <buffer> <silent> <CR> :<C-u>call g:sosowa#show_object()<CR>
    nnoremap <buffer> <silent> h :<C-u>call g:sosowa#next_page()<CR>
    nnoremap <buffer> <silent> l :<C-u>call g:sosowa#prev_page()<CR>
    nnoremap <buffer> <silent> q :<C-u>q!<CR>

endfunction

function! g:sosowa#next_page()
    if exists('b:is_sosowa_buffer') 
    \ && exists('g:sosowa_current_page')
    \ && b:is_sosowa_buffer == 1919810

        call g:sosowa#open_main_page(g:sosowa_current_page + 1)
    else
        echo "There is not sosowa main window"
    endif

endfunction

function! g:sosowa#prev_page()

    if exists('b:is_sosowa_buffer') 
     \ && exists('g:sosowa_current_page')
     \ && b:is_sosowa_buffer == 1919810
        call g:sosowa#open_main_page(g:sosowa_current_page - 1)
    else
        echo "There is not sosowa main window"
    endif

endfunction

function! s:show_object(id)
let s:article_id = a:id
python3 << EOF
import vim
import sys
sys.path.insert(0, vim.eval('g:sosowa_py_path'))
from sosowa_scraper.sosowa_requester import sosowa_requester

sosowa_sreq = sosowa_requester(vim.eval('g:sosowa_conf_path'))

sosowa_current_page = int(vim.eval('g:sosowa_current_page'))
sosowa_article_id = vim.eval('s:article_id')

sosowa_article = sosowa_sreq.get_sosowa_article(sosowa_article_id, sosowa_current_page)

for line in sosowa_article.content_array():
    vim.current.buffer.append(line)
 
EOF
endfunction
 
function! g:sosowa#show_object()
    if exists('b:is_sosowa_buffer') 
     \ && exists('g:sosowa_current_page')
     \ && b:is_sosowa_buffer == 1919810
        let s:line = getline('.')
        if s:line[0] != '|'
            let s:obj_id = matchstr(s:line, '\d*', 0)
        else
            echo "Attribute for open objects not found."
            return
        endif

        call s:reset_window()
        new `=s:buf_name_article`
        let b:is_sosowa_buffer = 114514

        setlocal buftype=nowrite
        call s:show_object(s:obj_id)
        setlocal readonly

        nnoremap <buffer> <silent> q :<C-u>call g:sosowa#open_main_page()<CR>

    else
        echo "There is not sosowa main window"

    endif

endfunction

function! s:reset_window()
    for i in range(1, bufnr("$"))
        unlet! s:nt
        let s:nt = getbufvar(i, "is_sosowa_buffer")
        if empty(s:nt)
            continue
        endif

        bdelete! i
    endfor

endfunction

let &cpo = s:save_cpo
unlet s:save_cpo
