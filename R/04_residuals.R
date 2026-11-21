# 04_residuals.R ----------------------------------------------------------
# Section g: residual diagnostics for every method.

methods <- c("naive", "snaive", "ses", "des", "decomposition")

residual_list <- list(
  naive         = residuals(naive_fc),
  snaive        = residuals(snaive_fc),
  ses           = residuals(ses_fc),
  des           = residuals(des_fc),
  decomposition = residuals(decomposition_fc)
)

results <- list()
for (method in methods) {
  res <- residual_list[[method]]
  results[[method]] <- list(
    t_test         = t.test(res),                                   # mean equals 0?
    ks_test        = ks.test(res, "pnorm", mean = 0),               # normal distribution
    shapiro_test   = shapiro.test(res),                             # normality
    box_test       = Box.test(res, lag = 12, fitdf = 0),            # autocorrelation
    ljung_box_test = Box.test(res, lag = 12, fitdf = 0, type = "Ljung-Box")
  )
  checkresiduals(res)   # residual plots
}

p_values <- data.frame(
  Method      = methods,
  T_test      = sapply(results, function(r) r$t_test$p.value),
  KS_test     = sapply(results, function(r) r$ks_test$p.value),
  Shapiro     = sapply(results, function(r) r$shapiro_test$p.value),
  Box         = sapply(results, function(r) r$box_test$p.value),
  Ljung_Box   = sapply(results, function(r) r$ljung_box_test$p.value)
)

cat("\n=== Residual tests (p-values) ===\n")
print(p_values, row.names = FALSE, digits = 3)
write.csv(p_values, file.path(out_dir, "residual_tests.csv"), row.names = FALSE)
