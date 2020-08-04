#' Get credentials for MPCA's internal oracle database DELTA
#'
#' Requires a direct connection to MPCA's internal network. If connection exists, the function will generate login credentials.
#'
#' @examples
#' library(mpcadb)
#'
#' /dontrun{
#' get_creds()
#' }
#'
#'

get_creds <- function() {

    file_loc <- "X:/Agency_Files/Data_Services/DAU/Data Analytics User Group/Shared/r/db_connections/db_con_check.csv"

    if (file.exists(file_loc)) {

      df <- read.csv(file_loc)[ , -1]

      user <- gsub("K", "B", df[29, 1]) %>%
              gsub("P", "A", .) %>%
              gsub("Z", "U", .) %>%
              tolower()

      pwd <- paste0("D", substring(df[42, 1], 3, 5)) %>%
             paste0(df[38, 3]) %>%
             paste0(df[29, 2], df[34, 1], gsub("B", "I", df[46, 1])) %>%
             tolower() %>%
             paste0(df[10, 1] %>% substring(1, 1))

      #message("Success!")

      return(c(user, pwd))

    } else {

      stop(paste("\nSorry for the bad news - the DB connection was unsuccessful. \nMPCA's X-drive was not found, but don't give up! Check your VPN connection and test if you can access this file", file_loc))

    }
}

