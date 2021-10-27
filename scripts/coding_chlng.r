# import libraries
library(tidyverse)
library(ggplot2)
library(scales)
library(ggthemes)

# Read in data
dat <- read_csv("C:/code/coding_challenges/data/runners_100k.csv")
head(dat)

ggplot(dat, mapping = aes(x = chiptime, y = ..density..)) +
  geom_histogram(bins = 9, binwidth = 1, na.rm = TRUE) + #c(230,300,330,400,430,500,530,600,630)) +
  scale_y_continuous(labels = percent, position = 'right') +
  labs(x = '', y = '', title = "Marathon Finishers By Chip Times") +
       scale_x_continuous(breaks = c(230,300,330,400,430,500,530,600,630)) +
  geom_vline(xintercept= c(230, 245, 300, 315, 330, 345, 400, 415, 430, 445, 500, 515, 530, 545, 600, 615, 630),
             color="purple",linetype="solid") +
    xlim(150, 700) +
  theme_minimal()

#Save graph
ggsave("C:/code/coding_challenges/documents/copying_first_graph.png", width = 15, height = 5)

# Summarized data
dat2 <- dat %>% 
      group_by(country, year) %>%
      summarise(finishers = mean(finishers))

# second graph
ggplot(data = dat2, mapping = aes(x = year, y = finishers, color = country)) +
  geom_point(na.rm = TRUE)+ 
  labs(x = "Year",
       y = "Finishers",
       title = "Finishers By Year Per Country",
       #subtitle = "MPG comparison by car class",
       color = "Country") +
  facet_wrap(~country, scales = "free_y")

#Save graph
ggsave("C:/code/coding_challenges/documents/my_graph.png", width = 15, height = 5)

