# Vol code

rtn.1 <- Weekly_Ret %>% filter(Period == "Period_1") %>% mutate(Ticker = gsub(" Index", "", Ticker)) %>% 
  select(-Period, -Name, -Value) %>% spread(Ticker, Weekly_Return) %>% tbl_xts()

rtn.2 <- Weekly_Ret %>% filter(Period == "Period_2") %>% mutate(Ticker = gsub(" Index", "", Ticker)) %>%   
  select(-Period, -Name, -Value) %>% spread(Ticker, Weekly_Return) %>% tbl_xts()

rtn.1 <- rtn.1[-1,]
rtn.2 <- rtn.2[-1,]

# Center the data:
rtn.1 <- scale(rtn.1,center=T,scale=F)
rtn.2 <- scale(rtn.2,center=T,scale=F)

# And clean it using Boudt's technique:
rtn.1 <- Return.clean(rtn.1, method = c("none", "boudt", "geltner")[2], alpha = 0.01)
rtn.2 <- Return.clean(rtn.2, method = c("none", "boudt", "geltner")[2], alpha = 0.01)

# DCCPre
DCCPre.1 <- dccPre(rtn.1, include.mean = T, p = 0)
names(DCCPre.1)
DCCPre.2 <- dccPre(rtn.2, include.mean = T, p = 0)
names(DCCPre.2)

# Change to usable xts
Vol.1 <- DCCPre.1$marVol
colnames(Vol.1) <- colnames(rtn.1)

Vol.2 <- DCCPre.2$marVol
colnames(Vol.2) <- colnames(rtn.2)

#======================================================
# VOLS
# =====================================================

vol.df <-
  bind_rows(
    
    data.frame( cbind( date = as.Date(index(rtn.1)), Vol.1)) %>% # Add date column which dropped away...
      mutate(date = as.Date(date)) %>% tbl_df() %>% gather(Ticker, Sigma, -date) %>% 
      mutate(Period = "Period 1"),
    
    data.frame( cbind( date = as.Date(index(rtn.2)), Vol.2)) %>% # Add date column which dropped away...
      mutate(date = as.Date(date)) %>% tbl_df() %>% gather(Ticker, Sigma, -date) %>% 
      mutate(Period = "Period 2")  ) %>% 
  left_join(., equity.list %>% mutate(Ticker = gsub(" Index", "", Ticker)), by = "Ticker")