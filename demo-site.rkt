#lang racket

(require website/bootstrap)

(define (website)
  (list
    (bootstrap-files)
    (page index.html
      (content
        (jumbotron
          (h1 "This is a website")
          (iframe 
            style: (properties border: "none"
                               width: "100%"
                               height: "215px")
            src: "http://localhost:8080/mailing-list?background-color=%23e9ecef")
          )))))

(render (website) #:to "out")
