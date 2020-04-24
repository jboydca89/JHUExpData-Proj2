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

# Filter Baltimore, format year and type to factor variables
balt <- NEI %>% filter(fips == "24510") %>% mutate(year = as.factor(year), type = as.factor(type))

# Create a summary of total emissions, grouped by year and type of source
bsum <- balt %>% group_by(year, type) %>% summarize(total_PM25 = sum(Emissions))

# Create a plot of emissions totals by year, faceted by type
qplot(year, total_PM25, data = bsum, facets = .~type, geom = c("point", "line"), group = 1, main = "PM2.5 Emissions, Baltimore, by Type of Source", xlab = "Year", ylab = "Emissions (tons)")

# Save to .png file
dev.copy(png, filename = "plot3.png")
dev.off()