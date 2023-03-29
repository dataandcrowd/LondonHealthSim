library(tidyverse)
library(directlabels)
library(data.table)

# Import Files
csv_files <- fs::dir_ls(regexp = "_BAU_")
test <- csv_files %>% 
  map_dfr(fread) %>% 
  select(-c(`scenario-percent`, `PM10-parameters`, siminputrow, `[run number]`, `random-seed`)) %>% 
  group_by(`[step]`, Scenario, AC) %>% ungroup()


test1 <- test %>% 
  group_by(Scenario) %>% 
  filter(`[step]` == 8763, AC==100) %>% 
  select(Scenario, contains('dead')) %>%
  summarise_all(funs(sum))


test2 <- test1 %>% reshape2::melt(id="Scenario", variable.name = "Age", value.name = "Persons")
  
census <- read_csv("census2015_age_Seoul.csv") %>% ## Census age distribution
  filter(Region == "Seoul")

census$samplepop <- round(census$Persons * .05, 0)
census$patients <- test2$Persons
census$risk <- (census$patients / census$samplepop) * 100
census$Age <- factor(census$Age, levels=c("5-9", "10-14", "15-19", "20-24", "25-29", "30-34", "35-39", "40-44", "45-49", "50-54", "55-59", "60-64", "65-69","70-74", "75ov"))

census %>% 
  ggplot(aes(Age, risk)) +
  geom_bar(stat = "identity") +
  ylab("Percentage (%)") +
  ylim(0,15) +
  theme_minimal() +
  theme(axis.text.x=element_text(size = 12),
        axis.text.y=element_text(size = 12),
        strip.text.x = element_text(size = 12),
        legend.title=element_text(size=12), 
        legend.text=element_text(size=12)
  )  -> censusplot

ggsave("riskpop_model.png", censusplot, width = 10, height = 6, dpi = 200)
