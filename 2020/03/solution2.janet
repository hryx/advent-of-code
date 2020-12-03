(def tree (get "#" 0))
(def ski-map (string/split "\n" (file/read stdin :all)))
(def height (length ski-map))
(def width (length (get ski-map 0)))

(defn count-trees [dx dy]
    (var tree-count 0)
    (var x 0)
    (var y 0)
    (while true
        (+= x dx)
        (%= x width)
        (+= y dy)
        (if (>= y height) (break))
        (def char (or (get (get ski-map y) x) (break)))
        (if (= char tree) (++ tree-count))
    )
    tree-count
)

(def cases [
    {:dx 1 :dy 1}
    {:dx 3 :dy 1}
    {:dx 5 :dy 1}
    {:dx 7 :dy 1}
    {:dx 1 :dy 2}
])

(print (reduce
    (fn [a b]
        (* a (count-trees (get b :dx) (get b :dy)))
    ) 1 cases
))
