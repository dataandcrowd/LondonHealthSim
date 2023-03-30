library(tidyverse)
library(data.table)

# Read multiple text files
list_files <- list.files(pattern = "atrisk")
rbindlist(lapply(list_files, read.table), idcol = "id") %>% 
  as_tibble %>% 
  select(-c(V1, V7)) %>% 
  rename(ticks = V2,
         total = V3,
         und15 = V4,
         btw1564 = V5,
         ov65 = V6) -> df

df %>% dim

df %>% 
  pivot_longer(!c(id, ticks), names_to = "type", values_to = "value") %>%
  filter(id == 1) %>% 
  ggplot(aes(ticks, value, colour = factor(type))) +
  geom_line()+
  facet_wrap(~type, scales = "free")
  #geom_ribbon(alpha=0.5) 


