"该“中文版”指whichkey的窗口提示为中文

" ================================================================================================
" 🍰🍰🍰 Extensions 🍰🍰🍰
" ================================================================================================
Plug 'preservim/nerdtree'
Plug 'easymotion/vim-easymotion'

"下列插件需要在IDEA中下载
"ideaVim
"IdeaVim-EasyMotion
"IdeaVimExtension
"which-key
"CodeGlance Pro

" ================================================================================================
" 🐧🐧🐧 Basic settings 🐧🐧🐧
" ================================================================================================
"--开启快速移动光标插件
set easymotion
"--开启surround(包裹功能)
set surround
"设置在光标距离窗口顶部或底部一定行数时，开始滚动屏幕内容的行为
set scrolloff=10

"--递增搜索功能：在执行搜索（使用 / 或 ? 命令）时，
"Vim 会在您输入搜索模式的过程中逐步匹配并高亮显示匹配的文本。
set incsearch

"--在搜索时忽略大小写
set ignorecase

"--将搜索匹配的文本高亮显示
set hlsearch

"--设置相对行号 和 当前行的绝对行号
set number relativenumber

"--设置返回normal模式时回到英文输入法
"set keep-english-in-normal

"--vim寄存器同步系统剪切板
set clipboard=unnamedplus

set showMarksInGutter
" ================================================================================================
" 🌍🌍🌍 No Leader Keymaps 🌍🌍🌍
" ================================================================================================
"--普通模式下使用回车键，向下/向上 增加一行
nmap <CR> o<Esc>
nmap <S-Enter> O<Esc>

"--在普通和插入模式下，向下交换行/向上交换行
nnoremap <C-j> :m +1<CR>
nnoremap <C-k> :m -2<CR>
inoremap <C-j> <Esc> :m +1<CR>gi
inoremap <C-k> <Esc> :m -2<CR>gi
xnoremap <C-j> :m '>+1<cr>gv=gv
xnoremap <C-k> :m '<-2<cr>gv=gv

" 使用 gc 作为注释操作符
nmap gc <Action>(CommentByLineComment)
vmap gc <Action>(CommentByLineComment)

"--将 jj 和 jk 映射为 <Esc>
"jj和jk为主流配置，可按喜好自行调整
imap jj <Esc>
imap jk <Esc>

"--快速上下移动
nmap J 5j
nmap K 5k

"快速移动到开头和结尾
nmap H ^
nmap L $

"--格式化（规范化）文本，即对选定的文本进行换行或重排，适应指定的文本宽度。
"全文规范化：Ctrl+Alt+l
map Q gq
" --像鼠标悬停一样显示错误提示
nmap gh <action>(ShowErrorDescription)
"跳转到下一个错误或警告
nmap ge <action>(GotoNextError)
let g:WhichKeyDesc_GotoNextError = "ge 跳转到下一个错误或警告"
"在源代码和测试代码之间快速切换
" !!!与gt和gT的vim原生切换标签页冲突!!!
"nmap gt <action>(GotoTest)
"let g:WhichKeyDesc_GotoTest = "gt 在源代码和测试代码之间快速切换"
"将光标移动到上一个方法的声明处
" last changed in current buffer(file)
nmap gm <action>(MethodUp)
let g:WhichKeyDesc_MethodUp = "gm 将光标移动到上一个方法的声明处"
"跳转到当前接口或抽象类的实现处
nmap ga <action>(GotoImplementation)
lHet g:WhichKeyDesc_GotoImplementation = "ga 跳转到当前接口或抽象类的实现处"


" --- 多光标/多选区 (Multiple Cursors / Selections) ---
" 模拟 VSCode 中的 'gb' 功能，选中下一个匹配项。

" 在普通模式下 (nmap)，按下 gb 会选中光标下的单词，并准备好多光标编辑。
nmap gb <action>(SelectNextOccurrence)
" 在可视模式下 (vmap)，按下 gb 会在已有的选择基础上，继续添加下一个匹配项。
vmap gb <action>(SelectNextOccurrence)
" 添加一个 'gB' 快捷键来取消最后一个选择，与 gb 对应。
nmap gB <action>(UnselectPreviousOccurrence)
vmap gB <action>(UnselectPreviousOccurrence)



" bookmark 切换书签
nmap ma <action>(ToggleBookmark)
let g:WhichKeyDesc_bookmark = "ma 书签"

