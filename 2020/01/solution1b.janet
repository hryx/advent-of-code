(def numbers @[])
(loop [line :in (string/split "\n" (file/read stdin :all))]
    (def x (scan-number line))
    (if x (array/push numbers x))
)
(def len (length numbers))
(var i 0)
(while (< i len)
    (var j (+ i 1))
    (while (< j len)
        (def a (get numbers i))
        (def b (get numbers j))
        (if (= 2020 (+ a b)) (do
            (print (* a b))
            (quit)
        ))
        (++ j)
    )
    (++ i)
)
