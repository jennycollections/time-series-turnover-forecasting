# 02_models.R -------------------------------------------------------------
# Sections d-e: Box-Cox choice and the five forecasting methods.

## e) Box-Cox transformation (decided BEFORE fitting, so every model uses it)
lambda_final <- NULL                      # NULL = no transformation
if (boxcox_transform) {
  if (is.na(lambda_user)) {
    lambda_final <- BoxCox.lambda(train_data)   # optimal lambda from the training data
  } else {
    lambda_final <- lambda_user                 # user-chosen lambda
  }
  message("Box-Cox lambda used: ", round(lambda_final, 4))
} else {
  message("Box-Cox transformation not requested.")
}

## d) forecasts
# h must equal the length of the test data, so forecast errors can be computed
h <- length(test_data)

naive_fc         <- naive(train_data,  h = h, lambda = lambda_final)
snaive_fc        <- snaive(train_data, h = h, lambda = lambda_final)
ses_fc           <- ses(train_data,    h = h, lambda = lambda_final)   # simple exponential smoothing
des_fc           <- holt(train_data,   h = h, lambda = lambda_final)   # double exponential smoothing
# stlf = seasonal decomposition + forecast; "naive" is used for the non-seasonal part
decomposition_fc <- stlf(train_data,   h = h, lambda = lambda_final, method = "naive")

# helper: plot training data, test data and one forecast
plot_fc <- function(fc, label) {
  autoplot(y_ts) +
    autolayer(train_data, series = "Training Data", color = "blue") +
    autolayer(test_data,  series = "Test Data",     color = "red") +
    autolayer(fc, series = label, PI = FALSE, color = "green") +   # PI = FALSE: no interval
    ggtitle(paste("Time Series Data with", label)) +
    xlab("Time") + ylab("Turnover") +
    guides(colour = guide_legend(title = "Legend")) +
    theme_minimal()
}

print(plot_fc(naive_fc,         "Naive Forecast"))
print(plot_fc(snaive_fc,        "Seasonal Naive Forecast"))
print(plot_fc(ses_fc,           "Simple Exponential Smoothing"))
print(plot_fc(des_fc,           "Double Exponential Smoothing"))
print(plot_fc(decomposition_fc, "Decomposition Forecast"))
