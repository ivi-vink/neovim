(vim.cmd "colorscheme gruvbox-material")
(vim.cmd "filetype plugin on")
(vim.cmd "filetype indent on")
(vim.cmd "highlight WinSeparator guibg=None")

(require :conf.settings)
(require :conf.pkgs)
(require :conf.lsp)
(require :conf.events)

(require :conf.diagnostic)
