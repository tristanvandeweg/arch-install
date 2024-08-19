;;; minesweeper-autoloads.el --- automatically extracted autoloads (do not edit)   -*- lexical-binding: t -*-
;; Generated by the `loaddefs-generate' function.

;; This file is part of GNU Emacs.

;;; Code:

(add-to-list 'load-path (or (and load-file-name (directory-file-name (file-name-directory load-file-name))) (car load-path)))



;;; Generated autoloads from minesweeper.el

(autoload 'minesweeper "minesweeper" "\
Major mode for playing Minesweeper in Emacs.

There's a field of squares; each square may hold a mine.
Your goal is to uncover all the squares that don't have mines.
If a revealed square doesn't have a mine, you'll see how many mines
are in the eight neighboring squares.
You may mark squares, which protects them from accidentally being revealed.

\\{minesweeper-mode-map}" t)
(register-definition-prefixes "minesweeper" '("*minesweeper-" "minesweeper-"))

;;; End of scraped data

(provide 'minesweeper-autoloads)

;; Local Variables:
;; version-control: never
;; no-byte-compile: t
;; no-update-autoloads: t
;; no-native-compile: t
;; coding: utf-8-emacs-unix
;; End:

;;; minesweeper-autoloads.el ends here