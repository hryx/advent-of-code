(def numbers @[])
(defn try-line []
    (def line (file/read stdin :line))
    (if (nil? line) (break nil)) # EOF
    (def val (scan-number (string/trim line)))
    (if (not (number? val)) (break (try-line))) # recur
    (var result nil) # use mutable var because loop/while always return nil
    (loop [n :in numbers :until (tuple? result)]
        (if (= 2020 (+ n val)) (set result [n val]))
    )
    (if (tuple? result) (break result))
    (array/push numbers val)
    (try-line)
)
(def result (try-line))
(print (and result (product result)))
