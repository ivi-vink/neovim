(let [null-ls (require :null-ls)
      lsp-conf (require :conf.lsp)]
  (null-ls.setup {:update_on_insert false
                  :on_attach (fn [client buf]
                               (lsp-conf.attach client buf true))
                  :sources [null-ls.builtins.formatting.black
                            null-ls.builtins.formatting.goimports
                            null-ls.builtins.formatting.gofumpt
                            null-ls.builtins.formatting.golines
                            null-ls.builtins.formatting.prettier
                            null-ls.builtins.formatting.raco_fmt
                            null-ls.builtins.formatting.alejandra
                            null-ls.builtins.formatting.fnlfmt]}))
