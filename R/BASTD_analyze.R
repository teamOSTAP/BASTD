#' BASTD_analyze
#'
#'Batch analysis of stop-signal task data or BASTD is a function used to batch analyze SST data
#'In order to use this function, you may need to change the column name of your output files
#'The column names required are: ID, Block, Trial, Stimulus, Signal, Correct, Response, RT, RE, SSD
#'BASTD_analyze is used by OSARI_analyze and STOPIT_analyze
#'
#' @param dataframe refers to a dataframe containing participant's performance
#'
#' @return BASTD_analyze will return a dataframe with a single row, containing the performance metrics for all the protocols completed by a given participant.
#'
#' @examples
#' See OSARI_analyze or STOPIT_analyze for examples
#'
#' @export

BASTD_analyze <- function(data, task){

warning(
"Note:
 BASTD_analyze produces performance outcomes for go trials in three different ways
  1. Including all go trials, regardless of accuracy
  2. Including only accurate go trials
  3. Including only inaccurate go trials
  4. Including only accurate go trials with go omission errors replaced

  It is recommended that users use option 4, see consensus paper:
  https://elifesciences.org/articles/46323

  For all performance outcomes use [[1]]
  For performance outcomes with omission errors replaced use[[2]]

Additional Note:
 We recommend users check for violations of context independence (CI) before using the SSRTs estimated using BASTD.
 To check for violations of CI, and to estimate SSRTs when CI is violated, see: osf.io/tw46u/

"
  )


# Setup -------------------------------------------------------------------
#Convert the data into the appropriate format for use with BASTD analyze

if(task == "OSARI"){
  data <- OSARI_convert(data)
  maximum_go_trial_RT <- 1000
}

if(task == "STOP-IT"){
  # data <- data
  maximum_go_trial_RT <- 1250
}

# Standardize naming ------------------------------------------------------
names(data)[names(data) == "block"] <- "Block"
names(data)[names(data) == "trial"] <- "Trial"
names(data)[names(data) == "stimulus"] <- "Stimulus"
names(data)[names(data) == "signal"] <- "Signal"
names(data)[names(data) == "respons"] <- "Response" #STOP-IT has 'respons' rather than 'response'
names(data)[names(data) == "response"] <- "Response"
names(data)[names(data) == "correct"] <- "Correct"
names(data)[names(data) == "rt"] <- "RT"
names(data)[names(data) == "re"] <- "RE"
names(data)[names(data) == "ssd"] <- "SSD"

  #Note: you may use a version of the stop-signal task with slightly different column names
  #You may use this section to adjust the script to suit your data
  #Simply replace the left hand side with the corresponding column in your data


# Participant information -------------------------------------------------
id_number <- data$ID[[1]] #store the participant id number

# Procedure characteristics ------------------------------------------------
#Save information about the task characteristics

if(task == "STOP-IT"){

number_of_blocks <- length(unique(data$Block))

number_of_go_trials_per_block <- nrow(data[data$Signal==0 &
                                             data$Block==0,])

number_of_stop_trials_per_block <- nrow(data[data$Signal==1 &
                                               data$Block==0,])

}

if(task == "OSARI"){

number_of_blocks <- length(unique(data$TrialType))

number_of_go_trials_per_block <- nrow(data[data$Signal==0 &
                                             data$Block==0 & data$TrialType=="testBlocks",])

number_of_stop_trials_per_block <- nrow(data[data$Signal==1  &
                                               data$Block==0 & data$TrialType=="testBlocks",])
}

procedure_characteristics <- cbind(
  number_of_blocks,
  number_of_go_trials_per_block,
  number_of_stop_trials_per_block
  )


# Standard Go trial performance outcomes ---------------------------------

all_go_trials <- data[data$Signal==0,] #subset dataframe to only go trials
n_of_go_trials <- nrow(all_go_trials) #number of go trials

#accuracy and omissions
go_trial_accuracy <- (nrow(all_go_trials[all_go_trials$Correct==2,])/n_of_go_trials) * 100
omission_error <- (nrow(all_go_trials[all_go_trials$Response==0,])/n_of_go_trials) * 100

#Go trial RT irrespective of accuracy
go_trial_RT_mean <- mean(as.numeric(as.character(all_go_trials$RT)))
go_trial_RT_sd <- sd(as.numeric(as.character(all_go_trials$RT)))

#Accurate Go trial RT
accurate_go_trial_RT_mean <- mean(as.numeric(as.character(all_go_trials$RT[all_go_trials$Correct==2])))
accurate_go_trial_RT_sd <- sd(as.numeric(as.character(all_go_trials$RT[all_go_trials$Correct==2])))

#Inaccurate Go trial RT
inaccurate_go_trial_RT_mean <- mean(as.numeric(as.character(all_go_trials$RT[all_go_trials$Response!=0 &
                                                                               all_go_trials$Correct==0])))

inaccurate_go_trial_RT_sd <- sd(as.numeric(as.character(all_go_trials$RT[all_go_trials$Response!=0 &
                                                                           all_go_trials$Correct==0])))

#Accurate Go trial RT with omissions replaced
suppressWarnings(all_go_trials_omissions_replaced_with_max_duration <- all_go_trials)
suppressWarnings(all_go_trials_omissions_replaced_with_max_duration$RT[all_go_trials_omissions_replaced_with_max_duration$Response==0] <- maximum_go_trial_RT) #replace any omission errors with the maximum go trial RT
suppressWarnings(all_go_trials_omissions_replaced_with_max_duration$Correct[all_go_trials_omissions_replaced_with_max_duration$Response==0] <- 2) #replace any omission errors that are deemed to be inaccurate to be accurate

go_trial_RT_mean_omissions_replaced_with_max_duration <- mean(as.numeric(as.character(all_go_trials_omissions_replaced_with_max_duration$RT))) #RT with omission errors replaced as maximum go trial RT (using all trials regardless of accuracy)
go_trial_RT_sd_omissions_replaced_with_max_duration <- sd(as.numeric(as.character(all_go_trials_omissions_replaced_with_max_duration$RT))) #RT with omission errors replaced as maximum go trial RT (using all trials regardless of accuracy)

accurate_go_trial_RT_mean_omissions_replaced_with_max_duration <- mean(as.numeric(as.character(all_go_trials_omissions_replaced_with_max_duration$RT[all_go_trials_omissions_replaced_with_max_duration$Correct==2]))) #RT with omission errors replaced as maximum go trial RT (using only accurate trials)
accurate_go_trial_RT_sd_omissions_replaced_with_max_duration <- sd(as.numeric(as.character(all_go_trials_omissions_replaced_with_max_duration$RT[all_go_trials_omissions_replaced_with_max_duration$Correct==2]))) #RT with omission errors replaced as maximum go trial RT (using only accurate trials)

#combine all the go trial performance data
go_trial_performance_outcomes <- cbind(
  go_trial_accuracy,
  omission_error,
  go_trial_RT_mean,
  go_trial_RT_sd,
  accurate_go_trial_RT_mean,
  accurate_go_trial_RT_sd,
  inaccurate_go_trial_RT_mean,
  inaccurate_go_trial_RT_sd,
  go_trial_RT_mean_omissions_replaced_with_max_duration,
  go_trial_RT_sd_omissions_replaced_with_max_duration,
  accurate_go_trial_RT_mean_omissions_replaced_with_max_duration,
  accurate_go_trial_RT_sd_omissions_replaced_with_max_duration
  )

# Standard Stop trial performance outcomes --------------------------------

all_stop_trials <- data[data$Signal==1,] #subset dataframe to only go trials
n_of_stop_trials <- nrow(all_stop_trials) #number of go trials

#Accuracy
stop_trial_accuracy <- (nrow(all_stop_trials[all_stop_trials$Correct==2,]))/(nrow(all_stop_trials)) * 100

#Failed Stop RTs
failed_stop_RT_mean <- mean(as.numeric(as.character(all_stop_trials$RT[all_stop_trials$Correct == 0])))
failed_stop_RT_sd <- sd(as.numeric(as.character(all_stop_trials$RT[all_stop_trials$Correct==0])))

stop_trial_performance_outcomes <- cbind(
  stop_trial_accuracy,
  failed_stop_RT_mean,
  failed_stop_RT_sd
  )

# Ex-Gaussian parameters of Go RT distribution  -------------------------
#Estimation of ex-gaussian parameters for the Go RT distribution using the retimes package
#Note that the retimes package is now archived, and has to be installed (see howTo.R)

#Go trial RT irrespective of accuracy
all_go_trial_RTs_with_omissions <- as.numeric(as.character(all_go_trials$RT))
all_go_trial_RTs_without_omissions <- all_go_trial_RTs_with_omissions[!is.na(all_go_trial_RTs_with_omissions)]
exGaus_go_trial_RT <- retimes::mexgauss(all_go_trial_RTs_without_omissions)
mu_go <- exGaus_go_trial_RT[[1]]
sigma_go <- exGaus_go_trial_RT[[2]]
tau_go <- exGaus_go_trial_RT[[3]]

#Go trial RT for only accurate Go trials
accurate_go_trial_RTs <- as.numeric(as.character(all_go_trials$RT[all_go_trials$Response!=0 & all_go_trials$Correct==2]))
if(length(
  accurate_go_trial_RTs
  ) > 1){

  exGaus_accurate_go_trial_RT <- retimes::mexgauss(accurate_go_trial_RTs)
  mu_accurate_go <- exGaus_accurate_go_trial_RT[[1]]
  sigma_accurate_go <- exGaus_accurate_go_trial_RT[[2]]
  tau_accurate_go <- exGaus_accurate_go_trial_RT[[3]]

} else {
  mu_accurate_go <- NA
  sigma_accurate_go <- NA
  tau_accurate_go <- NA
}

#Go trial RT for only accurate Go trials with omission errors replaced with maximum trial duration (recommended by consensus paper)
#see: https://elifesciences.org/articles/46323

accurate_go_trial_RTs_with_omissions_replaced_with_max_duration <- as.numeric(as.character(all_go_trials_omissions_replaced_with_max_duration$RT))
accurate_go_trial_RTs_with_omissions_replaced_with_max_duration <- accurate_go_trial_RTs_with_omissions_replaced_with_max_duration[!is.na(accurate_go_trial_RTs_with_omissions_replaced_with_max_duration)]

if(length(
  accurate_go_trial_RTs_with_omissions_replaced_with_max_duration
  ) > 1){

  exGaus_accurate_go_trial_RT_with_omissions_replaced_with_max_duration <- retimes::mexgauss(accurate_go_trial_RTs_with_omissions_replaced_with_max_duration)
  mu_accurate_go_omissions_replaced_with_max_duration <- exGaus_accurate_go_trial_RT_with_omissions_replaced_with_max_duration[[1]]
  sigma_accurate_go_omissions_replaced_with_max_duration <- exGaus_accurate_go_trial_RT_with_omissions_replaced_with_max_duration[[2]]
  tau_accurate_go_omissions_replaced_with_max_duration <- exGaus_accurate_go_trial_RT_with_omissions_replaced_with_max_duration[[3]]

} else {

  mu_accurate_go_omissions_replaced_with_max_duration <- NA
  sigma_accurate_go_omissions_replaced_with_max_duration <- NA
  tau_accurate_go_omissions_replaced_with_max_duration <- NA

}

#Inaccurate Go trial RT
inaccurate_go_trial_RTs <- as.numeric(as.character(all_go_trials$RT[all_go_trials$Response!=0 &
                                                                      all_go_trials$Correct==0]))

inaccurate_go_trial_RTs <- inaccurate_go_trial_RTs[!is.na(inaccurate_go_trial_RTs)]

if(length(inaccurate_go_trial_RTs) > 1){

  exGaus_inaccurate_go_trial_RT <- retimes::mexgauss(inaccurate_go_trial_RTs)
  mu_inaccurate_go <- exGaus_inaccurate_go_trial_RT[[1]]
  sigma_inaccurate_go <- exGaus_inaccurate_go_trial_RT[[2]]
  tau_inaccurate_go <- exGaus_inaccurate_go_trial_RT[[3]]

} else {

  mu_inaccurate_go <- NA
  sigma_inaccurate_go <- NA
  tau_inaccurate_go <- NA

}

exGaussian_go_outcomes <- cbind(mu_go,
                                sigma_go,
                                tau_go,
                                mu_accurate_go,
                                sigma_accurate_go,
                                tau_accurate_go,
                                mu_inaccurate_go,
                                sigma_inaccurate_go,
                                tau_inaccurate_go,
                                mu_accurate_go_omissions_replaced_with_max_duration,
                                sigma_accurate_go_omissions_replaced_with_max_duration,
                                tau_accurate_go_omissions_replaced_with_max_duration
                                )


# Ex-Gaussian parameters of SSRT distribution (W.I.P) ---------------------

# SSRT --------------------------------------------------------------------
unique_ssds <- unique(all_stop_trials$SSD) #list the unique ssds
mean_ssd <- mean(as.numeric(as.character(all_stop_trials$SSD))) #mean SSD
mean_presp <- mean(as.numeric(as.character(all_stop_trials$Correct))/2) #nb: divide by 2 is because correct = 2


# Estimating SSRTs using the mean method ----------------------------------
go_trial_RT_SSRT_mean_method <- go_trial_RT_mean - mean_ssd #SSRT irrespective of Go trial accuracy

accurate_go_trial_SSRT_mean_method <- accurate_go_trial_RT_mean - mean_ssd #Accurate Go trial SSRT

go_trial_RT_SSRT_mean_method_omissions_replaced_with_max_duration <- go_trial_RT_mean_omissions_replaced_with_max_duration - mean_ssd #Go trial SSRT with omissions replaced

accurate_go_trial_SSRT_mean_method_omissions_replaced_with_max_duration <- accurate_go_trial_RT_mean_omissions_replaced_with_max_duration - mean_ssd #Accurate Go trial SSRT with omissions replaced


# Estimating SSRTs using the integration method ---------------------------

#SSRT regardless of go accuracy
nth_all_go_RTs <- stats::quantile(as.numeric(as.character(all_go_trials$RT)),
                                  probs = mean_presp,
                                  type = 6,
                                  na.rm = TRUE)

all_go_SSRT_integration_method <- nth_all_go_RTs - mean_ssd

#SSRT using only accurate go RTs
nth_correct_go_RTs <- stats::quantile(as.numeric(as.character(all_go_trials$RT[all_go_trials$Correct==2])),
                                      probs = mean_presp,
                                      type = 6,
                                      na.rm = TRUE)

accurate_go_SSRT_integration_method <- nth_correct_go_RTs - mean_ssd

#SSRT using only accurate go RTs with omission errors being replaced with maximum go RT
nth_correct_go_RTs_with_omissions_replaced_with_max_duration <- stats::quantile(as.numeric(as.character(all_go_trials_omissions_replaced_with_max_duration$RT[all_go_trials_omissions_replaced_with_max_duration$Correct==2])),
                                                                                probs = mean_presp,
                                                                                type = 6,
                                                                                na.rm = TRUE)

accurate_go_SSRT_omissions_replaced_integration_method <- nth_correct_go_RTs_with_omissions_replaced_with_max_duration - mean_ssd

SSRT_outcomes <- cbind(
  go_trial_RT_SSRT_mean_method,
  accurate_go_trial_SSRT_mean_method,
  go_trial_RT_SSRT_mean_method_omissions_replaced_with_max_duration,
  accurate_go_trial_SSRT_mean_method_omissions_replaced_with_max_duration,
  all_go_SSRT_integration_method,
  accurate_go_SSRT_integration_method,
  accurate_go_SSRT_omissions_replaced_integration_method,
  mean_ssd,
  mean_presp
  )

all_outcomes <- as.data.frame(cbind(
  id_number,
  procedure_characteristics,
  go_trial_performance_outcomes,
  exGaussian_go_outcomes,
  stop_trial_performance_outcomes,
  SSRT_outcomes)
  )

row.names(all_outcomes) <- c() #clear the row name

#change values to numeric and round to two decimal places
all_outcomes[7:40] <- lapply(all_outcomes[7:40], as.numeric)
all_outcomes[7:40] <- lapply(all_outcomes[7:40], round, 2)

standard_cols <- c(
  "id_number",
  "number_of_blocks",
  "number_of_go_trials_per_block",
  "number_of_stop_trials_per_block",
  "go_trial_accuracy",
  "omission_error",
  "stop_trial_accuracy",
  "failed_stop_RT_mean",
  "failed_stop_RT_sd",
  "mean_ssd",
  "mean_presp",
  "accurate_go_trial_RT_mean_omissions_replaced_with_max_duration",
  "accurate_go_trial_RT_sd_omissions_replaced_with_max_duration",
  "mu_accurate_go_omissions_replaced_with_max_duration",
  "sigma_accurate_go_omissions_replaced_with_max_duration",
  "tau_accurate_go_omissions_replaced_with_max_duration",
  "accurate_go_trial_SSRT_mean_method_omissions_replaced_with_max_duration",
  "accurate_go_SSRT_omissions_replaced_integration_method"
)

standard_outcomes <- all_outcomes[standard_cols]

all_outcomes <- list(all_outcomes,
                     standard_outcomes
                     )

# return(all_outcomes)
return(all_outcomes)
}



