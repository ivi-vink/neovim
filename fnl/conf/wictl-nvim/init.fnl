(tset package.loaded :conf.wict-nvim nil)
(local wict (require :conf.wict-nvim))

(local bld wict.builder)
(local eff wict.effects)

(local m {})

(local WictlConfig {})
;; {
;;   ["/path/to/project"] = {
;;      jobs = [...]
;;      terms = [{cmd = "k9s"}]
;; }
(var last-buf -1)
(local ui (-> (bld.For {:buffer (fn [] (P last-buf)
                                  last-buf)
                        :maps [{:mode [:n :v :o]
                                :lhs :q
                                :rhs (fn [effects window]
                                       (fn [] (effects:close)))}]})
              (bld.Padding 1)
              (bld.RightOf (-> (bld.For {:buffer (fn []
                                                   (P last-buf)
                                                   last-buf)
                                         :maps []})
                               (bld.Padding 1)) 0.2)
              (bld.Build (eff:new))))

(ui wict.root-frame)
