(local heirline (require :heirline))
(local conditions (require :heirline.conditions))
(local utils (require :heirline.utils))
(local colors (let [kanagawa-colors (require :kanagawa.colors)]
                (kanagawa-colors.setup)))

(local Align {:provider "%="})
(local Space {:provider " "})

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

(local Ruler {;; %l = current line number
              ;; %L = number of lines in the buffer
              ;; %c = column number
              ;; %P = percentage through file of displayed window
              :provider "%7(%l/%3L%):%2c %P"})

(local ScrollBar
       {:static {:sbar ["▁" "▂" "▃" "▄" "▅" "▆" "▇" "█"]}
        ;; Another variant, because the more choice the better.
        ;; sbar { '🭶', '🭷', '🭸', '🭹', '🭺', '🭻'}}
        :provider (lambda [self]
                    (local curr_line (. (vim.api.nvim_win_get_cursor 0) 1))
                    (local lines (vim.api.nvim_buf_line_count 0))
                    (local i (+ (math.floor (* (/ (- curr_line 1) lines)
                                               (length (. self :sbar))))
                                1))
                    (string.rep (. self :sbar i) 2))
        :hl {:fg (theme :syn :fun) :bg (theme :ui :bg)}})

(local StatusLine [FileNameBlock
                   Space
                   DAPMessages
                   Align
                   Ruler
                   Space
                   ScrollBar
                   Space])

(local harpoon-mark (require :harpoon.mark))
(local Tabpage
       {:provider (lambda [self]
                    (fn fnamemod [name mod]
                      (vim.fn.fnamemodify name mod))

                    (fn format-name [name]
                      (if (= name "") "[No Name]"
                          (fnamemod name ":.:t")))

                    (local harpoon_marks
                           (accumulate
                             (icollect [_ win (ipairs (vim.api.nvim_tabpage_list_wins self.tabpage))]
                                (vim.api.nvim_win_get_buf win))))
                    (print (vim.inspect harpoon_marks))
                    (.. "%" self.tabnr "T " self.tabnr " " " %T"))
        :hl (lambda [self]
              (if (not (. self :is_active)) :TabLine :TabLineSel))})

(local TabpageClose {:provider "%999X  %X" :hl :TabLine})

(local TabPages
       {;; only show this component if there's 2 or more tabpages
        :condition (lambda []
                     (>= (length (vim.api.nvim_list_tabpages)) 2))})

(local TabPages
       (utils.insert TabPages {:provider "%="} (utils.make_tablist Tabpage)
                     TabpageClose))

(heirline.setup {:statusline StatusLine :tabline [TabPages]})
