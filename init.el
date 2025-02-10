;;; init.el --- Load the full configuration -*- lexical-binding: t -*-
;;; Commentary:

;; This file bootstraps the configuration, which is divided into
;; a number of other files.

(add-to-list 'load-path (expand-file-name "lisp" user-emacs-directory)) ;user source code dir

(defconst *spell-check-support-enabled* nil)
(defconst *is-a-mac* (eq system-type 'darwin))

;; Adjust garbage collection thresholds during startup, and thereafter

(let ((normal-gc-cons-threshold (* 20 1024 1024))
      (init-gc-cons-threshold (* 128 1024 1024)))
  (setq gc-cons-threshold init-gc-cons-threshold)
  (add-hook 'emacs-startup-hook
	    (lambda () (setq gc-cons-threshold normal-gc-cons-threshold))))

(setq confirm-kill-emacs #'yes-or-no-p)
(setq inhibit-startup-screen t)
(setq make-backup-files nil) ; stop creating ~ files

(column-number-mode t) ; show column number in mode line
(global-display-line-numbers-mode 1) ; show line number 
(tool-bar-mode -1)
(when (display-graphic-p) (toggle-scroll-bar -1))

(electric-pair-mode t) ; auto paren
(add-hook 'prog-mode-hook #'show-paren-mode) ; highlight the other paren
(add-hook 'prog-mode-hook #'hs-minor-mode) ; zip code block

(global-set-key (kbd "C-c '") 'comment-or-uncomment-region) ; comment/uncomment select region
(global-set-key (kbd "C-v") 'set-mark-command)
(global-set-key "\C-ca" 'org-agenda)

;; Faster move cursor
(defun next-ten-lines()
  "Move cursor to next 10 lines."
  (interactive)
  (next-line 10))

(defun previous-ten-lines()
  "Move cursor to previous 10 lines."
  (interactive)
  (previous-line 10))
;; 绑定到快捷键
(global-set-key (kbd "M-n") 'next-ten-lines)            ; 光标向下移动 10 行
(global-set-key (kbd "M-p") 'previous-ten-lines)        ; 光标向上移动 10 行

(global-set-key (kbd "<f6>") 'org-capture)      ; capture function 

(global-set-key (kbd "C-j") nil)
;; 删去光标所在行（在图形界面时可以用 "C-S-<DEL>"，终端常会拦截这个按法)
(global-set-key (kbd "C-j C-k") 'kill-whole-line)

(provide 'init)
;;; init.el ends here
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(custom-enabled-themes '(tsdh-dark))
 '(org-agenda-files
   '("~/Documents/goals.org" "/Users/lich/Documents/zmed2.org"))
 '(org-capture-templates
   '(("j" "Journal entry" entry
      (file+olp+datetree "~/Documents/journal_2025.org")
      (file "~/Documents/emacs_templates/journal-day.txt"))
     ("w" "Work templates")
     ("wt" "TODO entry" entry
      (file+headline "~/Documents/power.org" "BackLog")
      (file "~/Documents/emacs_templates/todo.txt"))
     ("l" "Learn entry" entry
      (file+headline "~/Documents/goals.org" "Learning")
      (file "~/Documents/emacs_templates/learn.txt"))
     ("g" "New Goal entry" entry
      (file+headline "~/Documents/goals.org" "Goals")
      (file "~/Documents/emacs_templates/goal.txt"))
     ("i" "Idea backlog" entry
      (file+headline "~/Documents/goals.org" "Ideas")
      (file "~/Documents/emacs_templates/idea.txt"))))
 '(org-enforce-todo-dependencies t)
 '(org-export-backends '(ascii html icalendar latex md odt))
 '(org-log-into-drawer t)
 '(org-refile-allow-creating-parent-nodes 'confirm)
 '(org-refile-targets '((org-agenda-files :tag . ":maxlevel . 2")))
 '(org-refile-use-outline-path 'file)
 '(org-track-ordered-property-with-tag t)
 '(package-selected-packages '(markdown-mode rust-mode eglot ## evil org auctex)))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )

(require 'rust-mode)


(defun my/copy-idlink-to-clipboard() "Copy an ID link with the
headline to clipboard, if no ID is there then create a new unique
ID.  This function works only in org-mode or org-agenda buffers.

The purpose of this function is to easily construct id:-links to
org-mode items. If its assigned to a key it saves you marking the
text and copying to the clipboard."
       (interactive)
       (when (eq major-mode 'org-agenda-mode) ;if we are in agenda mode we switch to orgmode
     (org-agenda-show)
     (org-agenda-goto))
       (when (eq major-mode 'org-mode) ; do this only in org-mode buffers
     (setq mytmphead (nth 4 (org-heading-components)))
         (setq mytmpid (funcall 'org-id-get-create))
     (setq mytmplink (format "[[id:%s][%s]]" mytmpid mytmphead))
     (kill-new mytmplink)
     (message "Copied %s to clipboard" mytmplink)
       ))

(global-set-key (kbd "<f5>") 'my/copy-idlink-to-clipboard)
