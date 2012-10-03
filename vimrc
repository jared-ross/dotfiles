" Folding cheet sheet
" zR    open all folds
" zM    close all folds
" za    toggle fold at cursor position
" zj    move down to start of next fold
" zk    move up to end of previous fold
" References:  {{{1
" https://bitbucket.org/sjl/dotfiles/src/2e25b11e75fc/vim/.vimrc#cl-86
" Manage plugins. {{{1
runtime macros/matchit.vim
runtime ftplugin/man.vim
runtime bundle/vim-pathogen/autoload/pathogen.vim
call pathogen#runtime_append_all_bundles()
call pathogen#helptags()
let g:GetLatestVimScripts_allowautoinstall=1
" An example for a vimrc file. {{{1
"
" Maintainer:	Bram Moolenaar <Bram@vim.org>
" Last change:	2008 Jul 02
"
" To use it, copy it to
"     for Unix and OS/2:  ~/.vimrc
"	      for Amiga:  s:.vimrc
"  for MS-DOS and Win32:  $VIM\_vimrc
"	    for OpenVMS:  sys$login:.vimrc

" When started as "evim", evim.vim will already have done these settings.
if v:progname =~? "evim"
  finish
endif

" Use Vim settings, rather then Vi settings (much better!).
" This must be first, because it changes other options as a side effect.
set nocompatible

" allow backspacing over everything in insert mode
set backspace=indent,eol,start


set history=50		" keep 50 lines of command line history
set ruler		" show the cursor position all the time
set showcmd		" display incomplete commands
set incsearch		" do incremental searching

" For Win32 GUI: remove 't' flag from 'guioptions': no tearoff menu entries
" let &guioptions = substitute(&guioptions, "t", "", "g")

" Don't use Ex mode, use Q for formatting
map Q gq

" CTRL-U in insert mode deletes a lot.  Use CTRL-G u to first break undo,
" so that you can undo CTRL-U after inserting a line break.
inoremap <C-U> <C-G>u<C-U>

" In many terminal emulators the mouse works just fine, thus enable it.
if has('mouse')
  set mouse=a
endif

" Switch syntax highlighting on, when the terminal has colors
" Also switch on highlighting the last used search pattern.
if &t_Co > 2 || has("gui_running")
  syntax on
  set hlsearch
endif

" Only do this part when compiled with support for autocommands.
if has("autocmd")

  " Enable file type detection.
  " Use the default filetype settings, so that mail gets 'tw' set to 72,
  " 'cindent' is on in C files, etc.
  " Also load indent files, to automatically do language-dependent indenting.
  filetype plugin indent on

  " Put these in an autocmd group, so that we can delete them easily.
  augroup vimrcEx
  au!

  " For all text files set 'textwidth' to 78 characters.
  autocmd FileType text setlocal textwidth=78

  " When editing a file, always jump to the last known cursor position.
  " Don't do it when the position is invalid or when inside an event handler
  " (happens when dropping a file on gvim).
  " Also don't do it when the mark is in the first line, that is the default
  " position when opening a file.
  autocmd BufReadPost *
    \ if line("'\"") > 1 && line("'\"") <= line("$") |
    \   exe "normal! g`\"" |
    \ endif

  augroup END

else

  set autoindent		" always set autoindenting on

endif " has("autocmd")

" Convenient command to see the difference between the current buffer and the
" file it was loaded from, thus the changes you made.
" Only define it when not defined already.
if !exists(":DiffOrig")
  command DiffOrig vert new | set bt=nofile | r # | 0d_ | diffthis
		  \ | wincmd p | diffthis
endif

" Preferences {{{1
set visualbell t_vb=
set relativenumber
set cursorline
set tabstop=4
set softtabstop=4
set shiftwidth=4
set expandtab
"set hidden
set nojoinspaces
set listchars=tab:▸\ ,eol:¬
set complete=.,b,u,]
set wildmode=longest,list:longest
set completeopt=menu,preview
set nrformats=
set spelllang=en_au
set tags+=tags;
set scrolloff=10
" backup {{{2
"Broken on  mac
"silent !mkdir -p ~/.vimtmp/{backup,swap,undo}/
if has("vms")
  set nobackup		" do not keep a backup file, use versions instead
