library(dplyr)
link.diemthi <- "datasets/diemthi2020.csv"
link.dstinh <- "datasets/listtinh.csv"
######## Function Island
xet_vku_theo_tinh<-function(df.raw){
  #tao data frame moi co
  df <- data.frame(So.Luong=double(),
                   Ma.Tinh = character())
}

##Ham nay dung de suy ra cac thi sinh du dieu kien xet tuyen vao truong VKU voi diem san va khong co mon nao trong to hop mon duoi diem liet
xet_vku_cntt <- function(df.raw, diemsan = 18.5,diemliet=1) {
  ##Tao bang df.xet_vku
  df.xet_vku <- df.raw
  # Tao cac cot to hop mon va gan gia tri mac dinh la -1
  df.xet_vku['A00'] <- -1
  df.xet_vku['A01'] <- -1
  df.xet_vku['D01'] <- -1
  #Gan gia tri cho to hop A00 co tong 3 mon la toan-li-hoa neu cot khoi thi la "TN"
  df.xet_vku$A00 <-
    ifelse(df.xet_vku$Khoi.Thi == "TN",
           df.xet_vku$Toan + df.xet_vku$Li + df.xet_vku$Hoa,-1)
  #Gan gia tri cho to hop A01 co tong 3 mon la toan-li-tienganh neu cot khoi thi la "TN" va ma ngoai ngu la "N1"
  df.xet_vku$A01 <-
    ifelse(
      df.xet_vku$Khoi.Thi == "TN" & df.xet_vku$Ma_mon_ngoai_ngu=="N1",
      df.xet_vku$Toan + df.xet_vku$Li + df.xet_vku$Ngoai_ngu,-1
    )
  #Gan gia tri cho to hop D01 co tong 3 mon la toan-Van-tienganh
  df.xet_vku$D01 <-
    df.xet_vku$Toan + df.xet_vku$Van + df.xet_vku$Ngoai_ngu
  
  #Tao cot Bi Liet de xet xem thi sinh do co mon nao bi diem liet khong
  df.xet_vku['Bi.Liet'] <- NA
  #Gan gia tri cho cot Bi.Liet theo tung khoi thi, neu khoi thi tu nhien thi xet 3 mon ly-hoa-sinh >-1, khoi thi xa hoi tuong ung
  df.xet_vku$Bi.Liet <-
    ifelse(((
      df.xet_vku$Khoi.Thi == "TN" &
        df.xet_vku$Sinh > diemliet &
        df.xet_vku$Hoa > diemliet &
        df.xet_vku$Li > diemliet
    ) |
      (
        df.xet_vku$Khoi.Thi == "XH" &
          df.xet_vku$Su > diemliet &
          df.xet_vku$Dia > diemliet &
          df.xet_vku$GDCD > diemliet
      )
    ) &
      (
        df.xet_vku$Toan > diemliet &
          df.xet_vku$Van > diemliet &
          df.xet_vku$Ngoai_ngu > diemliet
      ) ,
    FALSE,
    TRUE)
  df.xet_vku['Trung.Tuyen.VKU'] <- NA
  df.xet_vku$Trung.Tuyen.VKU <- ifelse(df.xet_vku$A00>=diemsan|df.xet_vku$A01>=diemsan|df.xet_vku$D01>=diemsan & df.xet_vku$Bi.Liet!=TRUE,TRUE,FALSE)
  return(df.xet_vku)
}
pho_diem_ngoai_ngu <- function(df.raw) {
  #Tao bang tb.pho_diem_ngoai_ngu voi cac gia tri diem ngoai ngu
  tb.pho_diem_ngoai_ngu <- table(df.raw[names(df.raw) == "Ngoai_ngu"])
  #Chuyen kieu du lieu table sang data frame
  df.pho_diem_ngoai_ngu = as.data.frame(tb.pho_diem_ngoai_ngu)
  #Tao cot 'percentage' trong bang "df.pho_diem_ngoai_ngu" voi cac gia tri bang -1
  df.pho_diem_ngoai_ngu[, 'percentage'] <- -1
  #Duyet tat ca cac gia tri diem trong bang
  for (i in 1:nrow(df.pho_diem_ngoai_ngu)) {
    #gan diem ngoai ngu o cot so 2 chia cho tong so hang roi nhan 100 de tinh ti so phan tram
    c = (df.pho_diem_ngoai_ngu[, 2][i] / nrow(df.raw)) * 100
    #gan ti so phan tram da tinh dc vao cot 3 ("percentage") va lam tron gia tri con chu so thap phan
    df.pho_diem_ngoai_ngu[, 3][i] = trunc(c * 10 ^ 4) / 10 ^ 4
  }
  #Xuat ra bang df.pho_diem_ngoai_ngu
  return(df.pho_diem_ngoai_ngu)
}

