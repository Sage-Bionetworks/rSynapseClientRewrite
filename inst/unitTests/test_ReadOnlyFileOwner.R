# TODO: Add comment
# 
# Author: furia
###############################################################################
.setUp <- 
  function()
{
  env <- attach(NULL, name = "testEnv")
  setPackageName("testEnv", env)
  suppressWarnings(
    setRefClass(
      "rFileOwn",
      contains = "ReadOnlyFileOwner",
      where = env
    )
  )
}

.tearDown <-
  function()
{
  detach("testEnv")
}


unitTestBracketAccessor <-
  function()
{
  own <- getRefClass("rFileOwn")$new()
  checkTrue(all(names(own[]) == c("cacheDir", "files")))
  checkTrue(all(names(own[NULL]) == c("cacheDir", "files")))
  
  checkTrue(all(names(own[c("cacheDir", "files")]) == c("cacheDir", "files")))
  checkEquals(names(own[1]), "cacheDir")
  checkTrue(all(names(own[c(2,1)]) == c("files", "cacheDir")))
  checkTrue(all(names(own[-2]) == c("cacheDir")))
}

unitTestDoubleBracketAccessor <-
  function()
{
  own <- getRefClass("rFileOwn")$new()
  own$cacheDir <- "/foo/bar"
  own$files <- "aFile"
  
  checkEquals(own[[2]], "aFile")
  checkEquals(own[['cacheDir']], "/foo/bar")
  
  checkException(own[[-1]])
}