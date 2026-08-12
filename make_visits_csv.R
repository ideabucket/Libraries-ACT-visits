library(tidyverse)
library(readxl)

xlsx_temp <- tempfile(fileext = ".xlsx")

download.file(
  url = "https://www.cityservices.act.gov.au/__data/assets/excel_doc/0011/3111959/26-184-Records-Attachment-C.xlsx",
  destfile = xlsx_temp
)

read_xlsx(xlsx_temp) |> 
  mutate(
    Date = format(Date, "%Y-%m-%d"),
    Hour = format(Hour, "%H:%M:%S")
  ) |> relocate(Hour, .after = Date) |> 
  write_csv("data/libraries-act-visits-20240701-20260211.csv")