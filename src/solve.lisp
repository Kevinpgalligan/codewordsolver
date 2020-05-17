(in-package codewordsolver)

(defparameter *alphabet*
  ;; Sorted by word list frequency.
  ;; Most frequent first.
  (list #\e #\i #\a #\o #\n #\s #\r #\t
        #\l #\c #\u #\p #\d #\m #\h #\g
        #\y #\b #\f #\v #\k #\w #\z #\x
        #\q #\j))

(defun solve-codeword (codes clues wordlist)
  "CODES should be a list of codes like ((1 2 3) (3 3 1)), while CLUES should be an alist of number->letter assignments. WORDLIST should be a list of valid words.

Returns an alist of number->letter, the solution, as well as the resulting list of words."
  (let* ((candidates
           (loop for code in codes
                 collect (list code
                               (find-candidates code clues wordlist))))
         (solution-clues (solve-aux candidates clues)))
    (values solution-clues
            (loop for code in codes collect
                  (format nil
                          "~{~a~}"
                          (loop for n in code collect
                                (find-clue solution-clues n)))))))

(defun solve-aux (candidates clues)
  (cond
    ;; There's a code with no possible solution, we've
    ;; hit a dead-end.
    ((some (lambda (candidate)
              (not (second candidate)))
           candidates)
     nil)
    ;; All codes complete, return solution.
    ((not candidates)
     clues)
    ;; Else, try to fill in one of the codes.
    (t
     ;; Try the code with the fewest possible words, it'll
     ;; narrow down the search.
     (let* ((best (alexandria:extremum candidates
                                       #'<
                                       :key (lambda (candidate)
                                              (length (second candidate)))))
            (code (first best))
            (words (second best)))
       ;; Will return nil (false) if none of the words gives
       ;; a solution.
       (loop for word in words do
             (multiple-value-bind (new-candidates new-clues)
                 (propagate code word (remove best candidates) clues)
               (let ((solution (solve-aux new-candidates new-clues)))
                 (when solution
                   (return solution)))))))))

(defun propagate (code word candidates clues)
  ;; Overriding the names of the original candidates/clues here, I'm
  ;; afraid of accidentally using the old ones. But this is also ugly.
  (let* ((clues (add-word-clue clues code word))
         (candidates
           (loop for (code words) in candidates collect
                 (list code
                       (loop for word in words
                             when (matches-code-p code clues word)
                             collect word))))
         (single-word-candidates
           (loop for candidate in candidates
                 when (= 1 (length (second candidate)))
                 collect candidate)))
    (cond
      ;; We've hit a dead-end as a result of propagation, stop
      ;; wasting time and return.
      ((some (lambda (candidate)
               (not (second candidate)))
             candidates)
       (values candidates clues))
      ;; Some codes have only a single remaining word that can
      ;; possibly fit them, so propagation can continue.
      (single-word-candidates
       (let* ((chosen-candidate (car single-word-candidates))
              (next-code (car chosen-candidate))
              (next-word (car (second chosen-candidate))))
         (propagate next-code
                    next-word
                    (remove chosen-candidate candidates)
                    clues)))
      ;; No further propagation possible, return what we have.
      (t
       (values candidates clues)))))

(defun find-candidates (code clues wordlist)
  (loop for word in wordlist
        when (matches-code-p code clues word)
        collect word))

(defun matches-code-p (code clues word)
  (and (= (length code) (length word))
       (let ((new-clues (make-clues)))
         (loop for n in code
               for letter across word
               always (let ((clue (or (find-clue clues n)
                                      (find-clue new-clues n))))
                        (if clue
                            (char= clue letter)
                            (let ((letter-assigned?
                                    (or (find-n clues letter)
                                        (find-n new-clues letter))))
                              (when (not letter-assigned?)
                                (setf new-clues (add-clue new-clues n letter)))
                              (not letter-assigned?))))))))

(defun make-clues ()
  (list))

(defun find-clue (clues n)
  (cdr (assoc n clues)))

(defun find-n (clues letter)
  (car (rassoc letter clues)))

(defun add-clue (clues n letter)
  (push (cons n letter)
        clues))

(defun add-word-clue (clues code word)
  (loop for n in code
        for letter across word
        when (not (find-clue clues n))
        do (setf clues (add-clue clues n letter)))
  clues)

(defun load-words (path)
  (with-open-file (stream path)
    (loop for line = (read-line stream nil)
          while line
          collect (string-trim '(#\Space #\Newline #\Backspace #\Tab 
                                 #\Linefeed #\Page #\Return #\Rubout)
                               line))))
