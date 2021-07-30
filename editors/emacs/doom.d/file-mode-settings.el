;;; filetype-modes.el -*- lexical-binding: t; -*-

;; Use variable width fonts and soft wrap for all prose filetypes
(add-hook 'text-mode-hook
          (lambda ()
            (variable-pitch-mode 1)
            (visual-line-mode)
            ;; (setq doom-modeline-enable-word-count t)
            ))
;; Exceptions for variable pitch text mode faces.
(add-hook 'text-mode-hook
          '(lambda ()
             (mapc
              (lambda (face)
                (set-face-attribute face nil :inherit 'fixed-pitch))
              (list 'line-number
                    'show-paren-match
                    'show-paren-mismatch
                    'sp-show-pair-enclosing
                    ))))

;; Use soft wraps instead of hard. Only enable if found to be neccessary.
;; (remove-hook 'text-mode-hook #'auto-fill-mode)
;; (add-hook 'message-mode-hook #'word-wrap-mode)

;; Add underscore to word character definition.
(modify-syntax-entry ?_ "w")

;;; For lisp,
;; (add-hook! 'lisp-mode-hook (modify-syntax-entry ?_ "w"))

;;; Markdown
(add-hook! 'markdown-mode-hook
  ( progn
    (setq markdown-fontify-code-blocks-natively 1)
    (setq markdown-header-scaling 1)
    )
  )
(setq markdown-fontify-code-blocks-natively 1)
(setq markdown-header-scaling 1)
(add-hook 'markdown-mode-hook
          '(lambda ()
             (mapc
              (lambda (face)
                (set-face-attribute face nil :inherit 'fixed-pitch))
              (list 'markdown-inline-code-face
                    'markdown-code-face
                    ))))

;;; LaTeX
(add-hook 'latex-mode-hook
          '(lambda ()
             (mapc
              (lambda (face)
                (set-face-attribute face nil :inherit 'fixed-pitch))
              (list 'font-latex-verbatim-face
                    'font-lock-keyword-face
                    ;; 'font-lock-sedate-face
                    'font-lock-function-name-face
                    'tex-verbatim
                    'font-latex-doctex-documentation-face
                    'font-latex-doctex-preprocessor-face
                    'TeX-error-description-help
                    'TeX-error-description-warning
                    'TeX-error-description-tex-said
                    ))))

;;; Org
;; Exclude these faces from using variable-pitch fonts.
(add-hook 'org-mode-hook
            '(lambda ()
               (mapc
                (lambda (face)
                  (set-face-attribute face nil :inherit 'fixed-pitch))
                (list 'org-code
                      'org-link
                      'org-block
                      'org-table
                      'org-block-begin-line
                      'org-block-end-line
                      'org-meta-line
                      'org-document-info-keyword))))
