filetype plugin indent on

set termguicolors
let &t_8f = "\<Esc>[38;2;%lu;%lu;%lum" " $BJ8;z?'(B
let &t_8b = "\<Esc>[48;2;%lu;%lu;%lum" " $BGX7J?'(B

call plug#begin('~/.vim/plugged')

" Apearance
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'junegunn/vim-easy-align'
Plug 'rafi/awesome-vim-colorschemes'
Plug 'yuttie/comfortable-motion.vim'
Plug 'itchyny/vim-cursorword'

" Code Syntax
Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}

" Filer
Plug 'lambdalisue/fern.vim'
Plug 'lambdalisue/fern-renderer-nerdfont.vim'
Plug 'lambdalisue/nerdfont.vim'
Plug 'lambdalisue/glyph-palette.vim'

" General operations
Plug 'jiangmiao/auto-pairs'
Plug 'tpope/vim-surround'
Plug 'tpope/vim-commentary'
Plug 'terryma/vim-expand-region'
Plug 'easymotion/vim-easymotion'
Plug 'vim-scripts/YankRing.vim'
Plug 'unblevable/quick-scope'
Plug 'rhysd/clever-f.vim'
" Plug 'bronson/vim-trailing-whitespace'
Plug 'ntpeters/vim-better-whitespace'

" Plug 'tversteeg/registers.nvim', { 'branch': 'main' }
Plug 'tversteeg/registers.nvim', { 'tag': 'v1.5.0' }
Plug 'kyazdani42/nvim-web-devicons'
Plug 'akinsho/bufferline.nvim', { 'tag': 'v2.*' }

" FZF
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'

" Custom commands
if executable('node')

    " Compleation
    Plug 'neoclide/coc.nvim', {'branch': 'release'}

    " Snipet
    Plug 'SirVer/ultisnips'
    Plug 'honza/vim-snippets'
endif

call plug#end()

source ~/.vimrc

" General shortcut for neovim
set termguicolors
tnoremap jk <C-\><C-n>


" set termguicolors
" let &t_8f = "\<Esc>[38;2;%lu;%lu;%lum" " $BJ8;z?'(B
" let &t_8b = "\<Esc>[48;2;%lu;%lu;%lum" " $BGX7J?'(B

" bufferline (Tab)
lua << EOF
require("bufferline").setup{}
EOF
nnoremap <Leader>n :BufferLineCycleNext<CR>
nnoremap <Leader>p :BufferLineCyclePrev<CR>
nnoremap <Leader>s :BufferLinePick<CR>

" YankRing
if has('win32') || has ('win64')
    let g:yankring_history_dir=expand("$HOME/AppData/Local/Temp")
else
    let g:yankring_history_dir="/tmp/"
endif

" Trigger configuration. You need to change this to something other than <tab> if you use one of the following:
" - https://github.com/Valloric/YouCompleteMe
" - https://github.com/nvim-lua/completion-nvim
let g:UltiSnipsExpandTrigger="<tab>"
let g:UltiSnipsJumpForwardTrigger="<c-b>"
let g:UltiSnipsJumpBackwardTrigger="<c-z>"

" If you want :UltiSnipsEdit to split your window.
let g:UltiSnipsEditSplit="vertical"


" Colorscheme
colorscheme solarized8

set statusline^=%{coc#status()}

" nvim-treesitter
lua <<EOF
require'nvim-treesitter.configs'.setup {
  highlight = {
    enable = true
  }
}
EOF

" clever_f
let g:clever_f_smart_case=1

" coc.vim
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)

" fzf.vim
" nnoremap <Leader>f :FZF<CR>
nnoremap <Leader>f :Files<CR>
nnoremap <Leader>r :Rg<CR>
nnoremap <Leader>h :History<CR>
nnoremap <Leader>b :Buffers<CR>
nnoremap <Leader>w :Windows<CR>

" easymotion
" <Leader>f{char} to move to {char}
nmap  <Leader>c <Plug>(easymotion-bd-f)
nmap <Leader>c <Plug>(easymotion-overwin-f)
" s{char}{char} to move to {char}{char}
" nmap s <Plug>(easymotion-overwin-f2)
"n Move to line
nmap <Leader>l <Plug>(easymotion-bd-jk)
nmap <Leader>l <Plug>(easymotion-overwin-line)

" Fern
let g:fern#default_hidden=1
let g:fern#renderer = 'nerdfont'
augroup my-glyph-palette
  autocmd! *
  autocmd FileType fern call glyph_palette#apply()
  autocmd FileType nerdtree,startify call glyph_palette#apply()
augroup END
augroup FernGroup
  autocmd!
  " autocmd FileType fern setlocal norelativennumber | setlocal nonumber | call FernInit()
  autocmd FileType fern setlocal norelativenumber | setlocal nonumber
augroup END
nnoremap <silent> <Leader>e :Fern . -drawer -width=30 -toggle -stay -reveal=%<CR>

" Registers
let g:registers_window_border = "single"

