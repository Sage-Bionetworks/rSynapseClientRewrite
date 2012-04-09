# TODO: Add comment
# 
# Author: furia
###############################################################################

setMethod(
  f = "initialize",
  signature = "CachingEnhancedEnvironment",
  definition = function(.Object){
    .Object@cacheDir <- tempdir()
    .Object@prefix <- tempfile(tmpdir = "")
    cache = file.path(.Object@cacheDir, .Object@prefix)
    dir.create(cache, recursive = TRUE)
    .Object
  }
)

## general purpose function for adding objects and caching to file
.doCacheObject <-
  function(x, object, name)
{
  x$objects[[name]] <- object
  tryCatch(
    .cacheObject(x, name),
    error = function(e){
      deleteObject(x, name)
      stop(e)
    }
  )
  x
}

setReplaceMethod(
  f = "[[",
  signature = signature(
    x = "EnhancedEnvironment",
    i = "character"
  ),
  function(x, i, value) {
    ## call the super-class method
    class(x) <- "EnhancedEnvironment"
    x[[i]] <- value
    if(!is.numeric(i))
      name <- names(x)[i]
    class(x) <- "CachingEnhancedEnvironment"
    .doCacheObject(x, name)
    x
  }
)



