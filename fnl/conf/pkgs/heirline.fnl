(local heirline (require :heirline))
(local conditions (require :heirline.conditions))
(local utils (require :heirline.utils))
(local colors (let [kanagawa-colors (require :kanagawa.colors)]
                (kanagawa-colors.setup)))

(heirline.load_colors colors)
(fn palette [name]
  (. (. colors :palette) name))

(fn theme [theme name]
  (. (. (. colors :theme) theme) name))

(var FileNameBlock
     {;; let's first set up some attributes needed by this component and it's children
      :init (lambda [self]
              (tset self :filename (vim.api.nvim_buf_get_name 0)))})

(local FileName
       {:provider (lambda [self]
                    ;; first, trim the pattern relative to the current directory. For other
                    ;;- options, see :h filename-modifers
                    (var filename (vim.fn.fnamemodify (. self :filename) ":."))
                    (if (= filename "")
                        (set filename "[No Name]")
                        ;;- now, if the filename would occupy more than 1/4th of the available
                        ;;-- space, we trim the file path to its initials
                        ;;-- See Flexible Components section below for dynamic truncation
                        (if (not (conditions.width_percent_below (length filename)
                                                                 0.25))
                            (set filename (vim.fn.pathshorten filename))))
                    filename)
        :hl {:fg (. (utils.get_highlight :Directory) :fg)}})

(local FileNameModifier {:hl (lambda []
                               (when vim.bo.modified
                                 {:fg (theme :diag :warning)
                                  :bold true
                                  :force true}))})

(local FileFlags [{:condition (lambda [] vim.bo.modified)
                   :provider "[+]"
                   :hl {:fg (theme :diag :warning)}}])

(set FileNameBlock (utils.insert FileNameBlock
                                 (utils.insert FileNameModifier FileName)
                                 FileFlags {:provider "%<"}))

(local DAPMessages {:condition (lambda []
                                 (local dap (require :dap))
                                 (local session (dap.session))
                                 (not (= session nil)))
                    :provider (lambda []
                                (local dap (require :dap))
                                (.. " " (dap.status)))
                    :hl :Debug})

(local Statusline [FileNameBlock DAPMessages])

(heirline.setup {:statusline Statusline})
