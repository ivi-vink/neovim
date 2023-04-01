(vim.cmd "colorscheme kanagawa-wave")
(vim.cmd "filetype plugin on")
(vim.cmd "filetype indent on")
(vim.cmd "highlight WinSeparator guibg=None")

(require :conf.settings)
(require :conf.pkgs)
(require :conf.lsp)
(require :conf.events)

;; (require :conf.cmd)

(require :conf.diagnostic)

;; TODO: make a function that sets this autocommand: au BufWritePost currentfile :!curl -X POST -d "{\"previewRun\": true, \"yamlOverride\": \"$(cat % | yq -P)\", \"resources\": {\"repositories\": {\"self\": {\"refName\": \"refs/heads/branch\"}}}}" -s -H "Content-Type: application/json" -H "Authorization: Basic $WORK_AZDO_GIT_AUTH" "$WORK_AZDO_GIT_ORG_URL/Stater/_apis/pipelines/pipelineid/preview?api-version=7.1-preview.1" | jq -r '.finalYaml // .' > scratch.yaml

(let [map vim.keymap.set]
  (map :n :<leader>qo ":copen<cr>")
  (map :n :<leader>qc ":cclose<cr>")
  (map :n :<leader>lo ":lopen<cr>")
  (map :n :<leader>lc ":lclose<cr>")
  (map :n "[q" ":cprevious<cr>")
  (map :n "]q" ":cnext<cr>")
  (map :n "[x" ":lprevious<cr>")
  (map :n "]x" ":lnext<cr>"))

(tset _G :P (lambda [...]
              (let [inspected (icollect [_ v (ipairs [...])]
                                (vim.inspect v))]
                (each [_ printer (ipairs inspected)]
                  (print printer)))))