## Ham nay dung de kiem tra cac gia tri missing trong cac cot diem
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
  return(df.raw)
}

# Ham nay dung de tinh ra so thi sinh thi khoi KHTN va khoi KHXH
tu_nhien_vs_xa_hoi <- function(df) {
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
  print(paste("So thi sinh thi khoi XH: ", xh, " chiem ", trunc(((
    xh / n
  ) * 100) * 10 ^ 4) / 10 ^ 4))
  print(paste("So thi sinh thi khoi TN: ", tn, " chiem ", trunc(((
    tn / n
  ) * 100) * 10 ^ 4) / 10 ^ 4))
}

#Ham nay dung de gan ten tinh cho cac thi sinh giua tren Ma Tinh
gan_ten_tinh <- function(df) {
  #Import bang ten tinh
  df.tinh <-
    read.csv(
      link.dstinh
    )
  #Xoa cot dau tien cua bang ten tinh
  df.tinh = select(df.tinh, -1)
  #Ghep bang thi sinh voi bang ten tinh theo cot "Ma.Tinh"
  df<-merge(x = df, y = df.tinh, by = "Ma.Tinh")
  #Sap xep lai cot "Ma.Tinh" sau cot 14
  df = df[c(2:13,1,14)]
  return(df)
}
################################### End Function Island

#Khoi tao cac frame
df.raw = data.frame()
df.pho_diem_ngoai_ngu = data.frame()
df.thi_sinh_moi_tinh = data.frame()
df.thi_sinhvku_moi_tinh = data.frame()
df.trung_tuyen_vku = data.frame()

###################################

#import file dữ liệu
df.raw <-
  read.csv(link.diemthi)
#Show thong tin chung cua frame
str(df.raw)
#Kiem tra cac gia tri diem thi bi thieu
check_missing(df.raw)
#Thay cac gia tri bi thieu bang -1
df.raw <- handle_missing(df.raw, -1)
#Kiem tra lai cac gia tri diem thi bi thieu
check_missing(df.raw)

### Gan du lieu cho frame pho diem ngoai ngu
df.pho_diem_ngoai_ngu = pho_diem_ngoai_ngu(df.raw)

#### Them cot Ma.Tinh bang cac gia tri -1
df.raw['Ma.Tinh'] <- -1
### Xoa 6 ki tu sau cua cot "sbd" va gan cho cot Ma.Tinh
df.raw$Ma.Tinh <- gsub('.{6}$', '', df.raw$sbd)
## Gan Ten tinh cho bang thi sinh
df.raw = gan_ten_tinh(df.raw)
tb.thi_sinh_moi_tinh <- table(df.raw[names(df.raw)=="Ten.Tinh"])
df.thi_sinh_moi_tinh <- as.data.frame(tb.thi_sinh_moi_tinh)

#### Xet VKU
df.raw['Khoi.Thi'] <- NA
df.raw$Khoi.Thi <-
  ifelse(df.raw$Dia + df.raw$GDCD + df.raw$Su == -3, "TN", "XH")

df.raw = xet_vku_cntt(df.raw)

df.trung_tuyen_vku = filter(df.raw, Trung.Tuyen.VKU ==TRUE)

tb.thi_sinhvku_moi_tinh <- table(df.trung_tuyen_vku[names(df.trung_tuyen_vku)=="Ten.Tinh"])
df.thi_sinhvku_moi_tinh <- as.data.frame(tb.thi_sinhvku_moi_tinh)
######
tu_nhien_vs_xa_hoi(df.raw)


# View(df.raw)
# View(df.pho_diem_ngoai_ngu)
# View(df.thi_sinh_moi_tinh)
# View(df.thi_sinhvku_moi_tinh)
# View(df.trung_tuyen_vku)


