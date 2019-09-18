
library(googlesheets)
#library(googlesheets4) # future will be googlesheets4
#(ptm <- drive_get("PTM - Master List"))

#need to authenticate (see popup window)
mysheets <- gs_ls()

gs_master <- gs_title("PTM - Master List")

#gets the data
gs_ptm<- gs_read(gs_master)

#cleans up columns
colnames(gs_ptm) <- gs_ptm[1,]
new <- gs_ptm[-c(1,2),]

bioblitz <- new %>% 
  filter(Project == "bioblitz2019")

sp_list <- unique(bioblitz$`Determination in the field`)

#Remove Petrocelis, NA, Unknown, Rhodophyta (4)
#Add Zostera marina? and Smithora naidum (collected but not pressed)