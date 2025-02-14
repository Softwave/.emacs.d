;; My random customizations

;; I need to organize all of this better 

;; No need for lockfiles
(setq create-lockfiles nil)

;; Yes or No to y or n
(fset 'yes-or-no-p 'y-or-n-p)

;; Go straight to scratch buffer on startup
(setq inhibit-startup-message t)

;; C indentation is 4
(setq c-default-style "bsd"
      c-basic-offset 4)
(c-set-offset 'case-label '+)


;; Tabs
(setq-default indent-tabs-mode nil)
(setq-default tab-width 4)
(setq indent-line-function 'insert-tab)

;; CSS Indenting
(setq css-intent-offset 4)

;; Stop this control-z shenanigans 
(global-unset-key (kbd "C-z"))
(global-set-key (kbd "C-z C-z") 'my-suspend-frame)
(defun my-suspend-frame ()
  "In a GUI environment, do nothing; otherwise `suspend-frame'."
  (interactive)
  (if (display-graphic-p)
      (message "suspend-frame disabled for graphical displays.")
    (suspend-frame)))





;; Build 6502 programs
;; Gotta redo this using KickAssembler 
;;
;(defun build-c64 ()
;  (interactive)
;  (setq fname (buffer-file-name))
;  (setq cname "/usr/local/bin/assemble_6502 ")
;  (setq cmdname (concat cname fname))
;  (with-temp-buffer
 ; 	(shell-command cmdname t)))

;(global-set-key (kbd "M-8") 'build-c64)
