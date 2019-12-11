#lang racket/base
(require racket/list
         db)
 
(provide initialize-mailing-list!
         mailing-list-insert-email!)
 
(define (initialize-mailing-list! home)
  (define db (sqlite3-connect #:database home #:mode 'create))
  (unless (table-exists? db "emails")
    (query-exec db
     (string-append
      "CREATE TABLE emails "
      "(id INTEGER PRIMARY KEY, name TEXT, email TEXT)")))
  db)
 
(define (mailing-list-insert-email! mailing-list name email)
  (query-exec
   mailing-list
   "INSERT INTO emails (name, email) VALUES (?, ?)"
   name email))
 
