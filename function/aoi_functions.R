# Function 1: Check Resolution --------------------------------------------
checkResolution <- function(image_name){
  # Load image
  img <- image_name
  df_image <- as.data.frame(load.image(here("image", img)))
  
  # Return resolution
  image_resolution <- paste0("width = ", max(df_image$x), "px", " height = ", max(df_image$y), "px")
  return(image_resolution)
  }

# Function 2: Add AOI -----------------------------------------------------
addAOI <- function(image_name, data, x_col, y_col, aoi_name){
  
  # Load image
  img <- image_name
  df_image <- as.data.frame(load.image(here("image", img)))
  
  # Filter non white
  df_image_wide <- df_image %>%
    filter(cc != 4) %>%
    unite("x_y", c(x, y), sep = "_", remove = F) %>%
    pivot_wider(
      id_cols = x_y,
      values_from = value,
      names_from = cc,
      names_prefix = "cc"
    ) %>% 
    separate(x_y, c("x", "y"), remove = T) %>% 
    filter(cc1 != 1 | cc2 != 1 | cc3 != 1) %>%  # filter only non-white pixel
    mutate(x = as.numeric(x), y = as.numeric(y))
  
  # AOI information
  line_vertical_left_start <- c(min(df_image_wide$x), 0) # c(x, y)
  line_vertical_left_end <-   c(min(df_image_wide$x), max(df_image$x))
  
  line_vertical_right_start <- c(max(df_image_wide$x), 0)
  line_vertical_right_end <-   c(max(df_image_wide$x), max(df_image$x))
  
  line_horizontal_lower_start <- c(x = 0, y = max(df_image_wide$y))
  line_horizontal_lower_end <- c(max(df_image$x), y = max(df_image_wide$y))
  
  line_horizontal_upper_start <- c(x = 0, y = min(df_image_wide$y))
  line_horizontal_upper_end <- c(max(df_image$x), y = min(df_image_wide$y))
  
  # Upper left point of AOI
  left_upper <- line.line.intersection(line_vertical_left_start, line_vertical_left_end, 
                                       line_horizontal_upper_start, line_horizontal_upper_end)
  
  # Upper right point of AOI
  right_upper <- line.line.intersection(line_vertical_right_start, line_vertical_right_end, 
                                        line_horizontal_upper_start, line_horizontal_upper_end)
  
  # Lower left point of AOI
  left_lower <-line.line.intersection(line_vertical_left_start, line_vertical_left_end, 
                                      line_horizontal_lower_start, line_horizontal_lower_end)
  
  # Lower right point of AOI
  right_lower <- line.line.intersection(line_vertical_right_start, line_vertical_right_end, 
                                        line_horizontal_lower_start, line_horizontal_lower_end)
  
  # Add AOI
  if(is.null(data$aoi)){
    data$aoi <- rep(NA, nrow(data))}
  
  for(i in c(1:nrow(data))){
    if(data[i, x_col] > left_upper[1] & data[i, x_col] < right_upper[1] &
       data[i, y_col] < left_lower[2] & data[i, y_col] > right_upper[2]){
      data$aoi[i] <- aoi_name
    }
#    else(data$aoi[i] <- NA)
  }
  
  return(data)
  }

# Function 3: AOI Size ----------------------------------------------------
extractAOIParameter <- function(image_name){
  
  # Load image
  img <- image_name
  df_image <- as.data.frame(load.image(here("image", img)))
  
  # Filter non white
  df_image_wide <- df_image %>%
    filter(cc != 4) %>%
    unite("x_y", c(x, y), sep = "_", remove = F) %>%
    pivot_wider(
      id_cols = x_y,
      values_from = value,
      names_from = cc,
      names_prefix = "cc"
    ) %>% 
    separate(x_y, c("x", "y"), remove = T) %>% 
    filter(cc1 != 1 | cc2 != 1 | cc3 != 1) %>%  # filter only non-white pixel
    mutate(x = as.numeric(x), y = as.numeric(y))
  
  # AOI information
  line_vertical_left_start <- c(min(df_image_wide$x), 0) # c(x, y)
  line_vertical_left_end <-   c(min(df_image_wide$x), max(df_image$x))
  
  line_vertical_right_start <- c(max(df_image_wide$x), 0)
  line_vertical_right_end <-   c(max(df_image_wide$x), max(df_image$x))
  
  line_horizontal_lower_start <- c(x = 0, y = max(df_image_wide$y))
  line_horizontal_lower_end <- c(max(df_image$x), y = max(df_image_wide$y))
  
  line_horizontal_upper_start <- c(x = 0, y = min(df_image_wide$y))
  line_horizontal_upper_end <- c(max(df_image$x), y = min(df_image_wide$y))
  
  # Upper left point of AOI
  left_upper <- line.line.intersection(line_vertical_left_start, line_vertical_left_end, 
                                       line_horizontal_upper_start, line_horizontal_upper_end)
  
  # Upper right point of AOI
  right_upper <- line.line.intersection(line_vertical_right_start, line_vertical_right_end, 
                                        line_horizontal_upper_start, line_horizontal_upper_end)
  
  # Lower left point of AOI
  left_lower <-line.line.intersection(line_vertical_left_start, line_vertical_left_end, 
                                      line_horizontal_lower_start, line_horizontal_lower_end)
  
  # Lower right point of AOI
  right_lower <- line.line.intersection(line_vertical_right_start, line_vertical_right_end, 
                                        line_horizontal_lower_start, line_horizontal_lower_end)
  
  # Calculate AOI size
  aoi_size <- list(
    width = paste0(round(right_upper[1] - left_upper[1], 2), "px"),
    height = paste0(round(right_lower[2] - right_upper[2], 2), "px")
  )
  
  # Calculate AOI size
  aoi_coordinates <- list(
    left_upper = paste0("x = ", round(left_upper[1],2), ", y = ", round(left_upper[2],2), " in px"),
    right_upper = paste0("x = ", round(right_upper[1],2), ", y = ", round(right_upper[2],2), " in px"),
    left_lower = paste0("x = ", round(left_lower[1],2), ", y = ", round(left_lower[2],2), " in px"),
    right_lower = paste0("x = ", round(right_lower[1],2), ", y = ", round(right_lower[2],2), " in px")
  )
   
  return(list(aoi_size, aoi_coordinates))
}