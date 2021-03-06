## get the current time
## 
## Author: Nicole Deflaxu <nicole.deflaux@sagebase.org>
###############################################################################

# All dates sent to Synapse should be in UTC
.now <- function() {
  as.POSIXlt(Sys.time(), 'UTC')
}

# All dates sent to Synapse as strings should be formatted as ISO8601 dates in timezone UTC
.nowAsString <- function() {
  format(.now(), "%Y-%m-%dT%H:%M:%S.000Z")
}