" ================================================================================================
" Obsidian Vimrc 配置文件
" 从 IdeaVim 配置转换而来
" ================================================================================================

" ================================================================================================
" 🐧🐧🐧 基础设置 🐧🐧🐧
" ================================================================================================

" 设置在光标距离窗口顶部或底部一定行数时，开始滚动屏幕内容的行为
set scrolloff=10

" 递增搜索功能：在执行搜索时，逐步匹配并高亮显示匹配的文本
set incsearch

" 在搜索时忽略大小写
set ignorecase

" 智能大小写搜索（当搜索词包含大写字母时区分大小写）
set smartcase

" 将搜索匹配的文本高亮显示
set hlsearch

" 设置相对行号和当前行的绝对行号
set number
set relativenumber

" vim寄存器同步系统剪切板
set clipboard=unnamed

" ================================================================================================
" 🌍🌍🌍 无 Leader 键映射 🌍🌍🌍
" ================================================================================================

" 普通模式下使用回车键，向下/向上 增加一行
nmap <CR> o<Esc>
nmap <S-CR> O<Esc>

" 在普通和插入模式下，向下交换行/向上交换行
nnoremap <A-j> :m .+1<CR>==
nnoremap <A-k> :m .-2<CR>==
inoremap <A-j> <Esc>:m .+1<CR>==gi
inoremap <A-k> <Esc>:m .-2<CR>==gi
xnoremap <A-j> :m '>+1<CR>gv=gv
xnoremap <A-k> :m '<-2<CR>gv=gv

" 将 jj 和 jk 映射为 <Esc>
imap jj <Esc>
imap jk <Esc>

" 快速上下移动
nmap J 5j
nmap K 5k

" 快速移动到开头和结尾
nmap H ^
nmap L $

" 格式化文本
map Q gq

" 多光标/多选区 (Obsidian Vimrc Surpport 插件支持的部分功能)
" 注意：Obsidian 的多光标支持有限，这些映射可能需要配合插件或手动调整

" 当你按下 ' 时，实际执行 ` 的功能 (精确跳转到光标位置)
nnoremap ' `

