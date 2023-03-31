(local dap (require :dap))
(local adapters (. dap :adapters))
(local configurations (. dap :configurations))

(local dapui (require :dapui))

(tset adapters :delve
      {:type :server
       :port "${port}"
       :executable {:command :dlv :args [:dap :-l "127.0.0.1:${port}"]}})

(tset configurations :go
      [{:type :delve :name :Debug :request :launch :program "${fileDirname}"}
       {:type :delve
        :name :DebugTest
        :request :launch
        :mode :test
        :env {:CGO_CFLAGS :-Wno-error=cpp}
        :program "${file}"}
       {:type :delve
        :name :DebugTerraform
        :request :launch
        :program "${file}"
        :env {:CGO_CFLAGS :-Wno-error=cpp}
        :args [:-debug]}
       {:type :delve
        :name :DebugTerraformAcc
        :request :launch
        :program "${file}"
        :mode :test
        :env {:CGO_CFLAGS :-Wno-error=cpp :TF_ACC :1}}
       {:type :delve
        :name :DebugTestMod
        :request :launch
        :mode :test
        :env {:CGO_CFLAGS :-Wno-error=cpp}
        :program "${relativeFileDirname}"}])

(let [venv (os.getenv :VIRTUAL_ENV)]
  (when venv
    (tset adapters :python
          {:type :executable
           :command (.. venv :/bin/python)
           :args [:-m :debugpy.adapter]})
    (tset configurations :python
          [{:type :python :request :launch :name :file :program "${file}"}])))

(dapui.setup)
(vim.keymap.set :n :<leader>dui dapui.toggle {:silent true})

(vim.keymap.set :n :sq dap.terminate {:silent true})
(vim.keymap.set :n :sc dap.continue {:silent true})
(vim.keymap.set :n :sr dap.run_to_cursor {:silent true})
(vim.keymap.set :n :sn dap.step_over {:silent true})
(vim.keymap.set :n :ss dap.step_into {:silent true})
(vim.keymap.set :n :so dap.step_out {:silent true})
(vim.keymap.set :n :sb dap.toggle_breakpoint {:silent true})
(vim.keymap.set :n :sB dap.set_breakpoint {:silent true})
(vim.keymap.set :n :slp
                (fn []
                  (dap.set_breakpoint nil nil
                                      (vim.fn.input "Log point message: ")))
                {:silent true})

(vim.keymap.set :n :st dap.repl.open {:silent true})
(vim.keymap.set :n :sl dap.run_last {:silent true})
