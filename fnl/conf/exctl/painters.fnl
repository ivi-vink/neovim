(local vec (require :conf.exctl.frames.vec))
(local exctl-frame (require :conf.exctl.frames.frame))
(local m {})

;; Creates a new painter that wraps the paint and close methods of a painter
(fn m.transform-painter [painter ori width height]
  (painter:transform (fn [self frame]
                       (local coord (exctl-frame.frame->coord frame))
                       (local new-ori (coord ori))
                       (P :new-ori new-ori)
                       (local new-frame
                              (exctl-frame new-ori
                                           (vec.sub (coord width) new-ori)
                                           (vec.sub (coord height) new-ori)))
                       (P new-frame)
                       (painter.paint self new-frame))
                     painter.close))

(fn m.pad [painter pad-size]
  (painter:transform (fn [self frame]
                       (local pad-width (/ pad-size (exctl-frame.width frame)))
                       (local pad-height
                              (/ pad-size (exctl-frame.height frame)))
                       (P :width pad-width)
                       (P :height pad-height)
                       (local transformed
                              (m.transform-painter painter
                                                   (vec.vec pad-width
                                                            pad-height)
                                                   (vec.vec (- 1 pad-width)
                                                            pad-height)
                                                   (vec.vec pad-width
                                                            (- 1 pad-height))))
                       (transformed.paint self frame))))

(fn m.beside [p1 p2]
  {:paint (fn [self frame]
            (local new-p1
                   (m.transform-painter p1 (vec.vec 0 0) (vec.vec 0.5 0)
                                        (vec.vec 0 1)))
            (local new-p2
                   (m.transform-painter p2 (vec.vec 0.5 0) (vec.vec 1 0)
                                        (vec.vec 0.5 1)))
            (new-p1:paint frame)
            (new-p2:paint frame))
   :close (fn []
            (p1:close)
            (p2:close))})

m
