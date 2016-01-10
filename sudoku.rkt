;; The following line is REQUIRED (do not remove)
(require "a10lib.rkt")


;; Place your Personal Identification here

;; Place your Personal Identification here
;; Xudong Yang 20559394
;; CS 135 Fall 2014
;; Assignment 10 Problem 3
;;*******************************

;; NOTE: Do NOT leave top-level expressions in your code.
;;       In other words, when your code is run, only the
;;       check-expect message "All X tests passed!"
;;       should appear in the interactions window

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; A SudokuDigit is one of:
;; * '?
;; * 1 <= Nat <= 9

;; A Puzzle is a (listof (listof SudokuDigit))
;; requires: the list and all sublists have a length of 9

;; A Solution is a Puzzle
;; requires: none of the SudokuDigits are '?
;;           the puzzle satisfies the number placement 
;;             rules of sudoku

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Here are some sample sudoku puzzles

;; From the basic test shown in the assignment:
(define veryeasy
  '((? 4 5 8 9 3 7 1 6)
    (8 1 3 5 7 6 9 2 4)
    (7 6 9 2 1 4 5 3 8)
    (5 3 6 9 8 7 1 4 2)
    (4 9 2 1 6 5 8 7 3)
    (1 7 8 4 3 2 6 5 9)
    (6 8 4 7 2 1 3 9 5)
    (3 2 1 6 5 9 4 8 7)
    (9 5 7 3 4 8 2 6 1)))

(define veryeasysoln
  '((2 4 5 8 9 3 7 1 6)
    (8 1 3 5 7 6 9 2 4)
    (7 6 9 2 1 4 5 3 8)
    (5 3 6 9 8 7 1 4 2)
    (4 9 2 1 6 5 8 7 3)
    (1 7 8 4 3 2 6 5 9)
    (6 8 4 7 2 1 3 9 5)
    (3 2 1 6 5 9 4 8 7)
    (9 5 7 3 4 8 2 6 1)))

(define veryeasy2
  '((? 4 5 8 9 3 7 1 6)
    (8 1 3 5 7 6 9 2 4)
    (7 6 9 2 1 4 5 3 8)
    (5 3 6 9 8 7 1 4 2)
    (4 9 2 1 6 5 8 7 3)
    (1 7 8 4 3 2 6 5 9)
    (6 8 4 7 2 1 ? ? ?)
    (3 2 1 6 5 9 ? ? ?)
    (9 5 7 3 4 8 ? ? ?)))

(define veryeasy3
  '((2 4 5 8 ? 3 7 1 6)
    (8 1 3 5 ? 6 9 2 4)
    (7 6 9 2 ? 4 5 3 8)
    (5 3 6 9 ? 7 1 4 2)
    (4 9 2 1 ? 5 8 7 3)
    (1 7 8 4 ? 2 6 5 9)
    (6 8 4 7 ? 1 3 9 5)
    (3 2 1 6 ? 9 4 8 7)
    (9 5 7 3 ? 8 2 6 1)))

(define veryeasy4
  '((? 4 ? ? 9 ? ? 1 ?)
    (? ? ? ? ? ? ? ? ?)
    (? ? ? ? ? ? ? ? 8)
    (5 3 6 9 8 7 1 4 2)
    (4 9 2 1 6 5 8 7 3)
    (1 7 8 4 3 2 6 5 9)
    (6 8 4 7 2 1 3 9 5)
    (3 2 1 6 5 9 4 8 7)
    (9 5 7 3 4 8 2 6 1)))


;; the above puzzle with more blanks:
(define easy
  '((? 4 5 8 ? 3 7 1 ?)
    (8 1 ? ? ? ? ? 2 4)
    (7 ? 9 ? ? ? 5 ? 8)
    (? ? ? 9 ? 7 ? ? ?)
    (? ? ? ? 6 ? ? ? ?)
    (? ? ? 4 ? 2 ? ? ?)
    (6 ? 4 ? ? ? 3 ? 5)
    (3 2 ? ? ? ? ? 8 7)
    (? 5 7 3 ? 8 2 6 ?)))

