if(!file.exists("data")) {
  dir.create("data")
}

fn.tidy <- 'data/df.tidy.Rda'

if(!file.exists(fn.tidy)) {
  date.from <- as.Date('2007-02-01', '%Y-%m-%d')
  date.to <- as.Date('2007-02-02', '%Y-%m-%d')
  fn <- 'data/exdata-data-household_power_consumption.zip'
  fn.source <- 'https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip'
  download.file(url=fn.source, destfile=fn, method='curl')
  
  fn.data <- 'household_power_consumption.txt'
  data <- read.table(unz(fn, fn.data), header = TRUE, sep = ";", stringsAsFactors=F)
  data$DateTime <- strptime(paste(data$Date, data$Time), '%d/%m/%Y %H:%M:%S')
  data$Date <- as.Date(data$Date, '%d/%m/%Y')
  df.tidy <- subset(data, data$Date >= date.from & data$Date <= date.to)
  rm(data)
  df.tidy$Global_reactive_power <- as.numeric(df.tidy$Global_reactive_power)
  df.tidy$Global_active_power <- as.numeric(df.tidy$Global_active_power)
  df.tidy$Voltage <- as.numeric(df.tidy$Voltage)
  df.tidy$Global_intensity <- as.numeric(df.tidy$Global_intensity)
  df.tidy$Sub_metering_1 <- as.numeric(df.tidy$Sub_metering_1)
  df.tidy$Sub_metering_2 <- as.numeric(df.tidy$Sub_metering_2)
  save(df.tidy, file="data/df.tidy.Rda")
} else {
  load(fn.tidy)
}

