(import build/md5 :prefix "")
(import common :prefix "")
(print "going...")
(each [input expected] [
    [""                                             "d41d8cd98f00b204e9800998ecf8427e"]
    ["The quick brown fox jumps over the lazy dog"  "9e107d9d372bb6826bd81d3542a419d6"]
    ["The quick brown fox jumps over the lazy dog." "e4d909c290d0fb1ca068ffaddf22cbd0"]
]
    (def res-raw (md5 input))
    (def res (hex-encode res-raw))
    (if (not= expected res) (errorf "expected %s, got %s" expected res))
)
