#lang web-server/insta
 
(require web-server/formlets
         "mailing-list-views.rkt"
         "mailing-list-joiner-model.rkt")

(static-files-path ".")

(define (start request)
  (displayln (current-directory))
  (render-mailing-list-page
   (initialize-mailing-list!
    (build-path (current-directory)
                "the-mailing-list.sqlite"))
   request))
 
(define new-email-formlet
  (formlet
   (#%# ,{input-string . => . name}
        ,{input-string . => . email})
   (values name email)))
 
(define (render-mailing-list-page a-mailing-list request)
  (define (response-generator embed/url)
   (joiner-view (embed/url insert-email-handler)
                (formlet-display new-email-formlet)) 
    #;
    (response/xexpr
     `(html (head (title "My Mailing List"))
            (body
             (h1 "My Mailing List")
             (form ([action
                     ,(embed/url insert-email-handler)])
                   ,@(formlet-display new-email-formlet)
                   (input ([type "submit"])))))))
 
  (define (insert-email-handler request)
    (define-values (name email)
      (formlet-process new-email-formlet request))
    (mailing-list-insert-email! a-mailing-list name email)
    (render-confirmation-page a-mailing-list (redirect/get)))
  (send/suspend/dispatch response-generator))

(define (render-confirmation-page a-mailing-list request) 
    (response/xexpr
     `(html (head (title "Confirmation page"))
            (body
             (h1 "Thanks for joining the mailing list!"))))) 
