#' Get all Agency Interest (AI) names from TEMPO.
#'
#' Requires a connection to MPCA's internal network.
#'
#' @param ai Vector of Agency Interest numbers to keep. The default, `NULL`. will keep all values.
#'
#' @param keep_alt_names Include alternative names? Default is `TRUE`. which will include a facility's previous names.
#'
#' @param tempo_test Connect to TEMPO's test database? Default is `FALSE`. which connects to TEMPO's working / production database.
#'
#' @examples
#' library(mpcadb)
#'
#' /dontrun{
#' get_ai(ai = c(3421, 566), keep_alt_names = TRUE, tempo_test = FALSE)
#' }
#'
#' @export

get_equis_monitors <- function(ai             = NULL,
                               keep_alt_names = TRUE,
                               tempo_test     = FALSE
                                 ) {

      deltaw <- con_delta()


      # Query to get alternative AI names and IDs
      query_alt_names   <- "SELECT * FROM EQUIS.RT_ANALYTE"

      # Add AI filter
      if (!is.null(ai)) {

        ai <- as.numeric(ai)

        ai <- ai[!is.na(ai)]

        if (length(ai) > 0) {

          ai_filter <- paste0("IN (", paste(paste0("'", as.numeric(ai), "'"), collapse = ", "), ")")

          query_alt_names <- paste(query_alt_names, "AND (master_ai_id", ai_filter) %>%
                             paste("OR alternate_ai_id", ai_filter, ")")
        }
      }

      # Run query
      alt_names <- RODBC::sqlQuery(deltaw, query_alt_names, max = 100000)

      # Drop columns
      alt_names <- dplyr::select(alt_names, -c(TMSP_CREATED, USER_CREATED, TMSP_LAST_UPDT, USER_LAST_UPDT))


      # Rename start/end date columns
      alt_names <- dplyr::rename(alt_names,
                                 START_DATE_ALT = START_DATE,
                                 END_DATE_ALT   = END_DATE)


      # Query to get AI names
      query_ai_names <- "SELECT *
                         FROM
                            tempo.agency_interest
                         WHERE
                            int_doc_id = 0"

      # Add AI filter
      if (!is.null(ai)) {

        ai_filter <- paste0("IN (", paste(paste0("'", alt_names$MASTER_AI_ID, "'"), collapse = ", "), ")")

        query_ai_names <- paste(query_ai_names, "AND master_ai_id", ai_filter)

      }

      # Run query
      ai_names <- sqlQuery(deltaw, query_ai_names)

      # Drop columns
      ai_names <- dplyr::select(ai_names, -c(TMSP_CREATED, USER_CREATED, TMSP_LAST_UPDT, USER_LAST_UPDT))

      name_order <- names(ai_names)

      # Join together if alt names needed
      if (keep_alt_names) {

        alt_names <- dplyr::left_join(alt_names, ai_names,
                                      by = c("MASTER_AI_ID", "INT_DOC_ID"))

        alt_names <- dplyr::select(alt_names, all_of(name_order), everything())

        # Add any AI missing from Alt ID table
        ai_names <- dplyr::bind_rows(alt_names, dplyr::filter(ai_names, !MASTER_AI_ID %in% alt_names$MASTER_AI_ID))

      }

        return(ai_names)
}

#' @rdname get_ai
#' @examples get_ai_names(ai = c(4558, 12, 549, 1:5), keep_alt_names = TRUE, tempo_test = FALSE)
#' @export
get_ai_names <- get_ai

