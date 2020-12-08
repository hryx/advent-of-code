(import build/md5 :prefix "")
(import ./common :prefix "")
(def input "yzbqklnj")
(var i 0)
(defn clz [h]
    (var i 0) # Index and half count of zeros found
    (while (< i (length h))
        (def byte (i h))
        (if (= 0x00 byte)
            (++ i)
            (do
                (if (< 0x80 byte) (+= i 0.5))
                (break)
            )
        )
    )
    (* i 2)
)
(forever
    (def val (string/format "%s%d" input i))
    (def h (md5 val))
    (def z (clz h))
    (if (>= z 4) (do
        (print (string/format "%d zeros: %s (%d)" z (hex-encode h) i))
        (if (>= z 6) (break))
    ))
    (++ i)
)
