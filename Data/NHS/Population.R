library(tidyverse)

popeng <- read_csv("TS007-2021-2.csv")

popeng %>% 
  rename(lacode = `Lower Tier Local Authorities Code`,
         laname = `Lower Tier Local Authorities`,
         agecode = `Age (101 categories) Code`,
         age = `Age (101 categories)`) %>% 
  filter(!agecode < 5) %>% 
  mutate(agegroup = case_when(agecode %in%   5:9 ~ "Age 05-09",
                              agecode %in% 10:14 ~ "Age 10-14",
                              agecode %in% 15:19 ~ "Age 15-19",
                              agecode %in% 20:24 ~ "Age 20-24",
                              agecode %in% 25:29 ~ "Age 25-29",
                              agecode %in% 30:34 ~ "Age 30-34",
                              agecode %in% 35:39 ~ "Age 35-39",
                              agecode %in% 40:44 ~ "Age 40-44",
                              agecode %in% 45:49 ~ "Age 45-49",
                              agecode %in% 50:54 ~ "Age 50-54",
                              agecode %in% 55:59 ~ "Age 55-59",
                              agecode %in% 60:64 ~ "Age 60-64",
                              agecode %in% 65:69 ~ "Age 65-69",
                              agecode %in% 70:74 ~ "Age 70-74",
                              agecode %in% 75:79 ~ "Age 75-79",
                              agecode %in% 80:84 ~ "Age 80-84",
                              .default = "over 85")) %>% 
  group_by(agegroup) %>% 
  summarise(pop = sum(Observation)) -> pop

pop

write_csv(pop, "pop.csv")
