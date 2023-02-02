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
  select(-no2) %>% 
  filter(!Station %in% c("London Haringey Priory Park South", # no data
                         "London Hillingdon",
                         "Haringey Roadside",
                         "Southwark A2 Old Kent Road",
                         "Tower Hamlets Roadside"))-> aq_clean


aq_clean %>% 
  group_by(Station) %>% 
  summarise(across(pm2.5, ~ mean(.x, na.rm = TRUE))) %>% 
  arrange(desc(pm2.5))
  #summarise(pm2.5mean = mean(pm2.5, na.rm = T),
  #          pm2.5max  = max(pm2.5, na.rm = T))
  
p <- ggplot(aq_clean, aes(x=datehms, y=pm2.5, colour = Station)) +
  geom_line() + 
  xlab("") 

ggsave("aq.jpg", p, width = 8, height = 4)



p1 <- ggplot(aq_clean, aes(x=datehms, y=pm2.5, colour = Station)) +
  geom_line() + 
  xlab("") +
  facet_wrap(~Station, ncol = 2, scales = "free") +
  theme(legend.position = "none")

ggsave("aq1.jpg", p1, width = 9, height = 9)
