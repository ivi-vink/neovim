(vim.cmd "colorscheme kanagawa-wave")
(vim.cmd "filetype plugin on")
(vim.cmd "filetype indent on")
(vim.cmd "highlight WinSeparator guibg=None")

(require :conf.settings)
(require :conf.pkgs)
(require :conf.lsp)
(require :conf.events)
(require :conf.newtab)
(require :conf.nix-develop)

;; (require :conf.cmd)

(require :conf.diagnostic)

;; TODO: make a function that sets this autocommand: au BufWritePost currentfile :!curl -X POST -d "{\"previewRun\": true, \"yamlOverride\": \"$(cat % | yq -P)\", \"resources\": {\"repositories\": {\"self\": {\"refName\": \"refs/heads/branch\"}}}}" -s -H "Content-Type: application/json" -H "Authorization: Basic $WORK_AZDO_GIT_AUTH" "$WORK_AZDO_GIT_ORG_URL/Stater/_apis/pipelines/pipelineid/preview?api-version=7.1-preview.1" | jq -r '.finalYaml // .' > scratch.yaml

(let [map vim.keymap.set]
  (map :t :<c-s> "<c-\\><c-n>")
  ;; pausing and continueing printing output is not necessary inside neovim terminal right?
  (map :t :<c-q> "<c-\\><c-n>")
  (map :n :<leader>qo ":copen<cr>")
  (map :n :<leader>qc ":cclose<cr>")
  (map :n :<leader>lo ":lopen<cr>")
  (map :n :<leader>lc ":lclose<cr>")
  (map :n "[q" ":cprevious<cr>")
  (map :n "]q" ":cnext<cr>")
  (map :n "[x" ":lprevious<cr>")
  (map :n "]x" ":lnext<cr>")
  (map :n :<c-p> ":Telescope find_files<cr>")
  (map :n "`<Backspace>" ":FocusDispatch "))

(tset _G :P (lambda [...]
              (let [inspected (icollect [_ v (ipairs [...])]
                                (vim.inspect v))]
                (each [_ printer (ipairs inspected)]
                  (print printer)))))

(vim.api.nvim_create_user_command :HomeManager
                                  (fn [ctx]
                                    (vim.cmd (.. ":Dispatch home-manager switch --impure "
                                                 (os.getenv :HOME) "/flake#"
                                                 (. ctx.fargs 1))))
                                  {:nargs 1})

(vim.api.nvim_create_user_command :Gpush
                                  (fn [ctx]
                                    (vim.cmd ":Dispatch git push"))
                                  {})

(vim.api.nvim_create_user_command :Grunt
                                  (fn [ctx]
                                    (if (= (. ctx.fargs 1) :plan)
                                        (vim.cmd (.. ":Dispatch " (if ctx.bang "TF_LOG=DEBUG " "") "terragrunt "
                                                     (table.concat ctx.fargs
                                                                   " ")))
                                        (vim.cmd (.. ":Start " (if ctx.bang "TF_LOG=DEBUG " "") "terragrunt "
                                                     (table.concat ctx.fargs
                                                                   " ")))))
                                  {:nargs "*" :bang true})
