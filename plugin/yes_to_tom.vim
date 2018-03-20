" Temp execution until I make some commands
nnoremap <leader>on :call <SID>OpenNotes()<cr>
nnoremap <leader>cn :call <SID>CloseNotes()<cr>

let s:notes_directory = "~/Documents/vim_notes/"
let s:notes_file_format = "notes_for_%Y_%b_%d.txt"

function! s:OpenNotes()
  " Open the day files
  execute "tab split " . <SID>MakeTodayFile()
  if filewritable(<SID>MakeTodayFile())
    execute "normal! iyay\<esc>"
  else
    execute "normal! iboo\<esc>"
  endif
  set buftype=nofile
  execute "split " . <SID>MakeTomorrowFile()
  set buftype=nofile
  execute "vsplit " . <SID>FindOrMakeYesterdayFile()
  set buftype=nofile

  " Move to the file for today
  execute "normal! \<C-w>j"
endfunction

function! s:CloseNotes()
  " Close the notes tab
  " TODO make sure it isn't already closed
  tabclose
endfunction

function! s:FindOrMakeYesterdayFile()
  let day_to_check = localtime()
  for days_ago in range(1, 30)
    if filewritable(<SID>FullFileByDate(day_to_check - (84600 * days_ago)))
      return <SID>FullFileByDate(day_to_check - (84600 * days_ago))
    endif
  endfor
  " TODO do something to notify that none was found
  return "__Yesterday__"
endfunction

function! s:MakeTodayFile()
  return <SID>FullFileByDate(localtime())
endfunction

function! s:MakeTomorrowFile()
  let tomorrow_time = localtime() + 84600
  return <SID>FullFileByDate(tomorrow_time)
endfunction

function! s:FullFileByDate(date)
  return s:notes_directory . strftime(s:notes_file_format, a:date)
endfunction
