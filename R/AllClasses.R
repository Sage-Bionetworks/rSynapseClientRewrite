# Class Definitions
# 
# Author: furia
###############################################################################

setClass(
  "Attributes",
  representation = representation(
    attributeMap = "list"
  )
)

setRefClass(
  Class = "BaseObject",
  contains = "VIRTUAL"
)

setClass(
  Class = "EnhancedEnvironment",
  representation = representation(
    env = "environment"
  )
)

setClass(
  Class = "CachingEnhancedEnvironment",
  contains = "EnhancedEnvironment",
  representation = representation(
    cacheDir = "character",
    prefix = "character"
  )
)

setRefClass(
  Class = "ReadOnlyObjectOwner",
  contains = c("BaseObject", "VIRTUAL"),
  fields = list(
    objects = "EnhancedEnvironment"
  ),
  methods = list(
    getObject = function(which){
      getObject(.self, which)
    },
    initialize = function(){
      callSuper()
      .self$initFields(objects = new("EnhancedEnvironment"))
    }
  ) 
)

setRefClass(
  Class = "CachingObjectOwner",
  contains = c("ReadOnlyObjectOwner", "VIRTUAL"),
  fields = list(
    objects = "CachingEnhancedEnvironment"
  ),
  methods = list(
    addObject = function(object, name, unlist = FALSE){
      if(missing(name) && class(object) == "list")
        addObject(.self, object, name, unlist)
    },
    intialize = function(){
      .self$initFields(
        objects = new("CachingEnhancedEnvironment")
      )
    }
  )
)

## singleton to indicate the availablility of zip
setClass(
  Class = "ZipIndicator",
  representation = representation(
    hasZip = "logical"
  ),
  prototype = prototype(
    hasZip = synapseClient:::.checkZip()
  )
)

