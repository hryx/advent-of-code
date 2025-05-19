(def col1 @[])
(def col2 @[])
(each line (file/lines (file/open "input.txt"))
  (def cols (peg/match '(* ':d+ :s+ ':d+) line))
  (array/push col1 (scan-number (0 cols)))
  (array/push col2 (scan-number (1 cols))))
(sort col1)
(sort col2)

(var total 0)
(def t (zipcoll col1 col2))
(eachp [n1 n2] t
  (set total (+ total (math/abs (- n1 n2)))))

(print total)
