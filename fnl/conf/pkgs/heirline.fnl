(local heirline (require :heirline))
(local colors (let [kanagawa-colors (require :kanagawa.colors)] (kanagawa-colors.setup)))
(print (vim.inspect heirline))
(print (vim.inspect colors))

(heirline.load_colors colors)
