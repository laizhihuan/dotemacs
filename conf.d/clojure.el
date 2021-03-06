;; (eval-after-load 'clojure-mode
;;   '(font-lock-add-keywords
;;     'clojure-mode `(("(\\(fn\\)[\[[:space:]]"
;;                      (0 (progn (compose-region (match-beginning 1)
;;                                                (match-end 1) "λ")
;;                                nil))))))

(eval-after-load 'clojure-mode
  '(font-lock-add-keywords
    'clojure-mode `(("\\(#\\)("
                     (0 (progn (compose-region (match-beginning 1)
                                               (match-end 1) "ƒ")
                               nil))))))

(eval-after-load 'clojure-mode
  '(font-lock-add-keywords
    'clojure-mode `(("\\(#\\){"
                     (0 (progn (compose-region (match-beginning 1)
                                               (match-end 1) "∈")
                               nil))))))


(require 'clojure-mode)
(require 'rainbow-delimiters)
(require 'ac-nrepl)
(require 'midje-mode)
;(require 'clojure-jump-to-file)

(add-hook 'clojure-mode-hook
          (lambda ()
            (enable-paredit-mode)
            (rainbow-delimiters-mode)
            (add-to-list 'ac-sources 'ac-source-yasnippet)
            (setq buffer-save-without-query t)))

(add-hook 'clojure-mode-hook 'midje-mode)

;;Treat hyphens as a word character when transposing words
(defvar clojure-mode-with-hyphens-as-word-sep-syntax-table
  (let ((st (make-syntax-table clojure-mode-syntax-table)))
    (modify-syntax-entry ?- "w" st)
    st))

(defun live-transpose-words-with-hyphens (arg)
  "Treat hyphens as a word character when transposing words"
  (interactive "*p")
  (with-syntax-table clojure-mode-with-hyphens-as-word-sep-syntax-table
    (transpose-words arg)))

(define-key clojure-mode-map (kbd "M-t") 'live-transpose-words-with-hyphens)

(setq auto-mode-alist (append '(("\\.cljs$" . clojure-mode))
                              auto-mode-alist))

(dolist (x '(scheme emacs-lisp lisp))
  (add-hook (intern (concat (symbol-name x) "-mode-hook")) 'enable-paredit-mode)
  (add-hook (intern (concat (symbol-name x) "-mode-hook")) 'rainbow-delimiters-mode))

(add-hook 'cider-mode-hook 'cider-turn-on-eldoc-mode)
(add-hook 'cider-mode-hook 'ac-nrepl-setup)

(add-hook 'cider-repl-mode-hook 'enable-paredit-mode)
(add-hook 'cider-repl-mode-hook 'cider-turn-on-eldoc-mode)
(add-hook 'cider-repl-mode-hook 'rainbow-delimiters-mode)
(add-hook 'cider-repl-mode-hook 'subword-mode)
(add-hook 'cider-repl-mode-hook 'ac-nrepl-setup)

(setq cider-popup-stacktraces nil)
;; (add-to-list 'same-window-buffer-names "*nrepl*")

;; (defun clojure-complete ()
;;   (interactive)
;;   (auto-complete '(ac-source-nrepl-ns
;;                    ac-source-nrepl-vars
;;                    ac-source-nrepl-ns-classes
;;                    ac-source-nrepl-all-classes
;;                    ac-source-nrepl-java-methods
;;                    ac-source-nrepl-static-methods)))

(eval-after-load "auto-complete"
  '(add-to-list 'ac-modes 'cider-repl-mode 'cider-mode))

(eval-after-load "cider-mode"
  '(define-key cider-mode-map (kbd "C-c C-d") 'ac-nrepl-popup-doc))

;; highlight expression on eval
;(require 'highlight)
;(require 'nrepl-eval-sexp-fu)
;(setq nrepl-eval-sexp-fu-flash-duration 0.5)
;(setq nrepl-hide-special-buffers t)

