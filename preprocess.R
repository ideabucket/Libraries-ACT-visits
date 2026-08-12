library(assertthat)
library(tidyverse)
library(readxl)

raw_visits <- read_csv("libraries-act-visits-20240701-20260211.csv")
  
branch_locations <- read_csv("libraries-act-branches.csv")
standard_hours <- read_csv("libraries-act-hours-old-pattern.csv")
hours_exceptions <- read_csv("libraries-act-opening-exceptions-20240701-20260211.csv")

visits <- raw_visits |> mutate(
    Datetime = as.POSIXct(
      paste(as.Date(Date), format(Hour, "%H:%M:%S")),
      format = "%Y-%m-%d %H:%M:%S",
      # this will result in nonsense twice a year when daylight saving
      # starts/stops, but as those times are outside opening hours,
      # we don't care
      tz = "UTC"
    )
  ) |> select(Branch, Datetime, Date, Day, Visits)

data_coverage_dates <- visits |> 
  distinct(Branch, Day, Date = as_date(Datetime))

opening_hours <- data_coverage_dates |> 
  # create a row per date with the standard hours
  inner_join(standard_hours, by = join_by(Branch, Day)) |> 
  # remove any rows which have an exception
  anti_join(hours_exceptions, by = join_by(Branch, Date)) |>
  # make the columns identical so bind_rows() will work
  mutate(ReturnChutesOpen = TRUE, Reason = "") |> 
  # ingest the exception rows
  bind_rows(hours_exceptions) |> 
  # put the rows back into date order
  arrange(Date) |> 
  # make an Interval object out of the hours for easier comparison
  mutate(
    OpeningInterval = case_when(
      is.na(Open)  ~ NA,
      is.na(Close) ~ NA,
      .default = interval(
        start = as_datetime(
          paste(as.Date(Date), format(Open, "%H:%M:%S"))
        ),
        end = as_datetime(
          paste(as.Date(Date), format(Close, "%H:%M:%S"))
        # trim end of interval by one second to prevent interval overlaps    
        ) - seconds(1)
      )
    ), .before = Date
  )

# there should be exactly one row per (Date, Branch) combination
assert_that(
  nrow(opening_hours) == nrow(distinct(opening_hours, Date, Branch)),
  msg = "There appear to be one or more duplicate rows in opening_hours"
)

final_fact_table <- visits |> 
  left_join(opening_hours, by = join_by(Branch, Date), unmatched = "error") |> 
  mutate(
    ScheduledOpen = coalesce(Datetime %within% OpeningInterval, FALSE),
    .after = Branch
  ) |> 
  select(Branch, Datetime, Visits, ScheduledOpen, Reason)

final_fact_table |> write_csv("preprocessed_visits_data_20240701-20260211.csv")
