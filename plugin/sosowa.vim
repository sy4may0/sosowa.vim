" sosowa.vim
" plugin script of sosowa.vim.
" AUTHOR: sy4may0
" VERSION: 1.0

scriptencoding utf-8

let s:save_cpo = &cpo
set cpo&vim

autocmd FileType sosowa_vim nnoremap <buffer> q <C-w>c

"script
command! -nargs=? SosowaOpen call g:sosowa#open_main_page(<f-args>)

command! SosowaNextPage call g:sosowa#next_page()
"
command! SosowaPrevPage call g:sosowa#prev_page()
"
command! SosowaShowObject call g:sosowa#show_object()
"
"command! SosowaBackMain call s:sosowa#back_main()
"
let &cpo = s:save_cpo
unlet s:save_cpo
