(local heirline (require :heirline))
(local colors (let [kanagawa-colors (require :kanagawa.colors)] (kanagawa-colors.setup)))

(heirline.load_colors colors)
