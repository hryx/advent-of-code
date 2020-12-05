(var highest 0)
(each line (string/split "\n" (file/read stdin :all))
    (def value (reduce (fn [bits c]
        (bor (blshift bits 1) (case (keyword (string/from-bytes c))
            :F 0
            :B 1
            :L 0
            :R 1
        ))
    ) 0x00 line))
    (set highest (max highest value))
)
(print highest)
