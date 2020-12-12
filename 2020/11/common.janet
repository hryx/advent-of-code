(defn parse [input]
    (peg/match '{
        :main (* :s* (any (* :line :s*)))
        :line (group (some :spot))
        :spot (+
            (/ (<- "L") :empty)
            (/ (<- "#") :taken)
            (/ (<- ".") :floor)
        )
    } input)
)

(defn copy-seating [original]
    (def new (array/new (length original)))
    (each row original
        (array/push new (array ;row))
    )
    new
)

(defn count-occupied [seating]
    (reduce (fn [total row]
        (+ total (reduce (fn [total x]
            (+ total (if (= x :taken) 1 0))
        ) 0 row))
    ) 0 seating)
)

(defn count-occupied-adjacent [seating row col]
    (def dirs [
        [ 0  1]
        [-1  1]
        [-1  0]
        [-1 -1]
        [ 0 -1]
        [ 1 -1]
        [ 1  0]
        [ 1  1]
    ])
    (reduce (fn [total [dy dx]]
        (+ total (if (= :taken
            # get-in defaults to nil when an index is out of bounds. Thanks!
            (get-in seating [(+ row dy) (+ col dx)])
        ) 1 0))
    ) 0 dirs)
)

(defn new-state [seating row col]
    (def seat (get-in seating [row col]))
    (or (case seat
        :empty (if (zero? (count-occupied-adjacent seating row col)) :taken)
        :taken (if (>= (count-occupied-adjacent seating row col) 4) :empty)
    ) seat)
)

(defn do-round [seating]
    (def new (copy-seating seating))
    (for y 0 (length seating)
        (for x 0 (length (y seating))
            (put-in new [y x] (new-state seating y x))
        )
    )
    new
)
