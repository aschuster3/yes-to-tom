" Temp execution until I make some commands
nnoremap <leader>on :call <SID>OpenNotes()<cr>
nnoremap <leader>cn :call <SID>CloseNotes()<cr>

function! s:OpenNotes()
  " Save the current session
  mksession! ~/tmp/saved_state.vim

  " Open the day files
  edit __Today__
  set buftype=nofile
  split __Tomorrow__
  set buftype=nofile
  vsplit __Yesterday__
  set buftype=nofile

  " Move to the __Today__ file
  execute "normal! \<C-w>j"
endfunction

function! s:CloseNotes()
  " Restore state from closed notes
  source ~/tmp/saved_state.vim
endfunction
