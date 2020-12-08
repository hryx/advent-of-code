# Janet bit operations do not play well with its float-only numbers.
# Values above 0x7fffffff cause bitwise operations to produce the wrong value.
# Furthermore, Janet's core/u64 type does not work with arithemtic and bitwise functions.
# Because attempts to reimplement bit shift operations got messy, I abandoned this
# implementation and used a C module instead. This is just here as a record.

# (defn brshift32 [x bits] (math/floor (/ x (math/pow 2 bits))))
# (defn blshift32 [x bits] (math/floor (* x (math/pow 2 bits))))

# (defn bop32 [op & xs]
#     (defn byte [x n] (% (brshift32 x (* n 8)) 0x100))
#     (var val 0)
#     (for i 0 4
#         (def b (op ;(reduce (fn [_ x] (byte x i)) xs)))
#         (+= val (blshift32 b (* i 8)))
#     )
#     val
# )

(defn push-number [buf x n]
    "Push number x with size n bytes into buffer buf"
    # Struggling to get Janet to call push-word when highest bit is set:
    # (buffer/push-word buf (band x 0xffffffff))
    # (buffer/push-word buf (band (brshift x 32) 0xffffffff))
    # So, alternative:
    (var v x)
    (for i 0 n
        (buffer/push-byte buf (band v 0xff))
        (set v (brshift v 8))
    )
)

(defn add32 [& xs]
    (reduce (fn [x y] (% (+ x y) 0xffffffff)) 0 xs)
)

(defn blrot [x c]
    (def c- (% c 32))
    (bor (blshift x c-) (brushift x (- 32 c-)))
)

(defn buf-to-number [buf]
    (reduce (fn [n b] (+ (blshift n 8) (band b 0xff))) 0 buf)
)

(def s [
    7 12 17 22 7 12 17 22 7 12 17 22 7 12 17 22
    5  9 14 20 5  9 14 20 5  9 14 20 5  9 14 20
    4 11 16 23 4 11 16 23 4 11 16 23 4 11 16 23
    6 10 15 21 6 10 15 21 6 10 15 21 6 10 15 21
])

# We could use a precalculated table for K:
#   0xd76aa478 0xe8c7b756 0x242070db 0xc1bdceee
#   0xf57c0faf 0x4787c62a 0xa8304613 0xfd469501
#   ...
# But unfortunately, Janet interprets hex literals as positive floats, which gives
# the numbers incorrect bit patterns. Instead, generate the values on demand.
(defn K [i] (math/floor (* 0x100000000 (math/abs (math/sin (+ 1 i))))))

# Implementation of MD5 based on pseudocode in on Wikipedia:
# https://en.wikipedia.org/wiki/MD5#Pseudocode
(defn md5 [msg]
    "Returns MD5 digest, as a byte string, of input string"

    (var a0 0x67452301)
    (var b0 0xefcdab89)
    (var c0 0x98badcfe)
    (var d0 0x10325476)

    (def msg-len (length msg))
    (def buf (buffer/new (+ 512 msg-len))) # TODO don't copy input
    (buffer/push-string buf msg)
    (buffer/push-byte buf 0x80) # push bit '1' to msg
    (while (not= 56 (% (length buf) 64)) # pad until length (bits) is a multiple of 512 - 64
        (buffer/push-byte buf 0x00)
    )
    (push-number buf msg-len 8) # fill remaining 64 bits with original msg length

    (var off 0)
    (while (< off (length buf))
        (def chunk (buffer/slice buf off (+ off 64)))
        (var A a0)
        (var B b0)
        (var C c0)
        (var D d0)
        (for i 0 64
            (def [F g] (cond
                (< 16 i) [
                    (bor (band B C) (band D (bnot B)))
                    i
                ]
                (< 32 i) [
                    (bor (band B D) (band C (bnot D)))
                    (% (+ (* i 5) 1) 16)
                ]
                (< 48 i) [
                    (bxor B C D)
                    (% (+ (* i 3) 5) 16)
                ]
                [
                    (bxor C (bor B (bnot D)))
                    (% (* i 7) 16)
                ]
            ))
            (def F- (add32 F A (K i) (buf-to-number (buffer/slice chunk g 4))))
            (set A D)
            (set D C)
            (set C B)
            (set B (add32 B (blrot F- (get s i))))
        )
        (set a0 (add32 a0 A))
        (set b0 (add32 b0 B))
        (set c0 (add32 c0 C))
        (set d0 (add32 d0 D))
        (+= off 64)
    )

    (def digest (buffer/new 16))
    (push-number digest a0 4)
    (push-number digest b0 4)
    (push-number digest c0 4)
    (push-number digest d0 4)

    digest
)

(defn hex-encode [buf]
    (string (reduce (fn [buf byte]
        (buffer/push-string buf (string/format "%x" byte))
    ) (buffer/new (* 2 (length buf))) buf))
)

(print (hex-encode (md5 (file/read stdin :all))))
