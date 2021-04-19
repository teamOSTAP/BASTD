# functions & packages ---------------------------------------------------------------
load.packages <- function(pkg) {
  new.pkg <- pkg[!(pkg %in% installed.packages()[ , "Package"])]
  if (length(new.pkg)) {
    install.packages(new.pkg, dependencies = T)
  }
  sapply(pkg, require, character.only = T)
}

packages <- c("tidyverse", "nlme", "ggpubr", "Hmisc", "plyr", "Rmisc", "retimes", "data.table", "lme4","multcomp",
              "pastecs", "effects", "DataCombine", "gridExtra", "leaps", "ppcor", "ggm", "readxl", "emmeans",
              "eeptools", "psych","weights", "here", "cowplot", "reghelper", "sjstats", "devtools", "reader")

load.packages(packages)

#To install the retimes package, which is required for BASTD to estimate ex-gaussian parameters of response times, you will need to install 'retimes' package from the CRAN archive

#If you are using a Mac:
#retimes will require you to have Xcode (see: https://stackoverflow.com/questions/24194409/how-do-i-install-a-package-that-has-been-archived-from-cran)
# install_url("https://cran.r-project.org/src/contrib/Archive/retimes/retimes_0.1-2.tar.gz") #this will install xcode if you do not already have it installed, followed by retimes
# library(retimes) #initialise retimes

#If you are using Windows:
#see (https://ohdsi.github.io/Hades/rSetup.html) for information about installation
# library(retimes) #initialise retimes

# BASTD tester ------------------------------------------------------------
# install the latest version of the package -------------------------------
install_github("teamOSTAP/BASTD", force = TRUE) #install latest version of BASTD from GitHub
library(BASTD) #read the package into the library

# OSARI  ------------------------------------------------------------------
example_OSARI_data <- "https://raw.githubusercontent.com/teamOSTAP/BASTD/main/example-data/OSARI_raw.txt"
OSARI_data <- read.csv(example_OSARI_data, header = TRUE, sep = "") #read the example OSARI data

# OSARI analyze
OSARI_analyze(data = OSARI_data)
OSARI_analyze(data = OSARI_data)[[1]] #Subset to all variables
OSARI_analyze(data = OSARI_data)[[2]] #Subset to just accurate go trials with omissions replaced variables

# OSARI visualize
OSARI_visualize(data = OSARI_data)

