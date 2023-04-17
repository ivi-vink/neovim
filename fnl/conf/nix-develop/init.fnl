(local loop vim.loop)

(var original-env {})
(local ignored-variables {:SHELL true
                          :BASHOPTS true
                          :HOME true
                          :NIX_BUILD_TOP true
                          :NIX_ENFORCE_PURITY true
                          :NIX_LOG_FD true
                          :NIX_REMOTE true
                          :PPID true
                          :SHELL true
                          :SHELLOPTS true
                          :SSL_CERT_FILE true
                          :TEMP true
                          :TEMPDIR true
                          :TERM true
                          :TMP true
                          :TMPDIR true
                          :TZ true
                          :UID true})

(local separated-dirs {:PATH ":" :XDG_DATA_DIRS ":"})

(fn set-env [key value]
  (if (not (. original-env key))
      (tset original-env key (or (. vim.env key) :nix-develop-nil)))
  (local sep (. separated-dirs key))
  (if sep
      (do
        (local suffix (or (. vim.env key) ""))
        (tset vim.env key (.. value sep suffix)))
      (tset vim.env key value)))

(fn unload-env []
  (each [k v (pairs original-env)]
    (if (= v :nix-develop-nil)
        (tset vim.env k nil)
        (tset vim.env k v))))

(fn ignored? [key]
  (. ignored-variables (string.upper key)))

(fn exported? [Type]
  (= Type :exported))

(fn nix-develop [fargs]
  (local cmd :nix)
  (local fargs (or fargs []))
  (local args [:print-dev-env :--json (unpack fargs)])
  (local stdout (loop.new_pipe))
  (local stdio [nil stdout nil])
  (var nix-print-dev-env "")
  (local p (loop.spawn cmd {: args : stdio}
                       (fn [code signal]
                         (vim.notify (.. "nix-develop: exit code " code " "
                                         signal)))))
  (loop.read_start stdout
                   (fn [err data]
                     (assert (not err) err)
                     (if data
                         (set nix-print-dev-env (.. nix-print-dev-env data))
                         (do
                           (P {:msg "stdout end" : stdout})
                           (if (not= nix-print-dev-env "")
                               (vim.schedule #(each [key {: type : value} (pairs (. (vim.fn.json_decode nix-print-dev-env)
                                                                                    :variables))]
                                                (do
                                                  (if (and (exported? type)
                                                           (not (ignored? key)))
                                                      (do
                                                        (set-env key value))))))))))))

(vim.api.nvim_create_user_command :NixDevelop
                                  (fn [ctx]
                                    (nix-develop ctx.fargs))
                                  {:nargs "*"})

(vim.api.nvim_create_augroup :nix-develop {:clear true})
(vim.api.nvim_create_autocmd [:DirChanged :VimEnter]
                             {:pattern ["*"]
                              :callback (fn [ctx]
                                          (unload-env)
                                          (if (= 1
                                                 (vim.fn.filereadable (.. ctx.file
                                                                          :/flake.nix)))
                                              (nix-develop)))})
