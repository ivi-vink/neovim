(local {: frame->open-win-options} (require :conf.exctl.frames.frame))
(local buf {})

;; Paint procedure takes a frame to create a neovim window and populate the winbar and buffer of the window
;; frame is max height and width the painter can use
;; { height = number, width = number }
(fn buf.paint [self frame]
  (local open (or self.window false))
  (assert (not open)
          "Expect window not open, because i need to implement the closed paint case first")
  (vim.api.nvim_open_win 0 true (frame->open-win-options frame)))

(fn buf.transform [self paint]
  (buf.new {: self.fetch-buffers : paint}))

;; Buffer painters paints the window that is used to manage buffers where jobs put their output
;; (fn fetch-buffers [] ...) -> [buffers...]
(fn buf.new [self painter]
  (setmetatable painter self)
  (set self.__index self)
  painter)

;; Fancy lua way to create a new instance of the buf painter obj
(fn [fetch-buffers]
  (buf:new {: fetch-buffers :frames []}))
