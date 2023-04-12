library(tidyverse)
library(data.table)

# Read multiple text files
list_files <- list.files(pattern = "atrisk_scenario")
rbindlist(lapply(list_files, read.table), idcol = "id") %>% 
  as_tibble %>% 
  select(-c(V1, V8)) %>% 
  rename(ticks = V2,
         date = V3,
         total = V4,
         und15 = V5,
         btw1564 = V6,
         ov65 = V7) -> df

#
list_files1 <- list.files(pattern = "atrisk_output")
rbindlist(lapply(list_files1, read.table), idcol = "id") %>% 
  as_tibble %>% 
  select(-c(V1, V8)) %>% 
  rename(ticks = V2,
         date = V3,
         total = V4,
         und15 = V5,
         btw1564 = V6,
         ov65 = V7) -> df_baseline
#

df %>% dim

df %>% 
  filter(id == 1, ticks %in% c(800, 900, 1000, 1100, 1200)) %>% 
  pull(date)
#specify labels for plot
my_labels <- c("2019-02-05", "2019-03-27", "2019-05-16", "2019-07-05", "2019-08-24")


df %>% 
  filter(id == 1, ticks %in% c(1000, 2000, 2921)) %>% 
  pull(date)



##############
# df %>% 
#   select(-id) %>% 
#   group_by(ticks) %>% 
#   summarise(across(where(is.numeric), list(mean = mean))) %>% 
#   rename(Total = total_mean,
#          `<15` = und15_mean,
#          `15-64` = btw1564_mean,
#          `>65` = ov65_mean) %>% 
#   pivot_longer(!ticks, names_to = "type", values_to = "value") %>% 
#   mutate(type = factor(type, levels = c("Total", "<15", "15-64", ">65"))) -> df_clean

df_baseline %>% 
  select(-c(id, ticks, date)) %>% 
  pivot_longer(everything(), names_to = "type", values_to = "value") %>% 
  group_by(type) %>% 
  summarise(across(where(is.numeric), list(mean = mean))) 

df %>% 
  select(-c(id, ticks, date)) %>% 
  pivot_longer(everything(), names_to = "type", values_to = "value") %>% 
  group_by(type) %>% 
  summarise(across(where(is.numeric), list(mean = mean))) 






7# Read multiple text files
list_files <- list.files(pattern = "borough_scenario")
rbindlist(lapply(list_files, read.table), idcol = "id") %>% 
  as_tibble %>% 
  select(-c(2, last_col())) %>% select(c(-1:-3)) -> df_borough

col_odd <- seq_len(ncol(df_borough)) %% 2
df_borough_odd <- df_borough[ , col_odd == 1]            # Subset odd columns
df_borough_odd 
df_borough_even <- df_borough[ , col_odd == 0]            # Subset odd columns
df_borough_even

df_borough_odd %>% stack %>% with(unique(values)) -> london_districts
colnames(df_borough_even) <- london_districts

df %>% select(1:3) %>% 
  bind_cols(df_borough_even) -> df_borough_fin


#
list_files <- list.files(pattern = "borough_output")
rbindlist(lapply(list_files, read.table), idcol = "id") %>% 
  as_tibble %>% 
  select(-c(2, last_col())) %>% select(c(-1:-3)) -> df_borough_baseline

col_odd <- seq_len(ncol(df_borough_baseline)) %% 2
df_borough_baseline_odd <- df_borough_baseline[ , col_odd == 1]            # Subset odd columns
df_borough_baseline_odd 
df_borough_baseline_even <- df_borough_baseline[ , col_odd == 0]            # Subset odd columns
df_borough_baseline_even

df_borough_baseline_odd %>% stack %>% with(unique(values)) -> london_districts
colnames(df_borough_baseline_even) <- london_districts

df_baseline %>% select(1:3) %>% 
  bind_cols(df_borough_baseline_even) -> df_borough_baseline_fin


df_borough_fin %>% 
  select(-c(id, ticks, date)) %>% 
  pivot_longer(everything(), names_to = "type", values_to = "value") %>% 
  group_by(type) %>% 
  summarise(across(where(is.numeric), list(mean = mean))) -> summary_boro_scenario


df_borough_baseline_fin %>% 
  select(-c(id, ticks, date)) %>% 
  pivot_longer(everything(), names_to = "type", values_to = "value") %>% 
  group_by(type) %>% 
  summarise(across(where(is.numeric), list(mean = mean))) -> summary_boro_base

left_join(summary_boro_base, summary_boro_scenario, by = "type") %>% 
  rename(base = value_mean.x,
         scenario = value_mean.y) %>% 
  mutate(leap = scenario / base) %>% ## measuring the effect of tight guideline
  arrange(desc(scenario)) %>% View
  #pull(leap) %>% mean


#######
list_files <- list.files(pattern = "calibration")
rbindlist(lapply(list_files, read.table), idcol = "id") %>% 
  as_tibble %>% 
  select(-c(2, last_col())) %>% select(c(-1:-3)) -> df_cali
