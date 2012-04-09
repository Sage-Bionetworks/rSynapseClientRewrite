# TODO: Add comment
# 
# Author: furia
###############################################################################

setRefClass(
  "FileOwner",
  contains = c("BaseObject", "VIRTUAL"),
  fields = list(
    fileCache = "FileCache"
  ),
  methods = list(
    initialize = function(){
      .self$initFields(fileCache = new("FileCache"))
    }
  )
)

