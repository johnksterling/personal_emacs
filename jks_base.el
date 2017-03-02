;; UI Treatment on Mac OS
(when (memq window-system '(mac ns))
  (set-face-font 'default "Monaco-13")
  (setq mac-command-modifier 'meta)
  (setq mac-option-modifier 'super)
  (setq mouse-drag-copy-region t))

;; whitespace
(defun jks-auto-fill-mode ()
  (setq fill-column 120)
  (auto-fill-mode))
(add-hook 'text-mode-hook 'jks-auto-fill-mode)

;; nav key bindings
(defun backward-whitespace ()
  (interactive)
  (forward-whitespace -1))

(global-set-key (kbd "M-*") 'pop-tag-mark)
(global-set-key (kbd "M-<right>") 'forward-whitespace)
(global-set-key (kbd "M-<left>") 'backward-whitespace)
(global-set-key (kbd "C-x C-o") 'ff-find-other-file)
(global-set-key (kbd "C-x e") 'compile)
(global-set-key (kbd "M-c") 'recompile)
(global-set-key (kbd "C--") 'negative-argument)

;; turn off the beep!
(setq visible-bell t)

;; elisp
(define-key emacs-lisp-mode-map (kbd "C-c C-r") 'eval-region)

;; js/json
(setq-default js-indent-level 2
              json-reformat:indent-width 2
              jsons-path-printer 'jsons-print-path-jq)

;; sh
(setq-default sh-basic-offset 2
              sh-indentation 2)

;; docker
(prelude-require-package 'docker)
(docker-global-mode)

(defadvice docker-containers (before docker-containers-url-at-point)
  "If `url-get-url-at-point' returns a tcp:// url, setenv DOCKER_HOST url."
  (let ((url (url-get-url-at-point)))
    (when (and url (s-starts-with? "tcp://" url))
      (message "setenv DOCKER_HOST=%s" url)
      (setenv "DOCKER_HOST" url))))

(ad-activate 'docker-containers)

;; .dir-locals.el
(setq enable-local-eval t
      enable-local-variables :all)

;; server
(require 'server)
(unless (server-running-p) (server-start))

;; term
(add-hook 'term-mode-hook
          (lambda ()
            (prelude-off)
            (define-key term-raw-map (kbd "C-'") 'term-line-mode)
            (define-key term-mode-map (kbd "C-'") 'term-char-mode)
            (define-key term-raw-map (kbd "C-y") 'term-paste)))

;; bats
(prelude-require-package 'bats-mode)
(add-hook 'bats-mode-hook
          (lambda ()
            (let ((map bats-mode-map))
              (define-key map (kbd "C-c a") 'bats-run-all)
              (define-key map (kbd "C-c m") 'bats-run-current-file)
              (define-key map (kbd "C-c .") 'bats-run-current-test))))

;; auto-mode
(add-to-list 'auto-mode-alist '("\\.markdown$" . gfm-mode))

;; misc
(prelude-require-packages '(list-environment
                            powershell
                            strace-mode))

(setq dired-listing-switches "-laX")

(setq ping-program-options '("-c" "10"))

(setq diff-switches "-u")

(setq sort-fold-case t)

(display-time-mode 1)
(setq display-time-default-load-average nil)
(persistent-scratch-setup-default)
(setq initial-buffer-choice "~/sterling/log.org")
(end-of-buffer)
(defun run-python-once ()
  (remove-hook 'python-mode-hook 'run-python-once)
  (run-python (python-shell-parse-command)))

(add-hook 'python-mode-hook 'run-python-once)
