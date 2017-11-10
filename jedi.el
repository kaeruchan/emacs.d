;;; jedi.el ---                                      -*- lexical-binding: t; -*-
 (jedi:setup)
  (define-key jedi-mode-map (kbd "<C-tab>") nil) ;;C-tabはウィンドウの移動に用いる
  (setq jedi:complete-on-dot t)
  (setq ac-sources
    (delete 'ac-source-words-in-same-mode-buffers ac-sources)) ;;jediの補完候補だけでいい
  (add-to-list 'ac-sources 'ac-source-filename)
  (add-to-list 'ac-sources 'ac-source-jedi-direct)
  (define-key python-mode-map "\C-ct" 'jedi:goto-definition)
  (define-key python-mode-map "\C-cb" 'jedi:goto-definition-pop-marker)
  (define-key python-mode-map "\C-cr" 'helm-jedi-related-names)



;; Copyright (C) 2017  ShenTianji

;; Author: ShenTianji <shentianji@ShenTianji-no-MacBook-Air.local>
;; Keywords: abbrev, 
