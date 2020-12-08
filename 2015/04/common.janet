(def chars "0123456789abcdef")
(defn hex-encode [msg]
    (def out (buffer/new (* 2 (length msg))))
    (var i 0)
    (each char msg
        (put out i (get chars (brshift char 4)))
        (put out (+ i 1) (get chars (band char 0x0f)))
        (+= i 2)
    )
    (string out)
)
