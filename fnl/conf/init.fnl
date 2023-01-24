(vim.cmd "colorscheme gruvbox-material")
(vim.cmd "filetype plugin on")
(vim.cmd "filetype indent on")
(vim.cmd "highlight WinSeparator guibg=None")

(require :conf.settings)
(require :conf.pkgs)
(require :conf.lsp)
(require :conf.events)

(require :conf.diagnostic)

(let [map vim.keymap.set]
  (map :n :<leader>qo ":copen<cr>")
  (map :n :<leader>qc ":cclose<cr>")
  (map :n :<leader>lo ":lopen<cr>")
  (map :n :<leader>lc ":lclose<cr>")
  (map :n "<leader>[q" ":cprevious<cr>")
  (map :n "<leader>]q" ":cnext<cr>")
  (map :n "<leader>[x" ":lprevious<cr>")
  (map :n "<leader>]x" ":lnext<cr>"))
