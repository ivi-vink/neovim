(var buf nil)
(var channel nil)

(var static-buf nil)
(var static-channel nil)

(fn show-buf [b split]
  (local split-cmd split)
  (vim.cmd split-cmd)
  (local w (vim.api.nvim_get_current_win))
  (vim.api.nvim_win_set_buf w b)
  w)

(fn hide-buf [b]
  (local wlist (vim.fn.win_findbuf b))
  (each [_ w (pairs wlist)]
    (vim.api.nvim_win_close w false)))

(fn visible? [b]
  (if (or (= nil b) (not (vim.api.nvim_buf_is_valid b))) false)
  (local wlist (vim.fn.win_findbuf b))
  (print (vim.inspect wlist))
  (< 0 (length wlist)))

(fn open-terminal [opts]
  (if (or (= nil buf) (not (vim.api.nvim_buf_is_valid buf)))
      (let [b (vim.api.nvim_create_buf false true)]
        (match b
          0 :error
          _ (set buf b))))
  (show-buf (. opts :splitcmd))
  (if (= nil channel)
      (let [c (vim.fn.termopen [vim.o.shell]
                               {:on_exit (fn []
                                           (set buf nil)
                                           (set channel nil))})]
        (match c
          0 :error
          _ (set channel c)))))

(fn cmd [cmd opts]
  (if (not (visible?)) (open-terminal {:splitcmd "vertical bo split"}))
  (vim.fn.chansend channel (.. cmd "\r")))

(fn job [opts]
  (if (or (= nil static-buf) (not (vim.api.nvim_buf_is_valid static-buf)))
      (let [b (vim.api.nvim_create_buf false true)]
        (match b
          0 :error
          _ (set static-buf b))))
  (if (= nil static-channel)
      (let [c (vim.api.nvim_open_term static-buf
                                      {:on_input (fn []
                                                   (print :on_input))})]
        (match c
          0 :error
          _ (set static-channel c))))
  (local command (or (. opts :cmd) (.. vim.o.shell " -c \"echo 'hi three'\"")))
  (if (not (visible? static-buf)) (show-buf static-buf "vertical bo split"))
  (vim.fn.chansend static-channel (.. command "\r")))

(job {})
(print static-buf)
(print static-channel)
