(local loop vim.loop)

(var dev-env {})
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

(fn ignored? [key]
  (. ignored-variables (string.upper key)))

(fn split [str sep]
  (local l [])
  (each [m (str:gmatch "[^\r\n]+")]
    (P m)
    (table.insert l m))
  (P l))

(fn qf [title lines]
  (P lines)
  (vim.fn.setqflist [] " " {: title : lines})
  (vim.cmd :cope))

(fn exported? [Type]
  (= Type :exported))

(fn set-env [variables])
(fn unload-env [])

(fn nix-develop [fargs]
  (local cmd :nix)
  (local fargs (or fargs []))
  (local args [:print-dev-env :--json (unpack fargs)])
  (local stdout (loop.new_pipe))
  (local stdio [nil stdout nil])
  (var nix-print-dev-env "")
  (local p (loop.spawn cmd {: args : stdio}
                       (fn [code signal]
                         (vim.schedule (fn []
                                         (local json
                                                (vim.fn.json_decode nix-print-dev-env))
                                         (-> (accumulate [kvps {} key {: Type
                                                                       : value} (pairs json.variables)]
                                              (do
                                                (if (and (exported? Type)
                                                         (not (ignored? key)))
                                                    (tset kvps key value))
                                                kvps))
                                             (#(each [key value (pairs $1)]
                                                 (set-env key value)))
                                             (#(set dev-env $1))))))))
  (loop.read_start stdout
                   (fn [err data]
                     (assert (not err) err)
                     (if data
                         (set nix-print-dev-env (.. nix-print-dev-env data))
                         (P {:msg "stdout end" : stdout})))))

(nix-develop)

(vim.api.nvim_create_user_command :NixDevelop
                                  (fn [ctx]
                                    (nix-develop ctx.fargs))
                                  {:nargs "*"})
