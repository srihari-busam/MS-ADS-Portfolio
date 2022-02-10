#################################################################
#
# Author: Srihari Busam
# Purpose: Poster plots
# Course: IST 719
#
#################################################################

library(ggplot2)
library(dplyr)
library(tidyr)
library(webr)

my.dir <- "C:\\Users\\sriha\\Documents\\IST719\\Poster\\Data\\"
games.sales <- read.csv(
  file=paste0(my.dir,  "Video_Games_Sales_as_at_22_Dec_2016.csv"),
  header = TRUE,
  stringsAsFactors = FALSE)
names(games.sales)

platforms.of.interest <- c("Wii","NES", "GB", "DS","X360", "PS3","PS2","SNES",
                           "GBA","PS4","3DS","N64","PS","XB","PSP","XOne",
                           "WiiU","PSV","SCD")

nintendo.platform <- c("Wii","NES", "GB", "DS","SNES","GBA","3DS","N64","WiiU","SCD")
playstation.platform <- c("PS3","PS2","PS4","PS","PSP","PSV")
xbox.platform <- c("X360","XB","XOne")

## data cleanup
unique(games.sales$Year_of_Release)

## filter games only for Nintendo, Play Station and Xbox
sales.fitered <- games.sales %>%
  filter(Platform %in% platforms.of.interest)

unique(sales.fitered$Platform)
table(sales.fitered$Platform)

## filter data for year of release
## Filter data with NA value and years that do not have enough observations
sales.fitered <- sales.fitered %>%
  filter(Year_of_Release != "N/A") %>%
  filter(Year_of_Release != "1980") %>%
  filter(Year_of_Release != "2017") %>%
  filter(Year_of_Release != "2020")

table(sales.fitered$Year_of_Release)

## Enhance dataset, Add the company that produced the console platform

sales.fitered$console.company <- "Unknown"
sales.fitered$console.company[sales.fitered$Platform %in% nintendo.platform] <- "Nintendo"
sales.fitered$console.company[sales.fitered$Platform %in% playstation.platform] <- "Sony-PlayStation"
sales.fitered$console.company[sales.fitered$Platform %in% xbox.platform] <- "Microsoft-Xbox"

unique(sales.fitered$console.company)

names(sales.fitered)

agg.sales <- sales.fitered %>% 
  group_by(console.company,Platform) %>% 
  summarise(Global_Sales = sum(Global_Sales, na.rm = TRUE),
            NA_Sales = sum(NA_Sales, na.rm = TRUE),
            EU_Sales = sum(EU_Sales, na.rm = TRUE),
            JP_Sales = sum(JP_Sales, na.rm = TRUE),
            Other_Sales = sum(Other_Sales, na.rm = TRUE),
  )

summary(agg.sales)

###########################################################################################
### Key pie chart about console sales
###########################################################################################

PieDonut(agg.sales,aes(pies=console.company,donuts=Platform, count = Global_Sales),r0=0,showPieName=FALSE, explode=3, title="Global Sales")
PieDonut(agg.sales,aes(pies=console.company,donuts=Platform, count = NA_Sales),r0=0,showPieName=FALSE, explode=3, title="NA_Sales")
PieDonut(agg.sales,aes(pies=console.company,donuts=Platform, count = EU_Sales),r0=0,showPieName=FALSE, explode=3, title="EU_Sales")
PieDonut(agg.sales,aes(pies=console.company,donuts=Platform, count = JP_Sales ),r0=0,showPieName=FALSE, explode=3, title="JP_Sales")
PieDonut(agg.sales,aes(pies=console.company,donuts=Platform, count = Other_Sales ),r0=0,showPieName=FALSE, explode=3, title="Other_Sales")


###########################################################################################
### Yearly sales
###########################################################################################

sales.fitered %>% 
  group_by(console.company) %>%
  summarise(Global_Sales = sum(Global_Sales, na.rm = TRUE))



yearly.sales <- sales.fitered %>% 
  group_by(Year_of_Release, console.company) %>% 
  summarise(Global_Sales = sum(Global_Sales, na.rm = TRUE),
            NA_Sales = sum(NA_Sales, na.rm = TRUE),
            EU_Sales = sum(EU_Sales, na.rm = TRUE),
            JP_Sales = sum(JP_Sales, na.rm = TRUE),
            Other_Sales = sum(Other_Sales, na.rm = TRUE)
  )

colnames(yearly.sales) <- c("Year", "Brand", "Global Sales","North America Sales","EU_Sales","Japan Sales","Other Sales" )

yearly.sales %>%
  ggplot( aes(x=Year, y="Other Sales", group=Brand, color=Brand)) +
  geom_line() +
  ggtitle("Game sales by year") +
  ylab("Sales in Million$") +
  theme(axis.text.x = element_text(angle = 90))


