(def validators (let [
    between (fn [x lo hi] (and x (>= x lo) (<= x hi)))
] {
    :byr (fn [x] (between (scan-number x) 1920 2002))
    :iyr (fn [x] (between (scan-number x) 2010 2020))
    :eyr (fn [x] (between (scan-number x) 2020 2030))
    :hgt (fn [x] (do
        (def [n units] (or (peg/match '{
            :main (* (<- :n) (<- :units) :end)
            :n :d+
            :units :a+
            :end (! 1)
        } x) (break)))
        (case units
            "cm" (between (scan-number n) 150 193)
            "in" (between (scan-number n) 59 76)
            false
        )
    ))
    :hcl (fn [x] (peg/match '(* "#" (6 :h) (! 1)) x))
    :ecl (fn [x] (index-of (keyword x) [:amb :blu :brn :gry :grn :hzl :oth]))
    :pid (fn [x] (peg/match '(* (9 :d) (! 1)) x))
}))

(var valid-count 0)
(def passports (string/split "\n\n" (file/read stdin :all)))
(each passport passports
    (def found-fields @{})
    (each str (string/split " " (string/replace-all "\n" " " passport))
        (def [k v] (string/split ":" (string/trim str)))
        (put found-fields k v)
    )
    (if
        (reduce (fn [is-valid k]
            (def value (get found-fields (string k)))
            (and is-valid value ((get validators k) value))
        ) true (keys validators))
        (++ valid-count)
    )
)

(print valid-count)
