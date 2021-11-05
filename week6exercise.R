hist(rnorm(100,mean = 161.1, sd = 8.8))
hist(rnorm(200,mean = 120, sd = 7))
library("lubridate")
library("tidyverse")
##2.1.1 load the iris data set
data("iris")
## Plot the sepal widths so we can visualise if there are differences between the different species
ggplot(iris, aes(x=Species, y=Sepal.Width, col-Specise)) + 
  geom_jitter() +
  theme_bw()

ggplot(iris, aes(x=Sepal.Width, fill=Species)) +
  geom_histogram(binwidth=.1, alpha=.5, position="dodge")

##2.1.2fit a glm()
mod_iris <- glm(Sepal.Width ~ Species,
                ##specify the data
                data = iris,
                ##specify the error structure
                family = "gaussian")

##2.1.3display the class of the model object
class(mod_iris)
##display the class of the model object
plot(mod_iris)
##2.1.4 summarise the model outputs
summary(mod_iris)
##2.1.5 Multiple comparisons test
## load the multcomp pack
install.packages("multcomp")
library(multcomp)

## run the multiple comparisons, and look at the summary output:
summary(glht(mod_iris, mcp(Species="Tukey")))

##2.2 drop NA
endanger_long <- endanger %>%
  pivot_longer(cols = -c(species, 
                         primary_threat, 
                         secondary_threat, 
                         tertiary_threat), 
               names_to = c("population", "date"),
               names_pattern = "(.*)_(.*)",
               values_drop_na = T, 
               values_to = "abundance")
##look at the data
print(endanger_long) 
##Set the date column to date format
endanger_long$date <- as_date(endanger_long$date)
##filter the species:Trichocolea tomentella
single_spp <- endanger_long %>%
  filter(species == "Trichocolea tomentella")
single_spp
##2.2.1make the plot
p1 <- ggplot(single_spp, aes(x=Date.corrected, y=abundance)) +
  geom_point() +
  geom_line() +
  theme_bw() +
  ylab("Abundance") +
  xlab("Year")
##add the loess smoothing:
p1 + geom_smooth(method="loess")

#### calculate a new column (`standardised_time`) which is the difference between the
## starting date of the time series and each other date in weeks (see ?difftime)
## we will set this to a numeric vector
single_spp <- single_spp %>%
  mutate(standardised_time = as.numeric(difftime(as.Date(date),
                                                 min(as.Date(date)),
                                                 units = "weeks")))

print(single_spp[,c("abundance", "date", "standardised_time")])
##fit a glm()
mod1 <- glm(abundance ~ standardised_time,
            data = single_spp,
            family = "gaussian")

##2.2.1return the predicted (response) values from the model
##and add them to the single species tibble:
single_spp$pred_gaussian <- predict(mod1,
                                    type="response")
##task return the residuals残差
single_spp$resid_gaussian <- resid(mod1,
                                   type="response")
## plot the abundances through time
p2 <- ggplot(single_spp, aes(x = standardised_time,
                             y = abundance)) +
  geom_point() +
  geom_line() +
  theme_bw() +
  ylab("Abundance") +
  xlab("standardised_time")

##add in a line of the predicted values from the model
p2 <- p2 + geom_line(aes(x = standardised_time,
                         y = pred_gaussian),
                     col = "dodgerblue",
                     size = 1)
##add the redsidual残余 error
p2 <- p2 +
  geom_segment(aes(xend = standardised_time,
                   yend = pred_gaussian),
               col="lightblue")

## add a title
p2 <- p2 + ggtitle("Fitted model (gaussian with identity link)")

##print the plot
p2
##plot a histogram of the residuals from the model using geom_histogram()
p3 <- ggplot(single_spp, aes(x = resid_gaussian)) +
  geom_histogram(fill="goldenrod") +
  theme_minimal() +
  ggtitle("Histogram of residuals (gaussian with identity link)")
## print the plot
p3

##task ##make the plot of predicted vs residuals
p4 <- ggplot(single_spp,
             aes(x = pred_gaussian,
                 y = resid_gaussian)) +
  geom_point() +
  theme_minimal() +
  xlab("Predicted values") +
  ylab("residuals") +
  ggtitle("Predicted vs residual (gaussian with identity link)") +
  ##using geom_smooth without specifying the method (see later) means geom_smooth()
  ##will try a smoothing function with a formula y~x and will try to use a loess smoothing
  ##or a GAM (generalised additive model) smoothing depending on the number of data points
  geom_smooth(fill="lightblue", col="dodgerblue")

##print it
p4

##print QQ plot
qqnorm(single_spp$resid_gaussian); qqline(single_spp$resid_gaussian)



##2.2.1.1fit a glm with a poisson distribution
mod2 <- glm(abundance ~ standardised_time,
            data = single_spp,
            family = "poisson")
## fit a glm with a gaussian distribution with a log link
mod3 <- glm(abundance ~ standardised_time,
            data = single_spp,
            family = gaussian(link = "log"))
## we could also try a guassian model with an inverse link
mod4 <- glm(abundance ~ standardised_time,
            data = single_spp,
            family = gaussian(link = "inverse"))
##install the gamlr package, and then:
install.packages("gamlr")
library(gamlr)
##compare the models
AIC_mods <- data.frame(model = c("mod1", "mod2", "mod3", "mod4"),
                       AICc = c(AICc(mod1), AICc(mod2), AICc(mod3), AICc(mod4)))

## rank them by AIC using the order() function
AIC_mods[order(AIC_mods$AICc),]
##找出mod3是最合适实际data，然后用module作图
##return the predicted (response) values from the model and add them to the single species tibble:
single_spp$pred_gaussian_log <- predict(mod3,
                                        type="response")

##return the model residuals and add to the single species tibble:
single_spp$resid_gaussian_log <- resid(mod3)

##first off let's plot the data again, and add in the predicted values from the model as a line. We can modify the plot we started earlier:
p5 <- ggplot(single_spp, aes(x=standardised_time, y=abundance)) +
  geom_point() +
  geom_line() +
  theme_bw() +
  ylab("Abundance") +
  xlab("standardised_time")

##add in a line of the predicted values from the model
p5 <- p5 + geom_line(aes(x = standardised_time,
                         y = pred_gaussian_log),
                     col = "dodgerblue",
                     size = 1)

## we can also add in lines showing the distance of each observation from
## the value predicted by the model (i.e. these lines visualise the residual error)
p5 <- p5 + geom_segment(aes(xend = standardised_time,
                            yend = pred_gaussian_log),
                        col="lightblue")

## add a title
p5 <- p5 + ggtitle("Fitted model (gaussian with log link)")

##print the plot
p5
##plot the diagnostic graphics for model 3
plot(mod3)


##2.2summarise the model outputs
summary(mod3)

## first off let's plot the data again
p6 <- ggplot(single_spp, aes(x=standardised_time, y=abundance)) +
  geom_point() +
  geom_line() +
  theme_bw() +
  ylab("Abundance") +
  xlab("standardised_time")

## use the geom_smooth() function to add the regression to the plot.
## unlike earlier here we are specifying the model type (glm), the formula,
## and the error structure and link
p6 <- p6 + geom_smooth(data=single_spp,
                       method="glm",
                       method.args = list(family = gaussian(link="log")),
                       formula = y ~ x,
                       col = "dodgerblue",
                       fill = "lightblue")

##print the plot
p6
AIC_mods
