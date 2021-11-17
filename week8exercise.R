install.packages("dplyr")
library(dplyr)

##1 ##long vector
x <- c(1:1e6)

##time a calculation
system.time(sin(x + x^2))
##time a calculation
system.time({
  ##long vector
  x <- c(1:1e6)
  
  ##calculate the sin of the folliwing
  v <- sin(x + x^2)
  
  ##put it into a tibble
  data_out <- as_tibble(v)
})
##look at the data
data_out

####好用的load the microbenchmark package
install.packages("microbenchmark")
library(microbenchmark)

##long vector
x <- c(1:1e6)

##2 ##approach 1
f_1 <- function(x){
  ##calculate the sin of the folliwing
  v <- sin(x + x^2)
  
  ##put it into a tibble
  data_out <- as_tibble(v)
  
  return(data_out)
}

##approach 2
f_2 <- function(x){
  ##calculate the sin of the folliwing
  ##without saving objects v and data_out
  return(as_tibble(sin(x + x^2)))
}

##compare the speeds of the two functions, 
##running each 500 times
benchmarks <- microbenchmark(f_1,
                             f_2,
                             times = 1000, 
                             unit = "s")

##look at the results
benchmarks
##3 
x <- c(1:7)
print (x)
sample(x, 2)
print (sample)
##3.1non-vectorised addition function
non_vec_addition <- function(x, y){
  ##define an object to store the values in
  z <- numeric(length(x))
  
  ##use a loop to add each element of the vectors together in turn
  ##and then save the output into the correct slot in the z vector
  for(i in 1:length(x)){
    z[i] <- x[i] + y[i]
  }
  ##return the result
  return(z)
}
vec_1 <- c(3, 4, 5, 2) 
vec_2 <- c(1, 2, 3, 4) 
##addition of two vectors
non_vec_addition(vec_1, vec_2)
##3.2##make sure you load in the data.table library to access rbindlist()
install.packages("data.table")
library(data.table)
##make a blank list 
save_data <- vector(mode = "list", 
                    length = length(unique(iris$Species)))

##add some additional data to to the iris data frame
for(o in 1:length(unique(iris$Species))){
  ##subset the full data set, making a new subset for each species in turn
  sub <- subset(iris, Species==unique(iris$Species)[o])
  
  ##add in a new column called "outlier"
  ##we will use this to identify possible outliers in the data
  ## we initially fill this with NAs
  sub$outlier <- NA
  ##then if the subset data is from the species "versicolor"...
  if(sub$Species[1]=="versicolor"){
    ##...and the value of the Petal.Length column is greater than 5
    ## then save an "outlier" not in the outlier column
    sub$outlier[which(sub$Petal.Length > 5)] <- "outlier"
  }
  ##add the data to our blank list
  save_data[[o]] <- sub
}

##bind the list togehter (using rbindlist from the data.table package)
save_data <- rbindlist(save_data)

##see if it worked:
filter(save_data, Species == "versicolor", Petal.Length > 5)
print(iris)
## make a new column
iris$outlier <- NA

##using logical operators
iris$outlier[iris$Petal.Length>5 & iris$Species=="versicolor"] <- "outlier"
