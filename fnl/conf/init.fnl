(vim.cmd "colorscheme kanagawa-wave")
(vim.cmd "filetype plugin on")
(vim.cmd "filetype indent on")
(vim.cmd "highlight WinSeparator guibg=None")
(vim.cmd "packadd cfilter")

(require :conf.settings)
(require :conf.pkgs)
(require :conf.lsp)
(require :conf.events)
(require :conf.filetype)
(require :conf.newtab)
(require :conf.nix-develop)

(require :conf.diagnostic)

;; TODO: make a function that sets this autocommand: au BufWritePost currentfile :!curl -X POST -d "{\"previewRun\": true, \"yamlOverride\": \"$(cat % | yq -P)\", \"resources\": {\"repositories\": {\"self\": {\"refName\": \"refs/heads/branch\"}}}}" -s -H "Content-Type: application/json" -H "Authorization: Basic $WORK_AZDO_GIT_AUTH" "$WORK_AZDO_GIT_ORG_URL/Stater/_apis/pipelines/pipelineid/preview?api-version=7.1-preview.1" | jq -r '.finalYaml // .' > scratch.yaml

(let [map vim.keymap.set]
  (map :t :<c-s> "<c-\\><c-n>")
  ;; pausing and continueing printing output is not necessary inside neovim terminal right?
  (map :t :<c-q> "<c-\\><c-n>:q<cr>")
  (map :n :<leader>qo ":copen<cr>")
  (map :n :<leader>qc ":cclose<cr>")
  (map :n :<leader>lo ":lopen<cr>")
  (map :n :<leader>lc ":lclose<cr>")
  (map :n "[q" ":cprevious<cr>")
  (map :n "]q" ":cnext<cr>")
  (map :n "[x" ":lprevious<cr>")
  (map :n "]x" ":lnext<cr>")
  (map :n :<c-p> ":Telescope find_files<cr>")
  (map :n "`<Backspace>" ":FocusDispatch ")
  (map :n :<leader>p ":NewTab<cr>")
  (map :n :<leader>cf ":tabedit ~/flake|tc ~/flake|G<cr><c-w>o")
  (map :n :<leader>cn ":tabedit ~/neovim|tc ~/neovim|G<cr><c-w>o"))

(tset _G :P (lambda [...]
              (let [inspected (icollect [_ v (ipairs [...])]
                                (vim.inspect v))]
                (each [_ printer (ipairs inspected)]
                  (print printer)))))

(local git-worktree (require :git-worktree))
(git-worktree.setup {:change_directory_command :tcd
                     :update_on_change true
                     :autopush false})

(vim.keymap.set [:n] :<leader>w ":Worktree ")
(vim.api.nvim_create_user_command :Worktree
                                  (fn [ctx]
                                    (match ctx.fargs
                                      [:create tree branch upstream] (git-worktree.create_worktree tree
                                                                                                   branch
                                                                                                   upstream)
                                      [:create tree upstream] (git-worktree.create_worktree tree
                                                                                            tree
                                                                                            upstream)
                                      [:create tree] (git-worktree.create_worktree tree
                                                                                   tree
                                                                                   :origin)
                                      [:switch tree] (git-worktree.switch_worktree tree)
                                      [:delete tree] (git-worktree.delete_worktree tree)
                                      [tree] (git-worktree.switch_worktree tree)))
                                  {:nargs "*"
                                   :complete (fn [lead cmdline cursor]
                                               (local cmds
                                                      [:create :switch :delete])
                                               (if (accumulate [cmd-given false _ cmd (ipairs cmds)]
                                                     (or cmd-given
                                                         (string.find cmdline
                                                                      cmd)))
                                                   []
                                                   cmds))})

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
                                    (match (. ctx.fargs 1)
                                      :plan (vim.cmd (.. ":Dispatch "
                                                         (if ctx.bang
                                                             "TF_LOG=DEBUG "
                                                             "")
                                                         "terragrunt "
                                                         (table.concat ctx.fargs
                                                                       " ")
                                                         " " :-out=gruntplan))
                                      :apply (vim.cmd (.. ":Dispatch "
                                                          (if ctx.bang
                                                              "TF_LOG=DEBUG "
                                                              "")
                                                          "terragrunt "
                                                          (table.concat ctx.fargs
                                                                        " ")
                                                          " " :gruntplan))
                                      _ (vim.cmd (.. ":Start "
                                                     (if ctx.bang
                                                         "TF_LOG=DEBUG "
                                                         "")
                                                     "terragrunt "
                                                     (table.concat ctx.fargs
                                                                   " ")))))
                                  {:nargs "*" :bang true})

(vim.api.nvim_create_user_command :K9s
                                  (fn [ctx]
                                    (vim.cmd (.. ":Start k9s --context "
                                                 (. ctx.fargs 1))))
                                  {:nargs 1})
