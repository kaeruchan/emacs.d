;;; touch.el --- 

;;touch����ؿ�
;.emacs�ˡ�(load-library "touch")�Ȥ�����ʸ��񤭲ä���

(defun touch ()  (interactive) (newline) (delete-backward-char 1) (save-buffer))
