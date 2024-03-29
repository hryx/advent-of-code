(import ./common :as t)
(setdyn :neighbor-tolerance 5)
(setdyn :check-neighbor-strategy t/line-of-sight-occupied?)
(var seating (t/parse (file/read stdin :all)))
(var previous nil)
(while (deep-not= previous seating)
    (prin "doing a round... ")
    (set previous seating)
    (set seating (t/do-round seating))
    (print (t/count-occupied seating))
)
