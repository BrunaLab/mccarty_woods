# code to read, clean, and save the data from tree planting
# at mccarty woods 12 feb 2022.

# trees were measured ay 8 cm above ground level. If tress had 
# multiple stems, all stems reading 8 cm minimum height were measured.


# load libraries ----------------------------------------------------------

library(tidyverse)
# read data ---------------------------------------------------------------
trees<-read_csv("./data_raw/mccarty_20221202.csv") %>% 
  mutate(across(.cols = everything(), .fns = tolower)) %>% 
  mutate(across(.cols = everything(), .fns = trimws)) %>% 
  mutate(across(.cols = c(common_name:species), as.factor)) %>% 
  mutate(across(.cols = c(stem_1:stem_3), as.numeric))

trees$tag_number <- factor(trees$tag_number, ordered = TRUE)

trees %>% 
  select(common_name, genus,species) %>% 
  group_by(common_name, genus,species) %>% 
  summarize(count=n()) %>% 
  arrange(desc(count))

  

# convert to long format --------------------------------------------------

trees_long<-trees %>% pivot_longer(stem_1:stem_3,
                                   names_to = "stem", 
                                   names_prefix = "stem_", 
                                   values_to = "diam_mm") %>% 
  filter(!is.na(diam_mm))
  
trees_long$diam_mm<-as.numeric(trees_long$diam_mm)
trees_long$stem <- factor(trees_long$stem, ordered = TRUE)
trees_long$tag_number <- factor(trees_long$tag_number, ordered = TRUE)

levels(trees_long$common_name)
levels(trees_long$genus)
levels(trees_long$species)
summary(trees_long)

# save clean data as csv --------------------------------------------------

write_csv(trees_long, "./data_clean/mccarty_trees_20221202.csv")


