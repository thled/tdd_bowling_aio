call plug#begin()

" theme
Plug 'morhetz/gruvbox'

" statusline
Plug 'itchyny/lightline.vim'

" search
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'

" autocomplete + navigation
Plug 'neoclide/coc.nvim', {'branch': 'release'}

" comment in/out
Plug 'tpope/vim-commentary'

" surround
Plug 'tpope/vim-surround'

" additional text objects
Plug 'wellle/targets.vim'

" switch true/false
Plug 'zef/vim-cycle'

" php syntax
Plug 'StanAngeloff/php.vim'

call plug#end()

