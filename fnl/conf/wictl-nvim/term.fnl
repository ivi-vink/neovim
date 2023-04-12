(local ui-bld (require :conf.wict-nvim))
(local ui-eff (require :conf.wict-nvim.effects))
(local M {})

(local ProjectBufs {})
(local ui (-> (ui-bld.For {:buffer M.selected-buffer})))

(fn M.open [idx])
(fn M.start [])

M
