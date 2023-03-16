(fn has-words-before []
  (local [line col] (vim.api.nvim_win_get_cursor 0))
  (local [word & rest] (vim.api.nvim_buf_get_lines 0 (- line 1) line true))
  (local before (word:sub col col))
  (local is_string (before:match "%s"))
  (and (not= col 0) (= is_string nil)))

(fn cmp-setup [cmp autocomplete]
  (let [luasnip (require :luasnip)
        snip (fn [args]
               (luasnip.lsp_expand (. args :body)))]
    (local cfg
           {:snippet {:expand snip}
            :mapping {:<Tab> (cmp.mapping (fn [fallback]
                                            (if (cmp.visible)
                                                (cmp.select_next_item)
                                                (luasnip.expand_or_jumpable)
                                                (luasnip.expand_or_jump)
                                                (has-words-before)
                                                (cmp.complete)
                                                (fallback))
                                            [:i :s]))
                      :<S-Tab> (cmp.mapping (fn [fallback]
                                              (if (cmp.visible)
                                                  (cmp.select_prev_item)
                                                  (luasnip.jumpable -1)
                                                  (luasnip.jump -1)
                                                  (fallback))
                                              [:i :s]))
                      :<C-b> (cmp.mapping.scroll_docs -4)
                      :<C-f> (cmp.mapping.scroll_docs 4)
                      :<C-A> (cmp.mapping.complete)
                      :<C-y> (cmp.mapping.confirm {:select true})}
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
