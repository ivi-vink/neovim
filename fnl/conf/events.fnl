(vim.api.nvim_create_augroup "conf#events" {:clear true})

(fn white_space_highlight []
  (local pattern "'\\s\\+$'")
  (vim.cmd (.. "syn match TrailingWhitespace " pattern))
  (vim.cmd "hi link TrailingWhitespace IncSearch"))

(vim.api.nvim_create_autocmd [:BufReadPost]
                             {:pattern ["*"]
                              :callback white_space_highlight
                              :group "conf#events"})

(local vimenter-cwd (vim.fn.getcwd))
(fn save-session []
  (P vimenter-cwd)
  (vim.cmd (.. "mksession! " vimenter-cwd :/.vimsession.vim)))

(vim.api.nvim_create_autocmd [:VimLeave]
                             {:pattern ["*"]
                              :callback save-session
                              :group "conf#events"})

(vim.api.nvim_create_autocmd [:BufWinEnter :WinEnter]
                             {:pattern ["term://*"]
                              :callback (fn []
                                          (vim.cmd :startinsert))
                              :group "conf#events"})

(vim.api.nvim_create_autocmd [:BufLeave]
                             {:pattern ["term://*"]
                              :callback (fn []
                                          (vim.cmd :stopinsert))
                              :group "conf#events"})
