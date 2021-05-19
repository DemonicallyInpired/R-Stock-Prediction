#Dataset from Google open stocks
Google_stock <- read.csv("GOOG2.csv");
Google_stock = data.frame(Google_stock);
head(Google_stock);

#installing the required Packages
if(!require(ggplot2)) install.packages("ggplot2");
if(!require(pROC)) install.packages("pROC");
if(!require(randomForest))install.packages("randomForest");
if(!require(party))install.packages("party");
if(!require(tidyr))install.packages("tidyr");
if(!require(dplyr))install.packages("dplyr");

#Load the installed packages
library("ggplot2")
library(party)
library(randomForest)
library(pROC)

#Check for null values in the dataFrame
print(colSums(is.na(Google_stock)));
glimpse(Google_stock)
print(ggplot(Google_stock, aes(x = 1:nrow(Google_stock), y = Adj.Close)) + geom_line())

#Prepare the boxplot by flattening the rows in dataFrame
box = Google_stock %>%
      pivot_longer(Open:Volume, names_to = "Attributes", values_to = "Value")
print(box)

#Plotting the box plot for all the stocks attribute
print(Google_stock %>%
  pivot_longer(Open:Volume, names_to = "Attributes", values_to = "Value") %>%
  ggplot(aes(x = Value)) +
  geom_boxplot() +
  facet_wrap(vars(Attributes), ncol = 3) +
  labs(x = "Attributes", y = "Value")
);

#Here, in correspondance to the previous dataFrame we noticed that since Volume Column of the dataFrame consists way larger values than the rest, 
#we need to normalize the data arond the mean
print(Google_stock %>%
  pivot_longer(Open:Adj.Close, names_to = "Attributes", values_to = "Value") %>%
  ggplot(aes(x = Value)) +
  geom_boxplot() +
  facet_wrap(vars(Attributes), ncol = 3) +
  labs(x = "Attributes", y = "Value")
);

#Normalizing the data around the mean in correpondance to the relation z = (x - mean)/sd;
Google_stock <- data.matrix(Google_stock[,-1]);
train_data = Google_stock[1: nrow(Google_stock)*0.8,]
mean <- apply(train_data, 2, mean)
sd <- apply(train_data, 2, sd);
Google_stock <- scale(Google_stock, center=mean, scale = sd)
Google_stock <- data.frame(Google_stock)

#Plotting box plot for the normalized data, however volume still have a bunch of outliers
print(Google_stock %>%
  pivot_longer(Open:Volume, names_to = "Attributes", values_to = "Value") %>%
  ggplot(aes(x = Value)) +
  geom_boxplot() +
  facet_wrap(vars(Attributes), ncol = 3) +
  labs(x = "Attributes", y = "Value"));

#Printing the histrograms for the resulting normalized data, however, there are still vartation between the Volume and the rest of the data
#as the volume results in the ___ curve while the rest indicates a comb curve
print(Google_stock %>%
  pivot_longer(Open:Volume, names_to = "Attributes", values_to = "Value") %>%
  ggplot(aes(x = Value)) +
  geom_histogram() +
  facet_wrap(vars(Attributes), ncol = 3) +
  labs(x = "Attributes", y = "Value"));

#Dropping the Volume Column
Google_stock <- within(Google_stock, rm(Volume));

#Spliting the data into train and test sets
dt = sort(sample(nrow(Google_stock), nrow(Google_stock)*.8))
train_data<-Google_stock[dt,]
test_data<-Google_stock[-dt,]

#Printing the dimenssions of resulting training and testing sets
print(dim(train_data))
print(dim(test_data))

#Dropping target_var i.e Adjusted Close price column from the test data
test_data = data.frame(test_data)
target_var = test_data["Adj.Close"]
Adj.Close = data.frame(target_var)
test_features = within(test_data, rm(Adj.Close))
test_features = test_features
test_features

#Fitting the Random Forest Regressor
forest <- randomForest(formula = Adj.Close ~ ., 
           data = train_data)
print(forest);

#Printing the relative importance of each feature somewhat similar to a heatmap
print(importance(forest,type = 2)); 


predictions <- predict(forest, test_features);

#Plotting a ROC curve
rocCurve <-roc(test_data$Adj.Close,predictions);
plot(rocCurve)


predictions = as.data.frame(predictions)
Merged_data = cbind(test_data, predictions)

#Plotting the predicted values of the stocks as compared to the actual values
print(ggplot(Merged_data, aes(x = 1:nrow(test_data))) + 
  geom_line(aes(y = Adj.Close), color = "darkred") + 
  geom_line(aes(y = predictions), color="steelblue", linetype="twodash"));