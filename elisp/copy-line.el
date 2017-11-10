;;; copy-line.el --- 

;;一行コピーする関数．自作

(defun copy-line ()  (interactive)  (kill-line) (yank))