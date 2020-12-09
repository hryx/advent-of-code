(def grammar (peg/compile '{
    :main (* :s* (any :rule) :eof)
    :rule (group (* :colored-bag :CONTAIN (group (+ :list-of-bag :NO-MORE-BAGS)) :rule-end))
    :colored-bag (* :color :BAG :s*)
    :list-of-bag (* :count-of-bag (any (* :COMMA :count-of-bag)))
    :count-of-bag (group (* :number :colored-bag))
    :number (* (<- :d+) :s*)
    :color (* (<- (* :a+ :s* :a+)) :s*)
    :rule-end (* "." :s*)
    :BAG (* "bag" (opt "s") :s*)
    :CONTAIN (* "contain" :s*)
    :COMMA (* "," :s*)
    :NO-MORE-BAGS (* "no other bags" :s*)
    :eof (! 1)
}))

(defn parse [str]
    (def ast (assert (peg/match grammar str) "input did not match grammar"))
    (def rules @{})
    (each rule ast
        (def outer (0 rule))
        (def inners (1 rule))
        (put rules outer @{})
        (each inner-kind inners
            (def n (scan-number (0 inner-kind)))
            (def color (1 inner-kind))
            (put-in rules [outer color] n)
        )
    )
    rules
)
