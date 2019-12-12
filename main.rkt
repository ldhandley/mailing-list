#lang racket
 
(require web-server/servlet
         web-server/servlet-env
         web-server/formlets
         "view.rkt"
         "model.rkt")

(provide mailing-list-server)

(define (start request)
  (render-mailing-list-page
   (initialize-mailing-list!
    (build-path (current-directory)
                "the-mailing-list.sqlite"))
   request))
 
(define (render-mailing-list-page a-mailing-list request)
  (define maybe-background-color 
    (extract-bindings 'background-color (request-bindings request)))
  (define background-color
    (if (empty? maybe-background-color)
      "white"
      (first maybe-background-color)))
  (define (response-generator embed/url)
   (joiner-view background-color 
                (embed/url insert-email-handler)
                (formlet-display new-email-formlet)))
 
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

(define (mailing-list-server)
  (serve/servlet #:port 8080 
                 #:servlet-path "/mailing-list"
                 #:listen-ip "0.0.0.0"
                 #:extra-files-paths (list (build-path "."))
                 start))

(module+ main
  (mailing-list-server))
