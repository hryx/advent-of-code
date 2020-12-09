(import ./common)

# rules = {outer1 = {inner1 = 2, inner2 = 1, ...}, outer2 = ...}
(defn count-inside [rules color]
    (reduce (fn [total [sub n]]
        (+ total n (* n (count-inside rules sub)))
    ) 0 (pairs (get rules color)))
)

(print (count-inside (common/parse (file/read stdin :all)) "shiny gold"))
