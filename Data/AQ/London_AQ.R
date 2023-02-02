library(tidyverse)
library(imputeTS)
library(lubridate)

aq <- read_csv("London_AQ_Road.csv") 

unique(aq$Station)

aq %>% 
  mutate(Date = dmy(Date),
         datehms = ymd_hms(paste0(Date, Time)),
         hours = as.character(Time),
         pm2.5 = as.numeric(pm2.5)) %>% 
  select(-no2) -> aq_clean


aq_clean %>% 
  group_by(Station) %>% 
  na_seasplit(algorithm = "mean", find_frequency=TRUE) %>% 
  ungroup()-> aq_imputed

aq_imputed %>% 
  mutate(hours = as.numeric(as.difftime(hours), "hours"),
         dn = case_when(hours >= 8 & hours <= 17 ~ "Work",
                        TRUE ~ "Home")) -> cleaned


cleaned %>% 
  select(-c(datehms,Time)) %>% 
  mutate(hours = paste0("h", hours)) %>% 
  pivot_wider(names_from = hours, values_from = pm2.5, values_fill = -999) -> cleaned_wider


cleaned_wider %>% 
  group_by(Station) %>% 
  mutate(id = row_number()) %>%
  select(id, everything()) -> cleaned_wider_with_id

write_csv(cleaned_wider_with_id, "London_AQ.csv")
