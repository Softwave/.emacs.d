;; UI customizations

;(menu-bar-mode 1)
(global-linum-mode)


;; Colour line numbers
(add-hook 'prog-mode-hook 'highlight-numbers-mode)
;; Highlight operators
(add-hook 'prog-mode-hook 'highlight-operators-mode)
(add-hook 'prog-mode-hook 'highlight-parentheses-mode)

;; Some modes I like 
(cua-mode t)
(electric-pair-mode 1)

;(tool-bar-mode -1)

;; Set font
;set-frame-font "Cozette" nil t)
(set-frame-font "-*-vga-normal-*-normal-*-*-*-*-*-*-*-*-*" nil t)
;(set-frame-font "-ibm-vga-normal-r-normal--16-120-96-96-c-80-iso10646-1" nil t)

;; Font size
;(set-face-attribute 'default nil :height 140)

;; Don't show scrollbars
(when (fboundp 'scroll-bar-mode)
  (scroll-bar-mode -1))

(setq ;; makes killing/yanking interact with the clipboard
      x-select-enable-clipboard t

      ;; I'm actually not sure what this does but it's recommended?
      x-select-enable-primary t

      ;; Save clipboard strings into kill ring before replacing them.
      ;; When one selects something in another program to paste it into Emacs,
      ;; but kills something in Emacs before actually pasting it,
      ;; this selection is gone unless this variable is non-nil
      save-interprogram-paste-before-kill t

      ;; Shows all options when running apropos. For more info,
      ;; https://www.gnu.org/software/emacs/manual/html_node/emacs/Apropos.html
      apropos-do-all t

      ;; Mouse yank commands yank at point instead of at click.
      mouse-yank-at-point t)

;; full path in title bar
(setq-default frame-title-format "%b (%f)")

;; no bell
(setq ring-bell-function 'ignore)
