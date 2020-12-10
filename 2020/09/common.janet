(def xmas-stream (seq [x
    :iterate (file/read stdin :line)
    :when (not (empty? (string/trim x)))
] (scan-number (string/trim x))))

(defn valid-xmas? [prefix num]
    (if (one? (length prefix)) (break false))
    (def frst (0 prefix))
    (def rest (array/slice prefix 1))
    (def valid (reduce (fn [valid elem]
        (or valid (and (not= frst elem) (= num (+ elem frst))))
    ) false rest))
    (or valid (valid-xmas? rest num))
)

(defn find-invalid-xmas-number [stream]
    (var invalid-num nil)
    (for i 0 (- (length xmas-stream) 26)
        (def prefix (array/slice xmas-stream i (+ i 25)))
        (def num ((+ i 25) xmas-stream))
        (if (not (valid-xmas? prefix num)) (break (set invalid-num num)))
    )
    invalid-num
)
