;; go
(defun go-test-current-package-coverage ()
  (interactive)
  (shell-command (concat "go test . -coverprofile=" go--coverage-current-file-name) (messages-buffer))
  (if current-prefix-arg
      (shell-command (concat "go tool cover -html=" go--coverage-current-file-name))
    (go-coverage)))

(setq go-projectile-tools-path (expand-file-name "~/gotools")
      go-test-verbose t
      go--coverage-current-file-name "cover.out")

;; Release tools
;;(add-to-list 'go-projectile-tools '(gvt . "github.com/FiloSottile/gvt"))
;;(add-to-list 'go-projectile-tools '(github-release . "github.com/aktau/github-release"))

(eval-after-load 'go-mode
  '(progn
     (setenv "GOPATH" (getenv "HOME"))
     (remove-hook 'projectile-after-switch-project-hook 'go-projectile-switch-project)

     (let ((map go-mode-map))
       (define-key map (kbd "C-c c") 'go-test-current-package-coverage))))
