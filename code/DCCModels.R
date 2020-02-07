
#==============================================================================
# DCC
# =============================================================================
StdRes.1 <- DCCPre.1$sresi
StdRes.2 <- DCCPre.2$sresi # save the residuals

detach("package:rmsfuns", unload = TRUE)
detach("package:tidyverse", unload=TRUE)
detach("package:tbl2xts", unload=TRUE)

# The DCC estimations take a while (I suggest a cup of coffee in the meantime)
DCC.1 <- dccFit(StdRes.1, type="Engle")
DCC.2 <- dccFit(StdRes.2, type="Engle")

load_pkg(c("tidyverse", "tbl2xts"))

Rhot.1 <- DCC.1$rho.t
Rhot.2 <- DCC.2$rho.t

# Renaming function
renamingdcc <- function(ReturnSeries, DCC.TV.Cor) {
  
  ncolrtn <- ncol(ReturnSeries)
  namesrtn <- colnames(ReturnSeries)
  paste(namesrtn, collapse = "_")
  
  nam <- c()
  xx <- mapply(rep, times = ncolrtn:1, x = namesrtn)

# Design a nested for loop to save the names corresponding to the columns of interest.
  
  
  nam <- c()
  for (j in 1:(ncolrtn)) {
    for (i in 1:(ncolrtn)) {
      nam[(i + (j-1)*(ncolrtn))] <- paste(xx[[j]][1], xx[[i]][1], sep="_")
    }
  }
  
  colnames(DCC.TV.Cor) <- nam
  
  # So to plot all the time-varying correlations wrt SBK:
  # First append the date column that has (again) been removed...
  DCC.TV.Cor <- 
    data.frame( cbind( date = as.Date(index(ReturnSeries)), DCC.TV.Cor)) %>% # Add date column which dropped away...
    mutate(date = as.Date(date)) %>% tbl_df() 
  
  DCC.TV.Cor <- DCC.TV.Cor %>% gather(Pairs, Rho, -date)
  
  DCC.TV.Cor
  
}

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
  left_join(., cur.sample %>% mutate(Pairs = gsub(" Curncy", "", Ticker)) %>% 
              mutate(Pairs = paste0("ZAR_", Pairs)), by = "Pairs") %>% filter(!is.na(Country)) %>% 
  filter(Pairs != "ZAR_ZAR")

#===============================================================================
# Correlation plots
#===============================================================================
g.corr.brics <-
  ggplot(df.corr %>% filter(Group == "BRICS")) + 
  geom_line(aes(x = date, y = Rho, color = Country), alpha = 0.6) + 
  facet_wrap(~Period, scales = "free") + 
  ylim(-0.1, 1) +
  theme_bw() +
  theme(text = element_text(size = 10), axis.text = element_text(size = 10, hjust = 1, angle = 90),
        plot.title = element_text(size = 10)) +
  scale_x_date(date_breaks = "2 years", date_labels = "%Y") +
  labs(x = NULL)

print(g.corr.brics)

g.corr.asia <- 
ggplot(df.corr %>% filter(Group == "Asia")) + 
  geom_line(aes(x = date, y = Rho, color = Country), alpha = 0.6) + 
  facet_wrap(~Period, scales = "free") + 
  ylim(-0.1, 1) +
  theme_bw() +
  theme(text = element_text(size = 10), axis.text = element_text(size = 10, hjust = 1, angle = 90),
        plot.title = element_text(size = 10)) +
  scale_x_date(date_breaks = "2 years", date_labels = "%Y") +
  labs(x = NULL)

g.corr.southamerica <-
  ggplot(df.corr %>% filter(Group == "South America")) + 
  geom_line(aes(x = date, y = Rho, color = Country), alpha = 0.6) + 
  facet_wrap(~Period, scales = "free") + 
  ylim(-0.1, 1) +
  theme_bw() +
  theme(text = element_text(size = 10), axis.text = element_text(size = 10, hjust = 1, angle = 90),
        plot.title = element_text(size = 10)) +
  scale_x_date(date_breaks = "2 years", date_labels = "%Y") +
  labs(x = NULL)

g.corr.easterneurope <-
  ggplot(df.corr %>% filter(Group == "Eastern Europe")) + 
  geom_line(aes(x = date, y = Rho, color = Country), alpha = 0.6) + 
  facet_wrap(~Period, scales = "free") + 
  ylim(-0.1, 1) +
  theme_bw() +
  theme(text = element_text(size = 10), axis.text = element_text(size = 10, hjust = 1, angle = 90),
        plot.title = element_text(size = 10)) +
  scale_x_date(date_breaks = "2 years", date_labels = "%Y") +
  labs(x = NULL)
