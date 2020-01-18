;;; tea-timer.el --- Simple countdown timer      -*- lexical-binding: t; -*-

;; Copyright (C) 2018-2020  Daniel Kraus

;; Author: Daniel Kraus <daniel@kraus.my>
;; Version: 0.1
;; Package-Requires: ((emacs "24.4"))
;; Keywords: convenience, timer
;; URL: https://github.com/dakra/tea-timer

;; This program is free software; you can redistribute it and/or modify
;; it under the terms of the GNU General Public License as published by
;; the Free Software Foundation, either version 3 of the License, or
;; (at your option) any later version.

;; This program is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.

;; You should have received a copy of the GNU General Public License
;; along with this program.  If not, see <https://www.gnu.org/licenses/>.

;;; Commentary:

;; Simple countdown timer
;; TODO: Add modeline

;;; Code:

(require 'request)


(defgroup tea-timer nil
  "tea-timer"
  :prefix "tea-timer-"
  :group 'convenience)

(defcustom tea-timer-default-duration 2.5
  "Default timer duration."
  :type 'number
  :safe #'numberp)

(defcustom tea-timer-message "Tea ready!"
  "Message to show when timer is up."
  :type 'string)


(defvar tea-timer--timer nil
  "Store current running timer.")


(defun tea-timer-tea-ready ()
  "Display tea ready message and reset timer."
  (if (require 'alert nil 'no-error)
      (alert tea-timer-message)
    (message tea-timer-message))
  (setq tea-timer--timer nil))

;;;###autoload
(defun tea-timer (&optional duration)
  "Set a tea timer to DURATION in seconds or tea-timer-default-duration."
  (interactive "P")
  (when tea-timer--timer
    (when (y-or-n-p "Another tea timer already running.  Cancel the old one? ")
      (tea-timer-cancel)
      (setq tea-timer--timer nil)))
  (if tea-timer--timer
      (tea-timer-display-remaining-time)
    (message "Setting tea timer to %s minutes." (or duration tea-timer-default-duration))
    (setq tea-timer--timer
          (run-at-time (* 60 (or duration tea-timer-default-duration)) nil 'tea-timer-tea-ready))))

(defun tea-timer-display-remaining-time ()
  "Displays remaining time in the Minibuffer."
  (interactive)
  (if tea-timer--timer
      (let* ((remaining-time (decode-time (time-subtract (timer--time tea-timer--timer) (current-time)) t))
             (minutes (nth 1 remaining-time))
             (seconds (nth 0 remaining-time)))
        (message "%s minutes and %s seconds left" minutes seconds))
    (message "No tea timer active")))

(defun tea-timer-cancel ()
  "Cancel running tea timer."
  (interactive)
  (when tea-timer--timer
    (cancel-timer tea-timer--timer)
    (setq tea-timer--timer nil)))

(provide 'tea-timer)
;;; tea-timer.el ends here
