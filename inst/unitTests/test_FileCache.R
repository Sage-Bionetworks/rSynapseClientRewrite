# TODO: Add comment
# 
# Author: furia
###############################################################################


unitTestAddFile <-
  function()
{
  fc <- new("FileCache")
  file <- tempfile(prefix="fileOne")
  checkTrue(file.create(file))
  addFile(fc, file)
  checkEquals(length(fc$files), 1L)
  fname <- gsub(tempdir(), "", file, fixed = TRUE)
  fname <- gsub("^/", "", fname)
  checkEquals(fc$files, fname)
  checkTrue(file.exists(file.path(fc$cacheDir, fc$files)))
  
  file2 <- tempfile(prefix = "fileTwo")
  checkTrue(file.create(file2))
  addFile(fc, file2, "apath/")
  checkTrue(all(file.exists(file.path(fc$cacheDir, fc$files))))
  checkTrue(all(fc$files == c(fileOne, "aPath/fileTwo")))
  
}


unitTestDeleteFile <-
  function()
{
  
}

unitTestMoveFile <-
  function()
{
  
}

