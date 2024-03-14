# variables for configuration #
vimrc=~/.vimrc
IFS="
"
plugin=(
	"https://github.com/tpope/vim-fugitive.git"
	"https://github.com/Yggdroot/indentLine.git"
)
config_baseline=(
	"set mouse-=a"
	"set cursorcolumn"
	"highlight CursorColumn ctermbg=black"
	"set cursorline"
	"highlight CursorLine cterm=none ctermbg=black"
	"set tabstop=4"
	"set softtabstop=0 noexpandtab"
	"set shiftwidth=4"
	"set foldmethod=indent"
	"set foldlevelstart=9999"
	"set list lcs=tab:\|\ "
	"set number"
	"nnoremap <space> za"
	"syntax on"
)
config_indentLine=(
	"autocmd FileType yaml setlocal ts=2 sts=2 sw=2 expandtab"
	"let g:indentLine_char = '|'"
	"nnoremap <tab> :IndentLinesToggle <bar> :set number! <bar> :set list!<CR>"
)
# vimrc baseline configuration #
touch "$vimrc"
for configuration in ${config_baseline[*]}; do
	grep -qxF "$configuration" "$vimrc" || echo "$configuration" >> "$vimrc"
done
# vimrc plugin configuration #
for repository in ${plugin[*]}; do
	vendor=$(echo "$repository" | cut -d "/" -f 4)
	project=$(echo "$repository" | cut -d "/" -f 5 | cut -d "." -f 1)
	download=~/.vim/pack/$vendor/start/$project
	if [ ! -d "$download" -a ! -f "$download" ]; then
		git clone "$repository" "$download"
		vim -u NONE -c "helptags  $download/doc" -c "q"
		project_config="config_${project}"
		if [ -v "$project_config" ]; then
			array_config="${project_config}[@]"
			for configuration in ${!array_config}; do
				grep -qxF "$configuration" "$vimrc" || echo "$configuration" >> "$vimrc"
			done
		fi
	fi
done
# alias definition #
alias vi='vim'
