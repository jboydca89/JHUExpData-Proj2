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

# Find the EI Sectors pertaining to motor vehicles
vehicleSectors <- as.character(unique(SCC$EI.Sector)[grep("^Mobile", unique(SCC$EI.Sector))])

# Get the SCC codes related to vehicle sectors
vehicleSCC <- SCC %>% filter(EI.Sector %in% vehicleSectors)
vehicleSCC <- as.character(vehicleSCC$SCC)

# Now get a summary of total emissions, grouped by year, filtered by SCC code related to motor vehicles AND Baltimore City fips
vehicSum <- NEI %>% filter(SCC %in% vehicleSCC, fips == "24510") %>% group_by(year) %>% summarise(total_PM25 = sum(Emissions))

# Plot motor vehicle emissions by year in Baltimore
graphics.off()
par(mar = c(5,6,5,2))
plot(vehicSum$year, vehicSum$total_PM25, type = "b", xlab = "Year", ylab = "", main = "PM2.5 Emissions from Motor Vehicle Sources\nBaltimore, MD", yaxt = "n", ylim = c(350,900), xaxt = "n", pch = 19, col = "blue")
axis(1, at = vehicSum$year, labels = vehicSum$year)
axis(2, at = c(400, 500, 600, 700, 800, 900), labels = c(400, 500, 600, 700, 800, 900), las = 1)
title(ylab = "Emissions (tons)", line = 4)

# Save to .png file
dev.copy(png, filename = "plot5.png")
dev.off()