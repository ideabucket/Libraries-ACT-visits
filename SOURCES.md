Notes on data sources and preprocessing
=======================================

None of the files in this dataset were readily, cleanly available. Here are some notes on how I built them.

`libraries-act-visits-20240701-20260211.csv`
--------------------------------------------
The main data. CSV generated from the Excel file supplied in response to [FOI request 26-184][foi]. The code which does the conversion can be found in [`make_visits_csv.R`][csvR].

[foi]: https://www.cityservices.act.gov.au/about-us/freedom_of_information/disclosure-log/ced-2026/foi-disclosure-log-26-184
[csvR]: make_visits_csv.R


`libraries-act-branches.csv`
----------------------------
Compiled by hand. Addresses and coordinates are mostly derived from the [ACTGOV ADDRESSES][addr] dataset published in the [ACT Government geospatial data catalogue][geocat], but not all library buildings (e.g. Civic) have official street addresses, and/or the coordinates may not sensibly locate the library within a larger building, so some editorial adjustments have been made.

The classification of branch types is taken from the [Ministerial brief about the new hours][min] (paragraph 9). The way it is used suggests it is a common way of grouping the branches within Libraries ACT, but that's a guess on my part.

[addr]: https://actmapi-actgov.opendata.arcgis.com/datasets/13427dc77da340a29dd6601af4d7484d_0/explore
[geocat]: https://actmapi-actgov.opendata.arcgis.com/
[min]: https://www.cityservices.act.gov.au/__data/assets/pdf_file/0003/3111960/26-184-Records-Attachment-D.pdf

`libraries-act-hours-new-pattern.csv`
-------------------------------------
These are the new standard opening hours which will commence on 27 August 2026. The table was compiled by hand based on the [Libraries ACT news item about the new hours][newhours] (live at time of writing, no archive link available).

[newhours]:https://www.library.act.gov.au/whats-new/news-and-events/july-2026/libraries-act-adjusted-opening-hours

`libraries-act-hours-old-pattern.csv`
-------------------------------------
These are the standard opening hours up until 27 August 2026. The table was compiled from the [opening hours on the Libraries ACT website][oldhours] (live at time of writing; also [preserved in the Wayback Machine][oldhours_ia]).

[oldhours]: https://www.library.act.gov.au/find-us
[oldhours_ia]: https://web.archive.org/web/20260702185157/https://www.library.act.gov.au/find-us

`libraries-act-opening-exceptions-20240701-20260211.csv`
--------------------------------------------------------
The design principle for this file is that it should contain information about every _scheduled_ exception to standard opening hours—not unplanned closures due to staff shortages, etc.—for the period covered by the main data file. **It is almost certainly incomplete**. There is no public single source of information about all changes to library opening hours for the covered period, so I have had to compile it from multiple sources:

- Information about the 2025–6 end-of-year closedown and 2025–6 summer hours comes from the [ACT Government service availability page][avail].
- Information about 2026 public holidays comes from the live version of the [Libraries ACT opening hours][oldhours] page.
- Information about (most) 2025 public holidays comes from a Wayback Machine [archive of the opening hours page][hours25] from March 2025.
- Information about the 2025 summer hours comes from a Wayback Machine [archive of a news item][summer24] announcing the changes.
- Information about the extended closure of the Woden branch in 2024 comes from a [ministerial release][woden24].
- Information about the closure of the Dickson branch for toilet upgrades in 2025 comes from [another ministerial release][dickson25]

This is just what I could turn up in a sane amount of time. I am quite sure other planned closures occured (there is evidence to suggest at least one one-day closure for a systems upgrade) but I have only added things for which I could find evidence. I have asked City Services if they can give me access to better data.

[avail]: https://www.act.gov.au/service-availability#Libraries-ACT
[hours25]: https://web.archive.org/web/20250306110325/https://www.library.act.gov.au/find-us
[summer24]: https://web.archive.org/web/20250108155725/https://www.library.act.gov.au/whats-new/whats-new-items/december-2024/new-summer-operating-hours
[woden24]: https://www.cmtedd.act.gov.au/open_government/inform/act_government_media_releases/act-transport-canberra-and-city-services-media-releases/2024/upgraded-woden-library-to-reopen-18-november
[dickson25]: https://www.cmtedd.act.gov.au/open_government/inform/act_government_media_releases/act-transport-canberra-and-city-services-media-releases/2025/reminder-of-dickson-library-toilet-upgrade-planned-branch-closure-from-next-week

`preprocessed_visits_data_20240701-20260211.csv`
------------------------------------------------
Materialised fact table—takes the visits data from the FOI request and adds columns denoting whether the library was, on available information, scheduled to be open, and if the hours are nonstandard, the reason why. The output of  [`preprocess.R`][pR]. This is the table to be used for visualisations and analysis.

[pR]: preprocess.R
