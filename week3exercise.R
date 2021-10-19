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
##???????????read in the wader data set
wad_dat <- vroom("C:\Users\qb21029\OneDrive - University of Bristol\Desktop\wader_data.csv")

##use vroom to read in some data from github:
covid_dat <- vroom(https:/"github.com/WeixuanX/bioinformatics/blob/main/Data/Workshop%203/time_series_covid19_deaths_global.csv)
