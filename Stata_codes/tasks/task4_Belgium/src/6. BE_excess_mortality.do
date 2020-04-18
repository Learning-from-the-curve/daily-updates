* This version: April 17, 2020
* First version: April 17, 2020
* Author: Glenn Magerman

*----------------
* 1. COVID deaths	
*----------------
use "$task1/output/Belgium_MORT", clear
	collapse (sum) covid = deaths, by(date)	
	tsset date
	egen ma_covid = filter(covid), lags(0/7) normalise  // 30day MA
	gen doy = _n
	gen day = day(date)
	*gen week = week(date)
	gen month = month(date)
	drop if _n == _N | _n == _N - 1
save "./tmp/covid_deaths", replace

*-----------------------------------------
* 2. Average deaths by day/week last years
*-----------------------------------------
// load data
use "$task1/output/Belgium_deaths_bydate", clear
	tsset date
	
// moving average	
	egen ma_deaths = filter(deaths), lags(0/7) normalise  // 30day MA
	tsline deaths ma_deaths

// extract time components	
	gen day = day(date)
	*gen week = week(date)
	gen month = month(date)
	*egen day_month = group(day month)	
	gen year = year(date)
	bys year: gen doy = _n
	
// use avg of some years for expected mortality
	drop if day == 29 & month == 2
	keep if year >= 2015 & year <= 2017
	collapse (mean) deaths ma_deaths (last) date, by(day month)
	merge 1:1 day month using "./tmp/covid_deaths", nogen
	tsset date
	tsline deaths ma_deaths covid ma_covid, tlabel(, format(%tdmd)) ///
	xtitle("") ytitle("Daily mortality")
	graph export "./output/excess_mortality_avgyears.svg", replace
	
	
