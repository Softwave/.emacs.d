;; My emacs config thingy

;; Packages
(require 'package)
(add-to-list 'package-archives
             '("marmalade" . "http://marmalade-repo.org/packages/") t)
(add-to-list 'package-archives
             '("tromey" . "http://tromey.com/elpa/") t)
(add-to-list 'package-archives
             '("melpa" . "http://melpa.milkbox.net/packages/") t)
(add-to-list 'package-archives
             '("melpa-stable" . "https://stable.melpa.org/packages/") t)

(package-initialize)
(when (not package-archive-contents)
  (package-refresh-contents))


(defvar my-packages
  '(;; makes handling lisp expressions much, much easier
    paredit
    clojure-mode
    clojure-mode-extra-font-locking
    cider
    ido-ubiquitous
    smex
    projectile
    ;;rainbow-delimiters
    tagedit
    magit))

(if (eq system-type 'darwin)
    (add-to-list 'my-packages 'exec-path-from-shell))

;;(dolist (p my-packages)
;;  (when (not (package-installed-p p))
;;    (package-install p)))

(add-to-list 'load-path "~/.emacs.d/vendor")

;; Customizations 
(add-to-list 'load-path "~/.emacs.d/customizations")

;; Various Customizations
(load "shell-integration.el")
(load "navigation.el")
(load "ui.el")
(load "modes.el")

;; My tweaking
(load "keybindings.el")
(load "random.el")