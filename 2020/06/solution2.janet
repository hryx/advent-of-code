# For fun, a different approach from part 1.
# Convert input into 'chunks', a [[string]].
# Then convert 'chunks' into 'groups', a [[response]].
# A 'response' is an array of 26 bools, one for each question labeled a-z.
# Use 'map' to get the "unanimous" response from everyone in a group.
# Finally, sum the counts of unanimous positive reponses from each group.

(defn new-response [] (array/new-filled 26 false))
(defn index-for-letter [letter] (- letter 97))
(defn and-lists [& lists] (map (fn [& list] (all true? list)) ;lists))

(defn add-paragraph-to-chunks [chunks paragraph] (array/push chunks (string/split "\n" paragraph)))
(defn chunks-from-paragraphs [paragraphs] (reduce add-paragraph-to-chunks @[] paragraphs))
(defn chunks-from-input [input] (chunks-from-paragraphs (string/split "\n\n" (string/trim input))))

(defn add-letter-to-response [response letter] (put response (index-for-letter letter) true))
(defn response-from-line [line] (reduce add-letter-to-response (new-response) (string/trim line)))
(defn add-line-to-group [group line] (array/push group (response-from-line line)))
(defn group-from-chunk [chunk] (reduce add-line-to-group @[] chunk))
(defn add-chunk-to-groups [groups chunk] (array/push groups (group-from-chunk chunk)))
(defn groups-from-chunks [chunks] (reduce add-chunk-to-groups @[] chunks))

(defn unanimous-response-from-group [group] (reduce2 and-lists group))
(defn tally-unanimous-responses-from-groups [groups] (reduce (fn [total group]
    (+ total (count true? (unanimous-response-from-group group)))
) 0 groups))

(defn get-answer [input]
    (tally-unanimous-responses-from-groups (groups-from-chunks (chunks-from-input input)))
)

(print (get-answer (file/read stdin :all)))
