(local harpoon-mark (require :harpoon.mark))
(local harpoon-ui (require :harpoon.ui))
(fn make-harpoon [func]
  (fn []
    (func)
    (vim.cmd :redrawtabline)))

(vim.keymap.set :n "[]" (make-harpoon (fn [] (harpoon-mark.add_file))))
(vim.keymap.set :n "][" (make-harpoon (fn [] (harpoon-ui.toggle_quick_menu))))
(vim.keymap.set :n "]]" (make-harpoon (fn [] (harpoon-ui.nav_next))))
(vim.keymap.set :n "[[" (make-harpoon (fn [] (harpoon-ui.nav_prev))))
(vim.keymap.set :n "[+" (make-harpoon (fn [] (harpoon-ui.nav_file 1))))
(vim.keymap.set :n "[-" (make-harpoon (fn [] (harpoon-ui.nav_file 2))))
(vim.keymap.set :n "[<" (make-harpoon (fn [] (harpoon-ui.nav_file 3))))
(vim.keymap.set :n "[>" (make-harpoon (fn [] (harpoon-ui.nav_file 4))))
(vim.keymap.set :n "[\"" (make-harpoon (fn [] (harpoon-ui.nav_file 5))))
