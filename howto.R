rm(list = ls()) #Clear
# Below is a working example of how BASTD_analyze and BASTD_visualize are used:
# Author contact: teamOSTAP@gmail.com

#To install the retimes package, which is required for BASTD to estimate ex-gaussian parameters of response times, you will need to install 'retimes' package from the CRAN archive

#If you are using a Mac:
#retimes will require you to have Xcode (see: https://stackoverflow.com/questions/24194409/how-do-i-install-a-package-that-has-been-archived-from-cran)
# install_url("https://cran.r-project.org/src/contrib/Archive/retimes/retimes_0.1-2.tar.gz") #this will install xcode if you do not already have it installed, followed by retimes
# library(retimes) #initialise retimes

#If you are using Windows:
#see (https://ohdsi.github.io/Hades/rSetup.html) for information about installation
# library(retimes) #initialise retimes

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



