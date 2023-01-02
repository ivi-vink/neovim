(fn m [mode key cb]
  (vim.keymap.set mode key cb {:silent true :noremap true}))

(m :n :<leader>ge (fn []
                    (vim.diagnostic.open_float)))
