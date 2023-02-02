library(tidyverse)
library(imputeTS)
library(lubridate)

aq <- read_csv("London_AQ_Road.csv") 

aq %>% 
  mutate(Date = dmy(Date),
         #datehms = ymd_hms(paste0(Date, Time)),
         #hours = as.character(Time),
         Quarter = quarter(Date, type = "year.quarter"),
         pm2.5 = as.numeric(pm2.5)) %>% 
  select(-no2) -> aq_clean


unique(aq_clean$Station)

x <- ymd(c("2018-03-31", "2018-06-30", "2018-09-30", "2018-12-31",
           "2019-03-31", "2019-06-30", "2019-09-30", "2019-12-31",
           "2020-03-31", "2020-06-30", "2020-09-30", "2020-12-31",
           "2021-03-31", "2021-06-30", "2021-09-30", "2021-12-31"
           ))

aq_clean %>%
  group_by(Quarter) %>% 
  summarise(pm2.5 = mean(pm2.5, na.rm = T)) %>% 
  mutate(Quarter = x,
         no = 1:n(),
         type = "pm2.5",
         inc3per = pm2.5*1.3,
         incsub = inc3per - pm2.5) -> aq_final

write_csv(aq_final, "London_AQ_Scenario.csv")
