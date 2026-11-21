# 03_evaluation.R ---------------------------------------------------------
# Section f: forecast accuracy on the test set + time-series cross-validation.

cat("\n=== Accuracy on the test set ===\n")
fc_list <- list(naive = naive_fc, snaive = snaive_fc, ses = ses_fc,
                des = des_fc, decomposition = decomposition_fc)
for (m in names(fc_list)) {
  cat("\n--", m, "--\n")
  print(accuracy(fc_list[[m]], test_data))
}

# Errors on one test set only are not very informative, so we also compare the
# methods with time-series cross-validation (forecast horizons 1 to 12).
cat("\nRunning time-series cross-validation (this can take a minute)...\n")
naive_e         <- tsCV(y_ts, naive,  h = 12)
snaive_e        <- tsCV(y_ts, snaive, h = 12)
ses_e           <- tsCV(y_ts, ses,    h = 12)
des_e           <- tsCV(y_ts, holt,   h = 12)
decomposition_e <- tsCV(y_ts, stlf,   h = 12)

e_list <- list(naive = naive_e, snaive = snaive_e, ses = ses_e,
               des = des_e, decomposition = decomposition_e)

rmse_of <- function(e) sqrt(mean(e^2, na.rm = TRUE))
mape_of <- function(e) mean(abs(e / y_ts), na.rm = TRUE) * 100

cv_results <- data.frame(Method = names(e_list))
if (error_measure %in% c("RMSE", "BOTH")) cv_results$RMSE <- sapply(e_list, rmse_of)
if (error_measure %in% c("MAPE", "BOTH")) cv_results$MAPE <- sapply(e_list, mape_of)

cat("\n=== Cross-validation errors ===\n")
print(cv_results, row.names = FALSE)
write.csv(cv_results, file.path(out_dir, "cv_errors.csv"), row.names = FALSE)
