CreateVIXStratPlot <- function(data, DistributionSplit, SampleOneStartDate, SampleOneEndDate, SampleTwoStartDate, SampleTwoEndDate, MinTradeDays, NoTradeDaysToMinusBeg, TickerToPlot){
  
  Upper <- 1 - DistributionSplit
  
  data <-
    data %>% 
    filter(!is.na(Value)) %>%
    filter(Ticker == TickerToPlot)    
  
  data.q <-
    data %>% 
    mutate(Period = ifelse(date >= SampleOneStartDate & date <= SampleOneEndDate, "Period_1", 
                           ifelse(date >= SampleTwoStartDate & date <= SampleTwoEndDate, "Period_2", "Other"))) %>% 
    filter(Period %in% c("Period_1", "Period_2")) %>% 
    group_by(Period) %>% 
    arrange(date) %>% 
    mutate(Q1 = quantile(Value, probs = DistributionSplit, na.rm = TRUE),
           Q2 = quantile(Value, probs = Upper, na.rm = TRUE)) %>% 
    mutate(State = ifelse(Value < Q1, "Low",
                          ifelse(Value < Q2, "Middle", "High"))) %>% 
    ungroup()
  
  df.strat <-
    data.q %>% 
    group_by(Period) %>% 
    mutate(Change = ifelse(State != lag(State), row_number(), NA)) %>% 
    mutate(Change = ifelse(date == first(date), 1, Change)) %>% 
    tidyr::fill(Change, .direction = "down") %>% filter(State != "Middle") %>% 
    group_by(Period, Change) %>% mutate(NoTradingDays = n(), RowNum = row_number()) %>% 
    ungroup() %>% filter(NoTradingDays >= MinTradeDays) %>% filter(RowNum >= NoTradeDaysToMinusBeg)
  
  df.1 <-
    df.strat %>% filter(Period == "Period_1") %>% 
    group_by(Change) %>% filter(date == first(date) | date == last(date)) %>% 
    mutate(DateType = ifelse(date == first(date), "StartDate", "EndDate")) %>% 
    select(Change, date, DateType) %>% 
    spread(DateType, date) %>% ungroup()
  
  df.2 <-
    df.strat %>% filter(Period == "Period_2") %>% 
    group_by(Change) %>% filter(date == first(date) | date == last(date)) %>% 
    mutate(DateType = ifelse(date == first(date), "StartDate", "EndDate")) %>% 
    select(Change, date, DateType) %>% 
    spread(DateType, date) %>% ungroup()
  
  g <-
    ggplot(data %>% filter(date >= SampleOneStartDate)) + geom_line(aes(x = date, y = Value), color = "maroon") + 
    geom_line(data = data.q %>% filter(Period == "Period_1"), aes(date, Q1)) +
    geom_line(data = data.q %>% filter(Period == "Period_2"), aes(date, Q1)) +
    geom_line(data = data.q %>% filter(Period == "Period_1"), aes(date, Q2)) +
    geom_line(data = data.q %>% filter(Period == "Period_2"), aes(date, Q2)) +
    geom_rect(data = df.1, aes(xmin = StartDate, xmax = EndDate, ymin=-Inf, ymax=+Inf), fill='red', alpha=0.2) +
    geom_rect(data = df.2, aes(xmin = StartDate, xmax = EndDate, ymin=-Inf, ymax=+Inf), fill='red', alpha=0.2) +
    labs(caption="Source - Bloomberg (2019) \n *The top and bottom quintiles are illustrated by the black lines. \n *The pink shaded areas represent periods in which these quintiles are breached") +
    theme_bw() 
  
  g
  
}