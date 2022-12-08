(local lspconfig (require :lspconfig))
(local {: attach} (require :conf.lsp))

(lspconfig.pyright.setup {:root_dir (lspconfig.util.root_pattern :.git
                                                                 (vim.fn.getcwd))
                          :on_attach attach})

(lspconfig.tsserver.setup {:root_dir (lspconfig.util.root_pattern :.git
                                                                  (vim.fn.getcwd))
                           :on_attach attach})

(lspconfig.yamlls.setup {:root_dir (lspconfig.util.root_pattern :.git
                                                                (vim.fn.getcwd))
                         :on_attach attach})
