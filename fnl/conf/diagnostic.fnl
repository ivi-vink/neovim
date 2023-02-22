(fn m [mode key cb]
  (vim.keymap.set mode key cb {:silent true :noremap true}))

(m :n :<leader>ge (fn []
                    (vim.diagnostic.open_float)))

(vim.diagnostic.config {:virtual_text false})

(vim.keymap.set :n :<Leader>l (let [l (require :lsp_lines)]
                                l.toggle)
                {:desc "Toggle lsp_lines"})
