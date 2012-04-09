# TODO: Add comment
# 
# Author: furia
###############################################################################


setClass(
  Class = "ReadOnlyEnhancedEnvironment",
  contains = "EnhancedEnvironment"
)

setReplaceMethod("[[", 
  signature = signature(
    x = "EnhancedEnvironment",
    i = "character"
  ),
  definition = function(x, i, value) {
    stop("This object is read-only.")
  }
)
