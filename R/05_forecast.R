# 05_forecast.R -----------------------------------------------------------
# Section i: refit the chosen method (decomposition) on ALL data and forecast 24 months.

choose_fc <- stlf(y_ts, h = 24, method = "naive")

point_forecasts <- choose_fc$mean
lower_bounds    <- choose_fc$lower[, 2]   # 95% prediction interval
upper_bounds    <- choose_fc$upper[, 2]

# turn the time index into "YYYY-MM" labels
forecast_dates <- time(point_forecasts)
years          <- floor(forecast_dates + 1e-6)
months         <- round((forecast_dates - years) * 12) + 1
formatted_dates <- sprintf("%d-%02d", years, months)

forecast_table <- data.frame(
  Month          = formatted_dates,
  Point_Forecast = as.numeric(point_forecasts),
  Lower_95_PI    = as.numeric(lower_bounds),
  Upper_95_PI    = as.numeric(upper_bounds)
)
cat("\n=== 24-month forecast ===\n")
print(forecast_table)
write.csv(forecast_table, file.path(out_dir, "forecast_24_months.csv"), row.names = FALSE)

forecast_plot <- autoplot(choose_fc) +
  autolayer(y_ts, series = "Historical Data") +
  autolayer(point_forecasts, series = "Forecast") +
  ggtitle("Turnover Forecast for the Next 24 Months") +
  xlab("Time") + ylab("Turnover") +
  guides(colour = guide_legend(title = "Legend")) +
  theme_minimal()

print(forecast_plot)
ggsave(file.path(out_dir, "forecast_24_months.png"), forecast_plot,
       width = 9, height = 5, dpi = 150)
