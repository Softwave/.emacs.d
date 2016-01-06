;; Setting up various modes 


;; Markdown mode
(autoload 'markdown-mode "markdown-mode"
   "Major mode for editing Markdown files" t)
(add-to-list 'auto-mode-alist '("\\.text\\'" . markdown-mode))
(add-to-list 'auto-mode-alist '("\\.markdown\\'" . markdown-mode))
(add-to-list 'auto-mode-alist '("\\.md\\'" . markdown-mode))

;; Omnisharp mode
(setq omnisharp-server-executable-path 
	"/Users/Discovery/Local/omnisharp-server/OmniSharp/bin/debug/OmniSharp.exe")
(eval-after-load 'company
  '(add-to-list 'company-backends 'company-omnisharp))

;; Auto omnisharp 
(add-hook 'csharp-mode-hook 'omnisharp-mode)

;; Sonic Pi Mode
(setq false nil)
(add-to-list 'load-path "~/.sonic-pi.el/")
(require 'sonic-pi)
(setq sonic-pi-path "/Users/Discovery/Documents/sp/sonic-pi/")

;; Processing Mode
(setq processing-location "/usr/local/bin/processing-java")
(setq processing-application-dir "/Applications/Processing.app")
(setq processing-sketchbook-dir "~/Documents/Processing")
