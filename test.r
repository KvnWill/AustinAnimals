install.packages("dplyr")
install.packages("tidyr")
install.packages("lubridate")
install.packages("stringr")
install.packages("tibble")
install.packages("ggplot2")
install.packages("shinythemes")


library(dplyr)
library(tidyr)
library(lubridate)
library(ggplot2)
search()

just_join <- left_join(Austin_Animal_Center_Intakes, Austin_Animal_Center_Outcomes, by ="Animal ID", suffix = c(".in", ".out"))
just_join <- select(just_join, -MonthYear.in, -Name.out, -MonthYear.out, -'Animal Type.out', -Breed.out, -Color.out )

sec_try <- just_join %>%
  filter(mdy_hms(DateTime.in) < mdy_hms(DateTime.out))

list <- pull(sec_try, 'Animal ID')

list2 <- select(sec_try, 'Animal ID', DateTime.in)
list2 <- unique(list2, keep_all = FALSE)

list <- unique(list, keep_all = FALSE)

View(list)

x <- as.Date("12/07/2017 10:10:00 AM")
y <- as.Date("12/07/2017 05:56:00 PM")
x1 <- mdy_hms("12/07/2017 10:10:00 AM")
y1 <- mdy_hms("12/07/2017 05:56:00 PM")
x2 <- mdy_hms("12/07/2017 05:56:00 PM")

check <- unique(combined$Intake.Type)
checkG <- unique(combined$Sex.upon.Outcome)
View(check)

check2 <- combined %>%
  group_by(Intake.Type) %>%
  count() %>%
  View()
x <- 1

byMon <- combined %>%
  filter((Intake.Type == "Stray") & (Outcome.Type == "Adoption")) %>%
  mutate(mon = month.abb[month(mdy_hms(DateTime.out))]) %>%
  group_by(mon, Sex.upon.Intake) %>%
  count()
byMonth <- ggplot(byYear, aes(x = mon, y=n, fill=Sex.upon.Intake))+
  geom_bar(stat = "identity", position = position_dodge()) +
  scale_x_discrete(limits = month.abb)
byMonthp
x <- c("Stray","Public Assist")

test <- combined %>%
  filter((Intake.Type %in% x)) %>%
  View()




byYear <- combined %>%
  filter((Intake.Type == "Stray") & (Outcome.Type == "Adoption")) %>%
  mutate(mon = year(mdy_hms(DateTime.out))) %>%
  group_by(mon, Sex.upon.Intake) %>%
  count()
byYearp <- ggplot(byYear, aes(x = mon, y=n, fill=Sex.upon.Intake))+
  geom_bar(stat = "identity", position = position_dodge()) 
  
byYearp


combined %>%
  filter(Outcome.Type == "Adoption") %>%
  mutate(age = time_length(difftime(mdy_hms(DateTime.out), mdy(Date.of.Birth)),"years")) %>%
  mutate(mon = month(mdy_hms(DateTime.out))) %>%
  group_by(mon, floor(age)) %>%
  count() %>%
  View()

combined <- read.csv("AustinAnimals/newData.csv")

write.table(sec_try, "data.txt", sep = ";" , row.names = FALSE, quote = FALSE)
write.csv(list2, "list.txt", row.names = FALSE, quote = FALSE)
