;;; hiwin.el --- Visible active window mode.

;; Copyright (C) 2009 ksugita
;; 2010 tomoya <tomoya.ton@gmail.com>
;; 2010 ksugita <ksugita0510@gmail.com>
;; 2010 myuhe <yuhei.maeda@gmail.com>

;; Author: ksugita
;; Keywords: faces, editing, emulating
;; Version: 1.02

;; This file is free software; you can redistribute it and/or modify
;; it under the terms of the GNU General Public License as published by
;; the Free Software Foundation; either version 2, or (at your option)
;; any later version.

;; This file is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
;; GNU General Public License for more details.

;; You should have received a copy of the GNU General Public License
;; along with GNU Emacs; see the file COPYING. If not, write to
;; the Free Software Foundation, Inc., 51 Franklin Street, Fifth Floor,
;; Boston, MA 02110-1301, USA.

;;; Usage
;; put followings your .emacs
;; (require 'hiwin)
;;
;; if you visible active window, type M-x hiwin-mode.

;;; Changes
;; 2010-08-13 tomoya
;; myuhe ����� ksugita ����ν�����ޡ���
;;
;; 2010-08-13 ksugita
;; *Completions*ɽ������MiniBuf��ɽ���������Τ���
;; ��ư�ǲ��̥�ե�å���Ǥ���褦hiwin-refresh-win��interactive��
;; �Ŀ�Ū��������ä����ᡤrecenter��advice����
;;
;; 2010-08-11 myuhe
;; anything��Ϣ�δؿ���¹Ԥ������˥ߥ˥Хåե����󥢥��ƥ��֥�����ɥ��Ȥ��ư������������
;; anything��ư����anything�Хåե��ʳ��ΥХåե����󥢥��ƥ��֥�����ɥ��Ȥʤä��ޤ����ʤ��������
;;
;; 2010-07-04 ksugita
;; ������Ǻƥ�����å������ե������ tomoya�ᡤmasutaka��ν�����ȿ��
;; readonly�ʥ����ƥ���window���طʿ�������Ǥ���褦�˵�ǽ�ѹ�
;;
;; 2010-06-07 tomoya
;; �ޥ��ʡ��⡼�ɲ�
;;
;; 2009-09-13 ksugita
;; �֥��Ǹ���
;; http://ksugita.blog62.fc2.com/blog-entry-8.html


;;; Code:

(defvar hiwin-deactive-color "gray30"
  "�󥢥��ƥ���window���طʿ�")
(defvar hiwin-readonly-color "#000030"
  "�ɤ߼������window���طʿ�")
(defvar hiwin-normal-color (background-color-at-point)
  "�񤭹��߲�ǽwindow���طʿ�")
(defvar hiwin-ignore-buffer
  '(" *Minibuf-1*" "+draft/1" "+draft/2" "+draft/3")
  "�ϥ��饤���оݳ�buffer")
(defvar hiwin-ol-count 8
  "�󥢥��ƥ���window��overlay��")
(defvar hiwin-ol-lines 128
  "�󥢥��ƥ���window�ιԿ�")

(defvar hiwin-temp-buf "*hiwin-temp*"
  "����ѥХåե�")
(defvar hiwin-face nil
  "�󥢥��ƥ���window��face")
(defvar hiwin-ol nil
  "�󥢥��ƥ���window��overlay")
(defvar hiwin-window nil
  "�����ƥ���window��window")
(defvar hiwin-buffer nil
  "�����ƥ���window��buffer")

(define-minor-mode hiwin-mode
  "Visible active window."
  :global t
  :lighter " hiwin"
  :group 'hiwin
  (hiwin))

(defun hiwin-create-ol ()
  ;; �󥢥��ƥ���window��face�����
  (make-face 'hiwin-face)
  ;; �󥢥��ƥ���window��face���طʿ�������
  (set-face-background 'hiwin-face hiwin-deactive-color)
  (let ((num 0) ;; ������
        (buf nil)) ;; ����ѥХåե�
    ;; ����ѥХåե������
    (setq buf (get-buffer-create hiwin-temp-buf))
    ;; ��������overlayʬ������ʥ롼�׳��ϡ�
    (while (< num hiwin-ol-count)
      ;; �󥢥��ƥ���window��overlay�����
      (setq hiwin-ol (cons (make-overlay 1 1 buf nil t) hiwin-ol))
      ;; �󥢥��ƥ���window��overlay����ʸ��face������
      (overlay-put (nth 0 hiwin-ol) 'face 'hiwin-face)
      ;; �󥢥��ƥ���window��overlay��EOF��face������
      (overlay-put (nth 0 hiwin-ol) 'after-string
                   (propertize (make-string hiwin-ol-lines ?\n) 'face 'hiwin-face))
      ;; �����󥿥��å�
      (setq num (1+ num))
      ) ;; �ʥ롼�׽�λ��
    ;; ����ѥХåե�����
    (kill-buffer buf)))

(defun hiwin-draw-ol ()
  ;; �����ƥ���window��window�����
  (setq hiwin-window (selected-window))
  ;; �����ƥ���window��buffer�����
  (setq hiwin-buffer (current-buffer))
  (let ((num 0) ;; ������
        (win nil) ;; �����о�window
        (lst (window-list))) ;; ɽ��window�Υꥹ��
    ;; ɽ��winndow�Τ��٤Ƥ�����ʥ롼�׳��ϡ�
    (while lst
      ;; �����о�window�����
      (setq win (car lst))
      ;; �����о�window��ꥹ�Ȥ�����
      (setq lst (cdr lst))
      ;; �����о�window�ȥ����ƥ���window�����פ�����
      (if (or (eq win hiwin-window) (eq win (minibuffer-window)))
          (progn
            ;; EOB������ξ�硤��ʸ���ʤ�
            (if (and (eq (point) (1- (point-max)))
                     (> (point-max) 1))
                (forward-char 1))
            ;; �ɤ߼�����Ѥ��ݤ����طʿ����ѹ�
            (if buffer-read-only
                (set-background-color hiwin-readonly-color)
              (set-background-color hiwin-normal-color)))
        ;; �����о�window�ȥ����ƥ���window�����פ��ʤ����
        (progn
          (let ((buf (window-buffer win)))
            (if (member buf hiwin-ignore-buffer)
                ()
              ;; �����о�window�򥢥��ƥ��ֲ�
              (select-window win)
              ;; EOB�ξ�硤��ʸ�����
              (if (and (eq (point) (point-max))
                       (> (point-max) 1))
                  (backward-char 1))
              ;; �����о�window��overlay������
              (move-overlay (nth num hiwin-ol)
                            (point-min) (point-max) (current-buffer))
              (overlay-put (nth num hiwin-ol) 'window win)
              ;; �����󥿥��å�
              (setq num (1+ num))
              ))))) ;; �ʥ롼�׽�λ��
    ;; �����ƥ���window�򥢥��ƥ��ֲ�
    (select-window hiwin-window)))

(defun hiwin-delete-ol ()
  (let ((num 0)) ;; ������
    ;; �������줿overlayʬ������ʥ롼�׳��ϡ�
    (while (< num hiwin-ol-count)
      ;; �󥢥��ƥ���window��overlay����
      (delete-overlay (nth num hiwin-ol))
      ;; �����󥿥��å�
      (setq num (1+ num))
      )) ;; �ʥ롼�׽�λ��
  ;; �󥢥��ƥ���window��overlay���ѿ�������
  (setq hiwin-ol nil))

(defun hiwin-refresh-win ()
  (interactive)
  (let ((win (selected-window)) )
    ;; �ߥ˥Хåե���anything�Хåե��ʳ������򤷤Ƥ�����
    (unless (or (eq win (minibuffer-window))
                (eq 1 (string-match "anything" (buffer-name (window-buffer win)))))
      ;; ���ߤΥ�����ɥ��������ƥ��֥�����ɥ��ξ��
      ;; ���ġ����ߤΥХåե��������ȥХåե��ξ��
      (if (and (eq hiwin-window win) (eq hiwin-buffer (current-buffer)))
          ;; �ɤ߼�����Ѥ��ݤ����طʿ����ѹ�
          (if buffer-read-only
                (set-background-color hiwin-readonly-color)
              (set-background-color hiwin-normal-color)
              )
        ;; �����¹�
        (hiwin-draw-ol)
        ))))

(defun hiwin ()
  (if (null hiwin-ol)
      (progn (hiwin-create-ol)
             (add-hook 'pre-command-hook 'hiwin-refresh-win)
             (add-hook 'post-command-hook 'hiwin-refresh-win)
             (add-hook 'window-configuration-change-hook 'hiwin-refresh-win)
             (hiwin-refresh-win)
             )
    (progn (hiwin-delete-ol)
           (remove-hook 'pre-command-hook 'hiwin-refresh-win)
           (remove-hook 'post-command-hook 'hiwin-refresh-win)
           (remove-hook 'window-configuration-change-hook 'hiwin-refresh-win)
           )))

(defadvice split-window-vertically
  (around hiwin-split-window-vertically activate)
  ad-do-it
  (if hiwin-ol (hiwin-draw-ol)))

(defadvice split-window-horizontally
  (around hiwin-split-window-horizontally activate)
  ad-do-it
  (if hiwin-ol (hiwin-draw-ol)))

(defadvice delete-window
  (around hiwin-delete-window activate)
  ad-do-it
  (when hiwin-ol (hiwin) (hiwin)))

(defadvice other-window
  (around hiwin-other-window activate)
  ad-do-it
  (if hiwin-ol (hiwin-draw-ol)))

(defadvice twittering-edit-close
  (around hiwin-twittering-edit-close activate)
  ad-do-it
  (when hiwin-ol (hiwin)(hiwin)))

(provide 'hiwin)