#!/usr/bin/Rscript
#
# https://rsqlite.r-dbi.org/
#
#     $ aptitude install r-cran-dbi r-cran-rsqlite
#
# For MySQL try:
#
#     $ aptitude install libmariadbclient-dev
#     > install.packages("RMariaDB")
#
library(DBI)

# Create an ephemeral in-memory RSQLite database
con <- dbConnect(RSQLite::SQLite(), dbname = ":memory:")

dbListTables(con)
dbWriteTable(con, "mtcars", mtcars)
dbListTables(con)

dbListFields(con, "mtcars")
dbReadTable(con, "mtcars")

# You can fetch all results:
res <- dbSendQuery(con, "SELECT * FROM mtcars WHERE cyl = 4")
dbFetch(res)
dbClearResult(res)

# Or a chunk at a time
res <- dbSendQuery(con, "SELECT * FROM mtcars WHERE cyl = 4")
while(!dbHasCompleted(res)){
    chunk <- dbFetch(res, n = 5)
    print(nrow(chunk))
}
dbClearResult(res)

dbDisconnect(con)
