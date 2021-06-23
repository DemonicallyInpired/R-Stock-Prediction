## Stock Prediction Using Decision Tree Regressor in R
*The following Project deals with Google Stock Predictions for 3 consequtive months ranging from March to May, 2020. The underlying idea of the project and the staggering results revealing a AOC curve covering 100% of the area with specifity and senstivity of 1 indicates that Decision Tree can work well for Regression with dependent Classes, more so, the applied methods often indicates that Machine Learning Algorithm can work fairly well with limited amount of Data.* 

## Project Stucture
```
./StockPrediction/
├── data
│   └── GOOG2.csv
(data-dir)
├── Readme.md
└── src
    └── Stocks.R
    (Stock Prediction driver code)
```

## Dataset

The Dataset comprises of the follwing feature variables: 
<li>Date: The Date for the given Stock Exchanges</li>
<li>Open: The opening price for Stock on a given day</li>
<li>Close: The closing price for the Stock on a given day</li>
<li>Adj Close: The adjusted closing price for the Stock on a given day</li>
<li>Volume: The Volume of Stock Exchanged on a given day</li>