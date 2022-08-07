## Only one item of interest in picture. White background color. Picture with original resolution

# Initial set up ----------------------------------------------------------
rm(list = ls()) # Remove everything from environment
Sys.setenv(LANGUAGE = "en") # Set system language to English

# Load packages -----------------------------------------------------------
# install.packages("tidyverse")
# install.packages("here")
# install.packages("imager")
# install.packages("retistruct")
library(tidyverse)
library(here)
library(imager)
library(retistruct)

# Load functions ----------------------------------------------------------
source(here("functions", "aoi_functions.R"))

# Mock data ---------------------------------------------------------------
mock_data <- data.frame(
  X = c(rnorm(50, 1024, 20), rnorm(50, 512, 20), rnorm(50, 1536, 20)),
  Y = c(rnorm(50, 576, 20), rnorm(50, 288, 20), rnorm(50, 864, 20))
)

# Execute function --------------------------------------------------------
checkResolution(image_name = "circle.png")

mock_data_ed <- addAOI(image_name = "circle.png", data = mock_data, x_col = "X", y_col = "Y", aoi_name = "circle")  
mock_data_ed

params <- extractAOIParameter(image_name = "circle.png")
params