;; the puzzle listed on wikipedia
(define wikipedia '((1 ? ? ? ? ? ? ? ?)
                    (7 ? ? ? ? 8 1 ? 2)
                    (? 6 3 ? 5 ? ? ? ?)
                    (? 7 ? 3 9 ? ? ? ?)
                    (? ? 5 8 ? 4 6 ? ?)
                    (? ? ? ? 2 5 ? 4 ?)
                    (? ? ? ? 1 ? 8 7 ?)
                    (2 ? 8 9 ? ? ? ? 3)
                    (? ? ? ? ? ? ? ? 6)))
(define wikisoln 
  (list (list 5 3 4 6 7 8 9 1 2)
        (list 6 7 2 1 9 5 3 4 8)
        (list 1 9 8 3 4 2 5 6 7)
        (list 8 5 9 7 6 1 4 2 3)
        (list 4 2 6 8 5 3 7 9 1)
        (list 7 1 3 9 2 4 8 5 6)
        (list 9 6 1 5 3 7 2 8 4)
        (list 2 8 7 4 1 9 6 3 5)
        (list 3 4 5 2 8 6 1 7 9)))

;; A blank puzzle template for you to use:
(define blank '((? ? ? ? ? ? ? ? ?)
                (? ? ? ? ? ? ? ? ?)
                (? ? ? ? ? ? ? ? ?)
                (? ? ? ? ? ? ? ? ?)
                (? ? ? ? ? ? ? ? ?)
                (? ? ? ? ? ? ? ? ?)
                (? ? ? ? ? ? ? ? ?)
                (? ? ? ? ? ? ? ? ?)
                (? ? ? ? ? ? ? ? ?)))

(define wrong
  '((2 4 5 8 9 3 7 1 6)
    (8 1 7 ? ? 5 9 2 4)
    (7 ? 9 ? 4 6 5 3 8)
    (5 ? ? 9 ? 7 ? ? 1)
    (9 ? ? 1 6 ? ? ? 2)
    (1 ? ? 4 5 2 ? ? 3)
    (6 9 4 7 ? ? 3 ? 5)
    (3 2 1 2 ? ? ? 8 7)
    (4 5 7 3 1 8 2 6 9)))

(define wronghard '((5 3 ? ? 7 ? ? ? ?)
                    (6 ? ? 1 9 5 ? ? ?)
                    (? 9 8 ? ? ? ? 6 ?)
                    (8 ? ? ? 6 ? ? ? 3)
                    (4 ? ? 8 ? 3 ? ? 1)
                    (7 ? ? ? 2 ? ? ? 6)
                    (3 6 ? ? ? ? 2 8 ?)
                    (? ? ? 4 1 9 ? ? 5)
                    (? ? ? ? 8 ? ? 7 9)))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; HAVE FUN, good luck with your final exams, and have a Merry Christmas!
;; -- with love, the CS 135 team

