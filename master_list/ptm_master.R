## Global

mysheets <- gs_ls()

gs_master <- gs_title("PTM - Master List")

#gets the data
gs_ptm<- gs_read(master)

#cleans up columns
colnames(ptm) <- ptm[1,]
new <- ptm[-c(1,2),]

write_csv(new, "master_list/ptm.csv")
