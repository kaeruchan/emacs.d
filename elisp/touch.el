;;; touch.el --- 

;;touchする関数
;.emacsに，(load-library "touch")という一文を書き加える

(defun touch ()  (interactive) (newline) (delete-backward-char 1) (save-buffer))
