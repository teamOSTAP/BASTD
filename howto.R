# Below is a working example of how OSARI_analyze and OSARI_visualize are used:
# Author contact: jasonhe93@gmail.com

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
install_github("teamOSTAP/BASTD", force = TRUE) #install latest version of BASTD from GitHub
library(BASTD) #read the package into the library
library(here)

# OSARI  ------------------------------------------------------------------
example_OSARI_data <- "https://raw.githubusercontent.com/OSTAPL/BASTD/master/example-data/OSARI_raw.txt" # read data in from GitHub
OSARI_data <- read.csv(example_OSARI_data, header = TRUE, sep = "") # read the example STOP-IT data
OSARI_analyze(data = OSARI_data) # OSARI analyze
OSARI_visualize(OSARI_data) # OSARI visualize

# Analyze all examples ----------------------------------------------------
# OSARI_analyzed_all creates a folder called 'analyzed' in the specified working directory
# OSARI_visualized creates a folder called 'visualized' in the specified working directory
# These scripts work by looking for all the files in that folder with the term 'OSARI' and then analyze or visualize those data
OSARI_analyze_all(here("example-data")) # analyzed data will be saved as a .csv file
OSARI_visualize_all(here("example-data")) # visualized data will be saved as a .pdf file

# STOP-IT -----------------------------------------------------------------
# BASTD can also be used for traditional choice reaction stop signal task performance:
example_STOP_IT_data <- "https://raw.githubusercontent.com/OSTAP/BASTD/master/example-data/STOP-IT_raw.csv"
STOP_IT_data <- read.csv(example_STOP_IT_data, header = TRUE) # read the example STOP-IT data
STOPIT_analyze(data = STOP_IT_data) # STOPIT_analyze
