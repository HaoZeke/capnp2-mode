;;; capnp2-mode.el --- Major mode for editing Cap'n Proto files -*- lexical-binding: t; -*-
;;
;; Copyright (C) 2024 Rohit Goswami (HaoZeke)
;;
;; Author: Rohit Goswami (HaoZeke) <rgoswami[at]inventati[dot]org>
;; Maintainer: Rohit Goswami (HaoZeke) <rgoswami[at]inventati[dot]org>
;; Created: October 08, 2024
;; Modified: October 08, 2024
;; Version: 0.0.1
;; Keywords: languages, faces
;; Homepage: https://github.com/HaoZeke/capnp2-mode
;; Package-Requires: ((emacs "24.3"))
;;
;; This file is not part of GNU Emacs.
;;
;;; Commentary:
;; translation of keywords and highlighting from vim [1] and [2] textmate
;; [1] https://github.com/cstrahan/vim-capnp2
;; [2] https://github.com/textmate/capnp2roto.tmbundle/blob/master/Syntaxes/Cap%E2%80%99n%20Proto.tmLanguage

;; Put this in your .emacs file to enable autoloading of capnp2-mode
;; and auto-recognition of "*.capnp2" files:
;;
;; (autoload 'capnp2-mode "capnp2-mode.el" "CAPNP2 mode." t)
;; (setq auto-mode-alist (append auto-mode-alist
;;                               '(("\\.capnp2\\'" . capnp2-mode))
;;                               ))
;;
;;
;;
;;; Code:

;; Define keywords for Cap'n Proto
(defvar capnp2-keywords
  '("struct" "union" "enum" "interface" "const" "annotation" "using" "extends"))

;; Define built-in types for Cap'n Proto
(defvar capnp2-builtins
  '("Void" "Bool" "Text" "Data" "List" "Int8" "Int16" "Int32" "Int64"
    "UInt8" "UInt16" "UInt32" "UInt64" "Float32" "Float64" "union" "group"))

;; Define constants (e.g., boolean literals) for Cap'n Proto
(defvar capnp2-constants
  '("true" "false" "inf"))

;; Define regex for comments (single line starting with #)
(defvar capnp2-comment-regexp "#.*$")

;; Define regex for types (starting with a letter or underscore)
(defvar capnp2-type-regexp "\\_<\\([A-Za-z_][A-Za-z0-9_]*\\)\\_>")

;; Define regex for numbers
(defvar capnp2-number-regexp "\\_<[0-9]+\\_>")

;; Define regex for floating-point numbers
(defvar capnp2-float-regexp "\\_<[0-9]+\\.[0-9]*\\([eE][-+]?[0-9]+\\)?\\_>")

;; Define regex for Cap'n Proto unique IDs (e.g., @0xbd1f89fa17369103)
(defvar capnp2-unique-id-regexp "@0x[0-9A-Fa-f]+\\b")

;; Extend keywords to include annotation-related targets
(defvar capnp2-annotation-targets
  '("file" "struct" "field" "union" "group" "enum" "enumerant" "interface" "method" "param" "annotation" "const" "*"))

;; Define regex for annotations (e.g., $foo("bar"))
(defvar capnp2-annotation-regexp "\\([$]\\w+\\)(\\([^)]+\\))?")

;; Define syntax table to manage comments
(defvar capnp2-mode-syntax-table
  (let ((table (make-syntax-table)))
    ;; '#' starts a comment
    (modify-syntax-entry ?# "<" table)
    (modify-syntax-entry ?\n ">" table)
    table))

;; Define font lock (syntax highlighting) rules
(defvar capnp2-font-lock-keywords
  `((,(regexp-opt capnp2-keywords 'words) . font-lock-keyword-face)
    (,(regexp-opt capnp2-builtins 'words) . font-lock-type-face)
    (,(regexp-opt capnp2-constants 'words) . font-lock-constant-face)
    (,capnp2-type-regexp . font-lock-variable-name-face)
    (,capnp2-number-regexp . font-lock-constant-face)
    (,capnp2-float-regexp . font-lock-constant-face)
    (,capnp2-unique-id-regexp . font-lock-constant-face)
    (,capnp2-comment-regexp . font-lock-comment-face)
    (,capnp2-annotation-regexp . ((1 font-lock-preprocessor-face) (2 font-lock-string-face)))
    (,(regexp-opt capnp2-annotation-targets 'words) . font-lock-builtin-face)))

;; Define the major mode itself
(define-derived-mode capnp2-mode c-mode "Cap'n Proto"
  "Major mode for editing Cap'n Proto schema files."
  :syntax-table capnp2-mode-syntax-table
  (setq-local font-lock-defaults '((capnp2-font-lock-keywords)))
  (setq-local comment-start "# ")
  (setq-local comment-end "")
  (setq-local indent-line-function 'c-indent-line))

;; Automatically use capnp2-mode for .capnp2 files
(add-to-list 'auto-mode-alist '("\\.capnp2\\'" . capnp2-mode))

(provide 'capnp2-mode)
;;; capnp2-mode.el ends here
