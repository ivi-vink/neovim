(vim.api.nvim_create_augroup "conf#events" {:clear true})

(let [white_space_highlight (fn []
                              (local pattern "'\\s\\+$'")
                              (vim.cmd (.. "syn match TrailingWhitespace "
                                           pattern))
                              (vim.cmd "hi link TrailingWhitespace IncSearch"))
      trim [:*.fnl
            :*.nix
            :*.md
            :*.hcl
            :*.tf
            :*.py
            :*.cpp
            :*.qml
            :*.js
            :*.txt
            :*.json
            :*.html
            :*.lua
            :*.yaml
            :*.yml
            :*.bash
            :*.sh
            :*.go]
      white_space_trim (fn []
                         (local pattern "\\s\\+$")
                         (vim.cmd (.. "%substitute/" pattern ://ge)))]
  (vim.api.nvim_create_autocmd [:BufReadPost]
                               {:pattern ["*"]
                                :callback white_space_highlight
                                :group "conf#events"})
  (vim.api.nvim_create_autocmd [:BufWritePre]
                               {:pattern trim
                                :callback white_space_trim
                                :group "conf#events"}))
