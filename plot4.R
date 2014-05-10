# Dataset downloading and processing
if(!file.exists('data/df.tidy.Rda')) {
  if(!file.exists("data")) {
    dir.create("data")
  }
  date.from <- as.Date('2007-02-01', '%Y-%m-%d')
  date.to <- as.Date('2007-02-02', '%Y-%m-%d')
  fn <- 'data/exdata-data-household_power_consumption.zip'
  fn.source <- 'https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip'
  
  # download original dataset in ZIP
  download.file(url=fn.source, destfile=fn, method='curl')
  
  fn.data <- 'household_power_consumption.txt'
  # read dataset directly from ZIP
  data <- read.table(unz(fn, fn.data), header = TRUE, sep = ";", stringsAsFactors=F)
  
  data$DateTime <- strptime(paste(data$Date, data$Time), '%d/%m/%Y %H:%M:%S')
  data$Date <- as.Date(data$Date, '%d/%m/%Y')
  
  # subsetting original dataset 
  df.tidy <- subset(data, data$Date >= date.from & data$Date <= date.to)
  rm(data)
  
  # convert to numeric
  df.tidy$Global_reactive_power <- as.numeric(df.tidy$Global_reactive_power)
  df.tidy$Global_active_power <- as.numeric(df.tidy$Global_active_power)
  df.tidy$Voltage <- as.numeric(df.tidy$Voltage)
  df.tidy$Global_intensity <- as.numeric(df.tidy$Global_intensity)
  df.tidy$Sub_metering_1 <- as.numeric(df.tidy$Sub_metering_1)
  df.tidy$Sub_metering_2 <- as.numeric(df.tidy$Sub_metering_2)
  
  # Processed and subsetted dataset was saved for future use
  save(df.tidy, file='data/df.tidy.Rda')
} else {
  # If data already processed, simple load it into R  
  load('data/df.tidy.Rda')
}

# my computer default locale is non English, so I reset it to Englush for this plot
tmp <- Sys.getlocale("LC_TIME")
Sys.setlocale("LC_TIME", "C")

# plot on PNG device
png(filename='plot4.png', width=480, height=480, bg='transparent', type='cairo')
par(mfrow = c(2, 2))

# plot 1, 1
plot(df.tidy$DateTime, df.tidy$Global_active_power, type = "l",  xlab='', ylab='Global Active Power')
# plot 1, 2
plot(df.tidy$DateTime, df.tidy$Voltage, type = "l",  xlab='datetime', ylab='Voltage')

# plot 2, 1
plot(df.tidy$DateTime, df.tidy$Sub_metering_1, type = 'n',  xlab='', ylab='Energy sub metering')
points(df.tidy$DateTime, df.tidy$Sub_metering_1, type = 'l', col='black')
points(df.tidy$DateTime, df.tidy$Sub_metering_2, type = 'l', col='red')
points(df.tidy$DateTime, df.tidy$Sub_metering_3, type = 'l', col='blue')
legend("topright", lty=c(1,1), col = c('black', 'red', 'blue'), bty='n', legend = c('Sub_metering_1', 'Sub_metering_2', 'Sub_metering_3'))

# plot 2, 2
plot(df.tidy$DateTime, df.tidy$Global_reactive_power, type = "l",  xlab='datetime', ylab='Global_reactive_power')

dev.off()

# locale must be restored
Sys.setlocale("LC_TIME", tmp)

