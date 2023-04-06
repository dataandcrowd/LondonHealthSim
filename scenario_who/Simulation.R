library(tidyverse)
library(data.table)

# Read multiple text files
list_files <- list.files(pattern = "atrisk")
rbindlist(lapply(list_files, read.table), idcol = "id") %>% 
  as_tibble %>% 
  select(-c(V1, V8)) %>% 
  rename(ticks = V2,
         date = V3,
         total = V4,
         und15 = V5,
         btw1564 = V6,
         ov65 = V7) -> df

df %>% dim

df %>% 
  filter(id == 1, ticks %in% c(800, 900, 1000, 1100, 1200)) %>% 
  pull(date)
#specify labels for plot
my_labels <- c("2019-02-05", "2019-03-27", "2019-05-16", "2019-07-05", "2019-08-24")


df %>% 
  filter(id == 1, ticks %in% c(1000, 2000, 2921)) %>% 
  pull(date)


df %>% 
  pivot_longer(!c(id, date, ticks), names_to = "type", values_to = "value") %>%
  filter(id == 1) %>% 
  ggplot(aes(x = ticks, y = value, colour = type)) +
  geom_line()+
  xlim(800,1200) +
  facet_wrap(~type, scales = "free") +
  labs(x = "", y = "At-risk rate") +
  theme_bw() +
  theme(legend.position = "bottom")




df %>% 
  select(-id) %>% 
  group_by(ticks) %>% 
  summarise(across(where(is.numeric), list(mean = mean))) %>% 
  rename(Total = total_mean,
         `<15` = und15_mean,
         `15-64` = btw1564_mean,
         `>65` = ov65_mean) %>% 
  pivot_longer(!ticks, names_to = "type", values_to = "value") %>% 
  mutate(type = factor(type, levels = c("Total", "<15", "15-64", ">65"))) %>% 
  ggplot(aes(x = ticks, y = value, colour = type)) +
  geom_line() +
  facet_grid(vars(type), scales = "free") +
  labs(x = "", y = "At-risk rate(%)") +
  geom_hline(yintercept = 10, linetype=2) +
  scale_x_continuous(breaks = c(0, 1000, 2000, 2922), labels = c("Jan 2018", "May 2019", "Oct 2020", "Dec 2021")) +
  theme_bw() +
  theme(legend.position = "none",
        text = element_text(size=13))

ggsave("plot.jpg", width = 7, height = 5)


# Read multiple text files
list_files <- list.files(pattern = "borough")
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


df_borough_fin %>% 
  select(-id) %>% 
  group_by(ticks) %>% 
  summarise(across(where(is.numeric), list(mean = mean))) %>% 
  rename_with(~str_remove(., '_mean')) %>% 
  pivot_longer(!ticks, names_to = "type", values_to = "value") %>% 
  ggplot(aes(x = ticks, y = value, colour = type)) +
  geom_line() +
  facet_wrap(~type) +
  geom_hline(yintercept = 10, linetype=2) +
  labs(x = "", y = "At-risk rate(%)") +
  scale_x_continuous(breaks = c(0, 1000, 2000, 2922), labels = c("Jan 2018", "May 2019", "Oct 2020", "Dec 2021")) +
  theme_bw() +
  theme(legend.position = "none",
        text = element_text(size=13),
        axis.text.x = element_text(angle = 90, vjust = 0.5, hjust=1))

ggsave("borough.jpg", width = 10, height = 10)
