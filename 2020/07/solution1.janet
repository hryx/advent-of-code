(import ./common)

(def rules (common/parse (file/read stdin :all)))

(def can-contain-gold @{})
(defn check [color ?top]
    (def top (case ?top
        color (errorf "cycle detected: %s" color)
        nil color
        ?top
    ))
    (def known (get can-contain-gold color))
    (if (not (nil? known)) (break known))
    (var this-can false)
    (eachk k (get rules color [])
        (set this-can (or this-can
            (if (= k "shiny gold") true (check k top))
        ))
    )
    (put can-contain-gold color this-can)
    this-can
)
(each k (keys rules) (check k nil))

(print (count true? can-contain-gold))
