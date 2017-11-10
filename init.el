;; Last Updated: <2014/03/18 15:10:44 from Zeppelin.local by yoshito>


; -*- Mode: Emacs-Lisp ; Coding: utf-8 -*-
;; ------------------------------------------------------------------------


;; @ load-path

;; load environment value
;; (load-file (expand-file-name "~/.emacs.d/shellenv.el"))
;; (dolist (path (reverse (split-string (getenv "PATH") ":")))
;;   (add-to-list 'exec-path path))


;; より下に記述した物が PATH の先頭に追加されます


(setenv "MANPATH" (concat "/usr/local/man:/usr/share/man:/opt/local/man:/Developer/usr/share/man:/sw/share/man" (getenv "MANPATH")))
(setenv "PATH" (concat "Library/Tex/texbin:" (getenv "PATH")))

;; ;;Load-Pathtの追加関数
(defun add-to-load-path (&rest paths)
  (let (path)
    (dolist (path paths paths)
      (let ((default-directory (expand-file-name (concat user-emacs-directory path))))
        (add-to-list 'load-path default-directory)
        (if (fboundp 'normal-top-level-add-subdirs-to-load-path)
            (normal-top-level-add-subdirs-to-load-path))))))

;; ;; load-pathに追加するフォルダ
;; ;; 2つ以上フォルダを指定する場合の引数 => (add-to-load-path "elisp" "xxx" "xxx")
(add-to-load-path  "elisp")
                 

(eval-when-compile
  (require 'cl))



;他のエディタでファイルが更新されたら自動でrevert
(global-auto-revert-mode 1) 

;; カレントディレクトリをFinderで開く------------------------
(defun open-current-dir-with-finder ()
  (interactive)
  (shell-command (concat "open .")))
(global-set-key "\C-cf" 'open-current-dir-with-finder)


;; package.el -------------------------------------------------
(require 'package)
(add-to-list 'package-archives '("marmalade" . "http://marmalade-repo.org/packages/"))
(add-to-list 'package-archives '("melpa" . "http://melpa.milkbox.net/packages/") t)
(package-initialize)


;; ;; load environment variables -------------------------------
;; (let ((envs '("PATH" "C_INCLUDE_PATH" "CPLUS_INCLUDE_PATH" "TEXINPUTS" "BSTINPUTS" "BIBINPUTS")))
;; (exec-path-from-shell-copy-envs envs))


;;基本的なもの -------------------------------
;; スタートアップ非表示
;; (setq inhibit-startup-screen t)

(fset 'yes-or-no-p 'y-or-n-p)

(if (>= emacs-major-version 24)
    (electric-pair-mode t))

;; バッファの名前が重複した場合、上のフォルダまで表示する
(require 'uniquify)
(setq uniquify-buffer-name-style 'post-forward-angle-brackets)

;; ;; 1行ずつスクロール
;; (setq scroll-conservatively 35
;;       scroll-margin 0
;;       scroll-step 1)
;; (setq comint-scroll-show-maximum-output t) ;; shell-mode

;; ;; タブをスペースで扱う
(setq-default indent-tabs-mode nil)


;; scratchの初期メッセージ消去
(setq initial-scratch-message "")

;meta keyの変更
(setq ns-command-modifier (quote meta))
(setq ns-alternate-modifier (quote super))

(keyboard-translate ?\C-h ?\C-?)
(global-set-key "\C-h" nil)
;; (global-set-key "\C-z" 'undo)
(global-set-key "\C-x\C-b" 'electric-buffer-list)
;; (global-set-key "\C-j" 'newline-and-indent)

;; original
;;backword 1単語削除
(defun backward-kill-word-or-kill-region ()
  (interactive)
  (if (or (not transient-mark-mode) (region-active-p))
      (kill-region (region-beginning) (region-end))
    (backward-kill-word 1)))
(global-set-key "\C-w" 'backward-kill-word-or-kill-region)

(global-set-key "\M-h" 'backward-kill-word)
(global-set-key "\M-'" 'dabbrev-expand)

;; (global-set-key "\M-p" 'backward-paragraph)
;; (global-set-key "\M-n" 'forward-paragraph)
(global-set-key [C-M-f5] 'goto-line)
;; (global-set-key "\C-cr" 'rename-uniquely)
(global-set-key "\C-o" 'open-line)
(global-set-key "\M-n" (lambda () (interactive) (scroll-up 1)))
(global-set-key "\M-p" (lambda () (interactive) (scroll-down 1)))
(global-set-key "\M-N" (lambda () (interactive) (scroll-up 10)))
(global-set-key "\M-P" (lambda () (interactive) (scroll-down 10)))
		
(global-set-key "\C-@" 'ispell-word)
(global-set-key "\M-@" 'ispell-complete-word)



;(global-set-key [C-backspace] 'backward-kill-word)
(global-set-key [end] 'end-of-buffer)
(global-set-key [home] 'beginning-of-buffer)

;;色-------------------------------------------------------------------

;見分けやすさと美しさの両立を実現した (自分の基準で) 色配分。
;(set-foreground-color "lavender")
;(set-background-color "dark slate gray")
;(set-cursor-color "yellow")
;(set-face-foreground 'font-lock-comment-face "DeepSkyBlue")
;(set-face-foreground 'font-lock-string-face  "grey50")
;(set-face-foreground 'font-lock-constant-face "cyan")
;(set-face-foreground 'font-lock-keyword-face "#ff0066")
;(set-face-foreground 'font-lock-function-name-face "#d6de51")
;(set-face-foreground 'font-lock-variable-name-face "orange1")
;(set-face-foreground 'font-lock-type-face "RoyalBlue1")


;; ;パステルっぽい


(set-foreground-color "snow")
(set-background-color "black")
(set-cursor-color "yellow")
(set-face-foreground 'font-lock-comment-face "#6c91d2")
(set-face-foreground 'font-lock-string-face  "grey50")
(set-face-foreground 'font-lock-constant-face "#89c6ec")
(set-face-foreground 'font-lock-keyword-face "#d26ca5")
(set-face-foreground 'font-lock-function-name-face "#deaf60")
(set-face-foreground 'font-lock-variable-name-face "#e59975")
(set-face-foreground 'font-lock-type-face "#c5f7eb")

;; 起動時のフレームサイズ
 (setq default-frame-alist
      (append
       '((top . 0) (left . 0) (width . 115 ) (height . 56)) ;; ウィンドウサイズ 
       default-frame-alist))

;; ウィンドウサイズの確認手順
;; scratchバッファで
;; (frame-width) C-j
;; (frame-height) C-j


;;追加ライブラリとそのキーバインド---------------------------------------

;一行コピー
;; (load-library "copy-line")
;; (global-set-key "\C-o" 'copy-line)

;touch
(load-library "touch")


;; 画面左に行番号表示
(require 'linum)
(global-linum-mode)
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(linum-highlight-face ((t (:foreground "black" :background "SkyBlue3")))))

(setq linum-delay t)
(defadvice linum-schedule (around my-linum-schedule () activate)
  (run-with-idle-timer 0.2 nil #'linum-update-current))


;; (load-library "fold-dwim")
;ダブルクリックで，折りたたみtoggleを発動
;; (global-set-key [(double-mouse-1)] 'fold-dwim-toggle)
;all showとall hide ...うまく行かなかったのでやっぱり無し．
;;(global-set-key "\C-c\C-s" 'fold-dwim-show-all)
;;(global-set-key "\C-c\C-h" 'fold-dwim-hide-all)




;; 最近使ったファイルをメニューに表示
(recentf-mode t)

;; 最近使ったファイルの表示数
;(setq recentf-max-menu-items 10)

;; 行間
;(setq-default line-spacing 0)
;; バックアップを残さない
;(setq make-backup-files nil)

;; ;;カーソルの点滅を止めます
(blink-cursor-mode -1) 

;; ; 言語を日本語にする
(set-language-environment 'Japanese)
;; ; 極力UTF-8とする
(prefer-coding-system 'utf-8)

;; 好きなフォントを設定しましょう
 (set-face-attribute 'default nil
                     :family "Ricty"
                     :height 180         ;デフォルトは140
                     )

(set-fontset-font
  (frame-parameter nil 'font)
    'japanese-jisx0208
    '("Ricty" . "iso10646-1"))
(set-fontset-font
  (frame-parameter nil 'font)
    'japanese-jisx0212
    '("Ricty" . "iso10646-1")) 



;; ;;フォント
;; (when (>= emacs-major-version 23)
;;  (set-face-attribute 'default nil
;;                      :family "monaco"
;;                      ;; :height 170
;; 		     )
;;  (set-fontset-font
;;   (frame-parameter nil 'font)
;;   'japanese-jisx0208
;;   '("Hiragino Maru Gothic Pro" . "iso10646-1"))
;;  (set-fontset-font
;;   (frame-parameter nil 'font)
;;   'japanese-jisx0212
;;   '("Hiragino Maru Gothic Pro" . "iso10646-1"))
;;  (set-fontset-font
;;   (frame-parameter nil 'font)
;;   'mule-unicode-0100-24ff
;;   '("monaco" . "iso10646-1"))
;;  (setq face-font-rescale-alist
;;       '(("^-apple-hiragino.*" . 1.2)
;;         (".*osaka-bold.*" . 1.2)
;;         (".*osaka-medium.*" . 1.2)
;;         (".*courier-bold-.*-mac-roman" . 1.0)
;;         (".*monaco cy-bold-.*-mac-cyrillic" . 0.9)
;;         (".*monaco-bold-.*-mac-roman" . 0.9)
;;         ("-cdac$" . 1.3))))


;; ビープ音を消す
(setq visible-bell t)

;;; mark 領域に色付け
(setq transient-mark-mode t)

;;; 括弧の対応表示
(require 'paren)
(show-paren-mode)

;;; 前回の編集箇所を記録
(require 'saveplace)
(setq-default save-place t)
(setq save-place-file "~/Library/Application Support/places.txt")

;;バックアップファイルを~/backupに保存させます
(setq make-backup-files t)
(setq backup-directory-alist
      (cons (cons "\\.*$" (expand-file-name "~/Library/emacs-backup"))
	    backup-directory-alist))

;; テンプレートの保存先
(setq auto-insert-directory "~/.emacs.d/insert")
(auto-insert-mode 1)
;; ;; テンプレート挿入時に尋ねない ;; デフォルトは 'function
;; (setq auto-insert-query nil)
;; (setq auto-insert-alist
;;       (append
;;        '(
;;          ;; モード名で指定
;;          ;;(-mode . "test.html")
;;          ;; ファイル名で指定
;;          ("\\.cpp$" . "template.cpp")
;;          ("\\.sh$" . "template.sh")
;;          )
;;        auto-insert-alist))

;; 辞書をaspellに変更
(setq-default ispell-program-name "aspell")
	      


;;モード毎の設定-----------------------------------------------------

;;.hファイルをC++モードで開く。.shファイルが.hと見なされてしまうので、設定し直す
(setq auto-mode-alist
      (cons (cons ".\.h$" 'c++-mode) auto-mode-alist))

;; objective-cの.hファイルはobjc-modeで開く
(add-to-list 'magic-mode-alist '("\\(.\\|\n\\)*\n@implementation" . objc-mode))
(add-to-list 'magic-mode-alist '("\\(.\\|\n\\)*\n@interface" . objc-mode))
(add-to-list 'magic-mode-alist '("\\(.\\|\n\\)*\n@protocol" . objc-mode))

(setq auto-mode-alist
      (cons (cons ".sh$" 'shell-script-mode) auto-mode-alist))

;;CSSモード
(autoload 'css-mode "css-mode")
(setq auto-mode-alist (cons '("\\.css$" . css-mode) auto-mode-alist))


 
;; tabbar.el------------------------------------------
;; scratch buffer 以外をまとめてタブに表示する
(require 'cl) ; for emacs-22.0.50 on Vine Linux 4.2
(when (require 'tabbar nil t)
(setq tabbar-buffer-groups-function
(lambda (b) (list "All Buffers")))
(setq tabbar-buffer-list-function
(lambda ()
(remove-if
(lambda(buffer)
(find (aref (buffer-name buffer) 0) " *"))
(buffer-list))))
(tabbar-mode))
 
;;M-]で次のタブ、M-[で前のタブに移動
(global-set-key "\M-]" 'tabbar-forward)
(global-set-key "\M-[" 'tabbar-backward)
 
;; 外観変更
(set-face-attribute
'tabbar-default-face nil
:background "#585555")
(set-face-attribute
'tabbar-unselected-face nil
:background "gray85"
:foreground "black"
:box '(:line-width 2 :color "white" :style pressed-button))
(set-face-attribute
'tabbar-selected-face nil
:background "white"
:foreground "black"
:box '(:line-width 2 :color "red" :style released-button))
(set-face-attribute
'tabbar-button-face nil
:box '(:line-width 6 :color "gray72" :style released-button))
(set-face-attribute
'tabbar-separator-face nil
:height 0.7)
;; M-4 で タブ表示、非表示
(global-set-key "\M-4" 'tabbar-mode)


;; GUIで直接ファイルを開いた場合フレームを作成しない
(add-hook 'before-make-frame-hook
          (lambda ()
            (when (eq tabbar-mode t)
              (switch-to-buffer (buffer-name))
              (delete-this-frame))))


(setq visible-bell nil)
(setq ring-bell-function 'ignore)


(put 'upcase-region 'disabled nil)



;;
;; YaTeX
;;
(add-to-list 'load-path "~/dotemacs.d/elisp/yatex")
(autoload 'yatex-mode "yatex" "Yet Another LaTeX mode" t)
(setq auto-mode-alist
      (append '(("\\.tex$" . yatex-mode)
                ("\\.ltx$" . yatex-mode)
                ("\\.cls$" . yatex-mode)
                ("\\.sty$" . yatex-mode)
                ("\\.clo$" . yatex-mode)
                ("\\.bbl$" . yatex-mode)) auto-mode-alist))
(setq YaTeX-inhibit-prefix-letter nil)
(setq YaTeX-kanji-code 4)
(setq YaTeX-use-LaTeX2e t)
(setq YaTeX-use-AMS-LaTeX t)
(setq YaTeX-dvi2-command-ext-alist
      '(("[agx]dvi\\|PictPrinter" . ".dvi")
        ("gv" . ".ps")
        ("Preview\\|TeXShop\\|TeXworks\\|Skim\\|mupdf\\|xpdf\\|Firefox\\|Adobe" . ".pdf")))
(setq tex-command "/Library/Tex/texbin/pdfplatex.sh")
;(setq tex-command "/Library/Tex/texbin/latexmk")
;(setq tex-command "/Library/Tex/texbin/pdfplatex.sh -l -ot '-synctex=1'")
;(setq tex-command "/usr/texbin/ptex2pdf -l -ot '-synctex=1'")
;(setq tex-command "/usr/texbin/ptex2pdf -l -u -ot '-synctex=1'")
;(setq tex-command "/usr/local/bin/pdfplatex")
;(setq tex-command "/usr/local/bin/pdfplatex2")
;(setq tex-command "/usr/local/bin/pdfuplatex")
;(setq tex-command "/usr/local/bin/pdfuplatex2")
;(setq tex-command "/usr/texbin/pdfplatex -synctex=1")
;(setq tex-command "/usr/texbin/lualatex -synctex=1")
;(setq tex-command "/usr/texbin/luajitlatex -synctex=1")
;(setq tex-command "/usr/texbin/xelatex -synctex=1")
;(setq tex-command "/usr/texbin/latexmk")
;(setq tex-command "/usr/texbin/latexmk -e '$latex=q/platex -synctex=1/' -e '$bibtex=q/pbibtex/' -e '$makeindex=q/mendex/' -e '$dvipdf=q/dvipdfmx %O -o %D %S/' -norc -gg -pdfdvi")
;(setq tex-command "/usr/texbin/latexmk -e '$latex=q/platex -synctex=1/' -e '$bibtex=q/pbibtex/' -e '$makeindex=q/mendex/' -e '$dvips=q/dvips %O -z -f %S | convbkmk -g > %D/' -e '$ps2pdf=q/ps2pdf %O %S %D/' -norc -gg -pdfps")
;(setq tex-command "/usr/texbin/latexmk -e '$latex=q/uplatex -synctex=1/' -e '$bibtex=q/upbibtex/' -e '$makeindex=q/mendex/' -e '$dvipdf=q/dvipdfmx %O -o %D %S/' -norc -gg -pdfdvi")
;(setq tex-command "/usr/texbin/latexmk -e '$latex=q/uplatex -synctex=1/' -e '$bibtex=q/upbibtex/' -e '$makeindex=q/mendex/' -e '$dvips=q/dvips %O -z -f %S | convbkmk -u > %D/' -e '$ps2pdf=q/ps2pdf %O %S %D/' -norc -gg -pdfps")
;(setq tex-command "/usr/texbin/latexmk -e '$pdflatex=q/pdflatex -synctex=1/' -e '$bibtex=q/bibtex/' -e '$makeindex=q/makeindex/' -norc -gg -pdf")
;(setq tex-command "/usr/texbin/latexmk -e '$pdflatex=q/lualatex -synctex=1/' -e '$bibtex=q/bibtexu/' -e '$makeindex=q/texindy/' -norc -gg -pdf")
;(setq tex-command "/usr/texbin/latexmk -e '$pdflatex=q/luajitlatex -synctex=1/' -e '$bibtex=q/bibtexu/' -e '$makeindex=q/texindy/' -norc -gg -pdf")
;(setq tex-command "/usr/texbin/latexmk -e '$pdflatex=q/xelatex -synctex=1/' -e '$bibtex=q/bibtexu/' -e '$makeindex=q/texindy/' -norc -gg -xelatex")
(setq bibtex-command (cond ((string-match "uplatex\\|-u" tex-command) "/usr/texbin/upbibtex")
                           ;; ((string-match "platex" tex-command) "/usr/texbin/pbibtex")
                           ((string-match "platex" tex-command) "/Library/Tex/texbin/pbibtex")
                           ((string-match "lualatex\\|luajitlatex\\|xelatex" tex-command) "/usr/texbin/bibtexu")
                           ((string-match "pdflatex\\|latex" tex-command) "/usr/texbin/bibtex")
                           (t "/usr/texbin/pbibtex")))
(setq makeindex-command (cond ((string-match "uplatex\\|-u" tex-command) "/usr/texbin/mendex")
                              ((string-match "platex" tex-command) "/usr/texbin/mendex")
                              ((string-match "lualatex\\|luajitlatex\\|xelatex" tex-command) "/usr/texbin/texindy")
                              ((string-match "pdflatex\\|latex" tex-command) "/usr/texbin/makeindex")
                              (t "/usr/texbin/mendex")))
;(setq dvi2-command "/usr/bin/open -a Preview")
(setq dvi2-command "/usr/bin/open -a Skim")
;(setq dvi2-command "/usr/bin/open -a TeXShop")
;(setq dvi2-command "/usr/bin/open -a TeXworks")
;(setq dvi2-command "/usr/bin/open -a Firefox")
;(setq tex-pdfview-command "/usr/bin/open -a Skim")
(setq dviprint-command-format "/usr/bin/open -a \"Adobe Reader\" `echo %s | sed -e \"s/\\.[^.]*$/\\.pdf/\"`")

;YaTeXでコメントアウト、解除を割り当てる
(add-hook 'yatex-mode-hook
	  '(lambda ()
	     (local-set-key "\C-c\C-c" 'comment-region)
	     (local-set-key "\C-c\c" 'uncomment-region) ))

;RefTexをつかうため
(add-hook 'yatex-mode-hook '(lambda () (reftex-mode t)))


                                        ;Company-Mode
(add-to-list 'load-path "/path/to/company")
(autoload 'company-mode "company" nil t)

;; set latex to xelatex
(setq org-latex-pdf-process '("xelatex -shell-escape -interaction nonstopmode %f"
                              "xelatex -shell-escape -interaction nonstopmode %f"))

;; load environment variables
(let ((envs '("PATH" "C_INCLUDE_PATH" "CPLUS_INCLUDE_PATH" "TEXINPUTS" "BSTINPUTS" "BIBINPUTS")))
  (exec-path-from-shell-copy-envs envs))

;;helm
(require 'helm-config)
(helm-mode 1)

;; C-hで前の文字削除
(define-key helm-map (kbd "C-h") 'delete-backward-char)
(define-key helm-find-files-map (kbd "C-h") 'delete-backward-char)

;; TABで補完
(define-key helm-find-files-map (kbd "TAB") 'helm-execute-persistent-action)
(define-key helm-read-file-map (kbd "TAB") 'helm-execute-persistent-action)

;; キーバインド
(define-key global-map (kbd "C-x C-b") 'helm-for-files)
(define-key global-map (kbd "C-x C-f") 'helm-find-files)
(define-key global-map (kbd "M-x")     'helm-M-x)
(define-key global-map (kbd "M-y")     'helm-show-kill-ring)
(define-key global-map (kbd "C-x C-m") 'helm-recentf)


;; language-tool
(require 'langtool)
(setq lang-tool-language-tool-jar "/usr/local/Cellar/languagetool/3.2/libexec/languagetool-commandline.jar")
(setq langtool-default-language "en-US")

;;El Capitanでの不具合を直す
(setq visible-bell nil)
(setq ring-bell-function 'ignore)

;; reftex-mode
(add-hook 'yatex-mode-hook 'turn-on-reftex)

;;  Python part
;; INSTALL PACKAGES
;; --------------------------------------

(require 'package)

(add-to-list 'package-archives
       '("melpa" . "http://melpa.org/packages/") t)

(package-initialize)
(when (not package-archive-contents)
  (package-refresh-contents))

(defvar myPackages
  '(better-defaults
    material-theme))

(mapc #'(lambda (package)
    (unless (package-installed-p package)
      (package-install package)))
      myPackages)

;; BASIC CUSTOMIZATION
;; --------------------------------------

(setq inhibit-startup-message t) ;; hide the startup message
;; (load-theme 'material t) ;; load material theme
(global-linum-mode t) ;; enable line numbers globally



;; Enable elpy
(elpy-enable)
;; ;; init.el ends here

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
