# 00_config.R -------------------------------------------------------------
# Settings you can change + package setup. Everything else reads from here.

id               <- "A3349335T"  # ABS series ID (a column name in the Excel file)
train_ratio      <- 0.7          # share of the data used for training
boxcox_transform <- TRUE         # use a Box-Cox transformation? TRUE / FALSE
lambda_user      <- NA           # NA = pick the optimal lambda automatically,
                                 # or type a specific value, e.g. 0.25
error_measure    <- "BOTH"       # "RMSE", "MAPE" or "BOTH"

data_file <- file.path("data", "Turnover_Australia.xlsx")  # path relative to the project folder
out_dir   <- "outputs"                                     # tables and figures are saved here

# ---- checks -----------------------------------------------------------------
if (!error_measure %in% c("RMSE", "MAPE", "BOTH")) {
  stop("error_measure must be 'RMSE', 'MAPE' or 'BOTH'.")
}

needed  <- c("readxl", "forecast", "ggplot2")
missing <- needed[!vapply(needed, requireNamespace, logical(1), quietly = TRUE)]
if (length(missing) > 0) {
  stop("Please install the missing packages first:\n  install.packages(c(",
       paste0('"', missing, '"', collapse = ", "), "))")
}
suppressPackageStartupMessages({
  library(readxl)
  library(forecast)
  library(ggplot2)
})

dir.create(out_dir, showWarnings = FALSE)
