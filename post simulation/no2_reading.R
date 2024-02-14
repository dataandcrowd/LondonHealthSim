library(tidyverse)
library(data.table)
library(arrow)

no2 <- fread("no2_export_people.csv")

write_parquet(no2, "no2.parquet")
