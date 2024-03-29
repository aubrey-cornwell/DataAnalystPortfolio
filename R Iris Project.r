#STILL WORKING - SO FAR: LOOKING AT DATA

#######################
# Loading Iris data set
########################

install.packages("datasets")
library(datasets)
data(iris)

#######################
# Display summary stats
########################

# head() / tail()
head(iris)
tail(iris)

# summary()
summary(iris)

# check for missing data
sum(is.na(iris)) # no missing values

# using skmir() to see a larger set of statistics
# install.packages("skimr")
library(skimr)
skim(iris)

# grouping data by species
iris %>% 
    dplyr::group_by(Species) %>% 
    skim

##########################
# Data Visualization 

# R Base Plot - less useful
###########################

# panel plots
plot(iris)
plot(iris, col = "orange") 

# scatter plot
plot(iris$Sepal.Width, iris$Sepal.Length, col = "orange") #showing specific relationship between sepal length and width
plot(iris$Sepal.Width, iris$Sepal.Length, col ="orange",
xlab = "Sepal width", ylab = "Sepal length") #labelign axis

# histograms
hist(iris$Sepal.Width, col = "orange")

# feature plots
# https://www.machinelearningplus.com/machine-learning/caret-package/
install.packages("caret")
library(caret) # looking at the box and whiskers plots
featurePlot(x = iris[1:4],
            y = iris$Species,
            plot = "box",
            strip=strip.custom(par.strip.text=list(cex=.7)),
            scales = list(x = list(relation="free"),
                          y = list(relation ="free")))