" 当你按下 ` 时，实际执行 ' 的功能 (跳转到标记所在行的行首)
nnoremap ` '

" ================================================================================================
" ⭐️⭐️⭐️ Leader 键映射 ⭐️⭐️⭐️
" ================================================================================================

" 设置 Leader 键为空格
let mapleader = " "

" ================================================================================================
" 🌞🌞🌞 快捷键目录说明 🌞🌞🌞
" ================================================================================================
" <leader>c: 关闭相关操作
" <leader>d: 删除相关操作
" <leader>e: 打开文件浏览器（侧边栏）
" <leader>f: 查找相关操作
" <leader>h/j/k/l: 窗口跳转
" <leader>i: 插入相关操作
" <leader>n: 取消高亮/新建文件
" <leader>p/P: 粘贴
" <leader>r: 重命名
" <leader>s: 显示/搜索相关操作
" <leader>t: 标签页操作
" <leader>w: 窗口管理
" <leader>y: 复制到剪贴板
" <leader>z: 折叠相关操作

" ================================================================================================
" 🌟🌟🌟 详细配置 🌟🌟🌟
" ================================================================================================

" ========== c: 关闭相关 ==========
" 在 Obsidian 中，标签页关闭需要通过命令面板或插件实现
" 这里提供基础映射，具体功能依赖 Obsidian 的命令

" ========== d: 删除相关 ==========
" 在可视模式中：删除选择的文本并复制到剪切板
vmap <leader>d "+d

" ========== e: 打开文件浏览器 ==========
" 使用 Obsidian 的命令切换侧边栏
" 需要配合 obcommand 来执行 Obsidian 命令
exmap togglefolder obcommand app:toggle-left-sidebar
nmap <leader>e :togglefolder

" ========== f: 查找相关 ==========
" 快速打开文件（Quick Switcher）
exmap quickswitcher obcommand switcher:open
nmap <leader>ff :quickswitcher

" 全局搜索
exmap globalsearch obcommand global-search:open
nmap <leader>ft :globalsearch

" 打开命令面板
exmap commandpalette obcommand command-palette:open
nmap <leader>fc :commandpalette

" ========== h/j/k/l: 窗口跳转 ==========
" Obsidian 原生支持 Ctrl+h/j/k/l 进行窗口跳转
" 这里使用 leader 键提供替代方案
exmap focusleft obcommand editor:focus-left
nmap <leader>h :focusleft

exmap focusdown obcommand editor:focus-down
nmap <leader>j :focusdown

exmap focusup obcommand editor:focus-up
nmap <leader>k :focusup

exmap focusright obcommand editor:focus-right
nmap <leader>l :focusright

" ========== i: 插入相关 ==========
" 快速查找并跳转到下一个 (
nmap <leader>i f(a

" ========== n: 取消高亮/新建 ==========
" 取消搜索高亮显示
nmap <leader>nh :nohlsearch<CR>

" 新建笔记
exmap newnote obcommand file-explorer:new-file
nmap <leader>nc :newnote

" 新建文件夹
exmap newfolder obcommand file-explorer:new-folder
nmap <leader>nd :newfolder

" ========== p/P: 粘贴 ==========
" 从剪切板粘贴到下面行
nmap <leader>p "+p
vmap <leader>p "+p

" 从剪切板粘贴到上面行
nmap <leader>P "+P
vmap <leader>P "+P

" ========== r: 重命名 ==========
" 重命名当前文件
exmap rename obcommand workspace:edit-file-title
nmap <leader>rn :rename

" ========== s: 显示/搜索相关 ==========
" 显示文件大纲
exmap outline obcommand outline:open
nmap <leader>ss :outline

" 显示反向链接
exmap backlinks obcommand backlink:open
nmap <leader>sb :backlinks

" 全选所有匹配项（依赖编辑器功能）
" Obsidian 原生支持较少，建议使用 Ctrl+D 逐个选择

" ========== t: 标签页操作 ==========
" 切换到下一个标签页
exmap tabnext obcommand workspace:next-tab
nmap <leader>tn :tabnext
nmap gt :tabnext

" 切换到上一个标签页
exmap tabprev obcommand workspace:previous-tab
nmap <leader>tp :tabprev
nmap gT :tabprev

" ========== w: 窗口管理 ==========
" 垂直分割窗口
exmap splitvertical obcommand workspace:split-vertical
nmap <leader>wv :splitvertical

" 水平分割窗口
exmap splithorizontal obcommand workspace:split-horizontal
nmap <leader>ws :splithorizontal

" 关闭当前窗口
exmap closewindow obcommand workspace:close
nmap <leader>wc :closewindow

" 关闭其他窗口
exmap closeothers obcommand workspace:close-others
nmap <leader>wo :closeothers

" ========== y: 复制到剪贴板 ==========
" 复制当前行到剪贴板
nmap <leader>y "+yy

" 可视模式下复制选中内容到剪贴板
vmap <leader>y "+y

" ========== z: 折叠相关 ==========
" 折叠当前段落（依赖 Obsidian 的折叠功能）
exmap foldall obcommand editor:fold-all
nmap <leader>zc :foldall

" 展开所有折叠
exmap unfoldall obcommand editor:unfold-all
nmap <leader>zo :unfoldall

" 切换当前折叠状态
exmap togglefold obcommand editor:toggle-fold
nmap za :togglefold

" ================================================================================================
" 🌸🌸🌸 Surround 插件支持 🌸🌸🌸
" ================================================================================================
" Obsidian Vimrc Support 插件支持 vim-surround 的部分功能
" 使用方法：
" - ysiw" : 在当前单词周围添加引号
" - cs"' : 将双引号改为单引号
" - ds" : 删除周围的双引号
" - yss) : 在当前行周围添加括号

" 启用 surround（需要插件支持）
" surround 功能已内置在 Obsidian Vimrc Support 插件中