(var total 0)
(var left @[])
(var right @{})
(each line (file/lines (file/open "input.txt"))
  (def cols (peg/match '(* ':d+ :s+ ':d+) line))
  (array/push left (scan-number (0 cols)))
  (def rv (scan-number (1 cols)))
  (put right rv (+ 1 (get right rv 0))))
(each num left
  (+= total (* num (get right num 0))))
(print total)
