LoadPackages <- function(){
  
  library(rmsfuns)
  
  corepacks <- c("tidyverse","tidyselect", "RcppRoll", "ggplot2", "lubridate",
                 "ggthemes", "purrr", "tbl2xts", "xts", "MTS", "devtools", "rugarch", "forecast", "PerformanceAnalytics", "xtable","readxl","ggthemes","ggsci","gridExtra")
  
  load_pkg(corepacks)
  
}

