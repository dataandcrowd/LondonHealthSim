library(tidyverse)

bg <- c("BG1", "BG2", "BL0", "BQ7", "BX1", "BX2", "CT3", "CW3", "EI3", "EN1", "EN7", "GR4", "HG4", "HI0",
           "HP1", "HR1", "IS6", "KC1", "KX8", "LB6", "LH0", "LW1", "LW5", "NM3", "OP1", "OP2", "RB7", "RI2",
           "SK6", "WA2", "WA9", "WM0", "WM5")


for (i in 1:33){
  line1 <- paste0("let entirelist_", bg[i], " item ticks aq_", bg[i])  
  line2 <- paste0("let aq_", bg[i],"_ ", "sublist entirelist_", bg[i] , " 5 29")
  line3 <- paste0("let aq_", bg[i],"__ ", "remove -999 ", "aq_", bg[i],"_")
  line4 <- paste0("ask one-of patches with [monitor-code = ", bg[i], "] [set no2 aq_", bg[i], "__]")
  
  print(line1)
  print(line2)
  print(line3)
  print(line4)
}


