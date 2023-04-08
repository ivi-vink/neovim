(local vec (require :conf.exctl.frames.vec))
(local frame (require :conf.exctl.frames.frame))
(tset package.loaded :conf.exctl.painters.buf nil)
(local buf-painter (require :conf.exctl.painters.buf))
(tset package.loaded :conf.exctl.painters nil)
(local painter (require :conf.exctl.painters))

(local root-frame (frame (vec.vec 0 0)
                         (vec.vec vim.o.columns 0)
                         (vec.vec 0 vim.o.lines)))

(local output (buf-painter (fn [] [0])))
(local padded-output (painter.pad output 5))
(local b (painter.beside padded-output padded-output))

(b:paint root-frame)