(define values '(1 2 3 4 5 6 7 8 9))
(define box-width 3)

;; (sudoku puzzle) consumes a puzzle and produces a Solution or false
;; if there is no solution
;; sudoku: Puzzle -> (anyof Solution false)
;; Examples:
(check-expect (sudoku veryeasy) veryeasysoln)
(check-expect (sudoku wrong) false)

(define (sudoku puzzle)
  (local
    (; (solved? puzzle) consumes a puzzle and produces true if the puzzle
     ; is a Solution or false otherwise
     ; solved?: Puzzle -> Bool
     (define (solved? puzzle)
       (empty? (filter (lambda (row)
                         (member? '? row)) puzzle)))
     ; (replace puzzle n) consumes a puzzle and a natural number n and
     ; produces a puzzle with n replacing the first '? in the puzzle
     ; replace: Puzzle Nat -> Puzzle
     ; requires: 1 <= n <= 9
     (define (replace puzzle n)
       (cond
         ((member? '? (first puzzle))
          (cons (trans-row (first puzzle) n) (rest puzzle)))
         (else (cons (first puzzle) (replace (rest puzzle) n)))))
     ; (trans-row row n) consumes a row of a Puzzle and a natural number n
     ; and produces a row with n replacing the first '? in the row
     ; trans-row: (listof SudokuDigit) -> (listof SudokuDigit)
     ; requires: 1 <= n <= 9
     (define (trans-row row n)
       (cond
         ((empty? row) empty)
         ((symbol? (first row)) (cons n (rest row)))
         (else (cons (first row) (trans-row (rest row) n)))))
     ; (neighbours puzzle) consumes a puzzle and produces all legal
     ; puzzles resulting from the first '? being replaced by a number
     ; neighbours: Puzzle -> (listof Puzzle)
     (define (neighbours puzzle)
       (local
         (; (find-blank orig puzzle n) consumes two puzzles (puzzle, orig)
          ; and a number n and produces a list containing a list of two
          ; (list Nat (listof Sudokudigit)) with the Nat representing 
          ; the position of the row and column of the first '? in orig
          ; find-blank: Puzzle Puzzle Nat -> 
          ;             (listof (list Nat (listof SudokuDigit)))
          (define (find-blank orig puzzle n)
            (cond
              ((member? '? (first puzzle)) 
               (list (list n (first puzzle)) 
                     (find-column orig (first puzzle) 1)))
              (else (find-blank orig (rest puzzle) (add1 n)))))
          ; (find-column orig row n) consumes a puzzle orig, a row of
          ; puzzle and a number n and produces the column containing
          ; the first '? in orig
          ; find-column: Puzzle (listof SudokuDigit) Nat ->
          ;              (listof SudokuDigit)
          (define (find-column orig row n)
            (cond 
              ((symbol? (first row)) (list n (map first orig)))
              (else (find-column (map rest orig) (rest row) (add1 n)))))
          ; (find-box puzzle row-column) consumes a puzzle and a
          ; (listof (list Nat (listof SudokuDigit))) (row-column), making
          ; a list of SudokuDigits in the box of the first '? in puzzle
          ; find-box: Puzzle (listof (list Nat (listof SudokuDigit))) ->
          ;           (listof SudokuDigit)
          (define (find-box puzzle row-column)
            (cond
              ((> (first (first row-column)) box-width)
               (find-box (rest (rest (rest puzzle)))
                         (list (list (- (first (first row-column))
                                        box-width)
                                     (second (first row-column)))
                               (second row-column))))
              ((> (first (second row-column)) box-width)
               (find-box (map (lambda (x)
                                (rest (rest (rest x)))) puzzle)
                              (list (first row-column)
                                    (list (- (first (second row-column))
                                             box-width)
                                    (second (second row-column))))))
              (else (list (first (first puzzle))
                          (first (second puzzle))
                          (first (third puzzle))
                          (second (first puzzle))
                          (second (second puzzle))
                          (second (third puzzle))
                          (third (first puzzle))
                          (third (second puzzle))
                          (third (third puzzle))))))
          (define row-column (find-blank puzzle puzzle 1))
          (define possible-values
            (filter (lambda (x)
                      (not (or (member? x (second (first row-column)))
                               (member? x (second (second row-column)))
                               (member? x (find-box puzzle row-column)))))
                    values)))
         (map (lambda (n) (replace puzzle n)) possible-values))))
    (find-final puzzle neighbours solved?)))

;; Tests:
(check-expect (sudoku veryeasy2) veryeasysoln)
(check-expect (sudoku veryeasy3) veryeasysoln)
(check-expect (sudoku veryeasy4) veryeasysoln)
(check-expect (sudoku easy) veryeasysoln)
(check-expect (sudoku wronghard) false)
(sudoku wikipedia)
