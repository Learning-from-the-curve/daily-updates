* First Version: April 1, 2020
* This Version: April 1, 2020
* Author: Glenn Magerman

*---------------------------------------
* 1. EU28 total cases, deaths, countries
*---------------------------------------
use "$task1/output/covid_cases_bycountry", clear

// keep EU28 countries
	keep if EU28 == 1
	qui su date
	local last_date = r(max)
	keep if date == `last_date'
	drop if cum_cases == 0
	distinct country
	
// numbers in report: ncountries, ncases, ndeaths	
	global ncountries_EU28 = r(ndistinct)			
	egen grand_total_cases = total(cum_cases)
	global ncases_EU28 = grand_total_cases
	egen grand_total_deaths = total(cum_deaths)
	global ndeaths_EU28 = grand_total_deaths
