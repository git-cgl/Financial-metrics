# prepare the data
library(tidyverse)
currencies <- read_rds("data/Cncy.rds")

# change the element names to something simpler
currencies %>% gsub("Curncy", "",.) %>% 
