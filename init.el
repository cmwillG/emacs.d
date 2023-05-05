;;; package --- Summary
;;; Commentary:

;;; Code:
;;; Basic config
(tool-bar-mode -1) ;;remove tool bar
(set-scroll-bar-mode nil)
(global-visual-line-mode 1);; autowrap line
; default windows size
(set-frame-width (selected-frame) 110)
(set-frame-height (selected-frame) 33)

;; spell check config
(setq-default ispell-program-name "aspell")


;;; org-mode settings
(global-set-key (kbd "C-c l") #'org-store-link)
(global-set-key (kbd "C-c a") #'org-agenda)
(global-set-key (kbd "C-c c") #'org-capture)
(setq org-src-fontify-natively t)
;; chinese support
(add-hook 'org-mode-hook (lambda ()
			   (keyboard-translate ?¥ ?$)
			   (keyboard-translate ?· ?`)
			   (keyboard-translate ?\《 ?<)
			   (keyboard-translate ?\》 ?>)
			   (keyboard-translate ?、 ?\\)
			   (keyboard-translate ?\「 ?{)
			   (keyboard-translate ?\」 ?})
			   (keyboard-translate ?～ ?~)))
;; source code setting
(org-babel-do-load-languages 'org-babel-load-languages
			     '((emacs-lisp . t)))


;; show line number
(global-display-line-numbers-mode 1)

;; eww browser settings /emacs is so powerful!!!!!/
(setq
 browse-url-browser-function 'eww-browse-url ; Use eww as the default browser
 shr-use-fonts  nil                          ; No special fonts
 shr-use-colors nil                          ; No colours
 shr-indentation 2                           ; Left-side margin
 shr-width 70                                ; Fold text to 70 columns
 eww-search-prefix "https://bing.com/?q=")    ; Use another engine for searching



;; package using china mirror
(require 'package)
(setq package-archives '(("gnu" . "https://mirrors.ustc.edu.cn/elpa/gnu/")
                         ("melpa" . "https://mirrors.ustc.edu.cn/elpa/melpa/")
                         ("nongnu" . "https://mirrors.ustc.edu.cn/elpa/nongnu/")))
(package-initialize)
;; install use-package
(unless (package-installed-p 'use-package)
  (package-refresh-contents)
  (package-install 'use-package))
(eval-and-compile
  (setq use-package-always-ensure t
        use-package-expand-minimally t))


; Package Set-up
;; org-roam setting
(use-package org-roam
  :defer t
  :ensure t
  :config
  (setq org-roam-directory (file-truename "~/Documents/org-roam"))
  (org-roam-db-autosync-mode)
  (setq org-roam-completion-everywhere t)
  :bind
  (("C-c n f" . org-roam-node-find)
   ("C-c n i" . org-roam-node-insert))
  )

;; yasnippet
(use-package yasnippet
  :ensure t
  :init
  (yas-global-mode 1)
  :bind
  (:map yas-minor-mode-map
        ("C-c y". yas-expand)
        ([(tab)] . nil)
        ("TAB" . nil))
  ("C-c C-y C-n" . yas-new-snippet)
  )

;; doom theme
(use-package doom-themes
  :ensure t
  :config
  ;; Global settings (defaults)
  (setq doom-themes-enable-bold t    ; if nil, bold is universally disabled
        doom-themes-enable-italic t) ; if nil, italics is universally disabled
  (load-theme 'doom-one t)

  ;; Enable flashing mode-line on errors
  (doom-themes-visual-bell-config)
  ;; Enable custom neotree theme (all-the-icons must be installed!)
  ;;(doom-themes-neotree-config)
  ;; or for treemacs users
  ;;(setq doom-themes-treemacs-theme "doom-atom") ; use "doom-colors" for less minimal icon theme
  ;;(doom-themes-treemacs-config)
  ;; Corrects (and improves) org-mode's native fontification.
  (doom-themes-org-config))

;; mode line
(use-package doom-modeline
  :ensure t
  :init (doom-modeline-mode 1)
  :config
  (setq doom-modeline-minor-modes t
	doom-modeline-enable-word-count t
	doom-modeline-time t)
  )

;; ivy mode
(use-package counsel
  :ensure t
  :config
  (ivy-mode 1)
  (setq ivy-use-virtual-buffers t
        ivy-count-format "%d/%d ")
  :bind
  (("C-s" . swiper-isearch)
   ("M-x" . counsel-M-x)
   ("C-x C-f" . counsel-find-file)
   ("C-x b" . ivy-switch-buffer))
  )

;; company
(use-package company
  :ensure t
  :init (global-company-mode)
  :config
  (setq company-minimum-prefix-length 1)
  (setq company-idle-delay 0.0)
  (setq company-transformers '(company-sort-by-occurrence))
  (setq company-show-quick-access t)
  (setq company-tooltip-limit 10)
  (setq company-tooltip-align-annotations t)
  (setq company-tooltip-flip-when-above t)
  )
;; company-box
(use-package company-box
  :ensure t
  :if window-system
  :hook (company-mode . company-box-mode))

;; python setting
(use-package anaconda-mode
  :defer t
  :ensure t
  :config
  (add-hook 'python-mode-hook 'anaconda-mode)
  )

(use-package company-anaconda
  :ensure t
  :init (require 'rx)
  :after (company)
  :config
  (add-to-list 'company-backends 'company-anaconda)
  )

(use-package company-quickhelp
  ;; Quickhelp may incorrectly place tooltip towards end of buffer
  ;; See: https://github.com/expez/company-quickhelp/issues/72
  :ensure t
  :config
  (company-quickhelp-mode)
  )
; this package is used to interact with conda
(use-package conda
  :defer t
  :ensure t
  :init
  (setq conda-anaconda-home (expand-file-name "~/miniconda3"))
  (setq conda-env-home-directory (expand-file-name "~/miniconda3"))
  )


;---------------------------------------------------

;; which-key
(use-package which-key
  :ensure t
  :init
  (setq which-key-idle-delay 0.5
	which-key-idle-second-delay 1.0)
  :config
  (which-key-mode))

;; flycheck
(use-package flycheck
  :ensure t
  :init (global-flycheck-mode)
  :config
  (setq truncate-lines nil) ; 如果单行信息很长会自动换行
  )

;; flyspell
(use-package flyspell
  :ensure t
  :hook
  (org-mode . flyspell-mode)
  (latex-mode . flyspell-mode)
  (prog-mode . flyspell-mode)
  )

;; rainbow-delimiters
(use-package rainbow-delimiters
  :ensure t
  :hook (prog-mode . rainbow-delimiters-mode))

;; page-break-line
(use-package page-break-lines
  :ensure t
  :config (global-page-break-lines-mode t)
  )


;; all the icon
(use-package all-the-icons
  :ensure t
  :if (display-graphic-p))

;; dashboard
(use-package dashboard
  :ensure t
  :init
  (setq dashboard-banner-logo-title "")
  (setq dashboard-startup-banner 'logo)
  (setq dashboard-page-separator "\n\f\n")
  (setq dashboard-path-style 'truncate-middle)
  (setq dashboard-path-max-length 60)
  (setq dashboard-icon-type 'all-the-icons) ;; use `all-the-icons' package
  (setq dashboard-set-heading-icons t)
  (setq dashboard-set-file-icons t)
  (setq dashboard-items '((recents . 5)
			  (bookmarks . 5)))
  (setq dashboard-modify-heading-icons '((recents . "file-text")
                                  (bookmarks . "book")))
  (setq dashboard-set-init-info nil)
  (setq dashboard-set-footer nil)
  (dashboard-setup-startup-hook))

(use-package tex
  :defer t
  :ensure auctex
  :config
  (setq TeX-auto-save t)
  (setq TeX-parse-self t)
  (setq-default TeX-master nil)
  )

(use-package reftex
  :defer t
  :ensure t
  :hook
  (LaTeX-mode-hook . turn-on-reftex)
  )

(use-package magit
  :ensure t
  )

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(custom-safe-themes
   '("3c83b3676d796422704082049fc38b6966bcad960f896669dfc21a7a37a748fa" default))
 '(package-selected-packages
   '(doom-modeline doom-themes smart-mode-line page-break-lines all-the-icons dashboard conda pyenv company-quickhelp company-anaconda anaconda-mode dracula-theme flycheck company-box rainbow-delimiters which-key company yasnippet use-package org-roam nord-theme counsel)))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(rainbow-delimiters-depth-1-face ((t (:foreground "red"))))
 '(rainbow-delimiters-depth-2-face ((t (:foreground "black"))))
 '(rainbow-delimiters-depth-3-face ((t (:foreground "black"))))
 '(rainbow-delimiters-depth-4-face ((t (:foreground "red"))))
 '(rainbow-delimiters-depth-5-face ((t (:foreground "black"))))
 '(rainbow-delimiters-depth-6-face ((t (:foreground "black"))))
 '(rainbow-delimiters-depth-7-face ((t (:foreground "red"))))
 '(rainbow-delimiters-depth-8-face ((t (:foreground "black"))))
 '(rainbow-delimiters-depth-9-face ((t (:foreground "black"))))
 '(rainbow-delimiters-unmatched-face ((t (:background "cyan")))))

(provide 'init)
;;; init.el ends here
