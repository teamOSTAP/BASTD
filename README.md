# Batch Analysis of Stop-signal Task Data (BASTD)
BASTD is a package with a series of functions used to analyze and visualize stop-signal task (SST) data.

Written by Jason L He, Rohan Puri, Rebecca J Hirst

Created in R Studio 1.3.1093

Last edited: 07/04/2021

Script created to analyse data from the paradigm described in the following article:

He, J. L , Hirst, R. J , Pedapati, E., Byblow, W., Chowdhury, N., Coxon, J., Gilbert, Donald., Heathcote, A., Hinder, M., Hyde, C., Silk. T., Leunissen, I., McDonald, H., Nikitenko, T., Puri, R., Zandbelt, B., Puts, N. (In prep) Open-Source Anticipated Response Inhibition task (OSARI): a cross-platform installation and analysis guide. 


## About
BASTD was created to comprehensively batch analyse data from standard stop-signal paradigms. It was primarily developed to analyse data from OSTAP's OSARI, though it can be adapted to analyse data from other stop-signal paradigms. If you need help with implementing BASTD, please email the team at: opensourceTAP@gmail.com

## Getting Started
The functions of BASTD can be separated into those which analyze and those which visualize.

The functions which analyze data are: 

    . BASTD_analyze()
    . OSARI_analyze() and
    . STOPIT_analyze()

### BASTD_analyze 

Requires input of data collected from the SST. Given that different versions of the SST have different column names, it is the job of the user to ensure that column names line up with the column names used by BASTD_analyze. 

The column names are: (ID, Block, Trial, Stimulus, Signal, Correct, Response, RT, RE, SSD, TrialType)

ID: Any Character or String
Trial: Numeric values in increasing order and reset after every block (e.g., 0-64)
Stimulus: 1 or 2 (for choice-reaction variants of the SST)
Signal: 0 or 1 (0 meaning no signal was presenented (i.e., a Go-trial) and 1 meaning a signal was presented (i.e., a Stop-trial)
Correct: 0 or 2 (0 for incorrect, 2 for correct) 
Response: 0 or 1 (0 for no response, 1 for a response being made)
RT: A numerical value for RT in ms (e.g., 300 ms)
RE: *Not currently implemented*
SSD: A numerical value for Stop-signal delay in ms (e.g., 250 ms)
TrialType (Optional): *only relevant for data from OSARI*

Provided the column names are consistent with the above, BASTD_analyze should be able to analyze any dataset from a SST. 

### OSARI_analyze 
Converts data from OSARI to be compatible with BASTD_analyze. Returns analyzed data. See example-data for file structure.

### STOPIT_analyze
Converts data from STOP-IT to be compatible with BASTD_analyze. Returns analyzed data. See example-data for file structure.

Those which visualize are: 

    . OSARI_visualize()
    . STOPIT_visualize()

### Context independence violations

There may be violations of context independence in the data collected with OSARI. If you have reason to suspect this is the case, we recommend using the Dynamic Models of Choice (DMC) R system, which can be accessed at: osf.io/tw46u/. Please see the manuscript for further information. 

## Thanks for using BASTD
