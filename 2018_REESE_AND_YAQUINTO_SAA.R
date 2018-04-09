## MIND THE GAP: THE MESA VERDE NORTH ESCARPMENT
## KELSEY M. REESE AND BRIAN YAQUINTO
## SOCIETY FOR AMERICAN ARCHAEOLOGY ANNUAL MEETING 
## Mesa Verde Ancestral Pueblo Villages: Recent Research
## Poster Session Chair: Donna M. Glowacki
## Washington, D.C. 2018

## MASTER ##

## FILE STRUCTURE FOR USE:
# The working directory should contain the ANALYSIS and SCRIPT files. SPATIAL and CULTURAL data
# is located one level up from the working directory. You must replace the file paths to 
# your SPATIAL and CULTURAL datasets in ENVIRONMENT.R for everything to run properly.

## SPECIAL INSTRUCTIONS:
# The predictive model 'randomForests' is also dependent on 'rJava', which must be installed and 
# properly configured on your computer before running. You must also run options(java.parameters='-Xmx10g')
# before loading the 'dismo' package. The 'randomForests' package will also prompt
# you to download and install a file in your system to make everything run. These three things are noted
# in ANALYSIS.R in the prediction model section at the bottom of the script.

setwd('/YOUR/WORKING/DIRECTORY/HERE/')

## DIRECTORIES
dir.create('./ANALYSIS/PLOTS/',recursive=T,showWarnings=F)
dir.create('./ANALYSIS/RESULTS/',recursive=T,showWarnings=F)
dir.create('./ANALYSIS/PALEOCAR/',recursive=T,showWarnings=F)

## FUNCTIONS
base::source('../SCRIPT/SP_POLYGON.R')
base::source('../SCRIPT/PALEOCAR.R')

## ENVIRONMENT
base::source('./SCRIPT/ENVIRONMENT.R')

## ANALYSIS
base::source('./SCRIPT/ANALYSIS.R')

## RESULTS
base::source('./SCRIPT/RESULTS.R')

## PLOTS
base::source('./SCRIPT/PLOTS.R')

