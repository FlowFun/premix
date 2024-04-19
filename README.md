# Premix Stability Assessment Project

## Description
This project focuses on assessing the stability of premixes used in manufacturing processes. It evaluates how factors such as temperature, humidity, and storage duration impact the physical and chemical properties of premixes, aiming to optimize storage conditions and enhance product quality.

## Getting Started

### Dependencies
- R (version 4.0.0 or higher)
- RStudio (recommended)
- Required R packages:
  ```R
  install.packages(c("readxl", "ggplot2", "reshape2", "nlme", "tidyverse", "ggpubr", "kableExtra", "rstatix"))

  ```

### Installing
- Clone or download this repository to your local machine.
- Open the project in RStudio by accessing the `.Rproj` file.

### Executing Program
1. Load the required libraries:
   ```R
      library(readxl)
      library(ggplot2)
      library(reshape2)
      library(nlme)
      library(tidyverse)
      library(ggpubr)
      library(kableExtra)
      library(rstatix)
   ```
2. Execute the main analysis script located in the `src` directory:
   ```R
   source("/src/Premix_stability.R")
   ```

## Project Structure
- `/bin`: Contains executable scripts or compiled binaries used in processing.
- `/data`: Stores raw data files, typically in XLSX format.
- `/doc`: Documentation related to the project, including methodology and references.
- `/results`: Outputs from the analyses, including generated reports.
- `/src`: All R scripts necessary for the analysis.
  - `Premix_stability.R`: The primary script to iteratively call the r markdown generator.
  - `Premix_stability.Rmd`: The r markdown generator.

## Results
This section outlines the key findings from the analysis. For comprehensive details, please refer to the output files in the `/results` folder.

## Authors
- Aguirre Mimoun
- Arthur Tenenhaus
- Jean-Philippe Vial

## Acknowledgments
- Thank you to R community for continous support

## How to Contribute
- Contributions via pull requests are welcome. For substantial changes, please open an issue first to discuss what you'd like to change.
- Please ensure to update tests appropriately.

## License
This project is licensed under the [MIT License](LICENSE.txt).
