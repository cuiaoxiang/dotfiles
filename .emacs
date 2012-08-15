(add-to-list 'load-path "~/.emacs.d/site-lisp")

(setq visible-bell t)
(setq inhibit-startup-message t)
(mouse-avoidance-mode 'animate)

(global-font-lock-mode 1)
(setq column-number-mode t)
(setq size-indication-mode t)
(setq default-fill-column 100)
(setq default-tab-width 2)
(setq-default indent-tabs-mode nil)

(setq echo-keystrokes -1)

(blink-cursor-mode 0)
(tooltip-mode 0)
(tool-bar-mode 0)
(scroll-bar-mode 0)

(show-paren-mode 1)
(setq show-paren-style 'parenthese)
;; (set-face-foreground 'show-paren-match "green")
;; (set-face-foreground 'show-paren-mismatch "red")
;; (set-face-bold-p 'show-paren-match t)
;; (set-face-bold-p 'show-paren-mismatch t)
;; (set-face-background 'show-paren-match nil)
;; (set-face-background 'show-paren-mismatch nil)

(fset 'yes-or-no-p 'y-or-n-p)
(setq frame-title-format '(:eval (or (buffer-file-name) (buffer-name))))
(setq resize-mini-windows t)
(auto-image-file-mode t)

(display-time)
(setq display-time-24hr-format t)
(setq display-time-day-and-date t)

(setq default-frame-alist '((height . 40) (width . 110) (font . "Monospace-10")))
(set-fontset-font "fontset-default" 'gb18030 '("Microsoft YaHei" . "unicode-bmp"))

(global-set-key [f11] 'my-fullscreen)
(defun my-fullscreen ()
  (interactive)
  (x-send-client-message
   nil 0 nil "_NET_WM_STATE" 32
   '(2 "_NET_WM_STATE_FULLSCREEN" 0)))

(set-face-background 'modeline "#4466aa")
;; (set-face-background 'modeline-inactive "#99aaff")
(set-face-background 'fringe "#809088")

;; mode-line-buffer-identification: highlight with color, without key map
(setq-default mode-line-buffer-identification
              (list (propertize "%b" 'face '(:foreground "black" :background "yellow"))))

;; mode-line-position: total line, percent, size, point position
;; when region selected, size becomes char count
(setq-default mode-line-position
              (list '(:eval
                      (let ((lines (count-lines (point-min) (point-max))))
                        (propertize
                         (format "%dL" lines)
                         'help-echo (format "Total %d lines" lines))))
                    (propertize
                     " %p"
                     'local-map mode-line-column-line-number-mode-map
                     'mouse-face 'mode-line-highlight
                     'help-echo "Size indication mode\nmouse-1: Display Line and Column Mode Menu")
                    (if size-indication-mode
                        '(:eval
                          (propertize
                           (if (and transient-mark-mode mark-active)
                               (format " %d chars" (- (region-end) (region-beginning)))
                             " %I")
                           'face (and transient-mark-mode mark-active 'region)
                           'local-map mode-line-column-line-number-mode-map
                           'mouse-face 'mode-line-highlight
                           'help-echo "Size indication mode\nmouse-1: Display Line and Column Mode Menu")))
                    (if line-number-mode
                        (if column-number-mode
                            (propertize
                             " (%l,%c)"
                             'local-map mode-line-column-line-number-mode-map
                             'mouse-face 'mode-line-highlight
                             'help-echo "Line number and Column number\nmouse-1: Display Line and Column Mode Menu")
                          (propertize
                           " L%l"
                           'local-map mode-line-column-line-number-mode-map
                           'mouse-face 'mode-line-highlight
                           'help-echo "Line Number\nmouse-1: Display Line and Column Mode Menu"))
                      (if column-number-mode
                          (propertize
                           " C%c"
                           'local-map mode-line-column-line-number-mode-map
                           'mouse-face 'mode-line-highlight
                           'help-echo "Column number\nmouse-1: Display Line and Column Mode Menu")))))

(setq default-major-mode 'text-mode)
(setq-default auto-fill-function 'do-auto-fill)

(setq bookmark-save-flag t)
(setq bookmark-default-file "~/.emacs.d/.emacs.bmk")

(require 'tabbar)
(tabbar-mode t)
(global-set-key (kbd "<C-left>") 'tabbar-backward-tab)
(global-set-key (kbd "<C-right>") 'tabbar-forward-tab)
(global-set-key (kbd "<C-up>") 'tabbar-backward-group)
(global-set-key (kbd "<C-down>") 'tabbar-forward-group)

(add-hook 'dired-mode-hook '(lambda ()
                              (interactive)
                              (make-local-variable 'dired-sort-map)
                              (setq dired-sort-map (make-sparse-keymap))
                              (define-key dired-mode-map "s" dired-sort-map)
                              (define-key dired-sort-map "s"
                                '(lambda () "sort by Size"
                                   (interactive) (dired-sort-other (concat dired-listing-switches "S"))))
                              (define-key dired-sort-map "x"
                                '(lambda () "sort by eXtension"
                                   (interactive) (dired-sort-other (concat dired-listing-switches "X"))))
                              (define-key dired-sort-map "t"
                                '(lambda () "sort by Time"
                                   (interactive) (dired-sort-other (concat dired-listing-switches "t"))))
                              (define-key dired-sort-map "n"
                                '(lambda () "sort by Name"
                                   (interactive) (dired-sort-other (concat dired-listing-switches ""))))))

(add-hook 'dired-mode-hook '(lambda ()
                              (interactive)
                              (define-key dired-mode-map (kbd "/") 'dired-omit-expunge)
                              (define-key dired-mode-map (kbd "RET")
                                '(lambda () "kill current buffer when moving to subdirectory"
                                   (interactive)
                                   (let ((previous-dired-buffer (current-buffer))
                                         (file (dired-get-file-for-visit)))
                                     (if (file-directory-p file)
                                         (progn (dired-find-file)
                                                (kill-buffer previous-dired-buffer))
                                       (dired-find-file)))))))
;; (define-key dired-mode-map (kbd "^")
;;   '(lambda () "kill current buffer when moving to father directory"
;;      (interactive)
;;      (let ((previous-dired-buffer (current-buffer)))
;;        (dired-up-directory)
;;        (kill-buffer previous-dired-buffer))))))

(set-face-attribute 'tabbar-default nil
                    :family "Monospace"
                    :background "gray80"
                    :foreground "gray30"
                    :height 1.0)

(set-face-attribute 'tabbar-button nil
                    :inherit 'tabbar-default
                    :box '(:line-width 1 :color "gray30"))

(set-face-attribute 'tabbar-selected nil
                    :inherit 'tabbar-default
                    :foreground "DarkGreen"
                    :background "LightGoldenrod"
                    :box '(:line-width 2 :color "DarkGoldenrod")
                    ;; :overline "black"
                    ;; :underline "black"
                    :weight 'bold)

(set-face-attribute 'tabbar-unselected nil
                    :inherit 'tabbar-default
                    :box '(:line-width 2 :color "gray70"))

;; (require 'ctab)
;; (ctab-mode t)
;; ;; 如果需要让.h文件和.c/.cpp文件排在一起，则增加下面一行:
;; (setq ctab-smart t)

(autoload 'auto-revert-mode "autorevert" nil t)
(autoload 'turn-on-auto-revert-mode "autorevert" nil nil)
(autoload 'global-auto-revert-mode "autorevert" nil t)
(global-auto-revert-mode 1)

(setq adaptive-fill-regexp "[ \t]+\\|[ \t]*\\([0-9]+\\.\\|\\*+\\)[ \t]*")
;; first line start with "*" will be line prefix
(setq adaptive-fill-first-line-regexp "^\\* *$")

(global-set-key (kbd "M-SPC") 'set-mark-command)

(setq transient-mark-mode t)

(setq-default kill-whole-line t)
(setq kill-ring-max 200)

;; emacs clipboard can be used outside
(setq x-select-enable-clipboard t)

(setq sentence-end "\\([。！？]\\|……\\|[.?!][]\"')}]*\\($\\|[ \t]\\)\\)[ \t\n]*")
(setq sentence-end-double-space nil)
(setq enable-recursive-minibuffers t)
(setq scroll-margin 3
      scroll-conservatively 10000)
(global-set-key (kbd "<M-down>") '(lambda (&optional n)
                                    (interactive "p")
                                    (scroll-up (or n 1))))
(global-set-key (kbd "<M-up>") '(lambda (&optional n)
                                  (interactive "p")
                                  (scroll-down (or n 1))))

;; trigger on these default disabled
(put 'set-goal-column 'disabled nil)
(put 'narrow-to-region 'disabled nil)
(put 'upcase-region 'disabled nil)
(put 'downcase-region 'disabled nil)
(put 'LaTeX-hide-environment 'disabled nil)
(put 'dired-find-alternate-file 'disabled nil)
(put 'narrow-to-page 'disabled nil)

(setq make-backup-files nil)
;; (setq version-control t)
;; (setq kept-old-versions 1)
;; (setq kept-new-versions 2)
;; (setq delete-old-versions t)
;; (setq backup-directory-alist '(("" . "~/.emacs.d/backup")))
;; (setq delete-auto-save-files t)

(add-hook 'before-save-hook 'delete-trailing-whitespace)

;; move window: shift + direction
(windmove-default-keybindings)
(setq windmove-wrap-around t)

(global-set-key [f1] 'shell)
(global-set-key [f2] (lambda () (interactive)
                       (switch-to-buffer (other-buffer))))
(global-set-key [f3] 'other-window)
(global-set-key [f4] 'kill-this-buffer)

;; shell-mode with ansi color
(ansi-color-for-comint-mode-on)

;; 分割窗口后，全屏窗口可以恢复 C-c <left>, C-c <right>
(winner-mode 1)

;; (setq todo-file-do "~/.emacs.d/todo/do")
;; (setq todo-file-done "~/.emacs.d/todo/done")
;; (setq todo-file-top "~/.emacs.d/todo/top")
;; (setq diary-file "~/.emacs.d/diary")
;; (add-hook 'diary-hook 'appt-make-list)

(global-set-key (kbd "C-x g") 'goto-line)
(setq outline-minor-mode-prefix (kbd "C-o"))

(require 'view)
(global-set-key [f5] 'view-mode)
(define-key view-mode-map (kbd "p") 'previous-line)
(define-key view-mode-map (kbd "n") 'next-line)
(define-key view-mode-map (kbd "f") 'forward-char)
(define-key view-mode-map (kbd "b") 'backward-char)

(global-set-key (kbd "C-\\") 'just-one-space)
(global-set-key (kbd "C-c o") 'occur)

;; (add-to-list 'load-path "~/.emacs.d/site-lisp/auto-complete-1.3.1")
;; (require 'auto-complete-config)
;; (add-to-list 'ac-dictionary-directories
;;              "~/.emacs.d/site-lisp/auto-complete-1.3.1/dict")
;; (ac-config-default)
;; (define-key ac-complete-mode-map (kbd "RET") nil)
;; (define-key ac-complete-mode-map (kbd "<return>") nil)
;; (define-key ac-complete-mode-map (kbd "C-j") 'ac-complete)
;; (define-key ac-complete-mode-map (kbd "C-p") 'ac-previous)
;; (define-key ac-complete-mode-map (kbd "C-n") 'ac-next)

;; (require 'gccsense)
;; (global-set-key (kbd "M-?") 'ac-complete-gccsense)

(ido-mode 1)
(require 'dired-x)
(setq ido-save-directory-list-file "~/.emacs.d/.ido.last")
(add-hook 'dired-load-hook
          (function (lambda ()
                      (load "dired-x"))))

(global-linum-mode 1)
;; (setq linum-format "%3d")

(require 'uniquify)
(setq uniquify-buffer-name-style 'forward)

;; 让 dired 可以递归的拷贝和删除目录。
(setq dired-recursive-copies 'always)
(setq dired-recursive-deletes 'top)

(defun mark-symbol ()
  "Mark symbol containing point."
  (interactive)
  (let (beginning end bounds)
    (setq bounds (bounds-of-thing-at-point 'symbol)
          beginning (car bounds)
          end (cdr bounds))
    (if beginning (push-mark beginning nil t))
    (if end (goto-char end))))
(global-set-key (kbd "M-m") 'mark-symbol)

(defun mark-string ()
  "Mark string containing point."
  (interactive)
  (let (beginning end)
    (save-excursion
      (skip-chars-backward "^\"" (point-min))
      (setq beginning (point))
      (skip-chars-forward "^\"" (point-max))
      (setq end (point)))
    (if (/= beginning (point-min)) (push-mark beginning nil t))
    (if (/= end (point-max)) (goto-char end))))
(global-set-key (kbd "C-'") 'mark-string)

(defun mark-sexp ()
  "Mark sexp containing point.
If invoke multiple times, expand the range of the sexp."
  (interactive)
  (let (beginning end bounds)
    (setq bounds (bounds-of-thing-at-point 'list)
          beginning (car bounds)
          end (cdr bounds))
    (if beginning (push-mark beginning nil t))
    (if end (goto-char end))))
(global-set-key (kbd "C-;") 'mark-sexp)

(defun mark-line ()
  "Mark the current line."
  (interactive)
  (push-mark (line-beginning-position) nil t)
  (end-of-line))
(global-set-key (kbd "M-l") 'mark-line)

;; Smart copy, if no region active, it simply copy the current whole line
(defadvice kill-line (before check-position activate)
  (if (member major-mode
              '(emacs-lisp-mode scheme-mode lisp-mode
                                c-mode c++-mode objc-mode js-mode
                                latex-mode plain-tex-mode))
      (if (and (eolp) (not (bolp)))
          (progn (forward-char 1)
                 (just-one-space 0)
                 (backward-char 1)))))

(defadvice kill-ring-save (before slick-copy activate)
  "When called interactively with no active region, copy a single
line instead."
  (interactive
   (if mark-active (list (region-beginning) (region-end))
     (message "Line copied")
     (list (line-beginning-position)
           (line-beginning-position 2)))))

(defadvice kill-region (before slick-cut activate)
  "When called interactively with no active region, kill a single
line instead."
  (interactive
   (if mark-active (list (region-beginning) (region-end))
     (list (line-beginning-position)
           (line-beginning-position 2)))))

(defun smart-comment-dwim-line (&optional arg)
  "Replacement for the comment-dwim command.
If no region is selected and current line is not blank and we are
not at the end of the line, then comment current line. Replaces
default behaviour of comment-dwim, when it inserts comment at the
end of the line."
  (interactive "*P")
  (comment-normalize-vars)
  (if (and (not (region-active-p)) (not (looking-at "[ \t]*$")))
      (comment-or-uncomment-region (line-beginning-position) (line-end-position))
    (comment-dwim arg)))
(global-set-key (kbd "M-;") 'smart-comment-dwim-line)

;; replaced with yas/expand "time"
;; (defun my-insert-date ()
;;   (interactive)
;;   (insert (format-time-string "%Y/%m/%d %H:%M:%S" (current-time))))
;; (global-set-key (kbd "C-c d") 'my-insert-date)

(defun smart-beginning-of-line ()
  "If the point is not on beginning of current line, move point
to beginning of current line, as 'beginning-of-line' does.
If the point already is on the beginning of current line, then
move the point to the first non-space character, if it exists."
  (interactive)
  (if (not (eq (point) (line-beginning-position)))
      (beginning-of-line)
    (when (re-search-forward "[^[:blank:]　]" (line-end-position) t)
      (backward-char))))
(global-set-key (kbd "C-a") 'smart-beginning-of-line)

(defun count-words-region (beginning end)
  "Print number of words in the region."
  (interactive "r")
  (message "Counting words in region...")
  (save-excursion
    (let ((count 0))
      (goto-char beginning)
      (while (re-search-forward "\\w+\\W*" end t)
        (setq count (1+ count)))
      (cond ((zerop count) (message "Region does NOT have any words."))
            ((= 1 count) (message "Region has one word."))
            (t (message "Region has %d words." count))))))
(define-key text-mode-map (kbd "C-c =") 'count-words-region)

(defun kill-empty-lines ()
  "Kill all the empty lines in region or delete blank lines."
  (interactive)
  (if (and transient-mark-mode mark-active)
      (progn
        (message "Killing lines in region...")
        (let ((beginning (region-beginning))
              (end (region-end)))
          (save-excursion
            (goto-char beginning)
            (while (re-search-forward "^[[:blank:]　]*$" end t)
              (beginning-of-line)
              (kill-line)))))
    (delete-blank-lines)))
(global-set-key (kbd "C-x C-o") 'kill-empty-lines)

(defun ska-point-to-register()
  "Store cursorposition _fast_ in a register.
Use ska-jump-to-register to jump back to the stored position."
  (interactive)
  (setq zmacs-region-stays t)
  (point-to-register 8))
(defun ska-jump-to-register()
  "Switches between current cursorposition and position that was
stored with ska-point-to-register."
  (interactive)
  (setq zmacs-region-stays t)
  (let ((tmp (point-marker)))
    (jump-to-register 8)
    (set-register 8 tmp)))
(global-set-key (kbd "C-.") 'ska-point-to-register)
(global-set-key (kbd "C-,") 'ska-jump-to-register)

(require 'redo)
(global-set-key (kbd "C-?") 'redo)

;; (require 'iswitchb)
;; (iswitchb-default-keybindings)

(global-set-key (kbd "C-x C-b") 'ibuffer)

(require 'browse-kill-ring)
(global-set-key (kbd "C-c k") 'browse-kill-ring)

;; (load "~/.emacs.d/nxhtml/autostart.el")

(defun web-newline-and-indent ()
  "Indent first, then newline and indent"
  (interactive)
  (indent-according-to-mode)
  (newline-and-indent))

;; (require 'sgml-mode)
;; (define-key sgml-mode-map (kbd "RET") 'web-newline-and-indent)
;; (require 'css-mode)
;; (define-key css-mode-map (kbd "RET") 'web-newline-and-indent)
;; (require 'php-mode)
;; (define-key php-mode-map (kbd "RET") 'web-newline-and-indent)

(mapcar
 (function (lambda (setting)
             (setq auto-mode-alist
                   (cons setting auto-mode-alist))))
 '(("\\.h\\'" . c++-mode)
   ("\\.\\([ps]?html?\\|cfm\\|asp\\)\\'" . html-mode)
   ("\\.rdf\\'" .  sgml-mode)
   ("\\.session\\'" . emacs-lisp-mode)))

;; (load-file "~/.emacs.d/cedet-1.0pre4/common/cedet.el")
;; ;; Enabling various SEMANTIC minor modes.  See semantic/INSTALL for more ideas.
;; ;; Select one of the following:

;; ;; * This enables the database and idle reparse engines
;; (semantic-load-enable-minimum-features)

;; ;; * This enables some tools useful for coding, such as summary mode
;; ;;   imenu support, and the semantic navigator
;; (semantic-load-enable-code-helpers)

;; ;; * This enables even more coding tools such as the nascent intellisense mode
;; ;;   decoration mode, and stickyfunc mode (plus regular code helpers)
;; (semantic-load-enable-guady-code-helpers)

;; ;; * This turns on which-func support (Plus all other code helpers)
;; (semantic-load-enable-excessive-code-helpers)

;; ;; This turns on modes that aid in grammar writing and semantic tool
;; ;; development.  It does not enable any other features such as code
;; ;; helpers above.
;; ;; (semantic-load-enable-semantic-debugging-helpers)

;; (setq semanticdb-project-roots
;;        (list
;;         (expand-file-name "/")))

(setq hippie-expand-try-functions-list
      '(try-expand-dabbrev
        try-expand-dabbrev-visible
        try-complete-file-name-partially
        try-complete-file-name
        try-expand-dabbrev-all-buffers
        try-expand-dabbrev-from-kill
        try-expand-all-abbrevs
        try-expand-list
        try-expand-line
        try-complete-lisp-symbol-partially
        try-complete-lisp-symbol))

(defun smart-tab ()
  "This smart tab is minibuffer compliant: it acts as usual in
the minibuffer. Else, if mark is active, indents region. Else if
point is at the end of a symbol, expands it. Else indents the
current line."
  (interactive)
  (if (minibufferp)
      (unless (minibuffer-complete)
        (dabbrev-expand nil))
    (if mark-active
        (indent-region (region-beginning)
                       (region-end))
      (if (looking-at "\\_>")
          (hippie-expand nil)
        (indent-for-tab-command)))))
(global-set-key (kbd "<tab>") 'smart-tab)

(require 'template)
(template-initialize)

;; template expand
(global-set-key (kbd "M-/") 'yas/expand)

;; (add-to-list 'load-path "~/.emacs.d/ecb-2.32")

(autoload 'dictionary-search "dictionary" "Ask for a word and search it in all dictionaries" t)
(autoload 'dictionary-match-words "dictionary" "Ask for a word and search all matching words in the dictionaries" t)
(autoload 'dictionary-lookup-definition "dictionary" "Unconditionally lookup the word at point." t)
(autoload 'dictionary "dictionary" "Create a new dictionary buffer" t)
;; (autoload 'dictionary-mouse-popup-matching-words "dictionary" "Display entries matching the word at the cursor" t)
;; (autoload 'dictionary-popup-matching-words "dictionary" "Display entries matching the word at the point" t)
;; (autoload 'dictionary-tooltip-mode "dictionary" "Display tooltips for the current word" t)
;; (autoload 'global-dictionary-tooltip-mode "dictionary" "Enable/disable dictionary-tooltip-mode for all buffers" t)

;; (global-set-key (kbd "<mouse-3>") 'dictionary-mouse-popup-matching-words)
(global-set-key (kbd "C-c d") 'dictionary-lookup-definition)
(global-set-key (kbd "C-c s") 'dictionary-search)
(global-set-key (kbd "C-c m") 'dictionary-match-words)

;; choose a dictionary server
(setq dictionary-server "localhost")

;; for dictionary tooltip, choose the dictionary
;; (setq dictionary-tooltip-dictionary "xdict")
;; (global-dictionary-tooltip-mode t)
;; (dictionary-tooltip-mode t)

(require 'color-theme)
(color-theme-midnight)

(require 'cc-mode)
(define-key c-mode-base-map (kbd "RET") 'newline-and-indent)
;; (define-key c-mode-base-map (kbd "C-;") 'semantic-ia-complete-symbol-menu)

(define-key lisp-interaction-mode-map (kbd "RET") 'newline-and-indent)
(define-key emacs-lisp-mode-map (kbd "RET") 'newline-and-indent)

(require 'python)
(define-key python-mode-map (kbd "RET") 'newline-and-indent)

(require 'inf-haskell)

(require 'xcscope)
(define-key c-mode-base-map (kbd "C-=") 'cscope-find-global-definition-no-prompting)
(define-key c-mode-base-map (kbd "C--") 'cscope-find-functions-calling-this-function)
(define-key c-mode-base-map (kbd "C-;") 'cscope-pop-mark)
(define-key c-mode-base-map (kbd "C->") 'cscope-next-symbol)
(define-key c-mode-base-map (kbd "C-<") 'cscope-prev-symbol)

(add-hook 'c-mode-common-hook
          '(lambda ()
             (c-toggle-hungry-state 1)))

(add-hook 'java-mode-hook
          '(lambda ()
             (c-subword-mode)
             (setq c-basic-offset 2)))

(setq tab-stop-list
      (loop for i from 4 to 120 by 4 collect i))

(setq c-basic-offset 2)
(setq c-offsets-alist
      '((innamespace . 0)
        (brace-list-open . 0)
        (substatement-open . 0)
        (access-label . -)
        (inline-open . 0)
        (block-open . 0)))

(defun smart-compile ()
  "Compile programs accroding to mode.
Save buffers first. If makefile can be found, compile with
makefile; Otherwise, automatically generate compile command
accroding to mode."
  (interactive)
  (save-buffer)
  ;; find makefile
  (let ((candidate-make-file-name '("makefile" "Makefile" "GNUmakefile"))
        command)
    (if (not (null (find t candidate-make-file-name :key
                         '(lambda (f) (file-readable-p f)))))
        (setq command "make -k ")
      ;; makefile does not exist
      (let* ((filename (file-name-nondirectory buffer-file-name))
             (executable (file-name-sans-extension filename)))
        (cond ((eq major-mode 'c-mode)
               ;; add libs for header
               (setq command "gcc -Wall")
               (save-excursion
                 (goto-char (point-min))
                 (when (re-search-forward "^#include <mysql.h>" nil t)
                   (setq command (concat command " -I/usr/include/mysql -lmysqlclient")))
                                  (goto-char (point-min))
                 (when (re-search-forward "^#include <pthread.h>" nil t)
                   (setq command (concat command " -lpthread"))))
               (setq command (concat command " -o " executable " " filename)))
              ((eq major-mode 'c++-mode)
               ;; add libs for header
               (setq command "g++ -Wall")
               (save-excursion
                 (goto-char (point-min))
                 (when (re-search-forward "^#include <pthread.h>" nil t)
                   (setq command (concat command " -lpthread")))
                 (goto-char (point-min))
                 (when (re-search-forward "^#include <mysql.h>" nil t)
                   (setq command (concat command " -I/usr/include/mysql -lmysqlclient")))
                 (goto-char (point-min))
                 (when (re-search-forward "^#include *<boost/regex.hpp>" nil t)
                   (setq command (concat command " -lboost_regex")))
                 (goto-char (point-min))
                 (when (re-search-forward "^#include *<boost/signals.hpp>" nil t)
                   (setq command (concat command " -lboost_signals")))
                 (goto-char (point-min))
                 (when (or (re-search-forward "^#include *<unordered_set>" nil t)
                           (re-search-forward "^#include *<unordered_map>" nil t))
                   (setq command (concat command " -std=c++0x")))
                 (goto-char (point-min))
                 (when (re-search-forward "^#include <gmpxx.h>" nil t)
                   (setq command (concat command " -lgmp -lgmpxx"))))
               (setq command (concat command " -o " executable " " filename)))
              ((or (eq major-mode 'java-mode)
                   (eq major-mode 'jde-mode))
               (setq command (concat "LC_CTYPE=en_US.utf8 javac -Xlint " filename)))
              ((eq major-mode 'metapost-mode)
               (setq command (concat "mpost " filename))))
        (if (not (null command))
            ;; (compile (read-from-minibuffer "Compile command: " command))
          (compile command))))))

(defun smart-run ()
  "Run programs according to mode."
  (interactive)
  (let* ((filename (file-name-nondirectory buffer-file-name))
         (executable (file-name-sans-extension filename))
         (runbuffer (get-buffer-create (concat "*" executable "*")))
         command args)
    (message (concat "Running " executable))
    (cond ((or (eq major-mode 'c-mode) (eq major-mode 'c++-mode))
           (setq command (concat "./" executable)))
          ((or (eq major-mode 'java-mode) (eq major-mode 'jde-mode))
           (setq command "java")
           (setq args (list executable))))
    (save-excursion
      (set-buffer runbuffer)
      (erase-buffer)
      (insert (concat "default-directory: " default-directory "\n"))
      (insert (concat "\n" command " " (mapconcat (lambda (arg) arg)
                                                  args " ") "\n\n"))
      (comint-mode))
    (comint-exec runbuffer executable command nil args)
    (pop-to-buffer runbuffer)))

;; FIX: ansi-color-process-output: Marker does not point anywhere
(defadvice ansi-color-apply-on-region (around
                                       powershell-throttle-ansi-colorizing
                                       (begin end)
                                       activate compile)
  (progn
    (let ((start-pos (marker-position begin)))
      (cond
       (start-pos
        (progn
          ad-do-it))))))


(defun query-replace-variables (query replace)
  "Query replace each variables from current position or in region"
  (interactive
   (let* ((query (read-string "Query replace: "))
          (replace (read-string (format "Query replace %s with: " query))))
     (list query replace)))
  (let (beginning end)
    (if (and transient-mark-mode mark-active)
        (setq beginning (region-beginning)
              end (region-end))
      (setq beginning (point)
            end (point-max)))
    (query-replace-regexp
     (concat "\\<" query "\\>") replace nil beginning end)))
(define-key c-mode-base-map (kbd "C-c h") 'query-replace-variables)

(require 'gud)
(defun gdb-or-gud-go ()
  "If gdb isn't running; run gdb, else call gud-go."
  (interactive)
  (if (and gud-comint-buffer
           (buffer-name gud-comint-buffer)
           (get-buffer-process gud-comint-buffer)
           (with-current-buffer gud-comint-buffer (eq gud-minor-mode 'gdba)))
      (gud-call (if gdb-active-process "continue" "run") "")
    (gdb (gud-query-cmdline 'gdb))))

(defun gud-break-remove ()
  "Set/clear breakpoint."
  (interactive)
  (save-excursion
    (if (eq (car (fringe-bitmaps-at-pos (point))) 'breakpoint)
        (gud-remove nil)
      (gud-break nil))))

(defun gud-kill ()
  "Kill gdb process."
  (interactive)
  (with-current-buffer gud-comint-buffer (comint-skip-input))
  (kill-process (get-buffer-process gud-comint-buffer)))

(setq gdb-many-windows t)
(setq gdb-show-main t)
(setq gdb-use-separate-io-buffer t)
(setq gdb-create-source-file-list nil)

(define-key c-mode-base-map [f5] 'gdb-or-gud-go)
(define-key c-mode-base-map [S-f5] 'gud-kill)
(define-key c-mode-base-map [C-f5] 'smart-run)
(define-key c-mode-base-map [f7] 'compile)

(require 'meta-mode)
(define-key meta-mode-map (kbd "C-c C-c") 'smart-compile)
(define-key c-mode-base-map (kbd "C-c C-c") 'smart-compile)
(define-key java-mode-map (kbd "C-c C-c") 'smart-compile)
;; (define-key jde-mode-map (kbd "C-c C-c") 'smart-compile)

(define-key c-mode-base-map (kbd "C-c C-r") 'smart-run)
(define-key java-mode-map (kbd "C-c C-r") 'smart-run)
;; (define-key jde-mode-map (kbd "C-c C-r") 'smart-run) ;; jde-run

(define-key c-mode-base-map [f8] 'gud-print)
(define-key c-mode-base-map [C-f8] 'gud-pstar)
(define-key c-mode-base-map [f9] 'gud-break-remove)
(define-key c-mode-base-map [f10] 'gud-next)
(define-key c-mode-base-map [C-f10] 'gud-until)
(define-key c-mode-base-map [S-f10] 'gud-jump)
(define-key c-mode-base-map [f11] 'gud-step)
(define-key c-mode-base-map [C-f11] 'gud-finish)

(load "auctex.el" nil t t)
(load "tex-site.el" nil t t)
(load "preview-latex.el" nil t t)

(add-hook 'LaTeX-mode-hook
          '(lambda()
             (add-to-list 'TeX-command-list '("XeLaTeX" "xelatex %(mode) '%t'"
                                              TeX-run-TeX nil (latex-mode)
                                              :help "Run XeLaTex"))
             (setq TeX-command-default "XeLaTeX"
                   TeX-engine 'xetex
                   TeX-save-query nil
                   TeX-show-compilation t)))

(setq TeX-output-view-style
      '(("^dvi$" "." "evince %o")
        ("^pdf$" "." "evince %o")))

(add-to-list 'load-path "~/.emacs.d/yasnippet-0.6.1c")
(require 'yasnippet)
(yas/initialize)
(yas/load-directory "~/.emacs.d/yasnippet-0.6.1c/snippets")

(setq org-hide-leading-stars t)
;; (define-key global-map (kbd "C-c a") 'org-agenda)
;; (setq org-log-done 'time)

;; emacs server: opening files from terminal automatically edit in this window
(server-start)

;; session & desktop, put them at the bottom
(require 'session)
(add-hook 'after-init-hook 'session-initialize)
(require 'desktop)
(setq desktop-path '("~/.emacs.d/"))
(setq desktop-dirname "~/.emacs.d/")
(desktop-save-mode t)
