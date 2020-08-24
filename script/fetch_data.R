library(tidyverse)
library(lubridate)
library(DBI)
dir_data <- "data"
db_server <- dbConnect(odbc::odbc(), "iquizoo-v3")
raw_data <- dbGetQuery(
  db_server,
  read_file("sql/fetch_raw_data.sql")
) %>% 
  as_tibble()
raw_scores <- dbGetQuery(
  db_server,
  read_file("sql/fetch_raw_scores.sql")
) %>% 
  as_tibble()
dbDisconnect(db_server)
sub_names <- readxl::read_excel("assets/subjects.xlsx") %>% 
  pull(姓名)
for (sub_name in sub_names) {
  raw_data_user <- raw_data %>%
    filter(user_name == sub_name) %>% 
    mutate(
      order = game_time %>% 
        as_date() %>% 
        factor() %>% 
        as.integer()
    )
  assess_orders <- unique(raw_data_user$order)
  for (assess_order in assess_orders) {
    raw_data_list <- raw_data_user %>%
      filter(order == assess_order) %>% 
      select(game_name, game_data) %>%
      mutate(game_data = map(game_data, jsonlite::fromJSON)) %>%
      deframe()
    writexl::write_xlsx(
      raw_data_list,
      file.path(
        dir_data,
        str_c(sub_name, "-第", assess_order, "次", ".xlsx")
      )
    )
  }
}
raw_scores %>% 
  filter(user_name %in% sub_names) %>% 
  group_by(user_name) %>% 
  mutate(
    order = game_time %>% 
      as_date() %>% 
      factor() %>% 
      as.integer(),
    .before = game_time
  ) %>% 
  ungroup() %>% 
  arrange(user_name, game_name) %>% 
  writexl::write_xlsx(file.path(dir_data, "raw_scores.xlsx"))
