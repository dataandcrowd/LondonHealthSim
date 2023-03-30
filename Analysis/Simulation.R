library(tidyverse)
library(data.table)

# Read multiple text files
list_files <- list.files(pattern = "atrisk")
rbindlist(lapply(list_files, read.table), idcol = "id") %>% 
  as_tibble %>% 
  select(-c(V1, V8)) %>% 
  rename(ticks = V2,
         date = V3,
         total = V4,
         und15 = V5,
         btw1564 = V6,
         ov65 = V7) -> df

df %>% dim

df %>% 
  filter(id == 1, ticks %in% c(800, 900, 1000, 1100, 1200)) %>% 
  pull(date)
#specify labels for plot
my_labels <- c("2019-02-05", "2019-03-27", "2019-05-16", "2019-07-05", "2019-08-24")


df %>% 
  pivot_longer(!c(id, date, ticks), names_to = "type", values_to = "value") %>%
  filter(id == 1) %>% 
  ggplot(aes(x = ticks, y = value, colour = type)) +
  geom_line()+
  xlim(800,1200) +
#  scale_x_discrete(labels=my_labels) +
  facet_wrap(~type, scales = "free")
  #geom_ribbon(alpha=0.5) 


