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
vehicSum <- NEI %>% filter(SCC %in% vehicleSCC, fips == "24510" | fips == "06037") %>% group_by(year, fips) %>% summarise(total_PM25 = sum(Emissions))

# Turn fips into city names; convert to factor
vehicSum$fips[vehicSum$fips == "24510"] = "Baltimore"
vehicSum$fips[vehicSum$fips == "06037"] = "Los Angeles"
vehicSum <- vehicSum %>% mutate(City = as.factor(fips))

# Plot motor vehicle emissions by year in Baltimore
g <- ggplot(data = vehicSum, mapping = aes(x = year, y = total_PM25, color = City))
g + geom_point(size = 4) + geom_line() + labs(title = "PM2.5 Emissions from Motor Vehicle Sources", subtitle = "Baltimore & Los Angeles") +
        ylab("Emissions (tons)") + scale_x_continuous(name = "Year", breaks = as.numeric(unique(vehicSum$year)), labels = as.numeric(unique(vehicSum$year)))

# Save to .png file
dev.copy(png, filename = "plot6.png")
dev.off()