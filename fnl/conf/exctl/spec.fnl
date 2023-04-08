;; (local a (require :plenary.async))
;;
;; (local back2vim (a.wrap vim.schedule 1))
;;
;; (fn read_file [path]
;;   (local fd (a.uv.fs_open path :r 438))
;;   (back2vim)
;;   (vim.notify (vim.inspect fd)))
;;
;; (local f (.. (os.getenv :HOME) :/test))
;;
;; (a.run (fn []
;;          (read_file f)))
(tset package.loaded :conf.exctl.frames.vec nil)
(local vec (require :conf.exctl.frames.vec))
(local test-vec (vec.vec 0 1))
(test-vec:x-coord)
(test-vec:y-coord)
(vec.sub test-vec (vec.vec 1 0))
(vec.add test-vec (vec.vec 1 0))
(vec.scale 3 test-vec)

(tset package.loaded :conf.exctl.frames.frame nil)
(local frame (require :conf.exctl.frames.frame))
(local root-frame (frame (vec.vec 0 0) (vec.vec vim.o.columns 0)
                         (vec.vec 0 vim.o.lines)))

(root-frame:origin)
(root-frame:height-edge)
(root-frame:width-edge)
(frame.frame->open-win-options root-frame)

(tset package.loaded :conf.exctl.painters.buf nil)
(local buf-painter (require :conf.exctl.painters.buf))
(local test (buf-painter (fn [] [0])))

;; {: height
;;                                  : width
;;                                  :relative :editor
;;                                  :anchor :NW
;;                                  :row (math.floor (* vim.o.lines 0.7))
;;                                  :col 0.2])))