"将Ctrl + s 映射为保存文档(也可以在VIM设置里将此快捷键设置为IDEA的快捷键)
nmap <C-S> <action>(SaveAll)
imap <C-S> <Esc><action>(SaveAll)

" e: Extract重构
" extract method/function 将选中的代码片段提取为一个独立的方法(Ctrl + Alt + M)
vmap <leader>em <action>(ExtractMethod)
" extract constant （引入常量）的重构操作:将选中的代码片段抽取为一个常量，并自动替换选中的代码片段为新的常量引用(Ctrl + Alt + C)
vmap <leader>ec <action>(IntroduceConstant)
" extract field （引入字段）的重构操作:将选中的代码片段转化为一个新的字段，并自动将选中的代码片段替换为对该字段的引用(Ctrl + Alt + F)
vmap <leader>ef <action>(IntroduceField)
" extract variable （引入变量）的重构操作:将选中的代码片段抽取为一个新的变量，并自动替换选中的代码片段为新的变量引用(Ctrl + Alt + V)
vmap <leader>ev <action>(IntroduceVariable)

" 当你按下 ' 时，实际执行 ` 的功能 (精确跳转到光标位置)
nnoremap ' `
" 当你按下 ` 时，实际执行 ' 的功能 (跳转到标记所在行的行首)
nnoremap ` '

" ================================================================================================
" ⭐️⭐️⭐️ Leader Keymaps ⭐️⭐️⭐️ =====================================
" ================================================================================================
"--将<leader>设置为 空格 键
"可自行更改，只需更改双引号内的内容即可
"推荐<leader>:  "空格"  ";"  "\"  "-"  ","
let mapleader = " "



" ================================================================================================
" 👻👻👻 Which-Key 👻👻👻
" ================================================================================================

"which-key的官方推荐配置
set which-key
set notimeout

" ================================================================================================
" 🌞🌞🌞 目录-食用手册 🌞🌞🌞
" ================================================================================================

"===================================== A =====================================
" <leader>a:
"===================================== B =====================================
" <leader>b:
"===================================== C =====================================
" <leader>c:  Code Or Close-[目录]
" <leader>cc: CodeCompletion-自动补全
" <leader>cd: CloseEditor-关闭当前标签页
" <leader>ca: CloseAllEditors-关闭所有标签页
" <leader>co: CloseAllEditorsButActive-关闭其他标签页
"===================================== D =====================================
" <leader>d: Debug Or Delete-[目录]
" <leader>dp: BreakPoint-打断点/解除断点
" <leader>db: DeBug-调试
" [V]<leader>d: DeleteAndCopyClipboard-在可视模式中：删除选择的文本并复制到剪切板
"===================================== E =====================================
" <leader>e: ToggleExplorer ⭐️ 激活项目工具窗口
"===================================== F =====================================
" <leader>f: Find Or Format ⭐[目录]
" <leader>ff: FindFile-快速 导航/查找 项目中的其他文件(Ctrl + n)
" <leader>fl: FindFileLocation-将当前编辑的文件在项目视图中进行选中定位(Ctrl+f)
" <leader>ft: FindText-在整个项目中查找指定的文本、关键字或正则表达式，包括代码文件、配置文件和其他文件等(Ctrl + Shift + F)
" <leader>fc: Commands-打开 "Find Action"（查找动作）对话框(Ctrl + Shift + A)
" <leader>fm: Format-重新格式化代码，使其符合预定义的代码样式和规范 and 优化导入语句，删除未使用的导入，并将导入语句按字母顺序进行排列
"===================================== G =====================================
" <leader>g: Git Or Generate [目录]
" <leader>gr: RollbackHunk-执行版本控制（VCS）的回滚操作，将修改的代码还原到之前的版本
" <leader>gc: GenerateConstructor-生成构造函数
" <leader>gg: GenerateGetter-生成getter函数
" <leader>gs: GenerateSetter-生成setter函数
" <leader>ga: GenerateGetterAndSetter-生成getter和setter函数
" <leader>ge: GenerateEquals-生成equals和hashcode的重写方法
" <leader>gd: ShowTabbedFileHistory-显示文件的版本控制历史(git)
"===================================== H =====================================
" <leader>h: MoveToLeftMoveToLeft-跳转到左边的分割窗口
"===================================== I =====================================
" <leader>i: Insert ⭐快速查找并跳转到下一个以 ( 开始的函数或方法调用的位置️
"===================================== J =====================================
" <leader>j: MoveToDown-跳转到下边的分割窗口
"===================================== K =====================================
" <leader>k: MoveToUp-跳转到上边的分割窗口
"===================================== L =====================================
" <leader>l: MoveToRight-跳转到右边的分割窗口
"===================================== M =====================================
" <leader>m: CodeGlance-打开/关闭地图(需要CodeGlance Pro插件)
"===================================== N =====================================
" <leader>n: NERDTree Or No ⭐️[目录]
" <leader>nn: NERDTreeFocus-将使焦点转移到 NERDTree 窗口(配置在NERDTree专栏)
" <leader>nh: NoHighlight-取消搜索高亮显示
" <leader>nd: NewDir-新建文件夹
" <leader>nc: NewClass-新建类
"===================================== O =====================================
" <leader>o:
"===================================== P =====================================
" <leader>p: PasteClipboardDown-从剪切板粘贴到下面行
" <leader>P: PasteClipboardUp-从剪切板粘贴到上面行
" [V]<leader>p: PasteClipboardDown-在可视模式中：从剪切板粘贴到下面行
" [V]<leader>P: PasteClipboardUp-在可视模式中：从剪切板粘贴到上面行
"===================================== Q =====================================
" <leader>q:
"===================================== R =====================================
" <leader>r: Run Or Re ⭐️[目录]
" <leader>ru: Run-运行
" <leader>rc: RunClass-运行当前编辑器中的文件或类(Shift + F10)
" <leader>rr: ReRun-重新运行最近一次运行的程序或测试(Ctrl + Shift + F10)
" <leader>rt: ReRunTests-重新运行最近一次运行的测试（Unit Tests）(Ctrl + Shift + F10)
" <leader>rn: Rename-在代码中快速更改一个标识符的名称，并自动处理所有相关的引用(Shift + F6)
"===================================== S =====================================
" <leader>s: Show/stop/select ⭐️[目录]
" <leader>st: Stop
" <leader>ss: ShowFileStructure-显示当前打开文件的文件结构弹出窗口，其中包含文件中的类、方法、字段等结构(Alt + 7)
" <leader>sb: ShowBookmarks-显示书签（idea的Bookmarks）工具窗口，其中包含当前文件中设置的书签列表(Ctrl + F11)
" <leader>sm: ShowMarks-显示vim marks(:marks)
" <leader>sp: ShowParameterInfo-用于显示方法或函数的参数信息(Ctrl + p)
" <leader>sa: SelectAllOccurrences,-选中文件中所有匹配项,一般用多光标操作(Ctrl+Alt+Shift+J)
"===================================== T =====================================
" <leader>t: Tabs(请多使用vim原生gt/gT) ⭐️[目录]
" <leader>tn: 切换到下一个标签页(gt)
" <leader>tp: 切换到上一个标签页(gT)
"===================================== U =====================================
" <leader>u:
"===================================== V =====================================
" <leader>v:
"===================================== W =====================================
" <leader>w: Window ⭐️[目录]
" <leader>wh: MoveToLeft-跳转到左边的窗口(<c-w>h)
" <leader>wj: MoveToDown-跳转到下边的窗口(<c-w>j)
" <leader>wk: MoveToUp-跳转到上边的窗口(<c-w>k)
" <leader>wl: MoveToRight-跳转到右边的窗口(<c-w>l)
" <leader>wv: SplitVertical-垂直分割窗口(<c-w>v)
" <leader>ws: SplitHorizontal-水平分割窗口(<c-w>s)
" <leader>wc: CloseCurrent-关闭当前分割窗口(<c-w>c)
" <leader>wo: CloseOthers-关闭其他所有分割
" <leader>wu: Unsplit-取消拆分当前分割
" <leader>wa: UnsplitAll-取消所有分割
" <leader>ww: HideAllWindows-隐藏/显示所有工具窗口
"===================================== X =====================================
" <leader>x:
"===================================== Y =====================================
" <leader>y: CopyClipboard-将选中行复制到剪切板
" [V]<leader>y: CopyClipboard-在可视模式中：将选中文字复制到剪切板
"===================================== Z =====================================
" <leader>z: zip(fold) ⭐️[目录]
" <leader>zo: unZipAll-展开所有代码折叠区域(Ctrl + Shift + 加号键)
" <leader>zc: ZipAll-折叠所有代码折叠区域(Ctrl + Shift + 减号键)
"=============================================================================
"=============================================================================



" ================================================================================================
" 🌟🌟🌟 <leader>详细配置 🌟🌟🌟
" ================================================================================================
"========= NULL ========
"这一行为在按下<leader>后显示的,甭管就行
let g:WhichKeyDesc_LeaderKeymap= "<leader> 🌟🌟🌟紫色为二级目录🌟🌟🌟"


"========== b ==========


"========== c =========c
let g:WhichKeyDesc_CodeAndClose = "<leader>c Code&关闭"

"关闭所有标签页
let g:WhichKeyDesc_CodeAndClose_CloseAllEditors = "<leader>ca 关闭所有标签页"
nmap <leader>ca <action>(CloseAllEditors)
"关闭当前标签页
let g:WhichKeyDesc_CodeAndClose_CloseEditor = "<leader>cd 关闭当前标签页"
nmap <leader>cd :action CloseEditor<CR>
"代码自动补全
let g:WhichKeyDesc_CodeAndClose_CodeCompletion = "<leader>cc 代码自动补全"
nmap <leader>cc <action>(CodeCompletion)
"关闭其他标签页
let g:WhichKeyDesc_CodeAndClose_CloseAllEditorsButActive = "<leader>co 关闭其他标签页"
nmap <leader>co :action CloseAllEditorsButActive<CR>


"========== d ==========
let g:WhichKeyDesc_DeBugOrDelete= "<leader>d 调试&删除"
"打断点/解除断点
let g:WhichKeyDesc_DebugOrDelete_BreakPoint = "<leader>dp 打断点/解除断点 "
nmap <leader>dp <Action>(ToggleLineBreakpoint)
"调试
let g:WhichKeyDesc_DebugOrDelete_DeBug = "<leader>db 调试"
nmap <leader>db <Action>(Debug)
"在可视模式中：删除选择的文本并复制到剪切板
let g:WhichKeyDesc_DebugOrDelete_DeleteAndCopyToClipboard = "<leader>dd 删除并复制到剪切板"
vmap <leader>dd "+d


"========== e ==========
"激活项目工具窗口(Alt + 1)
let g:WhichKeyDesc_ToggleExplorerOrExtract = "<leader>e 打开文件列表"
nmap <leader>e <action>(ActivateProjectToolWindow)


"========== f ==========
let g:WhichKeyDesc_FindOrFormat = "<leader>f 查找&格式化"

"快速 导航/查找 项目中的其他文件(Ctrl + n)
let g:WhichKeyDesc_FindOrFormat_FindFile = "<leader>ff 查找文件"
nmap <leader>ff <action>(GotoFile)
"将当前编辑的文件在项目视图中进行选中定位(Alt + F1)
let g:WhichKeyDesc_FindOrFormat_FindFileLocation = "<leader>fl 定位文件位置"
nmap <leader>fl <action>(SelectInProjectView)
"在整个项目中查找指定的文本、关键字或正则表达式，包括代码文件、配置文件和其他文件等(Ctrl + Shift + F)
let g:WhichKeyDesc_FindOrFormat_FindText = "<leader>ft 查找字符"
nmap <leader>ft <action>(FindInPath)
"打开 "Find Action"（查找动作）对话框(Ctrl + Shift + A)
let g:WhichKeyDesc_FindOrFormat_Commands = "<leader>fc 打开查找菜单"
nmap <leader>fc <action>(GotoAction)
"重新格式化代码，使其符合预定义的代码样式和规范 \| 优化导入语句，删除未使用的导入，并将导入语句按字母顺序进行排列
let g:WhichKeyDesc_FindOrFormat_Format = "<leader>fm 格式化代码"
nmap <leader>fm <action>(ReformatCode) \| <action>(OptimizeImports)


"========== g ==========
let g:WhichKeyDesc_GitOrGenerate = "<leader>g Git&构造"

"执行版本控制（VCS）的回滚操作，将修改的代码还原到之前的版本
let g:WhichKeyDesc_GitOrGenerate_RollbackHunk = "<leader>gr git回滚"
nmap <leader>gr :action Vcs.RollbackChangedLines<CR>
"生成构造器
let g:WhichKeyDesc_GitOrGenerate_GenerateConstructor = "<leader>gc 生成构造器"
nmap <leader>gc :action GenerateConstructor<CR>
"生成getter
let g:WhichKeyDesc_GitOrGenerate_GenerateGetter = "<leader>gg 生成getter"
nmap <leader>gg :action GenerateGetter<CR>
"生成setter
let g:WhichKeyDesc_GitOrGenerate_GenerateSetter = "<leader>gs 生成setter"
nmap <leader>gs :action GenerateSetter<CR>
"生成setter和getter
let g:WhichKeyDesc_GitOrGenerate_GenerateGetterAndSetter = "<leader>ga 生成setter和getter"
nmap <leader>ga <action>(GenerateGetterAndSetter)
"生成 equals() 和 hashcode() 的重写方法
let g:WhichKeyDesc_GitOrGenerate_GenerateEquals = "<leader>ge 生成equals和hashcode的重写"
nmap <leader>ge <action>(GenerateEquals)
"生成toString
let g:WhichKeyDesc_GitOrGenerate_GenerateToString = "<leader>gt 生成toString"
nmap <leader>gt <action>(Actions.ActionsPlugin.GenerateToString)
"diff 显示文件的版本控制历史(git)
nmap <leader>gd <action>(Vcs.ShowTabbedFileHistory)
let g:WhichKeyDesc_DebugOrDelete_ShowTabbedFileHistory = "<leader>gd 显示文件的版本控制历史"


"========== h ==========
"跳转到左边的分割窗口
let g:WhichKeyDesc_Show_MoveToLeft = "<leader>h 向左跳转"
nmap <leader>h <c-w>h


"========== i ==========
"快速查找并跳转到下一个以 ( 开始的函数或方法调用的位置️
let g:WhichKeyDesc_InsertAfterBrackets = "<leader>i 跳转到选一个("
nmap <leader>i f(a


"========== j ==========
"跳转到下边的分割窗口
let g:WhichKeyDesc_Show_MoveToDown = "<leader>j 向下跳转"
nmap <leader>j <c-w>j


"========== k ==========
"跳转到上边的分割窗口
let g:WhichKeyDesc_Show_MoveToUp = "<leader>k 向上跳转"
nmap <leader>k <c-w>k


"========== l ==========
"跳转到右边的窗口
let g:WhichKeyDesc_Show_MoveToRight = "<leader>l 向右跳转"
nmap <leader>l <c-w>l


"========== m ==========
"打开/关闭 代码小地图
let g:WhichKeyDesc_CodeGlance = "<leader>m 开关小地图"
nmap <leader>m <action>(CodeGlance.toggle)
"好像更新版本后,突然用不了了,用默认的ctrl+shift+G吧


"========== n ==========
let g:WhichKeyDesc_NERDTreeOrNew = "<leader>n 目录树&新建"

"取消搜索高亮显示(No Highlight)
let g:WhichKeyDesc_NERDTreeOrNew_Highlight = "<leader>nl 取消搜索高亮"
nmap <leader>nl :nohlsearch<CR>
"在当前目录新建文件夹
let g:WhichKeyDesc_NERDTreeOrNew_NewDir = "<leader>nd 新建文件夹"
nmap <leader>nd <action>(NewDir)
"在当前目录新建类
let g:WhichKeyDesc_NERDTreeOrNew_NewClass = "<leader>nc 新建.Class"
nmap <leader>nc <action>(NewClass)


"========== p ==========
"从剪切板粘贴到下面行
let g:WhichKeyDesc_PasteClipboardDown = "<leader>p 从剪切板粘贴到下面行"
nmap <leader>p "+p
"从剪切板粘贴到上面行
let g:WhichKeyDesc_PasteClipboardUp = "<leader>P 从剪切板粘贴到上面行"
nmap <leader>P "+P
"在可视模式中：从剪切板粘贴到下面行
let g:WhichKeyDesc_PasteClipboardDown = "<leader>p 从剪切板粘贴到下面行"
vmap <leader>p "+p
"在可视模式中：从剪切板粘贴到上面行
let g:WhichKeyDesc_PasteClipboardUp = "<leader>P 从剪切板粘贴到上面行"
vmap <leader>P "+P


"========== r ==========
let g:WhichKeyDesc_RunOrRe = "<leader>r 运行&重新"

" ru: Run-运行 (运行后自动聚焦)
let g:WhichKeyDesc_Run_Run = "<leader>ru 运行"
nmap <leader>ru :action Run <bar> action ActivateRunToolWindow<CR>
"运行
" rc: RunClass-运行当前编辑器中的文件或类(Shift + F10) (运行后自动聚焦)
let g:WhichKeyDesc_Run_RunContext = "<leader>rc 运行当前文件"
nmap <leader>rc :action RunClass <bar> action ActivateRunToolWindow<CR>
"重新运行最近一次运行的程序或测试(Ctrl+Shift + F10)
let g:WhichKeyDesc_RunOrRe_ReRun = "<leader>rr 重新运行"
nmap <leader>rr <action>(Rerun)
" rr: ReRun-重新运行最近一次运行的测试,重新运行 (运行后自动聚焦)
let g:WhichKeyDesc_Run_Rerun = "<leader>rr 重新运行"
nmap <leader>rr :action Rerun <bar> action ActivateRunToolWindow<CR>
"在代码中快速更改一个标识符的名称，并自动处理所有相关的引用(Shift + F6)
let g:WhichKeyDesc_RunOrRe_Rename = "<leader>rn 重构"
map <leader>rn <action>(RenameElement)


"========== s ==========
let g:WhichKeyDesc_Show = "<leader>s 显示&停止&查找"

"显示当前打开文件的文件结构弹出窗口，其中包含文件中的类、方法、字段等结构(Alt + 7)
let g:WhichKeyDesc_Show_FileStructure = "<leader>ss 显示文件结构"
nmap <leader>ss <action>(FileStructurePopup)
"显示书签（Bookmarks）工具窗口，其中包含当前文件中设置的书签列表(Ctrl + F11)
let g:WhichKeyDesc_Show_Bookmarks = "<leader>sb 显示书签工具窗口"
nmap <leader>sb <action>(ShowBookmarks)
"显示所有Vim Marks列表(:marks)
let g:WhichKeyDesc_Show_Marks = "<leader>sm 显示Vim Marks列表"
nnoremap <leader>sm :marks<CR>
"用于显示方法或函数的参数信息(Ctrl + p)
let g:WhichKeyDesc_Show_ParameterInfo = "<leader>sp 显示方法或函数的参数信息"
nmap <leader>sp <action>(ParameterInfo)
"Stop
let g:WhichKeyDesc_Show_Stop = "<leader>st 停止运行"
nmap <leader>st <action>(Stop)
"选中文件中所有匹配项,一般用多光标操作(Ctrl+Alt+Shift+J)
let g:WhichKeyDesc_SelectAll = "<leader>sa 选中所有匹配项"
nmap <leader>sa <action>(SelectAllOccurrences)

"========= t ==========
" 标签页操作,请多使用vim原生gt/gT
let g:WhichKeyDesc_Tab_Group = "<leader>t 标签页"

let g:WhichKeyDesc_Tab_Previous = "<leader>tp 上一个标签页"
nnoremap <leader>tp :action PreviousTab<CR>
let g:WhichKeyDesc_Tab_Next = "<leader>tn 下一个标签页"
nnoremap <leader>tn :action NextTab<CR>

"========== w ==========
let g:WhichKeyDesc_Windows = "<leader>w 窗口"

" --- 窗口跳转 (Focus) ---
" 使用 <leader>h/j/k/l 快速在分割窗口间跳转
let g:WhichKeyDesc_Focus_Left = "<leader>h 左窗口"
nmap <leader>h <C-w>h
let g:WhichKeyDesc_Focus_Down = "<leader>j 下窗口"
nmap <leader>j <C-w>j
let g:WhichKeyDesc_Focus_Up = "<leader>k 上窗口"
nmap <leader>k <C-w>k
let g:WhichKeyDesc_Focus_Right = "<leader>l 右窗口"
nmap <leader>l <C-w>l
" 同时保留 <leader>w h/j/k/l 的跳转方式
let g:WhichKeyDesc_Windows_Focus_Left = "<leader>wh 左窗口"
nmap <leader>wh <C-w>h
let g:WhichKeyDesc_Windows_Focus_Down = "<leader>wj 下窗口"
nmap <leader>wj <C-w>j
let g:WhichKeyDesc_Windows_Focus_Up = "<leader>wk 上窗口"
nmap <leader>wk <C-w>k
let g:WhichKeyDesc_Windows_Focus_Right = "<leader>wl 右窗口"
nmap <leader>wl <C-w>l

" --- 窗口分割 (Split) ---
" 垂直分割窗口
let g:WhichKeyDesc_Windows_Split_Vertical = "<leader>wv 垂直分割"
nmap <leader>wv <action>(SplitVertically)

" 水平分割窗口
let g:WhichKeyDesc_Windows_Split_Horizontal = "<leader>ws 水平分割"
nmap <leader>ws <action>(SplitHorizontally)

" --- 窗口关闭 (Close) ---
" 关闭当前分割窗口
let g:WhichKeyDesc_Windows_Close_Current = "<leader>wc 关闭当前分割"
nmap <leader>wc <C-w>c

" 取消所有分割窗口
let g:WhichKeyDesc_Windows_UnsplitAll = "<leader>wa 取消所有分割窗口"
nmap <leader>wo <action>(UnsplitAll)

" 取消拆分当前分割窗口
let g:WhichKeyDesc_Windows_Unsplit = "<leader>wu 取消拆分当前分割窗口"
nmap <leader>wu <action>(Unsplit)

" 隐藏/显示所有窗口
let g:WhichKeyDesc_Windows_Hide_HideActiveWindow = "<leader>ww 隐藏/显示所有窗口"
nmap <leader>ww <action>(HideAllWindows)


"========== y ==========
"普通模式下将 "+ (复制到剪切板）简化为 <leader>y
let g:WhichKeyDesc_CopyClipboard = "<leader>y 复制到剪切板"
vmap <leader>y "+y
"可视模式下将 "+ (复制到剪切板）简化为 <leader>y
let g:WhichKeyDesc_CopyClipboard= "<leader>y 复制到剪切板"
nmap <leader>y "+yy


"========== z ==========
let g:WhichKeyDesc_Zip = "<leader>z 折叠"

"展开所有代码折叠区域(Ctrl + Shift + 加号键)
let g:WhichKeyDesc_Zip_unZipAll = "<leader>zo 展开所有折叠"
nmap <leader>zo <action>(ExpandAllRegions)
"折叠所有代码折叠区域(Ctrl + Shift + 减号键)
let g:WhichKeyDesc_Zip_ZipAll = "<leader>zc 折叠所有代码"
nmap <leader>zc <action>(CollapseAllRegions)




" ================================================================================================
" 🌸🌸🌸 NERDTree 🌸🌸🌸
" ================================================================================================
"<C-w-w>：在多个打开的编辑器窗口之间切换
"在目录中，按下 go 打开文件并保持光标在目录
"在目录中，按下 gi 以上下并排窗口形式打开文件(并关闭目录)
"在目录树中，使用空格预览文件
"光标在目录时，按Esc回到编辑器
"编辑器和目录间切换存在许多功能类似的快捷键，相似但不完全相同
"仅 打开/关闭 目录推荐使用<leader>wo 其次 Alt + 1

"按下 <leader>nn 将使焦点转移到 NERDTree 窗口
nnoremap <leader>nn :NERDTreeFocus<CR>
let g:WhichKeyDesc_NERDTreeOrNo_NERDTreeFocus = "<leader>nn 转移到目录树"

"按下 <C-n> 将打开 NERDTree 文件资源管理器(==<leader>nn)
nnoremap <C-n> :NERDTree<CR>

"按下 <C-t> 将切换 NERDTree 文件资源管理器的显示状态，即打开或关闭 NERDTree(不建议)
nnoremap <C-t> :NERDTreeToggle<CR>

"按下 <C-f> 将在 NERDTree 文件资源管理器中定位当前编辑文件所在的节点，并使其可见(相当于<leader>fl)
nnoremap <C-f> :NERDTreeFind<CR>


" ================================================================================================
" 🌸🌸🌸 Easymotion 🌸🌸🌸
" ================================================================================================

let g:WhichKeyDesc_easymotionkey = "<leader><leader> 快速跳转插件"

"普通模式输入s后输入要跳转到单词首字母(或多输入几个字母)
nmap s <Plug>(easymotion-bd-n)
let g:WhichKeyDesc_easymotion = "s 快速跳转"