##combine the matrix
mycount <- c(c(1, 4, 2, 1, 7),c(3, 2))
print (mycount)
##creat a matrix named "b"
b <- seq(from = 1, to = 6, by = 1)
dim(b) <- c(2, 3)
b
##look at the col and row in the matrix
?dim(matrix(1:6, ncol = 3, nrow = 2))

##creat a matrix
give_matrix <- matrix(6:1, ncol = 3, nrow =2)
give_matrix
##return the value of the give_matrix used [row, column]
give_matrix[1,3]
##return the values in the first row
give_matrix[1,]
##return the values in the first colomn
give_matrix[,1]
##add q to all of the values
give_matrix + 1
##creat a repeat matrix
rep(1:3, each = 5)
mat_rep <- matrix(rep(1:3, each = 5), nrow = 3, ncol = 5, byrow = TRUE)
mat_rep
##creat a vector from 1 to 5
vec_seq <- 1:5
##multiple the matrices using element-wise multiplication
mat_rep * vec_seq

##creat a matrix
matrix(rnorm(80, 1, 2),nrow = 8, ncol = 10)
##creat a matrix to be multiplication
mat_seq <- matrix(seq(from = 1, to = 20, length.out = 6 ),ncol = 3, nrow = 2)
mat_seq
##creat a vector
vec_seq <- seq(from = 10, to = 4, length.out = 3)
vec_seq
##multiple the matrices using element-wise multiplication
mat_seq %*% vec_seq

##make a matrix 
mat_seq <- matrix(seq(1, 20, length.out = 6), ncol=3, nrow=2)
mat_seq
##display the logical operate to select the value in matrix which is greater than 10
mat_seq > 10
##return the value in matrix larger than 10
mat_seq[mat_seq > 10]
##Calculate eighenvalues and eigenvectors
matrix(1:9, ncol = 3, nrow = 3)
eigen(matrix(1:9, ncol = 3, nrow = 3))
##creat an example array
myarray <- array(1:24, dim=c(3,2,4))
myarray
##creat an array contain 100 random numbers
anarray <- array(runif(100,min = 1,max = 38),dim = c(10,2,5))
anarray
##make a data frame with information on whether a Species was seen (1 = yes, 0 = no), on a particular Day:
our_data <- data.frame("Day" = rep(1:3, each = 3), 
                       "Species" = rep(letters[1:3], each = 3),
                       "Seen" = rbinom(n = 9, size = 1, prob = 0.5))

##look at the Day column
our_data["Day"]
##access the Day column
our_data$Day
##add a new column called location
our_data$location <- "United Kingdom"
##look the new column
our_data

##creat a new data column
name = c('Anastasia', 'Dima', 'Katherine', 'James', 'Emily', 'Michael', 'Matthew', 'Laura', 'Kevin', 'Jonas')
score = c(12.5, 9, 16.5, 12, 9, 20, 14.5, 13.5, 8, 19)
questions = c(1, 3, 2, 3, 2, 3, 1, 1, 2, 1)
qualify = c('yes', 'no', 'yes', 'no', 'no', 'yes', 'yes', 'no', 'no', 'yes')
df = data.frame(name, score, questions, qualify) 
df
##Display the structure of the data frame just created
str(df)


##install devtool
install.packages("devtools", dependencies = TRUE)
##load the devtools package
library("devtools")
##install the "vroom" package
install_github("r-lib/vroom")
writeLines('PATH="${RTOOLS40_HOME}\\usr\\bin;${PATH}"', con = "~/.Renviron")
Sys.which("make")
## "C:\\rtools40\\usr\\bin\\make.exe"
install.packages("jsonlite", type = "source")

##make sure vroom is loaded into your R session (you only need to do this once)
library(vroom)
##read in the wader data set
wad_dat <- vroom("C:/Users/qb21029/OneDrive - University of Bristol/Desktop/wader_data.csv")
##look at the top of the data
head(wad_dat)

##Relative pathways
##first we set the working directory (which is the location of the current file you are working on):
setwd(dirname(rstudioapi::getActiveDocumentContext()$path))

##then read in the data using vroom:
wad_dat <- vroom('./Data/wader_data.csv')


##Task
##first we set the working directory (which is the location of the current file you are working on):
setwd(dirname(rstudioapi::getActiveDocumentContext()$path))

##then read in the data using vroom:
Covid_data <- vroom('./Data/time_series_covid19_deaths_global.csv')

##4.1.2use vroom to read in some data from github:
covid_dat <- vroom("https://raw.githubusercontent.com/chrit88/Bioinformatics_data/master/Workshop%203/time_series_covid19_deaths_global.csv")
##4.1.2
##you can ignore this code for the moment if you want
##but to briefly summarise it is reading in some data included in base R
##and then splitting it into 3 differnt data.frame style objects based on the values in one of the columns ("cyl")
mt <- tibble::rownames_to_column(mtcars, "model")
purrr::iwalk(
  split(mt, mt$cyl),
  ##save this split files in to the default directory
  ~ vroom_write(.x, glue::glue("mtcars_{.y}.csv"), "\t")
)

##find files in the default directory which start with "mtcars" and end in "csv"
##save these file names as an object called "files"
files <- fs::dir_ls(glob = "mtcars*csv")

##these are then the names of the files matching the above arguments:
files
##then load these file names using vroom 
vroom(files)


##4.2load in some RData
load("my_data/pathway/my_data.RData")


##6.1install the tidyverse
install.packages("tidyverse")
##load the tidyverse
library("tidyverse")
##6.2what class is the object
class(covid_dat)
##look at the data
covid_dat
##change the first two names of our data frame
names(covid_dat)[1:2] <- c("Province.State", "Country.Region")
##6.3so this says take our data frame called covid_dat
covid_long <- covid_dat %>%
  ##and then apply this function 
  pivot_longer(cols = -c( Province.State, 
                          Country.Region, 
                          Lat, 
                          Long))

##our data frame
covid_long <- covid_dat %>%
  ##and then apply this function 
  pivot_longer(cols = -c(Province.State:Long),
               names_to = "Date",
               values_to = "Deaths")

##change long to wide
covid_wide <- covid_long %>% 
  pivot_wider(names_from = Date,
              values_from = Deaths)






##homework
endanger1 <- vroom("C:/Users/qb21029/OneDrive - University of Bristol/Documents/GitHub/bioinformatics/Bioinformatics_data_to_sort_pop_1.csv")
endanger2 <- vroom("C:/Users/qb21029/OneDrive - University of Bristol/Documents/GitHub/bioinformatics/Bioinformatics_data_to_sort_pop_2.csv")


endanger_long <- endanger %>%
  pivot_longer(cols = -c(species, 
                         primary_threat, 
                         secondary_threat, 
                         tertiary_threat), 
               names_to = c("population", "date"),
               names_pattern = "(.*)_(.*)",
               values_drop_na = F, 
               values_to = "abundance")




