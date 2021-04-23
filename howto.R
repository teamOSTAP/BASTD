rm(list = ls()) #Clear
# Below is a working example of how BASTD_analyze and BASTD_visualize are used:
# Author contact: teamOSTAP@gmail.com

#To install the retimes package, which is required for BASTD to estimate ex-Gaussian parameters of response times, you will need to install 'retimes' package from the CRAN archive

#If you are using a Mac:
#retimes will require you to have Xcode (see: https://stackoverflow.com/questions/24194409/how-do-i-install-a-package-that-has-been-archived-from-cran)
# install_url("https://cran.r-project.org/src/contrib/Archive/retimes/retimes_0.1-2.tar.gz") #this will install xcode if you do not already have it installed, followed by retimes
# library(retimes) #initialise retimes

#If you are using Windows:
#see (https://ohdsi.github.io/Hades/rSetup.html) for information about installation
# library(retimes) #initialize retimes

# Setup -------------------------------------------------------------------
# install the latest version of the package -------------------------------
devtools::install_github("teamOSTAP/BASTD", force = TRUE) #install latest version of BASTD from GitHub
# library(BASTD) #read the package into the library
library(BASTD)
library(here)

# OSARI  ------------------------------------------------------------------
example_OSARI_data <- "https://raw.githubusercontent.com/teamOSTAP/BASTD/main/example-data/OSARI_raw.txt" # read data in from GitHub
OSARI_data <- read.csv(example_OSARI_data, header = TRUE, sep = "") # read the example STOP-IT data
BASTD_analyze(data = OSARI_data, task = "OSARI")[[1]] #Subset to all variables
BASTD_analyze(data = OSARI_data, task = "OSARI")[[2]] #Subset to just accurate go trials with omissions replaced variables
BASTD_visualize(data = OSARI_data, task = "OSARI") #Visualise OSARI data

# STOP-IT -----------------------------------------------------------------
# BASTD's analyze function can also be used for traditional choice reaction stop signal task performance:
example_STOP_IT_data <- "https://raw.githubusercontent.com/teamOSTAP/BASTD/main/example-data/STOP-IT_raw.csv"
STOP_IT_data <- read.csv(example_STOP_IT_data, header = TRUE) # read the example STOP-IT data

BASTD_analyze(data = STOP_IT_data, task = "STOP-IT")[[1]] #Subset to all variables
BASTD_analyze(data = STOP_IT_data, task = "STOP-IT")[[2]] #Subset to just accurate go trials with omissions replaced variables
BASTD_visualize(data = STOP_IT_data, task = "STOP-IT") #Visualize STOP-IT data


# Batch analysis ----------------------------------------------------------
#Below is an example of a for loop which can be used to batch analyze stop-signal task data

sst_files <- list.files(here("example-data"), pattern = "_") #list the stop-signal task files in your working directory

#create lists external to the for loop that can store the analyzed and visualized data
analyzed_sst_data <- list()
visualized_sst_data <- list()

suppressWarnings( #suppress warnings for the for loop
for(f in sst_files){

  #print the participant file being analyzed and visualized
  print(paste("Now analyzing and visualizing participant file:", f))

  #if csv file:
  if(grepl(".csv", f)){
    data <- read.csv(here("example-data", f), header = TRUE, sep = ",")
  }

  #If txt file
  if(grepl(".txt", f)){
    data <- read.csv(here("example-data", f), header = TRUE, sep = "\t")
  }

  #if filename contains OSARI
  if(grepl("OSARI", f)){
    analyzed <- BASTD_analyze(data = data, task = "OSARI")[[1]]
    visualized <- BASTD_visualize(data = data, task = "OSARI") #Visualize STOP-IT data
  }

  #if filename contains STOP-IT
  if(grepl("STOP-IT", f)){
    analyzed <- BASTD_analyze(data = data, task = "STOP-IT")[[1]]
    visualized <- BASTD_visualize(data = data, task = "STOP-IT") #Visualize STOP-IT data
  }

  analyzed_sst_data[[f]] <- analyzed #store the analyzed data
  visualized_sst_data[[f]] <- visualized #store the visualized data
}
)

#combine and then save the analyzed data
analyzed_sst_data_combined <- do.call(rbind, analyzed_sst_data) #combine
write.csv(analyzed_sst_data_combined, here("example-data","analyzed-data", "BASTD_analyzed_sst_data_combined.csv")) #save

#save the visualized data in a single pdf file
pdf(
  here("example-data", "plots","BASTD_visualized_data_combined.pdf"),
    onefile = TRUE,
    width = 12,
    height = 6
    )

print(visualized_sst_data)
dev.off()
