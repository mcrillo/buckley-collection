
all_duplicated <- function (value) { 
  duplicated(value) | duplicated(value, fromLast = TRUE) 
}