tab_general <- tabItem(tabName = "general",
        fluidRow(
          box(title = "Số thí sinh",
              title_side = "top left",
              value_box("",
                        nrow(movies),
                        color = "blue",
                        size = "huge"),
              value_box("Khoa học Tự nhiên",1111,
                        color = "teal", size = "small"),
              value_box("Khoa học xã hội",12123,
                        color = "teal", size = "small")
          ),
          column(width = 7,
                 box(title = "Years",
                     value_box("From year", min(movies$title_year),
                               color = "teal",
                               size = "tiny"),
                     value_box("To year", max(movies$title_year),
                               color = "teal",
                               size = "tiny")),
                 box(title = "Rankings",
                     value_box("Best film overall",
                               movies$movie_title[(which.max(movies$imdb_score))],
                               color = "teal",
                               size = "tiny"),
                     value_box("Worst film overall",
                               movies$movie_title[(which.min(movies$imdb_score))],
                               color = "teal",
                               size = "tiny"),
                     value_box("Highest gross",
                               movies$movie_title[(which.max(movies$gross))],
                               color = "olive",
                               size = "tiny")
                 )
          )
        )
)