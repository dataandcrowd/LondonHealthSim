library(tidyverse)

files <- list.files(pattern = "\\.csv$")
files_short <- substr(files,1,3)

for (i in 1:length(files)){
  line1 <- paste0("let entirelist_", files_short[i], " item ticks rd_", files_short[i])  
  line2 <- paste0("let rd_", files_short[i],"_ ", "sublist entirelist_", files_short[i] , " 5 29")
  line3 <- paste0("let rd_", files_short[i],"__ ", "remove -999 ", "rd_", files_short[i],"_")
  line4 <- paste0("ask one-of patches with [monitor-code = ", files_short[i], "][set no2 rd_", files_short[i], "__]")
  
  print(line1)
  print(line2)
  print(line3)
  print(line4)
}


