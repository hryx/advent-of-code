(var total 0)
(each group (string/split "\n\n" (file/read stdin :all))
    (def affirmatives @{})
    (each char group # we only need unique answers per group, not per person
        (def question-id (string/from-bytes char))
        (if (peg/match '(range "az")  question-id) # skip newline, invalid chars
            (put affirmatives question-id true)
        )
    )
    (+= total (count truthy? affirmatives))
)
(print total)
