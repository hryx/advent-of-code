(import ./common)
(def res (common/run-program (common/parse (file/read stdin :all))))
(assert (not (get res :terminated)) "I was promised an infinite loop")
(print (get res :acc))
