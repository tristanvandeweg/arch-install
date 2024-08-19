;; generated config 
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(custom-enabled-themes '(solarized-dark-high-contrast))
 '(custom-safe-themes
   '("7f1d414afda803f3244c6fb4c2c64bea44dac040ed3731ec9d75275b9e831fe5" "524fa911b70d6b94d71585c9f0c5966fe85fb3a9ddd635362bfabd1a7981a307" "fee7287586b17efbfda432f05539b58e86e059e78006ce9237b8732fde991b4c" default))
 '(dired-listing-switches "-al")
 '(package-selected-packages
   '(dad-joke spotify auto-complete rainbow-delimiters speed-type highlight-indentation clippy minesweeper fireplace nyan-mode enlight magit ef-themes)))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )

;; extra package sources
(require 'package)
(add-to-list 'package-archives '("melpa" . "https://melpa.org/packages/") t)
;; Comment/uncomment this line to enable MELPA Stable if desired.  See `package-archive-priorities`
;; and `package-pinned-packages`. Most users will not need or want to do this.
;;(add-to-list 'package-archives '("melpa-stable" . "https://stable.melpa.org/packages/") t)
(package-initialize)

;; custom startup

;; hide top bars
(tool-bar-mode -1)
(menu-bar-mode -1)
(scroll-bar-mode -1)
;; start maximized
(add-to-list 'default-frame-alist '(fullscreen . maximized))
;; default minor modes
(add-hook 'find-file-hook 'hl-line-mode)
(add-hook 'find-file-hook 'display-line-numbers-mode)
(line-number-mode -1)
(global-set-key (kbd "TAB") 'self-insert-command)
(setq-default tab-width 4)
(electric-pair-mode)
(add-hook 'find-file-hook 'auto-complete-mode)
(add-hook 'find-file-hook 'rainbow-delimiters-mode)
;; custom startup menu
(use-package enlight
  :custom
	(enlight-content
	(concat
		(propertize "GNU EMACS" 'face 'highlight)
		"\n"
		(enlight-menu
			'(("Start"
			   ("Calendar" calendar "c")
			   ("IRC" erc-tls "i"))
			("Locations"
				("Documents" (dired "~/Documents") "d")
				("Downloads" (dired "~/Downloads") "a"))
			("Other"
				("Projects" project-switch-project "p")
				("Edit config" (find-file "~/.emacs") "e")
				("Emacs directory" (dired "~/.emacs.d/") "r")
))))))
(setopt initial-buffer-choice #'enlight)

(load "~/.emacs.d/elpa/sdz80-mode/z80opcodes.el")
(load "~/.emacs.d/elpa/sdz80-mode/sdz80-mode.el")
