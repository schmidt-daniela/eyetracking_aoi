# Image-based Calculation of Rectangular Areas of Interest (AOIs) in Eye Tracking Data

Eye tracking data in its most simplistic form may look as follows:

![](image/data_table.png)

## Problem

Did a participant pay visual attention towards an (static) image on the screen? A well-established approach to encounter this question is to assess (for each unit of time) whether the participant's gaze coordinates fell within the area of interest (AOI[^1]) or not. As this is normally done offline (after data collection), researcher need to inspect the visual image to identify the coordinates defining their AOI and write appropriate code. The functions provided in this repository simplify this process. By only providing an image as input, a column is added to the eye tracking data containing information on whether the gaze fell within the AOI of the image or not (per unit of time) (function: **addAOI**). Moreover, coordinates, width, and height of the AOI can be extracted (function: **extractAOIParameter**).

[^1] *= often defined as the most narrow rectangle covering the image.*

## Requirements

-   The stimulus must be on a white background.

-   The resolution of the image must be equal to the resolution in which the data was recorded. To check the resolution of the image, one can use the function **checkResolution**.

-   There shouldn't be more than one stimulus in the image (see Figure 1-3 below).

![Figure 1. Correct](image/circle_correct.png)

![Figure 2. False](image/circle_false_1.png)

![Figure 3. (unless you want this AOI.)](image/circle_false_2.png)

## Usage

1. Paste your eye-tracking data in the folder "data".
This is what the data looks like in the example:
| **time** | **x_coordinate** | **y_coordinate**  |
| ---:|---:| ---:|
| 1 | 906 | 546
| 2 | 1078 | 560
| 3 | 960 | 534
| 4 | 1005 | 542
| 5 | 1006 | 591
| 6 | 221 | 75
| 7 | 183 | 99
| 8 | 185 | 84
| 9 | 198 | 102
| 10 | 181 | 104

2. Paste the image that was presented during the time that the eye-tracking data refers to in the folder "image".

3. Open an IDE for R (e.g., RStudio). Install and load the following packages:

    install.packages("tidyverse")
    install.packages("here")
    install.packages("imager")
    install.packages("retistruct")
    
    library(tidyverse)
    library(here)
    library(imager)
    library(retistruct)

4. Load the eye-tracking functions of the repository:

```
source(here("function", "aoi_functions.R"))
```

4. Read the eye-tracking data:
```
et_data <- read.table(here("data", "eyetracking_data.txt"), sep = "\t", header = T)
```

5. Apply the function:
```
addAOI(image_name = "circle.png", data = et_data, x_col = "x_coordinate", y_col = "y_coordinate", aoi_name = "circle") 
```
6. Get the output:

| **time** | **x_coordinate** | **y_coordinate**  | **aoi**|
| ---:|---:| ---:| ---:|
| 1 | 906 | 546 | circle
| 2 | 1078 | 560 | circle
| 3 | 960 | 534 | circle
| 4 | 1005 | 542 | circle
| 5 | 1006 | 591 | circle
| 6 | 221 | 75 | <NA>
| 7 | 183 | 99 | <NA>
| 8 | 185 | 84 | <NA>
| 9 | 198 | 102 | <NA>
| 10 | 181 | 104 | <NA>
