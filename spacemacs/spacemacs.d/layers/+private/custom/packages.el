;;; funcs.el - custom layer file for Spacemacs
;;
;; Copyright (c) 2018 Seong Yong-ju
;;
;; Author: Seong Yong-ju <sei40kr@gmail.com>
;; URL: https://github.com/sei40kr/dotfiles
;;
;; This file is not part of GNU Emacs
;;
;;; License: MIT

(setq custom-packages
  '(
     avy
     company
     (competitive-programming-snippets :location local)
     edit-server
     evil
     evil-escape
     evil-magit
     evil-mc
     evil-surround
     exec-path-from-shell
     expand-region
     flycheck
     flycheck-popup-tip
     helm
     helm-ls-git
     linum
     linum-relative
     lsp-intellij
     magit
     neotree
     projectile
     python-mode
     ranger
     ruby-mode
     semantic
     solidity-mode
     spaceline
     spacemacs-theme
     ;; tabbar
     yatemplate))

(setq custom-excluded-packages '())

(defun custom/post-init-avy ()
  (setq avy-timeout-seconds 0.0))

(defun custom/post-init-company ()
  ;; Fix the behaviors of C-h, C-w on auto-completing.
  ;; cf https://github.com/syl20bnr/spacemacs/issues/4243
  (with-eval-after-load 'company
    (define-key company-active-map (kbd "C-h") #'delete-backward-char)
    (define-key company-active-map (kbd "C-w") #'backward-kill-word)))

(defun custom/init-competitive-programming-snippets ()
  (use-package competitive-programming-snippets))

(defun custom/post-init-edit-server ()
  (setq edit-server-url-major-mode-alist
    '("aidemy\\.net" . python-mode)))

(defun custom/pre-init-evil ()
  (setq
    evil-want-C-i-jump t
    evil-want-C-u-scroll t)
  (with-eval-after-load 'evil
    (evil-global-set-key 'normal (kbd "C-s") #'spacemacs/save-some-buffers)
    (evil-global-set-key 'insert (kbd "C-h") #'backward-delete-char-untabify)
    (define-key minibuffer-local-map (kbd "C-h") #'evil-ex-delete-backward-char)
    (define-key minibuffer-local-map (kbd "C-w") #'backward-kill-word)))

(defun custom/post-init-evil-escape ()
  (setq evil-escape-key-sequence "jk"))

(defun custom/pre-init-evil-magit ()
  (eval-after-load 'evil-magit
    '(evil-define-key evil-magit-state magit-mode-map
       "q" #'spacemacs/magit-mode-kill-buffer)))

(defun custom/post-init-evil-mc ()
  (setq evil-mc-one-cursor-show-mode-line-text nil)
  (evil-global-set-key 'normal
    (kbd "C-n") #'spacemacs/evil-mc-make-and-goto-next-match)
  (evil-global-set-key 'visual
    (kbd "C-n")
    #'(lambda (beginning end)
        (interactive (list (region-beginning) (region-end)))
        (if (= (line-number-at-pos beginning) (line-number-at-pos end))
          (spacemacs/evil-mc-make-and-goto-next-match)
          (spacemacs/evil-mc-make-vertical-cursors))))
  (with-eval-after-load 'evil-mc
    (advice-add 'evil-mc-define-vars
      :after #'spacemacs//evil-mc-define-vars-after)
    (evil-define-key 'normal evil-mc-key-map
      (kbd "C-n") #'evil-mc-make-and-goto-next-match
      (kbd "C-m") #'evil-mc-make-and-goto-prev-match
      (kbd "C-x") #'evil-mc-skip-and-goto-next-match
      (kbd "C-p") nil
      (kbd "C-t") nil
      (kbd "<escape>") #'spacemacs/evil-mc-undo-all-cursors)
    (evil-define-key 'visual evil-mc-key-map
      (kbd "C-n") nil
      (kbd "C-p") nil
      (kbd "C-t") nil)))

(defun custom/post-init-evil-surround ()
  (eval-after-load 'evil-surround
    '(evil-define-key 'visual evil-surround-mode-map
      (kbd "s") 'evil-substitute
      (kbd "S") 'evil-surround-region)))

(defun custom/pre-init-exec-path-from-shell ()
  (setq
    exec-path-from-shell-arguments '("-l")
    exec-path-from-shell-check-startup-files nil
    exec-path-from-shell-variables '("PATH" "MANPATH" "RUST_SRC_PATH")))

(defun custom/post-init-expand-region ()
  (evil-global-set-key 'visual (kbd "v") #'er/expand-region)
  (evil-global-set-key 'visual (kbd "V") #'er/contract-region))

(defun custom/post-init-flycheck ()
  (setq
    flycheck-display-errors-delay 0.3
    flycheck-check-syntax-automatically '(save mode-enabled)))

(defun custom/init-flycheck-popup-tip ()
  (use-package flycheck-popup-tip
    :defer t
    :init
    (add-hook 'flycheck-mode-hook #'flycheck-popup-tip-mode)
    :custom
    (flycheck-popup-tip-error-prefix "* ")))

(defun custom/post-init-helm ()
  (custom-set-variables
    '(helm-mini-default-sources '(helm-source-buffers-list)))
  ;; Fix the behaviors of C-h, C-w in helm.
  ;; cf https://github.com/syl20bnr/spacemacs/issues/4243
  (with-eval-after-load 'helm
    (define-key helm-map (kbd "C-h") #'delete-backward-char)
    (define-key helm-map (kbd "C-w") #'backward-kill-word)
    (define-key helm-find-files-map (kbd "C-h") #'delete-backward-char)
    (define-key helm-find-files-map (kbd "C-w") #'backward-kill-word)))

(defun custom/init-helm-ls-git ()
  (use-package helm-ls-git
    :defer t
    :init
    (eval-after-load 'evil
      '(evil-global-set-key 'normal (kbd "C-p") 'helm-ls-git-ls))
    :custom
    (helm-ls-git-fuzzy-match t)
    (helm-ls-git-default-sources '(helm-source-ls-git))
    (helm-ls-git-ls-switches '("ls-files" "-co" "--exclude-standard" "--"))))

(defun custom/post-init-linum ()
  (setq linum-delay t))

(defun custom/post-init-linum-relative ()
  (setq linum-relative-format " %3s "))

(defun custom/pre-init-lsp-intellij ()
  (if (configuration-layer/layer-used-p 'lsp)
    (progn
      (if (configuration-layer/package-used-p 'company)
        (spacemacs//lsp-intellij-setup-company-rjsx-mode))
      (spacemacs//lsp-intellij-setup-leader-keys 'rjsx-mode)
      (add-hook 'rjsx-mode-hook #'lsp-intellij-enable))))

(defun custom/post-init-magit ()
  (setq
    magit-refresh-status-buffer nil
    magit-repository-directories
    (if (spacemacs/system-is-mac)
      '(("~/dotfiles" . 5) ("~/Develop" . 3))
      '(("~/dotfiles" . 5) ("~/dev/ws" . 3)))
    magit-repolist-columns
    '(
       ("Name" 25 magit-repolist-column-ident nil)
       ("Version" 25 magit-repolist-column-version nil)
       ("Path" 99 magit-repolist-column-path nil))))

(defun custom/post-init-neotree ()
  (setq
    neo-confirm-create-directory 'off-p
    neo-confirm-create-file 'off-p
    neo-confirm-delete-directory-recursively 'off-p
    neo-confirm-delete-file 'y-or-n-p
    neo-confirm-kill-buffers-for-files-in-directory 'off-p
    neo-force-change-root t
    neo-smart-open t
    neo-theme 'arrow)
  (if (eq system-type 'darwin)
    (setq neo-default-system-application "qlmanage -p")))

(defun custom/post-init-projectile ()
  (setq
    projectile-find-dir-includes-top-level t
    projectile-git-submodule-command nil
    projectile-sort-order 'default
    projectile-switch-project-action #'spacemacs//projectile-switch-project-action
    projectile-use-git-grep t)
  (with-eval-after-load 'projectile
    (require 'magit)
    (mapc 'projectile-add-known-project
      (mapcar 'file-name-as-directory (magit-list-repos)))))

(defun custom/pre-init-python-mode ()
  (add-hook 'python-mode-hook #'spacemacs//python-set-evil-shift-width))

(defun custom/pre-init-ranger ()
  (setq ranger-key nil))

(defun custom/pre-init-ruby-mode ()
  (add-hook 'ruby-mode-hook #'spacemacs//ruby-set-evil-shift-width))

(defun custom/pre-init-rust-mode ()
  (add-hook 'rust-mode-hook #'spacemacs//rust-set-evil-shift-width))

(defun custom/post-init-semantic ()
  (require 'mode-local)
  (setq-mode-local emacs-lisp-mode
    semanticdb-find-default-throttle '(file local project unloaded system)))

(defun custom/init-solidity-mode ()
  (use-package solidity-mode))

(defun custom/post-init-spaceline ()
  (setq spaceline-show-default-input-method t)
  (advice-add 'spaceline-compile :before #'spacemacs//spaceline-compile-before))

(defun custom/post-init-spacemacs-theme ()
  (setq spacemacs-theme-comment-italic t))

;; (defun custom/init-tabbar ()
;;   (use-package tabbar
;;     :config
;;     (progn
;;       (tabbar-mode)
;;       (global-set-key [M-left] 'tabbar-backward-tab)
;;       (global-set-key [M-right] 'tabbar-forward-tab))
;;     :custom
;;     (tabbar-buffer-groups-function
;;       #'spacemacs//tabbar-buffer-groups-by-projectile-project)
;;     (tabbar-buffer-list-function #'spacemacs//tabbar-buffer-list)
;;     (tabbar-use-images nil)))

(defun custom/init-yatemplate ()
  (use-package yatemplate
    :config
    (progn
      (auto-insert-mode t)
      (yatemplate-fill-alist))
    :custom
    (yatemplate-dir (expand-file-name "templates" dotspacemacs-directory))
    (yatemplate-separator "_")))
