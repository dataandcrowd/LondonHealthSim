library(tidyverse)
files <- list.files(pattern = "\\.csv$")
files[1]


# file-open "Data/AQ-by-bg-stations/BG2.csv"
# let aqfile_bg2_raw csv:from-file "Data/AQ-by-bg-stations/BG2.csv"
# let aqfile_bg2 remove-item 0 aqfile_bg2_raw

for (i in 1:length(files)){
line1 <- paste0("file-open ", "Data/AQ-by-rd-stations/", files[i])  
line2 <- paste0("let aqfile_", substr(files[i],1,3), "_raw csv:from-file ", "Data/AQ-by-rd-stations/", files[i])
line3 <- paste0("let aq_", substr(files[i],1,3), " remove-item 0 ", "aqfile_", substr(files[i],1,3), "_raw")

print(line1)
print(line2)
print(line3)
  
}



paste0("rd_", substr(files,1,3))

