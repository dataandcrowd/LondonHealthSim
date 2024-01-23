library(tidyverse)
library(data.table)
library(janitor)

df <- fread("export_no2_results.csv")

df |> 
  as_tibble() |>
  clean_names() 
