qmark h http://news.ycombinator.com/
qmark g http://github.com/
qmark u http://mail.google.com/
qmark s https://ngs-team.slack.com/messages/devops
qmark p https://postdevops.slack.com/messages/general
qmark d https://postdevops.slack.com/messages/dead

map U gT
map I gt

nmap g      :tabopen http://google.ru/search?q=
nmap x      :tabopen http://slovari.yandex.ru/
nmap q      <ESC>
nmap s      :tabopen<space>
nmap b      :buffer<space>
nmap <C-P>  :set apptab=true<CR>:echomsg "Pinned"<CR>
nmap <C-N>  :set apptab=false<CR>:echomsg "Unpinned"<CR>
nmap v      cv
nmap w      gT
nmap e      gt
nmap .      /
nmap <C-K>  <ESC>
nmap <C-L>  O

imap <C-}>  <C-I>
imap jk     <ESC>

vmap c      <ESC><ESC>c

nnoremap j   5j
nnoremap k   5k
nnoremap ee  :buffer<space>
nnoremap %   :source ~/.vimperatorrc<CR>

inoremap <C-]> <Ins><C-a><Ins><C-I>
inoremap <C-a> <Ins><C-a><Ins>
