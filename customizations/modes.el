;; Setting up various modes

;; Load path
(add-to-list 'load-path "~/.emacs.d/modes")

;; Acme mode
(load "acme-mode.el")

;; SASS mode
(add-to-list 'auto-mode-alist '("\\.scss\\'" . css-mode))

;; C Mode customization


;; Copilot Mode
(add-to-list 'load-path "~/.emacs.d/copilot/copilot.el")
(require 'copilot)

;(use-package copilot
;  :quelpa (copilot.el :fetcher github
;                      :repo "zerolfx/copilot.el"
;                      :branch "main"
;                      :files ("dist" "*.el")))
;; you can utilize :map :hook and :config to customize copilot

;; Tab-accept using autocomplete
(with-eval-after-load 'company
  ;; disable inline previews
  (delq 'company-preview-if-just-one-frontend company-frontends))
  
(define-key copilot-completion-map (kbd "<tab>") 'copilot-accept-completion)
;(define-key copilot-completion-map (kbd "TAB") 'copilot-accept-completion)

