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

# Format year to factor variable
NEI <- NEI %>% mutate(year = as.factor(year))

# Create new dataframe with year in one column, total emissions in another
yearsum <- NEI %>% group_by(year) %>% summarise(total_PM25 = sum(Emissions))

# Plot total PM2.5 emissions
graphics.off()
million = 1000000
with(yearsum, plot(as.integer(as.character(year)), total_PM25, pch = 20, col = "blue", main = "Total PM2.5 Emissions, U.S.", xlab = "Year", ylab = "Emissions (tons)", xaxt = "n", yaxt = "n", ylim = c(2e06, 8e06)))
with(yearsum, lines(as.integer(as.character(year)), total_PM25, col = "blue"))
with(yearsum, axis(1, at = as.integer(as.character(year)), labels = year))
axis(2, at = c(2,4,6,8)*million, labels = paste(c(2,4,6,8), "million"))

# Save to .png file
dev.copy(png, filename = "plot1.png")
dev.off()