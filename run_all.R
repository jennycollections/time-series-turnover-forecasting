# run_all.R ---------------------------------------------------------------
# Runs the whole analysis in order.
#   RStudio : open turnover-forecasting.Rproj, then open this file and click "Source"
#   Terminal: Rscript run_all.R   (run from the project folder)

# make sure we are in the project folder, also when started with a full path
file_arg <- sub("^--file=", "", grep("^--file=", commandArgs(FALSE), value = TRUE))
if (length(file_arg) == 1) setwd(dirname(normalizePath(file_arg)))

if (!file.exists(file.path("R", "00_config.R"))) {
  stop("Run this from the project folder (open turnover-forecasting.Rproj in RStudio).")
}

# outside RStudio there is no plot window, so collect all plots in one PDF
if (!interactive()) {
  dir.create("outputs", showWarnings = FALSE)
  pdf(file.path("outputs", "all_plots.pdf"), width = 10, height = 6)
}

steps <- c("00_config.R", "01_load_data.R", "02_models.R",
           "03_evaluation.R", "04_residuals.R", "05_forecast.R")
for (s in steps) {
  message("\n>>> ", s)
  source(file.path("R", s))
}

if (!interactive()) invisible(dev.off())
message("\nDone. Tables and figures are in the 'outputs' folder.")
