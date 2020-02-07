# This code creates the date vectors for periods of low and high uncertainty (for both periods)

# Period 1
vix.high.period1.dates <- CreateIVQuintileStratificationDates(data = data.str %>% filter(Ticker == "VIX Index"), 
                                                              DistributionSplit = 0.2, SampleOneStartDate, SampleOneEndDate, 
                                                              SampleTwoStartDate, SampleTwoEndDate, MinTradeDays = 30, NoTradeDaysToMinusBeg = 10) %>% 
  filter(Period == "Period 1", State == "High") %>% pull(date)

vix.low.period1.dates <- CreateIVQuintileStratificationDates(data = data.str %>% filter(Ticker == "VIX Index"), 
                                                             DistributionSplit = 0.2, SampleOneStartDate, SampleOneEndDate, 
                                                             SampleTwoStartDate, SampleTwoEndDate, MinTradeDays = 30, NoTradeDaysToMinusBeg = 10) %>% 
  filter(Period == "Period 1", State == "Low") %>% pull(date)

# Period 2
vix.high.period2.dates <- CreateIVQuintileStratificationDates(data = data.str %>% filter(Ticker == "VIX Index"), 
                                                              DistributionSplit = 0.2, SampleOneStartDate, SampleOneEndDate, 
                                                              SampleTwoStartDate, SampleTwoEndDate, MinTradeDays = 30, NoTradeDaysToMinusBeg = 10) %>% 
  filter(Period == "Period 2", State == "High") %>% pull(date)

vix.low.period2.dates <- CreateIVQuintileStratificationDates(data = data.str %>% filter(Ticker == "VIX Index"), 
                                                             DistributionSplit = 0.2, SampleOneStartDate, SampleOneEndDate, 
                                                             SampleTwoStartDate, SampleTwoEndDate, MinTradeDays = 30, NoTradeDaysToMinusBeg = 10) %>% 
  filter(Period == "Period 2", State == "Low") %>% pull(date)