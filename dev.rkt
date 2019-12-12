#lang racket

(require website/raco-tools/preview
         "./main.rkt")


(thread (thunk
          (current-directory "out")
          (preview)))

(mailing-list-server)
