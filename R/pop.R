# a pop function that behaves like .pop() in
# python or javascript
pop <- function(vec) {
  newvec <- vec[-length(vec)]
  vecname <- deparse(substitute(vec))
  assign(vecname, newvec, envir = .GlobalEnv)
  tail(vec, 1) 
}