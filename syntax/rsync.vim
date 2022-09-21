if exists("b:current_syntax")
    finish
endif

syn match file '\S\+.*'                     contained
syn match folder '\S\+\/'                   contained nextgroup=file conceal
syn match timef '\S\+'                      contained nextgroup=folder,file skipwhite
syn match datef '\S\+'                      contained nextgroup=timef skipwhite
syn match sizef '\S\+'                      contained nextgroup=datef skipwhite
syn match modef '^\S\+'                     contained nextgroup=sizef skipwhite

syn match dir  '\S\+.*'                     contained
syn match timed '\S\+'                      contained nextgroup=dir skipwhite
syn match dated '\S\+'                      contained nextgroup=timed skipwhite
syn match sized '\S\+'                      contained nextgroup=dated skipwhite
syn match moded '^\S\+'                     contained nextgroup=sized skipwhite

syn match symtgt  '\S\+.*'                  contained conceal cchar=@
syn match symarr  '->'                      contained nextgroup=symtgt skipwhite
syn match symsrc  '\S\+.*\(->\)\@='         contained nextgroup=symarr skipwhite
syn match times '\S\+'                      contained nextgroup=symsrc skipwhite
syn match dates '\S\+'                      contained nextgroup=times skipwhite
syn match sizes '\S\+'                      contained nextgroup=dates skipwhite
syn match modes '^\S\+'                     contained nextgroup=sizes skipwhite

syntax region dirline start="^d" end="$"    oneline contains=moded
syntax region symline start="^l" end="$"    oneline contains=modes
syntax region fileline start="^-" end="$"   oneline contains=modef


hi def link sized Type
hi def link sizes Type
hi def link sizef Type
hi def link dated Function
hi def link dates Function
hi def link datef Function
hi def link timed String
hi def link times String
hi def link timef String

hi def link moded Statement
hi def link dir Statement

hi def link modef Identifier
hi def link folder Statement
hi def link file Identifier

hi def link modes Operator
hi def link symsrc Operator
hi def link symarr Comment
hi def link symtgt Special

function! Rsync_Expr(lnum)
    let is_dir = getline(a:lnum)[0] == 'd'
    let a = matchstr(getline(a:lnum), '\S\+\(\( ->\)\|$\)')
    let num_seps = len(split(a, '/', 1)) - 1
    if is_dir
        return '>' . (num_seps + 1)
    endif

    return num_seps
endfunction

setlocal foldexpr=Rsync_Expr(v:lnum)
setlocal foldmethod=expr
