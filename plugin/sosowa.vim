" sosowa.vim
" plugin script of sosowa.vim.
" AUTHOR: sy4may0
" VERSION: 1.0

scriptencoding utf-8

let s:save_cpo = &cpo
set cpo&vim

"script
command! SosowaOpen call g:sosowa#open_main_page()

"command! SosowaNextPage call s:sosowa#next_page()
"
"command! SosowaPrevPage call s:sosowa#prev_page()
"
"command! -nargs=1 SosowaJumpPage call s:sosowa#jump_page(<f-args>)
"
"command! -nargs=1 SosowaShowArticle call s:sosowa#show_article(<f-args>)
"
"command! SosowaBackMain call s:sosowa#back_main()
"
let &cpo = s:save_cpo
unlet s:save_cpo
