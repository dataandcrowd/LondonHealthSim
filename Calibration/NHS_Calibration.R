library(tidyverse)
#library(directlabels)
library(data.table)

# Read multiple text files
list_files <- list.files(pattern = ".txt$")
rbindlist(lapply(list_files, read.table)) %>% 
  as_tibble %>% 
  select(V4, V5, V6) %>% 
  rename(und15 = V4,
         btw1564 = V5,
         ov65 = V6) -> cali


cali %>% summary

cali_mean <- apply(cali,2,mean)
cali_sd <- apply(cali,2,sd)

 

write.table(cbind(cali_mean, cali_sd), "calibration_result.txt", row.names = c("und15","btw1564","ov65"))