tall.df <- gather(yearly.sales, key="Sales", value="value", c("North America Sales", "Japan Sales"))

tall.df %>%
  ggplot( aes(x=Year, y=value, group=Brand, color=Brand)) +
  geom_line() +
  ggtitle("Game sales by Year") +
  ylab("Sales in Million$") +
  theme(axis.text.x = element_text(angle = 90)) +
  facet_wrap(~Sales, ncol=1)


###########################################################################################
### TOP console sales by region
###########################################################################################

comp.agg.sales <- sales.fitered %>%
  group_by(Platform) %>% 
  summarise(Global_Sales = sum(Global_Sales, na.rm = TRUE),
            NA_Sales = sum(NA_Sales, na.rm = TRUE),
            EU_Sales = sum(EU_Sales, na.rm = TRUE),
            JP_Sales = sum(JP_Sales, na.rm = TRUE),
            Other_Sales = sum(Other_Sales, na.rm = TRUE),
  ) %>%
  arrange(desc(Global_Sales))

names(comp.agg.sales)

colnames(comp.agg.sales) <- c("Platform", "Global_Sales", "North America Sales", "European Sales","Japan Sales", "Other Sales")
# top 10

comp.agg.sales.top10 <- head(comp.agg.sales, 10)

df.new <- gather(comp.agg.sales.top10, key="Sales", value="value", c("North America Sales", "European Sales","Japan Sales", "Other Sales"))

# top 10 console sales breakouts.
ggplot(data=df.new, aes(x=reorder(Platform, -Global_Sales), y=value, fill=Sales)) +
  geom_bar(stat="identity", width = 0.9,position = position_dodge(width=0.5)) +
  ggtitle("Sales by console (1981- 2016)") +
  ylab("Sales (Million$)") +
  xlab("Gaming Console") +
  theme(axis.text.x = element_text(angle = 90))

###############################################################################################
# Console life
###############################################################################################

range.data <- sales.fitered[c("Platform", "Year_of_Release", "console.company")]
names(range.data)

colnames(range.data) <- c("Console", "Year", "Brand")

range.data$Year <- as.numeric(range.data$Year)

head(range.data)

group.range.data <- range.data  %>%
  group_by(Console, Brand)  %>%
  summarise(Min = min(Year), Max = max(Year)) %>%
  arrange(desc(Max-Min))

ggplot(group.range.data, aes(x=Console))+
  geom_linerange(aes(ymin=Min,ymax=Max, color=Brand),linetype=1)+
  geom_point(aes(y=Min),size=3,color="red")+
  geom_point(aes(y=Max),size=3,color="blue")+
  ggtitle("Console life time") +
  xlab("Console name") +
  ylab("Year")
theme_bw()

ggplot(group.range.data, aes(y=reorder(Console, (Max-Min))))+
  geom_linerange(aes(xmin=Min,xmax=Max,color=Brand),linetype=1,  size=4)+
  geom_point(aes(x=Min),size=3,color="blue", shape = 24, fill = "darkkhaki")+
  geom_point(aes(x=Max),size=3,shape = 25, fill = "darkorange")+
  ggtitle("Console life time") +
  xlab("Year") +
  ylab("Console Name")


ggplot(group.range.data, aes(y=reorder(Console, (Min))))+
  geom_linerange(aes(xmin=Min,xmax=Max,color=Brand),linetype=1,  size=4)+
  geom_point(aes(x=Min),size=3,color="blue", shape = 24, fill = "darkkhaki")+
  geom_point(aes(x=Max),size=3,shape = 25, fill = "red")+
  ggtitle("Console life time") +
  xlab("Year") +
  ylab("Console Name")



###############################################################################################
# WORD cloud
###############################################################################################

### Publisher, developer word cloud
library("wordcloud")
library("RColorBrewer")

library(plyr)

sales.fitered %>%
  group_by(Developer) %>%
  count()

developer.freq <- count(sales.fitered, 'Developer')
wordcloud(words = developer.freq$Developer, freq = developer.freq$freq, min.freq = 1,
          max.words=50, random.order=FALSE, rot.per=0.35, 
          colors=brewer.pal(8, "Dark2"))


developer.freq <- count(sales.fitered, 'Publisher') %>%
  arrange(desc(freq))

## cleanup long text
developer.freq$Publisher[developer.freq$Publisher == "Namco Bandai Games"] = "Namco"
developer.freq$Publisher[developer.freq$Publisher == "Konami Digital Entertainment"] = "Konami"
developer.freq$Publisher[developer.freq$Publisher == "Sony Computer Entertainment"] = "Sony"

wordcloud(words = developer.freq$Publisher, freq = developer.freq$freq, min.freq = 1,
          max.words=100, random.order=FALSE, rot.per=0.25, 
          colors=brewer.pal(8, "Dark2"),
          main="Video Game Developers")




