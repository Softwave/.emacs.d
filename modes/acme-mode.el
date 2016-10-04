;; acme-mode.el 
;; by abad in 2008 (abad.flt at gmail.com)
;; based on asm-mode.el by Eric Raymond

;;; Code:

(defgroup acme nil
  "Mode for editing assembler code."
  :group 'languages)

(defcustom acme-comment-char ?\;
  "*The comment-start character assumed by Acme mode."
  :type 'character
  :group 'acme)

(defvar acme-mode-syntax-table nil
  "Syntax table used while in Acme mode.")

(defvar acme-mode-abbrev-table nil
  "Abbrev table used while in Acme mode.")
(define-abbrev-table 'acme-mode-abbrev-table ())

(defvar acme-mode-map nil
  "Keymap for Acme mode.")

(if acme-mode-map
    nil
  (setq acme-mode-map (make-sparse-keymap))
  ;; Note that the comment character isn't set up until acme-mode is called.
  (define-key acme-mode-map ":"		'acme-colon)
  (define-key acme-mode-map "\C-c;"      'comment-region)
  (define-key acme-mode-map "\C-i"	'tab-to-tab-stop)
  (define-key acme-mode-map "\C-j"	'acme-newline)
  (define-key acme-mode-map "\C-m"	'acme-newline)
  )

(defconst acme-font-lock-keywords
  '(
    ("^\\(\\(\\sw\\|\\s_\\|[\\.]*\\)+\\)\\>:?[ \t]*\\(\\sw+\\(\\.\\sw+\\)*\\)?"
     (1 font-lock-function-name-face) (3 font-lock-keyword-face nil t))
    ;; label started from ".".
    ("^\\(\\.\\(\\sw\\|\\s_\\)+\\)\\>:"
     1 font-lock-function-name-face)
    ("^\\((\\sw+)\\)?\\s +\\(\\(\\.?\\sw\\|\\s_\\)+\\(\\.\\sw+\\)*\\)"
     2 font-lock-keyword-face)
    ;("^\\(\\.\\(\\sw\\|\\s_\\)+\\)\\>[^:]?"
    ; 1 font-lock-keyword-face)
    ("[#!]\\sw+" . font-lock-variable-name-face)
    ;("$[A-Fa-f0-9]+" . font-lock-function-name-face)
    ("\\b\\([$0-9][0-9a-fA-F]*\\)" . font-lock-function-name-face)
    (",[xy]" . font-lock-keyword-face))

  "Additional expressions to highlight in Assembler mode.")

(defvar acme-code-level-empty-comment-pattern nil)
(defvar acme-flush-left-empty-comment-pattern nil)
(defvar acme-inline-empty-comment-pattern nil)

(defun acme-mode ()
  "Major mode for editing typical assembler code.
Features a private abbrev table and the following bindings:

\\[acme-colon]\toutdent a preceding label, tab to next tab stop.
\\[tab-to-tab-stop]\ttab to next tab stop.
\\[acme-newline]\tnewline, then tab to next tab stop.
\\[acme-comment]\tsmart placement of assembler comments.

The character used for making comments is set by the variable
`acme-comment-char' (which defaults to `?\\;').

Alternatively, you may set this variable in `acme-mode-set-comment-hook',
which is called near the beginning of mode initialization.

Turning on Acme mode runs the hook `acme-mode-hook' at the end of initialization.

Special commands:
\\{acme-mode-map}
"
  (interactive)
  (kill-all-local-variables)
  (setq mode-name "Assembler")
  (setq major-mode 'acme-mode)
  (setq local-abbrev-table acme-mode-abbrev-table)
  (make-local-variable 'font-lock-defaults)
  (setq font-lock-defaults '(acme-font-lock-keywords))
  (make-local-variable 'acme-mode-syntax-table)
  (setq acme-mode-syntax-table (make-syntax-table))
  (set-syntax-table acme-mode-syntax-table)
  (setq tab-width 8)

  (run-hooks 'acme-mode-set-comment-hook)
  ;; Make our own local child of acme-mode-map
  ;; so we can define our own comment character.
  (use-local-map (nconc (make-sparse-keymap) acme-mode-map))
  (local-set-key (vector acme-comment-char) 'acme-comment)

  (modify-syntax-entry	acme-comment-char
			"< b" acme-mode-syntax-table)
  (modify-syntax-entry	?\n
			 "> b" acme-mode-syntax-table)

  (modify-syntax-entry ?/  ". 14" acme-mode-syntax-table)
  (modify-syntax-entry ?*  ". 23" acme-mode-syntax-table)

  (let ((cs (regexp-quote (char-to-string acme-comment-char))))
    (make-local-variable 'comment-start)
    (setq comment-start (concat (char-to-string acme-comment-char) " "))
    (make-local-variable 'comment-start-skip)
    (setq comment-start-skip (concat cs "+[ \t]*"))
    (setq acme-inline-empty-comment-pattern (concat "^.+" cs "+ *$"))
    (setq acme-code-level-empty-comment-pattern (concat "^[\t ]+" cs cs " *$"))
    (setq acme-flush-left-empty-comment-pattern (concat "^" cs cs cs " *$"))
    )
  (make-local-variable 'comment-end)
  (setq comment-end "")
  (setq fill-prefix "\t")
  (run-hooks 'acme-mode-hook))

(defun acme-colon ()
  "Insert a colon; if it follows a label, delete the label's indentation."
  (interactive)
  (save-excursion
    (beginning-of-line)
    (if (looking-at "[ \t]+\\(\\sw\\|\\s_\\)+$")
	(delete-horizontal-space)))
  (insert ":")
  (tab-to-tab-stop)
  )

(defun acme-newline ()
  "Insert LFD + fill-prefix, to bring us back to code-indent level."
  (interactive)
  (if (eolp) (delete-horizontal-space))
  (insert "\n")
  (tab-to-tab-stop)
  )

(defun acme-line-matches (pattern &optional withcomment)
  (save-excursion
    (beginning-of-line)
    (looking-at pattern)))

(defun acme-pop-comment-level ()
  ;; Delete an empty comment ending current line.  Then set up for a new one,
  ;; on the current line if it was all comment, otherwise above it
  (end-of-line)
  (delete-horizontal-space)
  (while (= (preceding-char) acme-comment-char)
    (delete-backward-char 1))
  (delete-horizontal-space)
  (if (bolp)
      nil
    (beginning-of-line)
    (open-line 1))
  )


(defun acme-comment ()
  "Convert an empty comment to a `larger' kind, or start a new one.
These are the known comment classes:

   1 -- comment to the right of the code (at the comment-column)
   2 -- comment on its own line, indented like code
   3 -- comment on its own line, beginning at the left-most column.

Suggested usage:  while writing your code, trigger acme-comment
repeatedly until you are satisfied with the kind of comment."
  (interactive)
  (cond

   ;; Blank line?  Then start comment at code indent level.
   ((acme-line-matches "^[ \t]*$")
    (delete-horizontal-space)
    (tab-to-tab-stop)
    (insert acme-comment-char comment-start))

   ;; Nonblank line with no comment chars in it?
   ;; Then start a comment at the current comment column
   ((acme-line-matches (format "^[^%c\n]+$" acme-comment-char))
    (indent-for-comment))

   ;; Flush-left comment present?  Just insert character.
   ((acme-line-matches acme-flush-left-empty-comment-pattern)
    (insert acme-comment-char))

   ;; Empty code-level comment already present?
   ;; Then start flush-left comment, on line above if this one is nonempty.
   ((acme-line-matches acme-code-level-empty-comment-pattern)
    (acme-pop-comment-level)
    (insert acme-comment-char acme-comment-char comment-start))

   ;; Empty comment ends line?
   ;; Then make code-level comment, on line above if this one is nonempty.
   ((acme-line-matches acme-inline-empty-comment-pattern)
    (acme-pop-comment-level)
    (tab-to-tab-stop)
    (insert acme-comment-char comment-start))

   ;; If all else fails, insert character
   (t
    (insert acme-comment-char))

   )
  (end-of-line))

(provide 'acme-mode)

;;; acme-mode.el ends here

