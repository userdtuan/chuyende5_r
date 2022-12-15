check_missing <- function(df.raw) {
  #Tinh tong so cac gia tri N/A o cot "Dia", va tuong tu cho may cot "GDCD","Hoa",..., sau do gan vao cac bien
  colSums(is.na(df.raw["Dia"])) -> dia
  colSums(is.na(df.raw["GDCD"])) -> gdcd
  colSums(is.na(df.raw["Hoa"])) -> hoa
  colSums(is.na(df.raw["Li"])) -> li
  colSums(is.na(df.raw["Ngoai_ngu"])) -> ngoaingu
  colSums(is.na(df.raw["Sinh"])) -> sinh
  colSums(is.na(df.raw["Su"])) -> su
  colSums(is.na(df.raw["Toan"])) -> toan
  colSums(is.na(df.raw["Van"])) -> van
  
  #In cac bien ra man hinh de kiem tra
  print(dia)
  print(gdcd)
  print(hoa)
  print(li)
  print(ngoaingu)
  print(sinh)
  print(su)
  print(toan)
  print(van)
}

# Ham nay dung de xu ly cac gia tri missing
handle_missing <- function(df.raw, value) {
  #Gan cac gia tri bi missing bang gia tri 'Value'
  df.raw["Dia"][is.na(df.raw["Dia"])] <- value
  df.raw["GDCD"][is.na(df.raw["GDCD"])] <- value
  df.raw["Hoa"][is.na(df.raw["Hoa"])] <- value
  df.raw["Li"][is.na(df.raw["Li"])] <- value
  df.raw["Ngoai_ngu"][is.na(df.raw["Ngoai_ngu"])] <- value
  df.raw["Sinh"][is.na(df.raw["Sinh"])] <- value
  df.raw["Su"][is.na(df.raw["Su"])] <- value
  df.raw["Toan"][is.na(df.raw["Toan"])] <- value
  df.raw["Van"][is.na(df.raw["Van"])] <- value
  df.raw['Ma_ngoai_ngu'] <- 'none'
  df.raw["Ma_ngoai_ngu"][df.raw["Ma_mon_ngoai_ngu"]=="N1"] <- "Anh"
  df.raw["Ma_ngoai_ngu"][df.raw["Ma_mon_ngoai_ngu"]=="N2"] <- "Nga"
  df.raw["Ma_ngoai_ngu"][df.raw["Ma_mon_ngoai_ngu"]=="N3"] <- "Phap"
  df.raw["Ma_ngoai_ngu"][df.raw["Ma_mon_ngoai_ngu"]=="N4"] <- "Trung"
  df.raw["Ma_ngoai_ngu"][df.raw["Ma_mon_ngoai_ngu"]=="N5"] <- "Duc"
  df.raw["Ma_ngoai_ngu"][df.raw["Ma_mon_ngoai_ngu"]=="N6"] <- "Nhat"
  return(df.raw)
}
gan_ten_tinh <- function(df,df.tinh) {
  df['Ma.Tinh'] <- -1
  ### Xoa 6 ki tu sau cua cot "sbd" va gan cho cot Ma.Tinh
  df$Ma.Tinh <- gsub('.{6}$', '', df$sbd)
  #Import bang ten tinh
  #Xoa cot dau tien cua bang ten tinh
  df.tinh = select(df.tinh, -1)
  #Ghep bang thi sinh voi bang ten tinh theo cot "Ma.Tinh"
  df<-merge(x = df, y = df.tinh, by = "Ma.Tinh")
  return(df)
}
tu_nhien_vs_xa_hoi <- function(df.raw) {
  #Gan n = tong so hang
  n = nrow(df.raw)
  # khoi tao gia tri tn va xh =0
  tn = 0
  xh = 0
  #Duyet qua tat ca cac hang
  for (i in 1:n) {
    #Neu hang nao co tong 3 mon KHXH = -3, tuong ung voi viec thi sinh do khong thi 3 mon nay, suy ra thi sinh do thi to hop 3 mon KHTN
    if (df.raw$Dia[i] + df.raw$Su[i] + df.raw$GDCD[i] == -3) {
      #Tang so thi sinh thi khoi KHTN len 1
      tn = tn + 1
    }
  }
  # Thi sinh thi KHXH bang tong so thi sinh tru di so thi sinh thi KHTN
  xh = nrow(df.raw) - tn
  # In so cac thi sinh thi KHXH va KHTN ra man hinh, lam tron toi 4 chu so thap phan
  # print(paste("So thi sinh thi khoi XH: ", xh, " chiem ", trunc(((
  #   xh / n
  # ) * 100) * 10 ^ 4) / 10 ^ 4))
  # print(paste("So thi sinh thi khoi TN: ", tn, " chiem ", trunc(((
  #   tn / n
  # ) * 100) * 10 ^ 4) / 10 ^ 4))
  TN <- c(tn)
  XH <- c(xh)
  
  return(data.frame(TN, XH))
}
pho_diem <- function(df.raw, mon_hoc) {
  #Tao bang tb.pho_diem_ngoai_ngu voi cac gia tri diem ngoai ngu
  tb.pho_diem <- table(df.raw[names(df.raw) == mon_hoc])
  #Chuyen kieu du lieu table sang data frame
  df.pho_diem = as.data.frame(tb.pho_diem)
  #Xuat ra bang df.pho_diem_ngoai_ngu
  colnames(df.pho_diem) <- c('name','value')
  df.pho_diem <- subset(df.pho_diem,name!=-1 )
  return(df.pho_diem)
}