##Create a vector of 100 random numbers between 0 and 50
a <- runif(100, 0, 50)

##order a from smallest to largeset
sort_a <- sort(a, decreasing = TRUE)

##write a function
func <- function(x){
  ##subtract lg(x) form x
  y <- x - log10(x)
  ##return the new vector
  return(y)
}

##ues function with random numbers
new_object <- func(sort_a)

##calculate mean
mean_object <- mean(new_object)

##calculate standard deviation
sd_object <- sd(new_object)

##calculate standard error 
se_object <- se(new_object)
##add from answer
se <- function(x)sd(x)/sqrt(length(x))

##save result into a single vector 
result <- c("mean" = mean_object,
            "sd" = se_object,
            "se" = sd_object)

##create a sequence
seq <- seq(15, 100, by=1)
##mean of the numbers > 20 and < 60
mean(seq[seq >20 & seq < 60])
##sum of the numbers > 48
sum(seq[seq >48])


##write a function
b <- function(x){
  return(c("min" = sort(x)[1],
           "max" = sort(x,decreasing = TRUE)[1]))
}
##check the result
b (runif(10, 2, 30))