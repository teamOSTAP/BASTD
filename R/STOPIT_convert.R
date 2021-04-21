#' STOPIT_convert
#'
#' Converts STOP-IT data into standard format used by BASTD_analyze.R
#'
#' @param dataframe refers to a dataframe containing participant's performance
#'
#' @return STOPIT_convert returns the STOP-IT data with standardised column names and values for use with BASTD_analyze.R and BASTD_visualize.R
#'
#' @examples
#' NA

#' @export

STOPIT_convert <- function(data){
  # data <- STOP_IT_data
  stopit_data <- data

  # Convert the columns of data to the universal columns names used by BASTD_analyze and OSARI_visualize
  ID <- stopit_data$ID
  Block <- stopit_data$block
  Trial <- stopit_data$trial
  TrialType <- stopit_data$trialType
  Stimulus <- NA
  Signal <- stopit_data$signal
  Correct <- stopit_data$correct
  Response <- stopit_data$response
  RT <- suppressWarnings(as.numeric(stopit_data$rt))
  RE <- NA
  SSD <- suppressWarnings(as.numeric(stopit_data$ssd))

  converted_stopit_data <- as.data.frame(
    cbind(
      ID,
      Block,
      Trial,
      Stimulus,
      Signal,
      Response,
      Correct,
      RT,
      RE,
      SSD,
      TrialType
    )
  ) #create the dataframe used for BASTD_analyze

  return(converted_stopit_data)
}



