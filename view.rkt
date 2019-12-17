#lang at-exp racket
 
(require (prefix-in f: web-server/formlets) 
         website/bootstrap
         web-server/http/response-structs
         (only-in xml xexpr->string)
         )

(provide joiner-view
         new-email-formlet)

(define (joiner-view color action-path displayed-formlet)
  (response/full 
    200 #"Success"
    (current-seconds) TEXT/HTML-MIME-TYPE
    '()
    (list (string->bytes/utf-8 (xml->string (webpage color action-path displayed-formlet))))))

(define (form-control type)
  (f:input #:type type 
           #:attributes '([class "form-control"])))

(define new-email-formlet
  (f:formlet
    (div 
      (div ([class "form-group"])
        (label "Name"),{(form-control "text") . => . name}) 
      (div ([class "form-group"])
        (label "Email"),{(form-control "email") . => . email}))
   (values name email)))
 
(define (webpage color action-path displayed-formlet)
  (content 
    @style/inline{
      body{
        background-color: @color; 
      } 
    }
    (form action: action-path
      (html/inline (string-join (map xexpr->string displayed-formlet)))
      (button-primary type: "submit" "Submit"))))
