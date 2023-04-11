(tset package.loaded :conf.exctl.frames.vec nil)
(local vec (require :conf.exctl.frames.vec))

(tset package.loaded :conf.exctl.frames.frame nil)
(local frame (require :conf.exctl.frames.frame))

(tset package.loaded :conf.exctl.builder nil)
(local builder (require :conf.exctl.builder))

(tset package.loaded :conf.exctl.effects nil)
(local effects (require :conf.exctl.effects))

(local root-frame (frame (vec.vec 0 0) (vec.vec vim.o.columns 0)
                         (vec.vec 0 vim.o.lines)))

(local painter (-> (builder:new)
                   (builder.For {:buffer (fn [] 0)
                                 :maps [{:mode [:n :v :o]
                                         :lhs :q
                                         :rhs (fn [effects window]
                                                (fn []
                                                  (effects:close)))}]})
                   (builder.Padding 5)
                   (builder.Beside (-> (builder:new)
                                       (builder.For {:buffer (fn [] 0)})))
                   (builder.Build (effects:new))))

(painter root-frame)
