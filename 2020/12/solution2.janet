(defn get-directions [input] (peg/match ~(
    any (group (* (<- :a) (/ (<- :d+) ,scan-number) :s*))
) input))

(def dirs (get-directions (file/read stdin :all)))

(var [x y] [0 0])
(var [wx wy] [10 -1])
(defn rotate90 [wx wy] [(- wy) wx])
(defn rotateN [wx wy n]
    (reduce (fn [[wx wy] _] (rotate90 wx wy)) [wx wy] (range (/ n 90)))
)
(defn normalize-rot [rot] (% (+ 360 rot) 360))
(defn rotate-waypoint [rot]
    (def [wx2 wy2] (rotateN wx wy (normalize-rot rot)))
    (set wx wx2)
    (set wy wy2)
)
(each [instr val] dirs
    (case instr
        "N" (-= wy val)
        "S" (+= wy val)
        "W" (-= wx val)
        "E" (+= wx val)
        "L" (rotate-waypoint (- val))
        "R" (rotate-waypoint val)
        "F" (for i 0 val (+= x wx) (+= y wy))
        (errorf "unexpected instruction %s" instr)
    )
    (print (string/format "ship: %d,%d\twaypoint: %d,%d" x y wx wy))
)

(print (+ (math/abs x) (math/abs y)))
