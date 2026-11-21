# 01_load_data.R ----------------------------------------------------------
# Sections a-c: read the data, build the time series, split train/test, plot.

if (!file.exists(data_file)) {
  stop("Cannot find '", data_file, "'.\n",
       "Open the project via turnover-forecasting.Rproj (or setwd() to the project folder)\n",
       "and make sure the Excel file is inside the 'data' folder.")
}

## a) read the data
# Row 1 of the sheet holds the series descriptions, so we skip it;
# row 2 (the Series IDs) then becomes the column names.
dataset <- read_excel(data_file, skip = 1)

if (!id %in% names(dataset)) {
  stop("Series ID '", id, "' not found. Example IDs: ",
       paste(head(names(dataset)[-1], 3), collapse = ", "), " ...")
}

# the first column holds the month; use its first date as the start of the series
first_date <- as.Date(dataset[[1]][1])
start_ym   <- c(as.integer(format(first_date, "%Y")), as.integer(format(first_date, "%m")))

y_ts <- ts(dataset[[id]], start = start_ym, frequency = 12)   # monthly time series

print(autoplot(y_ts) + xlab("Time") + ylab("Turnover") + ggtitle(id))

## b) training / test split
train_size <- floor(length(y_ts) * train_ratio)   # integer number of training observations

train_end_time  <- time(y_ts)[train_size]
test_start_time <- time(y_ts)[train_size + 1]     # the month right after the training data

train_data <- window(y_ts, end = train_end_time)
test_data  <- window(y_ts, start = test_start_time)

## c) plot the split
print(
  autoplot(y_ts) +
    autolayer(train_data, series = "Training") +
    autolayer(test_data,  series = "Test") +
    ggtitle("Training and test data") + xlab("Time") + ylab("Turnover")
)
