# Load libraries
library(tidyverse)

# Download and unzip main file
if(!file.exists("exdata_data_NEI_data.zip")) {download.file("https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2FNEI_data.zip", destfile = "exdata_data_NEI_data.zip")}
if(!(file.exists("Source_Classification_Code.rds") & file.exists("summarySCC_PM25.rds"))) {
        unzip("exdata_data_NEI_data.zip", exdir = ".")
}

# Read files into R
SCC <- readRDS("Source_Classification_Code.rds")
NEI <- readRDS("summarySCC_PM25.rds")

# Format year to factor variable, subset Baltimore
balt <- NEI %>% mutate(year = as.factor(year)) %>% filter(fips == "24510")

# Create a tibble w/ year in one column and total Baltimore emissions in another
bsum <- balt %>% group_by(year) %>% summarise(total_PM25 = sum(Emissions))

# Plot total Baltimore emissions by year
graphics.off()
par(mar = c(5,6,5,2))
with(bsum, plot(as.integer(as.character(year)), total_PM25, pch = 20, col = "blue", main = "Total PM2.5 Emissions, Baltimore", xlab = "Year", ylab = "", xaxt = "n", las = 1))
with(bsum, lines(as.integer(as.character(year)), total_PM25, col = "blue"))
with(bsum, axis(1, at = as.integer(as.character(year)), labels = year))
title(ylab = "Emissions (tons)", line = 4)

# Save to .png
dev.copy(png, filename = "plot2.png")
dev.off()