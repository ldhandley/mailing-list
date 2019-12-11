#lang racket
 
(require website/bootstrap
         web-server/http/response-structs
         (only-in xml xexpr->string)
         )

(provide joiner-view)

(define (joiner-view action-path displayed-formlet)
  (response/full 
    200 #"Success"
    (current-seconds) TEXT/HTML-MIME-TYPE
    '()
    (list (string->bytes/utf-8 (xml->string (webpage action-path displayed-formlet))))))

(define (webpage action-path displayed-formlet)
  (content
    (jumbotron
      (h1 "THIS IS OUR MAILING LIST")
      (form action: action-path
            (html/inline (string-join (map xexpr->string displayed-formlet)))
            (input type: "submit"))
      )))
