(fn cmp-setup [cmp autocomplete]
  (let [luasnip (require :luasnip)
        snip (fn [args]
               (luasnip.lsp_expand (. args :body)))]
    (local cfg
           {:snippet {:expand snip}
            :mapping (cmp.mapping.preset.insert {:<C-b> (cmp.mapping.scroll_docs -4)
                                                 :<C-f> (cmp.mapping.scroll_docs 4)
                                                 :<C-A> (cmp.mapping.complete)
                                                 :<C-e> (cmp.mapping.confirm {:select true})})
            :sources (cmp.config.sources [{:name :conjure}
                                          {:name :nvim_lsp}
                                          {:name :path}
                                          {:name :luasnip}])})
    (if (not autocomplete) (tset cfg :completion {:autocomplete false}))
    ;; (print (vim.inspect cfg))
    (cmp.setup cfg)))

(var autocomplete-flag false)
(fn toggle-autocomplete []
  (if autocomplete-flag
      (set autocomplete-flag false)
      (set autocomplete-flag true))
  (match (pcall require :cmp)
    (true cmp) (cmp-setup cmp autocomplete-flag)
    (false cmp) (print "Something went wrong")))

(toggle-autocomplete)
