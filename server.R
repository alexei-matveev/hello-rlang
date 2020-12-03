#
# https://rosettacode.org/wiki/Hello_world/Web_server#R
#
# aptitude install r-cran-httpuv
#
library(httpuv)

runServer("0.0.0.0", 5000,
	list(
		call = function(req) {
		  list(status = 200L,	headers = list('Content-Type' = 'text/html'), body = "Hello world!")
	        }
	)
)

