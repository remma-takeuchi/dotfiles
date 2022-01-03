filetype plugin indent on

call plug#begin('~/.vim/plugged')

" Apearance
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'junegunn/vim-easy-align'
Plug 'rafi/awesome-vim-colorschemes'
Plug 'yuttie/comfortable-motion.vim'

" FZF
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'

" Compleation
Plug 'neoclide/coc.nvim', {'branch': 'release'}
Plug 'bronson/vim-trailing-whitespace'

" Snipet
Plug 'SirVer/ultisnips'
Plug 'honza/vim-snippets'

" General operations
Plug 'jiangmiao/auto-pairs'
Plug 'tpope/vim-surround'
Plug 'tpope/vim-commentary'
Plug 'terryma/vim-expand-region'
Plug 'easymotion/vim-easymotion'

call plug#end()


source ~/.vimrc


" Trigger configuration. You need to change this to something other than <tab> if you use one of the following:
" - https://github.com/Valloric/YouCompleteMe
" - https://github.com/nvim-lua/completion-nvim
let g:UltiSnipsExpandTrigger="<tab>"
let g:UltiSnipsJumpForwardTrigger="<c-b>"
let g:UltiSnipsJumpBackwardTrigger="<c-z>"

" If you want :UltiSnipsEdit to split your window.
let g:UltiSnipsEditSplit="vertical"


" Colorscheme
colorscheme iceberg
set statusline^=%{coc#status()}


" fzf.vim
nnoremap <Leader>f :FZF<CR>
nnoremap <Leader>r :Rg<CR>
nnoremap <Leader>b :Buffers<CR>
nnoremap <Leader>w :Windows<CR>
nnoremap <Leader>h :History<CR>

" easymotion
" <Leader>f{char} to move to {char}
noremap  <Leader>c <Plug>(easymotion-bd-f)
nnoremap <Leader>c <Plug>(easymotion-overwin-f)
" s{char}{char} to move to {char}{char}
nnoremap s <Plug>(easymotion-overwin-f2)
" Move to line
noremap <Leader>l <Plug>(easymotion-bd-jk)
nnoremap <Leader>l <Plug>(easymotion-overwin-line)


" Custom commands
if executable('jq')
  command! Jqf %!jq '.'
endif

