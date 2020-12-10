(import ./common)
(def dist (common/distribution (common/get-differences (common/get-adapters
    (file/read stdin :all)
))))
(print (* ;dist))
