###PROBLEM STATEMENT:
###You are provided with a dataset of a departmental store. 
###It contains details of products from May, 2020, a period marked by covid-19.
###Your manager wants you to find out that investing in which products will be more profitable.
###Your objective is to analyse the patterns and trends of the products, and gather insights for 
###strategic decision making.(At this level, you don’t need to make reports/recommendations now.
###You will build reports and make recommendations in future, with the knowledge you gained from 
###this project.)



###LOAD THE PACKAGE
require(dplyr)
require(ggplot2)
library(corrplot)
library(ggcorrplot)
###LOAD THE DATASET
store <- read.csv("FINAL DEPARTMENTAL STORE.csv")


######## PART 1: DATA MANIPULATION
###i. ARRANGE YOUR DATASET IN DESCENDING ORDER OF PROFIT
###ii. USE FIRST 360 ROWS 

store1 <- arrange(store, desc(PROFIT))%>%slice_head(n=360)
View(store1)  






###iii. FIND THE AVERAGE, MAXIMUM AND MINIMUM OF PROFIT GROUPED BY PRODUCT CATEGORY

group_by(store1,PRODUCT_CATEGORY)%>%
  summarise(AVERAGE=mean(PROFIT),MAXIMUM=max(PROFIT),MINIMUM=min(PROFIT))






######## PART 2: DATA VISUALIZATION
### i.BUILD A COLUMN PLOT FOR AVERAGE_NET_PROFIT & COMPANY

store1 %>% group_by(COMPANY) %>% 
  summarise(AVERAGE_NET_PROFIT=mean(NET_PROFIT)) %>%
  ggplot(aes(x=COMPANY,y=AVERAGE_NET_PROFIT))+geom_col(width = 0.6, fill="pink")





### ii. BUILD A SCATTER PLOT FOR SELLING_PRICE & QUANTITY_DEMANDED

store1 %>%
  ggplot(aes(x=SELLING_PRICE, y=QUANTITY_DEMANDED, color=PRODUCT_CATEGORY))+geom_point()



######## PART 3:CORRELATION

#### i.BUILD A CORRELATION MATRIX OF THE COMPLETE DATASET

store<-dplyr::select_if(store, is.numeric)
r<-cor(store, use = "complete.obs")
round(r,2)


#### ii.PLOT THE HEAT MAP OF THE CORRELATION MATRIX  

ggcorrplot(r)


