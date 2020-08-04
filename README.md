
# mpcadb

:electric\_plug: :floppy\_disk: Easy R connections to MPCA’s databases:
DELTA, TEMPO, EQUIS, RAPIDS, ONBASE.

## Functions

  - `open_delta` : Open a connection to *DELTAW*, MPCA’s oracle database
    that houses TEMPO, EQUIS, RAPIDS, ONBASE and more.
  - `get_ai` : Get all Agency Interest (AI) names from TEMPO.

## Install

Install `mpcadb` from GitHub:

``` r
# First install the 'devtools' package
library(devtools)

# Install the development pkg from GitHub
remotes::install_github("MPCA-data/mpcadb")
```

-----

## Use

Open an RODBC connection to DELTA with the `open_delta()` function. It
will add the credentials for you.

``` r
library(mpcadb)

# Open DELTA connection and set to `deltaw`
deltaw <- open_delta()
```

    ## Connection successful!

<br>

## TEMPO AI’s

Get a complete list of the Agency Interests from TEMPO with `get_ai()`:

``` r
ai_names <- get_ai(keep_alt_names = TRUE)

kable(head(ai_names, 4))
```

| MASTER\_AI\_ID | INT\_DOC\_ID | MASTER\_AI\_NAME                        | AI\_TYPE\_CODE | START\_DATE         | END\_DATE | ALTERNATE\_RECORD\_SEQUENCE | USER\_GROUP\_ID | ALTERNATE\_AI\_ID | ALTERNATE\_AI\_NAME                     | ALTERNATE\_AI\_TYPE\_CODE | START\_DATE\_ALT    | END\_DATE\_ALT | COMMENTS | PROGRAM\_CODE |
| -------------: | -----------: | :-------------------------------------- | :------------- | :------------------ | :-------- | --------------------------: | :-------------- | :---------------- | :-------------------------------------- | :------------------------ | :------------------ | :------------- | :------- | :------------ |
|           3462 |            0 | Hastings Bus Co                         | CON            | 1992-07-23 19:11:05 | NA        |                           1 | HW+             | MND981784622      | Hastings Bus Co                         | CON                       | 1999-07-28 14:25:32 | NA             | NA       | HW            |
|           2489 |            0 | 3M Alexandria                           | CON            | 1992-09-29 00:00:00 | NA        |                           1 | AQ+             | 04100003          | 3M - Alexandria                         | CON                       | 1995-07-11 10:21:24 | NA             | NA       | AQ            |
|           2492 |            0 | Chart Inc., New Prague                  | CON            | 1992-09-17 00:00:00 | NA        |                           1 | IS+             | MNR0539M2         | Chart Inc., New Prague                  | CON                       | 2014-09-22 11:57:53 | NA             | NA       | IS            |
|           2504 |            0 | Virginia Department of Public Utilities | CON            | 1995-07-07 09:28:44 | NA        |                           1 | AQ+             | 13700028          | Virginia Department of Public Utilities | CON                       | 1995-07-07 09:28:44 | NA             | NA       | AQ            |

<br>

Get only a select list of TEMPO AI’s:

``` r
ai_names <- get_ai(ai = c(441, 288), keep_alt_names = FALSE)

kable(ai_names)
```

| MASTER\_AI\_ID | INT\_DOC\_ID | MASTER\_AI\_NAME        | AI\_TYPE\_CODE | START\_DATE         | END\_DATE |
| -------------: | -----------: | :---------------------- | :------------- | :------------------ | :-------- |
|            288 |            0 | Mountain Iron WWTP      | CON            | 1991-12-05 00:00:00 | NA        |
|            441 |            0 | Bryan Rock Products Inc | MOB            | 1993-06-23 09:45:05 | NA        |

<br>

## EQUIS examples…

<br>
