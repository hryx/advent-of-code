(def taken @[])
(loop
    [line
        :in (string/split "\n" (file/read stdin :all))
        :when (not (empty? (string/trim line)))
    ]
    (def seat-number (reduce (fn [bits c]
        (bor (blshift bits 1) (case (keyword (string/from-bytes c))
            :F 0
            :B 1
            :L 0
            :R 1
        ))
    ) 0x00 line))
    (put taken seat-number true)
)
(def first-seat (find-index truthy? taken)) # our seat must be after the first taken seat
(def offset (find-index not (array/slice taken first-seat)))
(print (+ first-seat offset))
