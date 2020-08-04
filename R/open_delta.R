#' Open a connection to MPCA's internal oracle database DELTAW, which houses TEMPO, EQUIS, RAPIDS, ONBASE
#'
#' Requires access to MPCA's internal network and X-drive.
#'
#'#' @param delta_dsn The Data Source Name assigned to the `DELTAW` database. The default value, `NULL`. will search your computer's data sources for "delta" and use the first returned value.
#'
#' @examples
#' library(mpcadb)
#'
#' /dontrun{
#' open_delta()
#' }
#'
#' @export

open_delta <- function(delta_dsn = NULL) {

      # Check if deltaw DB is available
      dbs <- RODBC::odbcDataSources(type = c("all", "user", "system"))

      # If not found and no DSN value supplied, EXIT
      if (length(grep("delta", names(dbs))) == 0 & is.null(delta_dsn)) {

        warning("I am sorry. The DELTA database was not found on this computer. But there's still hope. Try emailing Derek Nagel for instructions on adding the database connection.")

        return()

      } else { # Use the first DSN with "delta" in it


        if (is.null(delta_dsn)) {

          delta_dsn <- names(dbs)[grep("delta", names(dbs))]

        }

        creds <- get_creds()

        if (!exists("deltaw") || class(deltaw) != "RODBC") {

          if (FALSE) {
            # Connect to deltaW
            deltaw <<- DBI::dbConnect(odbc::odbc(),
                                     delta_dsn,
                                     timeout = 10,
                                     uid     = creds[1],
                                     pwd     = creds[2])

          }

             deltaw <<- RODBC::odbcConnect(delta_dsn,
                                       uid = creds[1],
                                       pwd = creds[2],
                                       believeNRows = FALSE)


          message("Connection successful!")

          return(deltaw)
      }
    }
}

