##2 load the following packages: ‘tidyverse’, ‘vroom’
install.packages("tidyverse")
library("tidyverse")
library(vroom)

##load data form
covid_dat <- vroom("https://raw.githubusercontent.com/chrit88/Bioinformatics_data/master/Workshop%203/time_series_covid19_deaths_global.csv")
##rename the first two column
names(covid_dat)[1:2] <- c("Province.State", "Country.Region")
##reshape the data into long
covid_long <- covid_dat %>%
  pivot_longer(cols = -c(Province.State:Long),
               names_to = "Date",
               values_to = "Deaths")
##2.1 load wbstats
install.packages("devtools", dependencies = TRUE)
library("devtools")
library("usethis")
install.packages("wbstats")
library("wbstats")
##extract the population data for all countries
pop_data <- wb_data(indicator = "SP.POP.TOTL", 
                    start_date = 2002, 
                    end_date = 2020)
##convert it to a tibble
pop_data <- as_tibble(pop_data)
##2.2 filter the data to include data from the year 2020 only:
pop_2020 <- pop_data %>% 
  ##only return data where the date is equal to the maximum value in the column "date"
  filter(date == 2020)
##look at the data
pop_2020

##2.3 the first 10 and last 10 unique values in the country column
## the ; operature acts as a new line - meaning you can run two bits of code which don't interact on the same line
head(unique(pop_2020$country), 10); tail(unique(pop_2020$country), 10)
##the covid data
head(covid_dat, 10)
##task filter the data that only show Australia
pop_Australia <- pop_data %>% 
  filter(country == "Australia")

##make a new data.frame from the old covid_long data.frame
covid_country <- covid_long %>% 
  ## we want to calculate the number of 
  ##deaths in each country and at each date:
  group_by(Country.Region, Date) %>% 
  ## and we want the sum of the "Death" column in these groups:
  summarise(Deaths = sum(Deaths))
## have a look at the data.frame that is produced:
covid_country

##download countrycode packages
install.packages("countrycode")
library("countrycode")

## add a column to covid data containing the 
covid_country$code <- countrycode(covid_country$Country.Region, 
                                  origin = "country.name", 
                                  destination = "iso3c")

##task look at the top row
head(covid_country,1)

##compare that to the values in the WB data
pop_2020 %>% filter(iso3c == "AFG")

##2.4rename the 5th column so it works with the following code
names(pop_2020)[5] <- "value"

##demonstration of what select does:
head(pop_2020 %>% select(iso3c, value))

## join the two data sets:
covid_w_pop <- left_join(covid_country, 
                         pop_2020 %>% select(iso3c, value),
                         by = c("code" = "iso3c"))

##look at the new data set
covid_w_pop
## column names
names(covid_w_pop)
##the ones which are equal to "value"
names(covid_w_pop) == "value"
##the position in the vector of the "TRUE" statements
which(names(covid_w_pop) == "value")
##change the name
names(covid_w_pop)[which(names(covid_w_pop) == "value")] <- "Population"

##2.5##filter to leave the most recent data
most_recent <- covid_country %>% 
  filter(Date == max(covid_country$Date))

##sum the deaths
sum(most_recent$Deaths)

##2.6make a new data frame of the global deaths using group_by() and summarise()
global_deaths_day <- covid_country %>% 
  group_by(Date) %>%
  summarise("Global.deaths" = sum(Deaths))
## make a new data frame of the global deaths using group_by() and summarise()
global_deaths_day <- covid_country %>% 
  group_by(Date) %>%
  summarise("Global.deaths" = sum(Deaths, na.rm=T))
##2.7calculate deaths per million people and add it to the data.frame
covid_w_pop$Deaths.p.m <- (covid_w_pop$Deaths / covid_w_pop$Population) * 1000000

##look at the data
tail(covid_w_pop)

##3.1make a ggplot object
ggplot(data = global_deaths_day, aes(x = Data, y = Global.deaths))

##
install.packages("lubridate")
library("lubridate")
global_deaths_day$Date.corrected <- as_date(global_deaths_day$Date,
                                            format = "%m/%d/%y")
## make a ggplot object
ggplot(data = global_deaths_day, aes(x = Date.corrected, y = Global.deaths)) + geom_point()

## a line plot
ggplot(data = global_deaths_day, aes(x = Date.corrected, y = Global.deaths)) + 
  ## lines
  geom_line()

##3.3##make the ggplot object
p1<-ggplot(data = global_deaths_day, aes(x=Date.corrected, y=Global.deaths)) 
## add the graphic (in this case lines)
p1<-p1+geom_line()
##make a second plot where you have points too, saved to a new object so you dont overwrite p1:
p2<-p1+geom_point()
##compare the two
p1
p2

##3.4.1add a new colum to have the correct date
covid_w_pop$Date.corrected <- as_date(covid_w_pop$Date, format = "%m/%d/%y")
##make the ggplot object
by_country <- ggplot(data = covid_w_pop, aes(x = Date.corrected, y = Deaths)) 
##make the ggplot object
by_country + geom_point(aes(col = Country.Region))
##make the ggplot object
by_country + geom_point(aes(col = Country.Region)) + theme(legend.position = "none")


##make a vector of countries we want to look at:
selec_countries <- c("United Kingdom", "China", "US", "Italy", "France", "Germany")

##use this to filter by for our plot. here using the %in% operature:
sel_country_plot <- ggplot(data = covid_w_pop %>% 
                             filter(Country.Region %in% selec_countries), 
                           aes(x = Date.corrected, y = Deaths)) 

##add a line geom specifying that the colours are dependant on the groups in `Country.Region`
sel_country_plot + geom_line(aes(col=Country.Region))
##3.4.2facet the data by country:
sel_country_plot + geom_line() + facet_wrap(. ~ Country.Region)
##facet the data by country:
sel_country_plot + geom_line(aes(col = Country.Region)) + facet_wrap(. ~ Country.Region)

##3.5 saving plot in PDF
##specify the directory and name of the pdf, and the width and height
pdf("C:/Users/qb21029/Desktop/Deaths by country.pdf", width = 6, height = 4)

##run your code to print your plot

sel_country_plot + 
  ##add lines
  geom_line(aes(col = Country.Region)) + 
  ##add facets
  facet_wrap(. ~ Country.Region)

##stop the pdf function and finish the .pdf file
dev.off()


geom_point(aes(col = species))

