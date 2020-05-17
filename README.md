# What?
A solver for Codeword puzzles.

![example codeword puzzle with 2 letters filled in](https://github.com/Kevinpgalligan/codewordsolver/blob/master/example-codeword.png)

> Codewords are like crossword puzzles - but have no clues! Instead, every letter of the alphabet has been replaced by a number, the same number representing the same letter throughout the puzzle.
> All you have to do is decide which letter is represented by which number!

Coded in Common Lisp. Uses a recursive search algorithm with constraint propagation.

# Setup and usage
Clone this repository in your Quicklisp local-projects folder.

Then, from the REPL:

```common-lisp
CL-USER> (ql:quickload 'codewordsolver)
CL-USER> (in-package codewordsolver)
CODEWORDSOLVER> (solve-codeword '((9 25 16 14 8 1 19)
                                  (10 25 12 19 14 6 23)
                                  (11 8 22 21 21)
                                  (24 21 17 23 1)
                                  (15 26 8 1 25 18 23)
                                  (24 23 25 20 3)
                                  (6 23 4 25 19)
                                  (10 21 6 2 8 11 23)
                                  (24 21 6 6 25 2 21 4 23)
                                  (11 8 6 4 8)
                                  (9 25 16 14 8 1 19)
                                  (5 13 21 15 11)
                                  (6 25 2 11)
                                  (2 25 15 11 13 26)
                                  (8 13 13)
                                  (8 6 4 2)
                                  (2 19 8 6)
                                  (19 3 24 8 15 11)
                                  (15 14 18)
                                  (7 23 6 11)
                                  (23 13 10)
                                  (6 8 9 19)
                                  (21 14 6)
                                  (11 21 24 19 21 24)
                                  (2 4 14 20)
                                  (18 25 17 8)
                                  (21 6 23)
                                  (11 25 4 21 1 21)
                                  (1 25 20 3))
                                (list (cons 14 #\u)
                                      (cons 15 #\c))
                                (load-words "~/proyectos/codewordsolver/words.txt"))
((7 . #\j) (13 . #\l) (5 . #\b) (17 . #\v) (22 . #\z) (11 . #\k) (12 . #\x)
 (10 . #\f) (3 . #\h) (20 . #\g) (4 . #\m) (2 . #\s) (6 . #\r) (21 . #\o)
 (24 . #\w) (19 . #\t) (9 . #\p) (23 . #\e) (25 . #\i) (1 . #\n) (8 . #\a)
 (26 . #\y) (18 . #\d) (14 . #\u) (15 . #\c) (16 . #\q))
("piquant" "fixture" "kazoo" "woven" "cyanide" "weigh" "remit" "forsake"
 "worrisome" "karma" "piquant" "block" "risk" "sickly" "all" "arms" "star"
 "thwack" "cud" "jerk" "elf" "rapt" "our" "kowtow" "smug" "diva" "ore" "kimono"
 "nigh")
```
