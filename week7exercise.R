##week3exercise code from week3 homework
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
long_spp <- endanger %>%
  pivot_longer(cols = -c(species, 
                         primary_threat, 
                         secondary_threat, 
                         tertiary_threat), 
               names_to = c("population", "date"),
               names_pattern = "(.*)_(.*)",
               values_drop_na = F, 
               values_to = "abundance")
##see the final result
long_spp




##week7
##2.1calculate standarised time per pop and per species. 
long_spp <-  long_spp %>% 
  group_by(species, population) %>%
  mutate(standardised_time = as.numeric(difftime(as.Date(date), 
                                                 min(as.Date(date)), 
                                                 units="weeks")))

## just look four of the columns to visualise the data 
## (you can look at all in Rstudio) but printing all the columns in 
## Rmarkdown means we won't see the standardised_time column
print(long_spp[,c("species", "population", "abundance", "standardised_time")], 10)

##last week's code about creat n.threats
long_spp <- long_spp %>% 
  rowwise %>%
  mutate(n.threats = length(which(!is.na(c(primary_threat, secondary_threat, tertiary_threat)))))

##visualise the data
ggplot(long_spp, aes(x = standardised_time,
                     y = abundance)) + 
  geom_line(aes(group = interaction(species, population))) + 
  facet_wrap(~n.threats) +
  theme_minimal() +
  ##fit a linear regression to the data to help visualise
  geom_smooth(method = "lm")

## see the range of trajectories of the different populations:
ggplot(long_spp, aes(x = standardised_time,
                     y = abundance,
                     group = interaction(species, population))) + 
  geom_line() + 
  facet_wrap(~n.threats) +
  theme_minimal() +
  geom_smooth(method = "lm")

##2.2find, install, and load the glmmTMB package
install.packages("nloptr")
library(glmmTMB)

##2.3##fit a random effects model
m_mod1 <- glmmTMB(abundance ~ 
                    standardised_time + 
                    n.threats + 
                    standardised_time:n.threats + 
                    (1|species), 
                  data=long_spp, 
                  family="gaussian")

##look at the model summary:
summary(m_mod1)
##Calculate the variance方差 explained by the random effect
9602 / (9602+4447)
##↑ so the result is about 70%

##2.4##fit a random effects model with nested random effects
m_mod2 <- glmmTMB(abundance ~ standardised_time + 
                    n.threats + 
                    standardised_time:n.threats + 
                    (1|species/population), 
                  data=long_spp, 
                  family="gaussian")

##look at the model summary:
summary(m_mod2)
##calculate the variance explained by these random effect
(8.988e+03+5.554e-93)/(8.988e+03+5.554e-93+3.755e+03)


##2.5just learn

##2.6##load DHARMa
library(DHARMa)

## simulate the residuals from the model
##setting the number of sims to 1000 (more better, according to the DHARMa help file)
m_mod2_sim <- simulateResiduals(m_mod2, n = 1000)

##plot out the residuals
plot(m_mod2_sim)