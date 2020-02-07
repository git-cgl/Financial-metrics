# DCC Models Script

#==============================================================================
# DCC
# =============================================================================
StdRes.1 <- DCCPre.1$sresi
StdRes.2 <- DCCPre.2$sresi # save the residuals

detach("package:rmsfuns", unload=TRUE)
detach("package:tidyverse", unload=TRUE)
detach("package:tbl2xts", unload=TRUE)


DCC.1 <- dccFit(StdRes.1, type="Engle")
DCC.2 <- dccFit(StdRes.2, type="Engle")

library(rmsfuns)
load_pkg(c("tidyverse", "tbl2xts"))

Rhot.1 <- DCC.1$rho.t
Rhot.2 <- DCC.2$rho.t

# Renaming function
source("code/renamingdcc.R")

# To see if the function works
Rhot.1 <-
  renamingdcc(ReturnSeries = rtn.1, DCC.TV.Cor = Rhot.1)

Rhot.2 <-
  renamingdcc(ReturnSeries = rtn.2, DCC.TV.Cor = Rhot.2)

# Create the correlation dataframe
df.corr <-
  bind_rows(
    Rhot.1 %>% mutate(Period = "Period 1"),
    Rhot.2 %>% mutate(Period = "Period 2")) %>%
  left_join(., equity.list %>% mutate(Pairs = gsub(" Index", "", Ticker)) %>% 
              mutate(Pairs = paste0("MXZA_", Pairs)), by = "Pairs") %>% filter(!is.na(Country)) %>% 
  filter(Pairs != "MXZA_MXZA")
