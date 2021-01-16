" Vim syntax file for GNU Emacs' Org mode
"
" Maintainer:   Alex Vear <av@axvr.io>
" License:      Vim (see `:help license`)
" Location:     syntax/org.vim
" Website:      https://github.com/axvr/org.vim
" Last Change:  2020-01-05
"
" Reference Specification: Org mode manual
"   GNU Info: `$ info Org`
"   Web: <https://orgmode.org/manual/index.html>

if exists('b:current_syntax') && b:current_syntax !=# 'outline'
    finish
endif

" Enable spell check for non syntax highlighted text
syntax spell toplevel


" Options
syntax match  orgOption /^\s*#+\w\+.*$/ keepend
syntax region orgTitle matchgroup=orgOption start="\c^\s*#+TITLE:\s*" end="$" keepend oneline
highlight def link orgBlockDelimiter SpecialComment
highlight def link orgOption SpecialComment
highlight def link orgTitle Title


" Comments
syntax match  orgComment /^\s*#\s\+.*$/ keepend
syntax region orgComment matchgroup=orgBlockDelimiter start="\c^\s*#+BEGIN_COMMENT" end="\c^\s*#+END_COMMENT" keepend
highlight def link orgComment Comment


" Headings
syntax match orgHeading1 /^\s*\*\{1}\s\+.*$/ keepend contains=@Spell,orgTag,orgTodo,orgMath
syntax match orgHeading2 /^\s*\*\{2}\s\+.*$/ keepend contains=@Spell,orgTag,orgTodo,orgMath
syntax match orgHeading3 /^\s*\*\{3}\s\+.*$/ keepend contains=@Spell,orgTag,orgTodo,orgMath
syntax match orgHeading4 /^\s*\*\{4}\s\+.*$/ keepend contains=@Spell,orgTag,orgTodo,orgMath
syntax match orgHeading5 /^\s*\*\{5}\s\+.*$/ keepend contains=@Spell,orgTag,orgTodo,orgMath
syntax match orgHeading6 /^\s*\*\{6,}\s\+.*$/ keepend contains=@Spell,orgTag,orgTodo,orgMath

syntax cluster orgHeadingGroup contains=orgHeading1,orgHeading2,orgHeading3,orgHeading4,orgHeading5,orgHeading6

syntax match orgTag /:\w\{-}:/ contained contains=orgTag
exec 'syntax keyword orgTodo contained ' . join(org#option('org_state_keywords', ['TODO', 'NEXT', 'DONE']), ' ')

highlight def link orgHeading1 Title
highlight def link orgHeading2 orgHeading1
highlight def link orgHeading3 orgHeading2
highlight def link orgHeading4 orgHeading3
highlight def link orgHeading5 orgHeading4
highlight def link orgHeading6 orgHeading5
highlight def link orgTodo Todo
highlight def link orgTag Type


" Lists
syntax match orgUnorderedListMarker "^\s*[-+]\s\+" keepend contains=@Spell
syntax match orgOrderedListMarker "^\s*\d\+[.)]\s\+" keepend contains=@Spell
highlight def link orgUnorderedListMarker Statement
highlight def link orgOrderedListMarker orgUnorderedListMarker


" Timestamps
syntax match orgTimestampActive /<\d\{4}-\d\{2}-\d\{2}.\{-}>/ keepend
syntax match orgTimestampInactive /\[\d\{4}-\d\{2}-\d\{2}.\{-}\]/ keepend
highlight def link orgTimestampActive Operator
highlight def link orgTimestampInactive Comment


" Hyperlinks
syntax match orgHyperlink /\[\{2}\([^][]\{-1,}\]\[\)\?[^][]\{-1,}\]\{2}/ containedin=ALL contains=orgHyperLeft,orgHyperRight,orgHyperURL
syntax match orgHyperLeft /\[\{2}/ contained conceal
syntax match orgHyperRight /\]\{2}/ contained conceal
syntax match orgHyperURL /[^][]\{-1,}\]\[/ contains=orgHyperCentre contained conceal
syntax match orgHyperCentre /\]\[/ contained conceal

syntax cluster orgHyperlinkBracketsGroup contains=orgHyperLeft,orgHyperRight,orgHyperCentre
syntax cluster orgHyperlinkGroup contains=orgHyperlink,orgHyperURL,orgHyperlinkBracketsGroup

highlight def link orgHyperlink Underlined
highlight def link orgHyperURL String
highlight def link orgHyperCentre Comment
highlight def link orgHyperLeft Comment
highlight def link orgHyperRight Comment


" TeX
"   Ref: https://orgmode.org/manual/LaTeX-fragments.html
if org#option('org_highlight_tex', 1)
    syntax include @LATEX syntax/tex.vim
    syntax region orgMath start="\\begin\[.*\]{.*}"  end="\\end{.*}"         keepend contains=@LATEX
    syntax region orgMath start="\\begin{.*}"        end="\\end{.*}"         keepend contains=@LATEX
    syntax region orgMath start="\\\["               end="\\\]"              keepend contains=@LATEX
    syntax region orgMath start="\\("                end="\\)"               keepend contains=@LATEX
    syntax region orgMath start="\S\@<=\$\|\$\S\@="  end="\S\@<=\$\|\$\S\@=" keepend oneline contains=@LATEX
    syntax region orgMath start=/\$\$/               end=/\$\$/              keepend contains=@LATEX
    syntax match  orgMath /\\\$/ conceal cchar=$
    highlight def link orgMath String
endif


let b:current_syntax = 'org'
