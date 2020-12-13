(defn get-directions [input] (peg/match ~(
    any (group (* (<- :a) (/ (<- :d+) ,scan-number) :s*))
) input))

(def dirs (get-directions (file/read stdin :all)))

(var [x y] [0 0])
(var rot 0)
(each [instr val] dirs
    (case instr
        "N" (-= y val)
        "S" (+= y val)
        "W" (-= x val)
        "E" (+= x val)
        "L" (-= rot val)
        "R" (+= rot val)
        "F" (case rot
            0   (+= x val)
            90  (+= y val)
            180 (-= x val)
            270 (-= y val)
            (errorf "weird angle %d" rot)
        )
        (errorf "unexpected instruction %s" instr)
    )
    (+= rot 360)
    (%= rot 360)
    (print (string/format "%d,%d\t%d" x y rot))
)

(print (+ (math/abs x) (math/abs y)))
