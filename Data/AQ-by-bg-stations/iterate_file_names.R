library(tidyverse)
dir()
dir()[1]

# file-open "Data/AQ-by-bg-stations/BG2.csv"
# let aqfile_bg2_raw csv:from-file "Data/AQ-by-bg-stations/BG2.csv"
# let aqfile_bg2 remove-item 0 aqfile_bg2_raw

for (i in 1:33){
line1 <- paste0("file-open ", "Data/AQ-by-bg-stations/", dir()[i])  
line2 <- paste0("let aqfile_", substr(dir()[i],1,3), "_raw csv:from-file ", "Data/AQ-by-bg-stations/", dir()[i])
line3 <- paste0("let aqfile_", substr(dir()[i],1,3), "remove-item 0 ", "aqfile_", substr(dir()[i],1,3), "_raw")

print(line1)
print(line2)
print(line3)
  
}