else
  set backup		" keep a backup file
  set backupdir=~/.vimtmp/backup//
  if has("persistent_undo")
    set undodir=~/.vimtmp/undo//
    set undofile
  endif
endif
set directory=~/.vimtmp/swap//
set backupskip=      
" 2}}}
if has("autocmd")
  autocmd FileType html,php,css,scss,ruby,pml,yaml,coffee,vim setlocal ts=2 sts=2 sw=2 expandtab
  autocmd FileType vim setlocal foldmethod=marker
  autocmd FileType html setlocal foldmethod=indent foldlevel=1
  autocmd FileType css,javascript setlocal foldmethod=marker foldmarker={,}

  " Use Shift-Return to turn this:
  "     <tag>|</tag>
  "
  " into this:
  "       <tag>
  "         |
  "     </tag>
  au FileType html,jinja,htmldjango nnoremap <buffer> <s-cr> vit<esc>a<cr><esc>vito<esc>i<cr><esc>
  
  autocmd FileType python setlocal tabstop=8 expandtab shiftwidth=4 softtabstop=4
  autocmd FileType javascript setlocal ts=4 sts=4 sw=4 noexpandtab
  autocmd FileType php setlocal errorformat="%m\ in\ %f\ on\ line\ %l"
  autocmd BufNewFile,BufRead ~/projects/sencha/**/*.js setlocal ts=4 sts=4 sw=4 et
  autocmd FileType markdown setlocal wrap linebreak nolist
  autocmd BufNewFile,BufRead *.rss setfiletype xml
  autocmd BufNewFile,BufRead Rakefile,Capfile,Gemfile,Termfile,Vagrantfile,config.ru setfiletype ruby
  autocmd FileType ruby :Abolish -buffer initialise initialize
  autocmd FileType vo_base :colorscheme solarized
  autocmd BufNewFile,BufRead ~/dotfiles/vim/macros/*,~/.vim/macros/* setfiletype viminfo
endif

" Toggles & Switches (Leader commands) {{{1
let mapleader = ","
nmap <silent> <leader>l :set list!<CR>
nmap <silent> <leader>w :set wrap!<CR>
nmap <silent> <buffer> <leader>s :set spell!<CR>
nmap <silent> <leader>n :silent :nohlsearch<CR>
nmap <silent> <leader>c :IndentGuidesToggle<CR>
command! -nargs=* Wrap set wrap linebreak nolist
command! -nargs=* Maxsize set columns=1000 lines=1000
" CTags {{{1
map <Leader>rt :!ctags --extra=+f -R *<CR><CR>
let Tlist_Ctags_Cmd = "/usr/local/bin/ctags"
let tlist_markdown_settings='markdown;h:Headings'
let Tlist_Show_One_File=1
nmap <Leader>/ :TlistToggle<CR>

" Mappings {{{1
" Speed up buffer switching {{{2
map <C-k> <C-W>k
map <C-j> <C-W>j
map <C-h> <C-W>h
map <C-l> <C-W>l
" Speed up tab switching {{{2
map <D-S-]> gt
map <D-S-[> gT
map <D-1> 1gt
map <D-2> 2gt
map <D-3> 3gt
map <D-4> 4gt
map <D-5> 5gt
map <D-6> 6gt
map <D-7> 7gt
map <D-8> 8gt
map <D-9> 9gt
map <D-0> :tablast<CR>
" Shortcuts for opening file in same directory as current file {{{2
cnoremap %% <C-R>=expand('%:h').'/'<cr>
" Shortcuts for visual selections {{{2
nmap gV `[v`]
" http://stackoverflow.com/questions/6228079/remove-newlines-from-a-register-in-vim/6235707#6235707
nnoremap <expr> gV    "`[".getregtype(v:register)[0]."`]"
" <c-x>{char} - paste register into search field {{{2
" escaping sensitive chars
" http://stackoverflow.com/questions/7400743/
cnoremap <c-x> <c-r>=<SID>PasteEscaped()<cr>
function! s:PasteEscaped()
  echo "\\".getcmdline()."\""
  let char = getchar()
  if char == "\<esc>"
    return ''
  else
    let register_content = getreg(nr2char(char))
    let escaped_register = escape(register_content, '\'.getcmdtype())
    return substitute(escaped_register, '\n', '\\n', 'g')
  endif
endfunction
" Substitute command repetition {{{2
nnoremap & :~&<Enter>
vnoremap & :~&<Enter>
" Alignment commands {{{1
if exists(":Tabularize")
  nmap <Leader>a= :Tabularize /=<CR>
  vmap <Leader>a= :Tabularize /=<CR>
  nmap <Leader>a: :Tabularize /:\zs<CR>
  vmap <Leader>a: :Tabularize /:\zs<CR>
endif
" TextObject tweaks {{{1
nnoremap viT vitVkoj
nnoremap vaT vatV
  " NumberText Object {{{2
  onoremap N :<c-u>call <SID>NumberTextObject(0)<cr>
  xnoremap N :<c-u>call <SID>NumberTextObject(0)<cr>
  onoremap aN :<c-u>call <SID>NumberTextObject(1)<cr>
  xnoremap aN :<c-u>call <SID>NumberTextObject(1)<cr>
  onoremap iN :<c-u>call <SID>NumberTextObject(1)<cr>
  xnoremap iN :<c-u>call <SID>NumberTextObject(1)<cr>

  function! s:NumberTextObject(whole)
      normal! v

      while getline('.')[col('.')] =~# '\v[0-9]'
          normal! l
      endwhile

      if a:whole
          normal! o

          while col('.') > 1 && getline('.')[col('.') - 2] =~# '\v[0-9]'
              normal! h
          endwhile
      endif
  endfunction
  " }}}
" Insert mode mappings {{{1
" http://stackoverflow.com/questions/6926034/creating-a-mapping-for-insert-mode-but-not-for-autocomplete-submode/6926691#6926691
inoremap <expr> <c-e> pumvisible() ? "\<c-e>" : "\<c-o>A"
inoremap <C-a> <C-o>I
" Easily modify vimrc {{{1
nmap <leader>v :e $MYVIMRC<CR>
" http://stackoverflow.com/questions/2400264/is-it-possible-to-apply-vim-configurations-without-restarting/2400289#2400289
if has("autocmd")
  augroup myvimrchooks
    au!
    au BufWritePost .vimrc,_vimrc,vimrc,.gvimrc,_gvimrc,gvimrc so $MYVIMRC | if has('gui_running') | so $MYGVIMRC | endif
  augroup END
endif

" Custom commands and functions {{{1
" Create a :Quickfixdo command, to match :argdo/bufdo/windo {{{2
" Define a command to make it easier to use
command! -nargs=0 -bar Qargs execute 'args ' . QuickfixFilenames()
function! QuickfixFilenames()
  " Building a hash ensures we get each buffer only once
  let buffer_numbers = {}
  for quickfix_item in getqflist()
    let buffer_numbers[quickfix_item['bufnr']] = bufname(quickfix_item['bufnr'])
  endfor
  return join(values(buffer_numbers))
endfunction

command! -nargs=+ QFDo call QFDo(<q-args>)
" Function that does the work
function! QFDo(command)
  " Create a dictionary so that we can get the list of buffers rather than
  " the list of lines in buffers (easy way to get unique entries)
  let buffer_numbers = {}
  " For each entry, use the buffer number as a dictionary key (won't get
  " repeats)
  for fixlist_entry in getqflist()
    let buffer_numbers[fixlist_entry['bufnr']] = 1
  endfor
  " Make it into a list as it seems cleaner
  let buffer_number_list = keys(buffer_numbers)

  " For each buffer
  for num in buffer_number_list
    " Select the buffer
    exe 'buffer' num
    " Run the command that's passed as an argument
    exe a:command
    " Save if necessary
    update
  endfor
endfunction
" http://stackoverflow.com/questions/4792561/how-to-do-search-replace-with-ack-in-vim
" Show syntax highlighting groups for word under cursor {{{2
" Tip: http://stackoverflow.com/questions/1467438/find-out-to-which-highlight-group-a-particular-keyword-symbol-belongs-in-vim
nmap <Leader>m :call <SID>SynStack()<CR>
function! <SID>SynStack()
    if !exists("*synstack")
        return
    endif
    echo map(synstack(line('.'), col('.')), 'synIDattr(v:val, "name")')
endfunc
" Wipe all buffers which are not active (i.e. not visible in a window/tab) {{{2
" http://stackoverflow.com/questions/2974192/how-can-i-pare-down-vims-buffer-list-to-only-include-active-buffers
" http://stackoverflow.com/questions/1534835/how-do-i-close-all-buffers-that-arent-shown-in-a-window-in-vim
command! -nargs=* Only call CloseHiddenBuffers()
function! CloseHiddenBuffers()
  " figure out which buffers are visible in any tab
  let visible = {}
  for t in range(1, tabpagenr('$'))
    for b in tabpagebuflist(t)
      let visible[b] = 1
    endfor
  endfor
  " close any buffer that are loaded and not visible
  let l:tally = 0
  for b in range(1, bufnr('$'))
    if bufloaded(b) && !has_key(visible, b)
      let l:tally += 1
      exe 'bw ' . b
    endif
  endfor
  echon "Deleted " . l:tally . " buffers"
endfun

command! -nargs=* Gprune call CloseFugitiveBuffers()
function! CloseFugitiveBuffers()
  let visible = {}
  for t in range(1, tabpagenr('$'))
    for b in tabpagebuflist(t)
      let visible[b] = 1
    endfor
  endfor
  let l:tally = 0
  for b in range(1, bufnr('$'))
    if bufloaded(b) && !has_key(visible, b)
      let l:tally += 1
      exe 'bw ' . b
    endif
  endfor
  echon "Deleted " . l:tally . " buffers"
endfunction

" Set tabstop, softtabstop and shiftwidth to the same value {{{2
" From http://vimcasts.org/episodes/tabs-and-spaces/
command! -nargs=* Stab call Stab()
function! Stab()
  let l:tabstop = 1 * input('set tabstop = softtabstop = shiftwidth = ')
  if l:tabstop > 0
    let &l:sts = l:tabstop
    let &l:ts = l:tabstop
    let &l:sw = l:tabstop
  endif
  call SummarizeTabs()
endfunction

function! SummarizeTabs()
  try
    echohl ModeMsg
    echon 'tabstop='.&l:ts
    echon ' shiftwidth='.&l:sw
    echon ' softtabstop='.&l:sts
    if &l:et
      echon ' expandtab'
    else
      echon ' noexpandtab'
    end
  finally
    echohl None
  endtry
endfunction

" Strip trailing whitespaces  {{{2
function! Preserve(command)
  " Preparation: save last search, and cursor position.
  let _s=@/
  let l = line(".")
  let c = col(".")
  " Do the business:
  execute a:command
  " Clean up: restore previous search history, and cursor position
  let @/=_s
  call cursor(l, c)
endfunction
nmap _$ :call Preserve("%s/\\s\\+$//e")<CR>
nmap _= :call Preserve("normal gg=G")<CR>
" Swap words in a single substitution command {{{2
" http://stackoverflow.com/questions/765894/can-i-substitute-multiple-items-in-a-single-regular-expression-in-vim-or-perl/766093#766093
function! Refactor(dict) range
  execute a:firstline . ',' . a:lastline .  's/\C\<\%(' . join(keys(a:dict),'\|'). '\)\>/\='.string(a:dict).'[submatch(0)]/ge'
endfunction
command! -range=% -nargs=1 Refactor :<line1>,<line2>call Refactor(<args>)

" Running :Refactor {'quick':'slow', 'lazy':'energetic'}  will change the following text:
"    The quick brown fox ran quickly next to the lazy brook.
"into:
"    The slow brown fox ran slowly next to the energetic brook.

" TODO: create a :Swap command, which turns:
"    :Swap(portrait,landscape)
" into
"    :Refactor {'portrait':'landscape', 'landscape':'portrait'}

" Status line {{{1
" Good article on setting a statusline:
"   http://got-ravings.blogspot.com/2008/08/vim-pr0n-making-statuslines-that-own.html
"
" Also using:
"   https://bitbucket.org/sjl/dotfiles/src/2e25b11e75fc/vim/.vimrc#cl-86
" Always show the status line (even if no split windows)
set laststatus=2

set statusline=%<
set statusline+=\                             " Space.
set statusline+=%#StatuslineNC#               " switch to directory highlight
set statusline+=%-.40F                        " Path.
set statusline+=%*                            " switch back to normal statusline highlight
set statusline+=\                             " Space.
set statusline+=%h                            " help file flag
set statusline+=%m                            " Modified flag.
set statusline+=%r                            " Readonly flag.
set statusline+=%w                            " Preview window flag.
set statusline+=%{fugitive#statusline()}
set statusline+=\                             " Space.

set statusline+=%#warningmsg#                 " Highlight the following as a warning.
set statusline+=%{SyntasticStatuslineFlag()}  " Syntastic errors.
set statusline+=%*                            " Reset highlighting.

set statusline+=%=                            " Right align.

" File format, encoding and type.  Ex:        " (unix/utf-8/python)"
set statusline+=%{&ft}                        " Type (python).
set statusline+=/
set statusline+=%{strlen(&fenc)?&fenc:&enc}   " Encoding (utf-8).
set statusline+=\  
set statusline+=%{&ff}                        " Format (unix/DOS).

" Line and column position and counts.
set statusline+=\  
set statusline+=\  
set statusline+=%l/%L                         " cursor line/total lines
set statusline+=\  
" Configure plugins {{{1
" Fugitive.vim {{{2
if has("autocmd")

  " Auto-close fugitive buffers
  autocmd BufReadPost fugitive://* set bufhidden=delete

  " Navigate up one level from fugitive trees and blobs
  autocmd User fugitive
    \ if fugitive#buffer().type() =~# '^\%(tree\|blob\)$' |
    \   nnoremap <buffer> .. :edit %:h<CR> |
    \ endif

endif
" Gundo.vim {{{2
map <Leader>u :GundoToggle<CR>

" TextObject customizations {{{2
" Entire text object {{{3
" Map text-object for entire buffer to `ia` and `aa`.
let g:textobj_entire_no_default_key_mappings = 1
xmap aa  <Plug>(textobj-entire-a)
omap aa  <Plug>(textobj-entire-a)
xmap ia  <Plug>(textobj-entire-i)
omap ia  <Plug>(textobj-entire-i)
" }}}
" Space.vim {{{2
let g:space_disable_select_mode=1
let g:space_no_search = 1

" Solarized {{{2
"let g:solarized_menu=0
"let g:solarized_termcolors=256
set background=light
colorscheme solarized
call togglebg#map("<F5>")
"colorscheme default
" EasyMotion {{{2
let g:EasyMotion_leader_key = ',,'

" Vim wiki {{{2
let g:vimwiki_menu=''
" NERDcommenter {{{2
let g:NERDMenuMode=0
" Rainbows: {{{2
nmap <leader>R :RainbowParenthesesToggle<CR>
" HTML5: {{{2

let g:event_handler_attributes_complete = 0
let g:rdfa_attributes_complete = 0
let g:microdata_attributes_complete = 0
let g:atia_attributes_complete = 0

"  Modelines: {{{1
" vim: nowrap fdm=marker
" }}}

" HTML tag closing {{{1
inoremap <C-_> <Space><BS><Esc>:call InsertCloseTag()<cr>a
function! InsertCloseTag()
" inserts the appropriate closing HTML tag; used for the \hc operation defined
" above;
" requires ignorecase to be set, or to type HTML tags in exactly the same case
" that I do;
" doesn't treat <P> as something that needs closing;
" clobbers register z and mark z
" 
" by Smylers  http://www.stripey.com/vim/ 2000 May 3

    " list of tags which shouldn't be closed:
    let UnaryTags = ' Area Base Br DD DT HR Img Input LI Link Meta P Param '

    " remember current position:
    normal mz

    " loop backwards looking for tags:
    let Found = 0
    while Found == 0
      " find the previous <, then go forwards one character and grab the first
      " character plus the entire word:
      execute "normal ?\<LT>\<CR>l"
      normal "zyl
      let Tag = expand('<cword>')

      " if this is a closing tag, skip back to its matching opening tag:
      if @z == '/'
        execute "normal ?\<LT>" . Tag . "\<CR>"

      " if this is a unary tag, then position the cursor for the next
      " iteration:
      elseif match(UnaryTags, ' ' . Tag . ' ') > 0
        normal h

      " otherwise this is the tag that needs closing:
      else
        let Found = 1

      endif
    endwhile " not yet found match

    " create the closing tag and insert it:
    let @z = '</' . Tag . '>'
    normal `z"zp

endfunction " InsertCloseTag()
" }}}

" Hex Mode
" ex command for toggling hex mode - define mapping if desired
command -bar Hexmode call ToggleHex()

" helper function to toggle hex mode
function ToggleHex()
  " hex mode should be considered a read-only operation
  " save values for modified and read-only for restoration later,
  " and clear the read-only flag for now
  let l:modified=&mod
  let l:oldreadonly=&readonly
  let &readonly=0
  let l:oldmodifiable=&modifiable
  let &modifiable=1
  if !exists("b:editHex") || !b:editHex
    " save old options
    let b:oldft=&ft
    let b:oldbin=&bin
    " set new options
    setlocal binary " make sure it overrides any textwidth, etc.
    let &ft="xxd"
    " set status
    let b:editHex=1
    " switch to hex editor
    %!xxd
  else
    " restore old options
    let &ft=b:oldft
    if !b:oldbin
      setlocal nobinary
    endif
    " set status
    let b:editHex=0
    " return to normal editing
    %!xxd -r
  endif
  " restore values for modified and read only state
  let &mod=l:modified
  let &readonly=l:oldreadonly
  let &modifiable=l:oldmodifiable
endfunction

" autocmds to automatically enter hex mode and handle file writes properly
if has("autocmd")
  " vim -b : edit binary using xxd-format!
  augroup Binary
    au!

    " set binary option for all binary files before reading them
    au BufReadPre *.bin,*.hex setlocal binary

    " if on a fresh read the buffer variable is already set, it's wrong
    au BufReadPost *
          \ if exists('b:editHex') && b:editHex |
          \   let b:editHex = 0 |
          \ endif

    " convert to hex on startup for binary files automatically
    au BufReadPost *
          \ if &binary | Hexmode | endif

    " When the text is freed, the next time the buffer is made active it will
    " re-read the text and thus not match the correct mode, we will need to
    " convert it again if the buffer is again loaded.
    au BufUnload *
          \ if getbufvar(expand("<afile>"), 'editHex') == 1 |
          \   call setbufvar(expand("<afile>"), 'editHex', 0) |
          \ endif

    " before writing a file when editing in hex mode, convert back to non-hex
    au BufWritePre *
          \ if exists("b:editHex") && b:editHex && &binary |
          \  let oldro=&ro | let &ro=0 |
          \  let oldma=&ma | let &ma=1 |
          \  silent exe "%!xxd -r" |
          \  let &ma=oldma | let &ro=oldro |
          \  unlet oldma | unlet oldro |
          \ endif

    " after writing a binary file, if we're in hex mode, restore hex mode
    au BufWritePost *
          \ if exists("b:editHex") && b:editHex && &binary |
          \  let oldro=&ro | let &ro=0 |
          \  let oldma=&ma | let &ma=1 |
          \  silent exe "%!xxd" |
          \  exe "set nomod" |
          \  let &ma=oldma | let &ro=oldro |
          \  unlet oldma | unlet oldro |
          \ endif
  augroup END
endif

" Highlighting terms:

nnoremap <silent> <leader>h1 :execute 'match W1 /\<<c-r><c-w>\>/'<cr> hi W1 guibg=#aeee00 guifg=#000000 ctermbg=154 ctermfg=16

" Sudo to write
cmap w!! w !sudo tee % >/dev/null

inoremap <F1> <ESC>
inoremap <Help> <ESC>
map <S-Down> <Down>
map <S-Up> <Up>

map <F2>    :set insertmode! <CR>

" Only show colorcolumn in the current window. 
au WinLeave * setlocal colorcolumn=0 
au WinEnter * setlocal colorcolumn=+1

inoremap <up> <nop>
inoremap <down> <nop>
inoremap <left> <nop>
inoremap <right> <nop>

map <up> <nop>
map <down> <nop>
map <left> <nop>
map <right> <nop>

noremap <Space> 
noremap <S-Space> 


" Might fix performance
autocmd BufWinLeave * call clearmatches()
