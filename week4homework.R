##code from week3 homework
#library the vroom function to read file
library(vroom)
##to read the two csv files use the manual pathways
endanger1 <- vroom("C:/Users/qb21029/Documents/GitHub/bioinformatics/to_sort_pop_1.csv")
endanger2 <- vroom("C:/Users/qb21029/Documents/GitHub/bioinformatics/to_sort_pop_2.csv")
##load the tidyverse
library("tidyverse")
##using tidyverse join both of these data together into a single tibble
endanger <- full_join(endanger1,endanger2)
endanger
##reshape them from wide to long format
endanger_long <- endanger %>%
  pivot_longer(cols = -c(species, 
                         primary_threat, 
                         secondary_threat, 
                         tertiary_threat), 
               names_to = c("population", "date"),
               names_pattern = "(.*)_(.*)",
               values_drop_na = F, 
               values_to = "abundance")
##see the final result
endanger_long

##creat a ggplot
##specify the directory and name of the pdf, and the width and height
pdf("C:/Users/qb21029/Desktop/endanger_long.pdf", width = 50, height = 20)

##run the ggplot code to print your plot
##make the data as data
library("lubridate")
endanger_long$Date.corrected <- as_date(endanger_long$date)
##make the ggplot object
picture <- ggplot(data = endanger_long, aes(x=Date.corrected, y=abundance)) 
picture + 
  ##add lines
  geom_point(aes(col= species, shape = population)) +
  ##add facets
  facet_wrap(. ~ species) +
  ##remove legend position
  theme(legend.position = "none")


dev.off()