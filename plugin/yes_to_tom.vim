" Temp execution until I make some commands
nnoremap <leader>on :call <SID>OpenNotes()<cr>
nnoremap <leader>cn :call <SID>CloseNotes()<cr>

let s:notes_directory = "~/Documents/vim_notes/"
let s:notes_file_format = "notes_for_%Y_%b_%d.txt"

function! s:OpenNotes()
  " Open the day files
  execute "tab split " . <SID>MakeTodayFile()
  autocmd InsertLeave <buffer> update
  execute "split " . <SID>MakeTomorrowFile()
  autocmd InsertLeave <buffer> update
  execute "vsplit " . <SID>FindOrMakeYesterdayFile()
  if <SID>FindOrMakeYesterdayFile() ==? "__Yesterday__"
    set buftype=nofile
  else
    autocmd InsertLeave <buffer> update
  end

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
