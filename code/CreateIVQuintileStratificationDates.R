CreateIVQuintileStratificationDates <- function(data, DistributionSplit, SampleOneStartDate, SampleOneEndDate, SampleTwoStartDate, SampleTwoEndDate, MinTradeDays, NoTradeDaysToMinusBeg){
  
  # This function returns dates for periods of high and low implied volatility according to quintiles (Top 20% and bottom 20% of distribution)
  # The distribution split is parameterized so you can change it from quintiles to quantiles for example.
  # MinTradeDays -- Minimum number of trading days the VIX must breach to top or bottom quntile
  # NoTradeDaysToMinusBeg -- number of trading days to minus at the beginning to allow correlation to adjust
  # "data" is a VIX dataframe which should be in tidy format (date, Ticker, Value)
 
  
  Upper <- 1 - DistributionSplit

  df.strat <-
    data %>% filter(!is.na(Value)) %>%
    mutate(Period = ifelse(date >= SampleOneStartDate & date <= SampleOneEndDate, "Period 1", 
                           ifelse(date >= SampleTwoStartDate & date <= SampleTwoEndDate, "Period 2", "Other"))) %>% 
    filter(Period %in% c("Period 1", "Period 2")) %>% 
    group_by(Period) %>% 
    arrange(date) %>% 
    mutate(Q1 = quantile(Value, probs = DistributionSplit, na.rm = TRUE),
           Q2 = quantile(Value, probs = Upper, na.rm = TRUE)) %>% 
    mutate(State = ifelse(Value < Q1, "Low",
                          ifelse(Value < Q2, "Middle", "High"))) %>% 
    mutate(Change = ifelse(State != lag(State), row_number(), NA)) %>% 
    mutate(Change = ifelse(date == first(date), 1, Change)) %>% 
    tidyr::fill(Change, .direction = "down") %>% filter(State != "Middle") %>% 
    group_by(Period, Change) %>% mutate(NoTradingDays = n(), RowNum = row_number()) %>% 
    ungroup() %>% filter(NoTradingDays >= MinTradeDays) %>% filter(RowNum >= NoTradeDaysToMinusBeg) %>% 
    select(date, Ticker, Period, State, Change)
  
  df.strat  
  
}