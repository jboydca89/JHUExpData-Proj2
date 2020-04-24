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

# Figure out which sector codes are related to coal combustion
sectorindices <- grep("[Cc]oal", unique(SCC$EI.Sector))
coalSectors <- as.character(unique(SCC$EI.Sector)[sectorindices])

# Get the SCC codes for those three EI.Sector values
coalSCC <- SCC %>% filter(EI.Sector %in% coalSectors) %>% select(SCC)
coalSCC <- as.character(coalSCC$SCC)

# Now subset the NEI data frame to only include EI
coal <- NEI %>% filter(SCC %in% coalSCC)

# Create a summary of total emissions from coal combustion-related sources by year
coalsum <- coal %>% group_by(year) %>% summarise(total_PM25 = sum(Emissions))

# Plot emissions from coal combustion-related sources by year across U.S.
graphics.off()
par(mar = c(5,6,5,2))
plot(coalsum$year, coalsum$total_PM25, type = "b", pch = 19, col = 4, yaxt = "n", xaxt = "n", xlab = "Year", ylab = "", main = "PM2.5 Emissions from Coal Combustion-Related\nSources in the U.S.")
with(coalsum, axis(1, at = year, labels = year))
with(coalsum, axis(2, at = c(350,400,450,500,550)*1000, labels = paste(c(350,400,450,500,550),"k", sep = ""), las = 1))
title(ylab = "Emissions (tons)", line = 4)

# Save to .png file
dev.copy(png, filename = "plot4.png")
dev.off()