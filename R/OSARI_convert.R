#' OSARI_convert
#'
#' Converts OSARI data into standard format used by BASTD_analyze.R
#'
#' @param dataframe refers to a dataframe containing participant's performance
#'
#' @return OSARI_convert returns the OSARI data with standardised column names and values for use with BASTD_analyze.R and OSARI_visualize.R
#'
#' @examples
#' NA

#' @export

OSARI_convert <- function(data){

  osari_data <- data

  #Standardize the 'correct' column to make all incorrect responses 0 and all correct responses 2
  osari_data$correct[osari_data$correct=="1"] <- "2"
  osari_data$correct[osari_data$correct=="0"] <- "0"
  osari_data$correct[osari_data$correct=="-1"] <- "0"

  # Convert the columns of data to the universal columns names used by BASTD_analyze and OSARI_visualize
  ID <- osari_data$id
  Block <- osari_data$block
  Trial <- osari_data$trial
  TrialType <- osari_data$trialType
  Stimulus <- NA
  Signal <- osari_data$signal
  Correct <- osari_data$correct
  Response <- osari_data$response
  RT <- suppressWarnings(as.numeric(osari_data$rt) * 1000)
  RE <- NA
  SSD <- suppressWarnings(as.numeric(osari_data$ssd) * 1000)

  converted_osari_data <- as.data.frame(
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

  return(converted_osari_data)
}



