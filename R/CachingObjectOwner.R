# TODO: Add comment
# 
# Author: furia
###############################################################################

####
# Methods for adding general objects
####
setMethod(
  f = "addObject",
  signature = signature("CachingObjectOwner", "ANY", "character", "missing"),
  definition = function(owner, object, name){
    invisible(.doAddObjectWithCache(owner, object, name))
  }
)

setMethod(
  f = "addObject",
  signature = signature("CachingObjectOwner", "ANY", "missing", "missing"),
  definition = function(owner, object){
    name = deparse(substitute(object, env=parent.frame()))
    name <- gsub("\\\"", "", name)
    addObject(owner, object, name)
  }
)

###
# Methods for adding list objects
###
setMethod(
  f = "addObject",
  signature = signature("CachingObjectOwner", "list", "character", "logical"),
  definition = function(owner, object, name, unlist){
    if(unlist)
      stop("cannot specify the object name when unlisting")
    invisible(.doAddObjectWithCache(owner, object, name))
  }
)


setMethod(
  f = "addObject",
  signature = signature("CachingObjectOwner", "list", "missing", "logical"),
  definition = function(owner, object, unlist){
    if(unlist)
      return(addObject(owner, object))
    name = deparse(substitute(object, env=parent.frame()))
    name <- gsub("\\\"", "", name)
    addObject(owner, object, name, unlist)
  }
)


setMethod(
  f = "addObject",
  signature = signature("CachingObjectOwner", "list", "missing", "missing"),
  definition = function(owner, object){
    if(any(names(object) == "") || is.null(names(object)))
      stop("all elements of the list must be named")
    lapply(names(object), FUN=function(nm){
        addObject(owner, object[[nm]], nm)
      }
    )
    invisible(owner)
  }
)


####
# Methods for adding data.frame objects
####
setMethod(
  f = "addObject",
  signature = signature("CachingObjectOwner", "data.frame", "missing", "missing"),
  definition = function(owner, object){
    name = deparse(substitute(object, env=parent.frame()))
    name <- gsub("\\\"", "", name)
    addObject(owner, object, name, unlist = FALSE)
  }
)

setMethod(
  f = "addObject",
  signature = signature("CachingObjectOwner", "data.frame", "character", "missing"),
  definition = function(owner, object, name){
    invisible(.doAddObjectWithCache(owner, object, name))
  }
)

setMethod(
  f = "deleteObject",
  signature = signature("CachingObjectOwner", "character"),
  definition = function(owner, which){
    rm(list=which, envir=as.environment(owner$objects))
    tryCatch(
      .deleteCacheFile(owner, which),
      error = function(e){
        warning(sprintf("Unable to delete cache file associated with %s\n%s", which, e))
      },
      warning = function(e){
        warning(sprintf("Unable to delete cache file associated with %s\n%s", which, e))
      }
    )
    invisible(owner)
  }
)

setMethod(
  f = "renameObject",
  signature = signature("CachingObjectOwner", "character", "character"),
  definition = function(owner, which, name){
    if(length(which) != length(name))
      stop("Must supply the same number of names as objects")
    
    ## make a copy of the objects that will be moved and delete them from
    ## the entity
    ## TODO : make this more performant by only making copies of objects
    ## when absolutely necessary
    tmpEnv <- new.env()
    lapply(which, FUN = function(key){
        assign(key, getObject(owner, key), envir = tmpEnv)
        deleteObject(owner, key)
      }
    )
    
    lapply(1:length(which), FUN=function(i){
        addObject(owner, get(which[i], envir=tmpEnv), name[i])
      }
    )
    rm(tmpEnv)
    invisible(owner)
  }
)






