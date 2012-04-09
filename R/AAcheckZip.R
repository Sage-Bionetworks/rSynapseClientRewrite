# TODO: Add comment
# 
# Author: furia
###############################################################################
.checkZip <-
  function(quiet = FALSE)
{
  ##set the R_OBJECT cache directory. check for a funcitonal zip first
  if(!quiet)
    message("Verifying zip installation")
  ff <- tempfile()
  file.create(ff)
  zzfile <- tempfile()
  ans <- zip(zzfile, ff)
  
  ## clean up
  file.remove(ff)
  if(file.exists(zzfile))
    file.remove(zzfile)
  
  ## check return value
  if(ans != 0){
    if(!quiet)
      warning("zip was not found on your system and so the Synapse funcionality related to file and object storage will be limited. To fix this, make sure that 'zip' is executable from your system's command interpreter.")
    retun(FALSE)
  }
  if(!quiet)
    message("OK")
  TRUE
}

