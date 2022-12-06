(tset vim.g "conjure#log#wrap" true)

(tset vim.g "conjure#client#python#stdio#command" "python -iq")

(vim.api.nvim_create_user_command :ConjurePythonCommand
                                  (fn [opts]
                                    (tset vim.g
                                          "conjure#client#python#stdio#command"
                                          opts.args))
                                  {:nargs 1})
