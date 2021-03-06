# TODO: Add comment
# 
# Author: furia
###############################################################################

##
## object CRUD calls should deletage to the enclosedEnhanced environment
## must assign the return value for Enhanced Environment calls back to the
## "objects" slot since Enhanced Environment is pass-by-copy. This isn't
## totally necessary for this implementation, but will be for subclasses
## that store in memory member variables as well as enclosing an basic "environment"
## class
##

## delegate addObject calls to the enclosed EnhancedEnvironment class
#setMethod(
#  f = "addObject",
#  signature = signature("CachingObjectOwner", "ANY", "character", "missing"),
#  definition = function(owner, object, name){
#    owner$objects <- addObject(owner$objects, object, name)
#    invisible(owner)
#  }
#)

setMethod(
  f = "setFileCache",
  signature = signature("CachingObjectOwner", "FileCache"),
  definition = function(owner, fileCache){
    owner$objects <- setFileCache(owner$objects, fileCache)
    owner
  }
)


## delegate deleteObject calls to the enclosed EnhancedEnvironment class
setMethod(
  f = "deleteObject",
  signature = signature("CachingObjectOwner", "character"),
  definition = function(owner, which){
    owner$objects <- deleteObject(owner$objects, which)
    invisible(owner)
  }
)

## delegate renameObject calls to the enclosed EnhancedEnvironment class
setMethod(
  f = "renameObject",
  signature = signature("CachingObjectOwner", "character", "character"),
  definition = function(owner, which, name){
    owner$objects <- renameObject(owner$objects, which, name)
    invisible(owner)
  }
)

## delegate getObject calls to the enclosed EnhancedEnvironment class
setMethod(
  f = "getObject",
  signature = signature("CachingObjectOwner", "character"),
  definition = function(owner, which){
    getObject(owner$objects, which)
  }
)

##
## list objects require special handling. if unlist=TRUE, the elements of the
## list should each be added as their own object. if unlist=FALSE, the entire list
## should be added as a single object. The default behavior is unlist = TRUE
##


setMethod(
    f = "addObject",
    signature = signature("CachingObjectOwner", "ANY", "character", "missing"),
    definition = function(owner, object, name){
      owner$objects <- addObject(owner$objects, object, name)
      invisible(owner)
    }
)

###
# Methods for adding list objects
###
setMethod(
    f = "addObject",
    signature = signature("CachingObjectOwner", "ANY", "missing", "missing"),
    definition = function(owner, object){
      name = deparse(substitute(object, env=parent.frame()))
      name <- gsub("\\\"", "", name)
      owner$objects <- addObject(owner$objects, object, name)
      invisible(owner)
    }
)

setMethod(
    f = "addObject",
    signature = signature("CachingObjectOwner", "ANY", "missing", "logical"),
    definition = function(owner, object, unlist){
      if(!unlist){
        name = deparse(substitute(object, env=parent.frame()))
        name <- gsub("\\\"", "", name)
        owner$objects <- addObject(owner$objects, object, name)
      }else{
        owner$objects <- addObject(owner$objects, object, unlist=unlist)
      }
      invisible(owner)
    }
)

setMethod(
  f = "loadObjectsFromFiles",
  signature = "CachingObjectOwner",
  definition = function(owner){
    owner$objects <- .loadCachedObjects(owner$objects)
    owner
  }
)

##
## Since data frames are a type of list, we need to customize thier behavior.By default
## unlist should be FALSE for data frames
##

##
## when the object names isn't provided, it should keep the same names as it had
## in the parent frame. this can lead to some wierd object names, so generally it's
## safest to simply specify the name
##
#setMethod(
#  f = "addObject",
#  signature = signature("CachingObjectOwner", "ANY", "missing", "missing"),
#  definition = function(owner, object){
#    name = deparse(substitute(object, env=parent.frame()))
#    name <- gsub("\\\"", "", name)
#    addObject(owner, object, name)
#  }
#)

## return the environment wrapped by the enclosed EnhancedEnvironment class
## should this be done? May not need this method since it encourages callers
## not to use the API. Commenting it out for now and will add it back later if
## it's needed
#setMethod(
#  f = "getEnv",
#  signature = "CachingObjectOwner",
#  definition = function(object){
#    object$getEnv()
#  }
#)

## delegate "objects" calls to the enclosed EnhancedObjects class
#objects.CachingObjectOwner <-
#  function(name, all.names, pattern)
#{
#  objects (name$objects, all.names, pattern) 
#}

## delegate "names" calls to the enclosed EnhancedObjects class
names.CachingObjectOwner <-
  function(x)
{
  "objects"
}





