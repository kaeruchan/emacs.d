;;; nurumacs.el --- animate scrolling like sublime editor

;; Copyright (C) 2013 zk_phi

;; This program is free software; you can redistribute it and/or modify
;; it under the terms of the GNU General Public License as published by
;; the Free Software Foundation; either version 2 of the License, or
;; (at your option) any later version.
;;
;; This program is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
;; GNU General Public License for more details.
;;
;; You should have received a copy of the GNU General Public License
;; along with this program; if not, write to the Free Software
;; Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA 02110-1301 USA

;; Author: zk_phi
;; URL: http://hins11.yu-yake.com/
;; Version: 3.2.0

;;; Commentary:

;; Just add an expression below in your init file :
;;
;;   (require 'nurumacs)
;;
;; then scrolling is automatically animated. If minimap is not confortable for
;; you, evaluate
;;
;;   (setq nurumacs-map nil)

;; When you load this library, "auto-hscroll-mode" is automatically disabled,
;; and nurumacs-auto-hscroll will work instead. To disable this, evaluate
;;
;;   (setq nurumacs-auto-hscroll nil)
;;
;; and to use original auto-hscroll again, evaluate
;;
;;   (setq auto-hscroll-mode t)

;;; Change Log:

;; 1.0.0 first released
;; 2.0.0 added horizontal animation
;;       now not depends on "pager.el"
;; 2.1.0 improved horizontal scrolling
;; 3.0.0 added minimap-like feature
;;       some minor fixes
;; 3.0.1 minor fizes
;; 3.2.0 improved post-command-function

;;; Code:

;; * constants

(defconst nurumacs-version "3.2.0")

;; * parameters

(defvar nurumacs-vdecc 1.7
  "how vertical scroll speed goes down")

(defvar nurumacs-hdecc 1.5
  "how vertical scroll speed goes down")

(defvar nurumacs-vspeeds '(1000 300 100 50 7 3 2)
  "speeds of vertical scrolling animation")

(defvar nurumacs-hspeeds '(10 3)
  "speeds of horizontal scrolling animation")

(defvar nurumacs-map t)

(defvar nurumacs-map-size 20
  "size of nurumacs-map")

(defvar nurumacs-max-fraction 0.3
  "maximum fraction of nurumacs-map size")

;; * disable auto-hscroll-mode

(defvar nurumacs-auto-hscroll auto-hscroll-mode)
(setq auto-hscroll-mode nil)

;; * utils

(defun nurumacs--linum ()
  (line-number-at-pos (window-start)))

(defun nurumacs--scroll-up (lines)
  (goto-char (window-start))
  (forward-line lines)
  (set-window-start (selected-window) (point)))

(defun nurumacs--scroll-down (lines)
  (nurumacs--scroll-up (- lines)))

;; * vscroll

(defun nurumacs--vscroll-effect (len)
  (save-excursion
    (let* ((fun (if (>= len 0) 'nurumacs--scroll-up 'nurumacs--scroll-down))
           (speeds nurumacs-vspeeds)
           (len (abs len))
           (cursor-type nil))
      (funcall fun (- len))
      (dolist (spd speeds)
        (while (>= len (floor (* nurumacs-vdecc spd)))
          (funcall fun spd) (setq len (- len spd)) (redisplay t)))
      (dotimes (tmp len)
        (funcall fun 1) (redisplay t)))))

;; * hscroll

(defun nurumacs--hscroll (len)
  (save-excursion
    (let* ((fun (if (>= len 0) 'scroll-left 'scroll-right))
           (speeds nurumacs-hspeeds)
           (len (abs len)))
      (dolist (spd speeds)
        (while (>= len (floor (* nurumacs-hdecc spd)))
          (funcall fun spd) (setq len (- len spd)) (redisplay t)))
      (dotimes (tmp len)
        (funcall fun 1) (redisplay t)))))

(defun nurumacs--horizontal-recenter (&optional arg)
  (interactive)
  (when (null arg) (setq arg (/ (window-width) 2)))
  (let ()
    (nurumacs--hscroll
     (- (current-column) (window-hscroll) arg))))

;; * map

(defvar nurumacs--map-window nil)
(defvar nurumacs--map-buffer nil)
(defvar nurumacs--map-killer nil)

(defun nurumacs--map-show ()
  ;; search for map window
  (setq nurumacs--map-window
        (cond ((and nurumacs--map-window
                    (window-live-p nurumacs--map-window))
               nurumacs--map-window)
              ((<= (/ nurumacs-map-size (window-width) 1.0)
                   nurumacs-max-fraction)
               (split-window (selected-window)
                             (- (window-width) nurumacs-map-size)
                             t))
              (t nil)))

  ;; setup map
  (when nurumacs--map-window
    (let ((text (buffer-string)) (point (point))
          (beg (window-start)) (end (window-end)))
      (with-selected-window nurumacs--map-window
        ;; kill old buffer
        (when (and nurumacs--map-buffer
                   (buffer-live-p nurumacs--map-buffer))
          (kill-buffer nurumacs--map-buffer))
        ;; make new buffer
        (switch-to-buffer
         (setq nurumacs--map-buffer (generate-new-buffer "*nurumap*")))
        (text-scale-set -7)
        ;; content
        (insert text)
        (overlay-put (make-overlay beg end) 'face 'highlight)
        (goto-char point)
        (recenter))))

  ;; set a timer for clean-up
  (when nurumacs--map-killer (cancel-timer nurumacs--map-killer))
  (setq nurumacs--map-killer
        (run-with-idle-timer 0.3 t 'nurumacs--map-kill)))

(defun nurumacs--map-kill ()
  ;; cancel timer
  (when nurumacs--map-killer
    (cancel-timer nurumacs--map-killer)
    (setq nurumacs--map-killer nil))
  ;; delete window
  (when (and nurumacs--map-window
             (window-live-p nurumacs--map-window))
    (delete-window nurumacs--map-window))
  ;; kill buffer
  (when (and nurumacs--map-buffer
             (buffer-live-p nurumacs--map-buffer))
    (kill-buffer nurumacs--map-buffer)))

;; * trigger

(defvar nurumacs--prev-lin nil)
(defvar nurumacs--prev-buf nil)
(defvar nurumacs--prev-wnd nil)

(defun nurumacs--pre-command-function ()
  (setq nurumacs--prev-lin (nurumacs--linum))
  (setq nurumacs--prev-buf (current-buffer))
  (setq nurumacs--prev-wnd (selected-window)))

(defun nurumacs--post-command-function ()
  (when (and (eq nurumacs--prev-buf (current-buffer))
             (eq nurumacs--prev-wnd (selected-window))
             (not (and transient-mark-mode mark-active))
             (not (and (boundp 'cua--rectangle) cua--rectangle))
             (not (and (boundp 'multiple-cursors-mode) multiple-cursors-mode)))
    (if (or (>= (point) (window-end))
            (<= (point) (window-start)))
        (recenter))
    (let* ((dlin (- (nurumacs--linum) nurumacs--prev-lin)))
      (when (not (= dlin 0))
        (nurumacs--vscroll-effect dlin)
        ;; if map-show is called before vscroll,
        ;; the range of overlay become not correct
        (when nurumacs-map (nurumacs--map-show)))
      (when (and nurumacs-auto-hscroll
                 (or (<= (current-column) (window-hscroll))
                     (<= (+ (window-hscroll) (window-width)) (current-column))))
        (nurumacs--horizontal-recenter)))))

(add-hook 'pre-command-hook 'nurumacs--pre-command-function)
(add-hook 'post-command-hook 'nurumacs--post-command-function)

;; * provide

(provide 'nurumacs)

;;; nurumacs.el ends here
