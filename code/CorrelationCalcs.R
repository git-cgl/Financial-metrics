library(tidyverse)
# =========================
# Period 1
# =========================
# Use this df for creating your tables 
# rename the last three columns
df.corr.vix <-
  df.corr %>% group_by(Period, Pairs) %>% 
  mutate(Average_Period_Corr = mean(Rho, na.rm = TRUE)) %>% 
  ungroup() %>% 
  
  left_join(., 
            df.corr %>% filter(date %in% c(vix.high.period1.dates, vix.high.period2.dates)) %>% group_by(Pairs, Period) %>% 
              summarise(Average_High_VIX = mean(Rho, na.rm = TRUE)) %>% ungroup(), by = c("Pairs", "Period")) %>% 
  
  left_join(., 
            df.corr %>% filter(date %in% c(vix.low.period1.dates, vix.low.period2.dates)) %>% group_by(Pairs, Period) %>% 
              summarise(Average_Low_VIX = mean(Rho, na.rm = TRUE)) %>% ungroup(), by = c("Pairs", "Period")) %>% 
  select(Pairs, Period, Group, Country, Average_Period_Corr, Average_High_VIX, Average_Low_VIX) %>% unique() %>% 
  arrange(Group, Country) %>% rename(SampleAverage = Average_Period_Corr, HighVIX = Average_High_VIX, LowVIX = Average_Low_VIX)

# VIX dataframes
High.VIX <-
  CreateIVQuintileStratificationDates(data = data.str %>% filter(Ticker == "VIX Index"), 
                                      DistributionSplit = 0.2, SampleOneStartDate, SampleOneEndDate, 
                                      SampleTwoStartDate, SampleTwoEndDate, MinTradeDays = 30, NoTradeDaysToMinusBeg = 10) %>% 
  filter(State == "High") %>% 
  group_by(Change) %>% 
  filter(date == first(date) | date == last(date)) %>% 
  mutate(DateType = ifelse(date == first(date), "StartDate", "EndDate")) %>% 
  select(Change, Period, date, DateType) %>% 
  spread(DateType, date) %>% ungroup() 

Low.VIX <-
  CreateIVQuintileStratificationDates(data = data.str %>% filter(Ticker == "VIX Index"), 
                                      DistributionSplit = 0.2, SampleOneStartDate, SampleOneEndDate, 
                                      SampleTwoStartDate, SampleTwoEndDate, MinTradeDays = 30, NoTradeDaysToMinusBeg = 10) %>% 
  filter(State == "Low") %>% 
  group_by(Change) %>% 
  filter(date == first(date) | date == last(date)) %>% 
  mutate(DateType = ifelse(date == first(date), "StartDate", "EndDate")) %>% 
  select(Change, Period, date, DateType) %>% 
  spread(DateType, date) %>% ungroup() 


