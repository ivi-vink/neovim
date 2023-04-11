(tset package.loaded :conf.exctl.frames.frame nil)
(local vec (require :conf.exctl.frames.vec))
(local frame (require :conf.exctl.frames.frame))
(local m {})

;; Creates a new painter that wraps the paint and close methods of a painter
(local transform-painter (fn [painter ori width height]
                           (fn [frm]
                             (local coord (frame.frame->coord frm))
                             (local new-ori (coord ori))
                             (local new-frame
                                    (frame new-ori
                                           (vec.sub (coord width) new-ori)
                                           (vec.sub (coord height) new-ori)))
                             (painter new-frame))))

(local pad (fn [painter pad-size]
             (fn [frm]
               (local pad-width (/ pad-size (frame.width frm)))
               (local pad-height (/ pad-size (frame.height frm)))
               (local transformed
                      (transform-painter painter (vec.vec pad-width pad-height)
                                         (vec.vec (- 1 pad-width) pad-height)
                                         (vec.vec pad-width (- 1 pad-height))))
               (transformed frm))))

(local builder {})
;;
(fn builder.For [self partial-painter ...]
  (table.insert self.partial-painters partial-painter)
  self)

(fn builder.Padding [self size]
  (table.insert self.partial-painters {:op :pad : size})
  self)

(fn builder.Beside [self partial-builder]
  (table.insert self.partial-painters {:op :beside : partial-builder})
  self)

(fn builder.build-painter [self effects]
  (accumulate [painter (fn [frame] (print :leaf-painter)) _ partial-painter (ipairs self.partial-painters)]
    (do
      (match partial-painter
        {:op :pad : size} (do
                            (pad painter size))
        {:op :beside : partial-builder} (do
                                          (P (partial-builder:build-painter effects))
                                          painter)
        {: maps : buffer} (do
                            (local window (effects:new-window maps))
                            (local painter-ptr painter)
                            (fn [frm]
                              (local frame-opts
                                     (frame.frame->open-win-options frm))
                              (local buf (buffer))
                              (if (not (window:open?))
                                  (window:open buf frame-opts)
                                  (window:repaint buf frame-opts))
                              (painter-ptr frm)))
        _ painter))))

(fn builder.Build [self effects]
  ;; TODO(mike): probably nice to model effects as pub sub pattern to make it rely less on references to mutable tables.
  (local painter (self:build-painter effects))
  (fn [frm]
    (effects:attach)
    (painter frm)))

(fn builder.new [self]
  (local bldr {:partial-painters []})
  (setmetatable bldr self)
  (set self.__index self)
  bldr)

builder
