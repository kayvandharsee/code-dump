library(tidyverse) 
library(scales)
monkey <- read_csv('data.csv')
monkey <- monkey[-c(1),]
monkey$Clouds[is.na(monkey$Clouds)] <- 'Unknown'
monkey$Precipitation[is.na(monkey$Precipitation)] <- 'No rain'
monkey$Wind[is.na(monkey$Wind)] <- 'Not windy'
monkey$Behaviour[is.na(monkey$Behaviour)] <- 'Missing Data'
monkey <- monkey %>% unite('Weather', Clouds, Precipitation, Wind, sep = ', ')
monkey_weather <- monkey %>% select(Weather, Behaviour)
make_bar <- function(df){
  ggplot(df, aes(x = Behaviour, fill = Behaviour)) + geom_bar() + 
  ggtitle(paste('Monkey Behaviour During',df$Weather[1], "Weather")) + 
    scale_y_continuous(breaks = pretty_breaks()) + labs(y = 'Count') + 
    guides(fill = 'none') + 
    theme(axis.text.x = element_text(angle = 90, vjust = 0.5, hjust = 1))
}
monkey_list <- split(monkey_weather, monkey_weather$Weather)


p <- lapply(monkey_list, make_bar)
p
