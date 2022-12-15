tab_pho_diem <- tabItem(tabName = "pho_diem",
box(title = "Phổ điểm theo từng môn",
                width = 16,
                color = "blue",
                selectInput(inputId =  "mon", choices = names(kq_thpt_fixed[,c('Li','Hoa','Sinh','Su','Dia','GDCD','Toan','Van', 'Ngoai_ngu')]),
                                label = "Chọn môn", selected = "Toan"),
                plotlyOutput("pho_diem"),
                )
)
