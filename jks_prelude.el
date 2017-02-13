;; load prelude modules
(require 'prelude-company)
(require 'prelude-c)
(require 'prelude-emacs-lisp)
(require 'prelude-go)
(require 'prelude-python)
(require 'prelude-js)
(require 'prelude-key-chord)
(require 'prelude-org)
(require 'prelude-shell)
(require 'prelude-ido)

;; ido
(prelude-require-package 'ido-vertical-mode)
(ido-vertical-mode t)
(setq ido-vertical-define-keys 'C-n-and-C-p-only)
;; projectile
(prelude-require-packages '(ag))
(setq ag-highlight-search t)
(setq grep-highlight-matches 'auto)
(setq projectile-use-git-grep t)
(setq projectile-sort-order 'recentf)
(setq projectile-switch-project-action 'jks-projectile-switch-project-hook)

(let ((map prelude-mode-map))
  (define-key map (kbd "s-g") 'projectile-grep)
  (define-key map (kbd "s-f") 'projectile-find-file)
  (define-key map (kbd "s-s") 'projectile-ag)
  (define-key map (kbd "C-c W") 'browse-url-at-point)
  (define-key map (kbd "C-c w") (lambda ()
                                  (interactive)
                                  (eww (browse-url-url-at-point)))))

;; dir-locals based project config without the .dir-locals.el file
(dir-locals-set-class-variables
 'project-locals
 '((nil . ((eval . (jks-projectile-project-locals))))))

(defun jks-projectile-project-locals ()
  (let ((project (projectile-project-name)))
    (cond
     ((string= project "auditor")
      (progn
        (setq-default sh-basic-offset 4 sh-indentation 4)))
     ((string= project "reactor_load_codes")
      (progn
        (setq-default sh-basic-offset 4 sh-indentation 4)
        (setq-local projectile-project-compilation-cmd "bootstrap.sh")
        (setq-local projectile-project-test-cmd "runtests.py")
        )))))

(defun jks-projectile-switch-project-hook ()
  (dir-locals-set-directory-class (projectile-project-root) 'project-locals)
  (projectile-vc))

;; midnight.el
(dolist (re '("^\\*ag search " "^\\*godoc "))
  (add-to-list 'clean-buffer-list-kill-regexps re))

;; flycheck
(prelude-require-packages '(flycheck-cask flycheck-color-mode-line))
(setq flycheck-emacs-lisp-load-path 'inherit)
(eval-after-load 'flycheck
  '(progn
     (delq 'mode-enabled flycheck-check-syntax-automatically)
     (add-hook 'flycheck-mode-hook 'flycheck-cask-setup)
     (add-hook 'flycheck-mode-hook 'flycheck-color-mode-line-mode)
     (setq flycheck-go-vet-shadow t)))

;; prelude git
(prelude-require-packages '(magit-gerrit magit-gh-pulls git-link))
(eval-after-load 'magit
  '(progn
     (setq magit-revision-show-gravatars nil)
     (add-hook 'magit-mode-hook 'turn-on-magit-gh-pulls)
     (require 'magit-gerrit)))
