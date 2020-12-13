(import ../common :prefix "")

(defn check [expected actual input]
    (if (not (deep= expected actual))
        (errorf "input failed: %s\n* expected: %q\n* actual:   %q" input expected actual)
    )
)

(each t [
    "L.# .#L #L."
    "LLL L.L\n##L"
    "..... .. ."
    "########"
    " "
]
    (def res (assert (parse t)))
    (def res2 (copy-seating res))
    (assert (deep= res res2) t)
)

(each [t [y x] [dy dx] expected1 expected2] [
    ["LLL LLL LLL" [0 0] [1 1] false false]
    ["LLL L#L LLL" [0 0] [1 1] true true]
    ["LLL LLL LL#" [0 0] [1 1] false false]
    ["LLL L.L LL#" [0 0] [1 1] false true]
    ["LLL L.L LL." [0 0] [1 1] false false]
]
    (def seating (assert (parse t)))
    (check expected1 (truthy? (neighbor-occupied? seating [y x] [dy dx])) t)
    (check expected2 (truthy? (line-of-sight-occupied? seating [y x] [dy dx])) t)
)

(each [t [y x] adj total] [
    ["LLL LLL" [0 0] 0 0]
    ["LLL #LL" [0 0] 1 1]
    ["LLL ###" [0 0] 2 3]
    ["LLL ..." [0 0] 0 0]
    ["LLL LLL LLL" [1 1] 0 0]
    ["LLL L#L LLL" [1 1] 0 1]
    ["### ### ###" [0 0] 3 9]
    ["### ### ###" [1 1] 8 9]
    ["#L# .#. #L#" [1 1] 4 5]
    ["### ### ###" [2 2] 3 9]
    ["### #.# ###" [1 1] 8 8]
    ["#L# ### ###" [1 1] 7 8]
]
    (def seating (assert (parse t)))
    (check adj (count-occupied-adjacent neighbor-occupied? seating y x) t)
    (check total (count-occupied seating) t)
)

# (setdyn :neighbor-tolerance 4)

(each [t [y x] expected] [
    ["LLL LLL LLL" [1 1] :taken]
    ["LLL LL. LLL" [1 1] :taken]
    ["... .L. ..." [1 1] :taken]
    ["LLL #L. LLL" [1 1] :empty]
    ["LL# LLL LLL" [1 1] :empty]
    ["LLL L.L LLL" [1 1] :floor]
    ["LL# LL# ###" [0 0] :taken]
    ["### ### ###" [0 0] :taken]
    ["### ### ###" [1 1] :empty]
    ["### #L# ###" [1 1] :empty]
    ["#L# #L# #L#" [1 1] :empty]
]
    (def seating (assert (parse t)))
    (check expected (new-state seating y x) t)
)

(each [a b] [
    ["LLL LLL LLL" "### ### ###"]
    ["... .L. ..." "... .#. ..."]
    ["... .LL ..." "... .## ..."]
    ["... .L# ..." "... .L# ..."]
    [".#. #L# .#." ".#. #L# .#."]
    [".#. ### .#." ".#. #L# .#."]
    ["### ### ###" "#L# LLL #L#"]
]
    (def before (assert (parse a)))
    (def after (assert (parse b)))
    (check after (do-round before) a)
)

(with-dyns [
    :neighbor-tolerance 5
    :check-neighbor-strategy line-of-sight-occupied?
]
    (def t `
    L.LL.LL.LL
    LLLLLLL.LL
    L.L.L..L..
    LLLL.LL.LL
    L.LL.LL.LL
    L.LLLLL.LL
    ..L.L.....
    LLLLLLLLLL
    L.LLLLLL.L
    L.LLLLL.LL
    `)
    (var seating (assert (parse t)))
    (var rounds 0)
    (each after [
        `
        #.##.##.##
        #######.##
        #.#.#..#..
        ####.##.##
        #.##.##.##
        #.#####.##
        ..#.#.....
        ##########
        #.######.#
        #.#####.##
        `
        `
        #.LL.LL.L#
        #LLLLLL.LL
        L.L.L..L..
        LLLL.LL.LL
        L.LL.LL.LL
        L.LLLLL.LL
        ..L.L.....
        LLLLLLLLL#
        #.LLLLLL.L
        #.LLLLL.L#
        `
        `
        #.L#.##.L#
        #L#####.LL
        L.#.#..#..
        ##L#.##.##
        #.##.#L.##
        #.#####.#L
        ..#.#.....
        LLL####LL#
        #.L#####.L
        #.L####.L#
        `
        `
        #.L#.L#.L#
        #LLLLLL.LL
        L.L.L..#..
        ##LL.LL.L#
        L.LL.LL.L#
        #.LLLLL.LL
        ..L.L.....
        LLLLLLLLL#
        #.LLLLL#.L
        #.L#LL#.L#
        `
        `
        #.L#.L#.L#
        #LLLLLL.LL
        L.L.L..#..
        ##L#.#L.L#
        L.L#.#L.L#
        #.L####.LL
        ..#.#.....
        LLL###LLL#
        #.LLLLL#.L
        #.L#LL#.L#
        `
        `
        #.L#.L#.L#
        #LLLLLL.LL
        L.L.L..#..
        ##L#.#L.L#
        L.L#.LL.L#
        #.LLLL#.LL
        ..#.L.....
        LLL###LLL#
        #.LLLLL#.L
        #.L#LL#.L#
        `
        `
        #.L#.L#.L#
        #LLLLLL.LL
        L.L.L..#..
        ##L#.#L.L#
        L.L#.LL.L#
        #.LLLL#.LL
        ..#.L.....
        LLL###LLL#
        #.LLLLL#.L
        #.L#LL#.L#
        `
    ]
        (++ rounds)
        (set seating (do-round seating))
        (check (assert (parse after)) seating (string rounds))
    )
)
