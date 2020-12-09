(import ./common)
(defn toggle-op [prog i]
    (case (get (i prog) 0)
        "nop" (put-in prog [i 0] "jmp")
        "jmp" (put-in prog [i 0] "nop")
        false
    )
)
(def prog (common/parse (file/read stdin :all)))
(for i 0 (length prog)
    (if (toggle-op prog i) (do
        (def res (common/run-program prog))
        (if (get res :terminated)
            (break (print (get res :acc) " (toggled #" i ")"))
        )
        (toggle-op prog i)
    ))
)
