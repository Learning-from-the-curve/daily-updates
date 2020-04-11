* This Version: April 3, 2020
* First Version: April 1, 2020
* Author: Glenn Magerman

*-----------------------------------------
* 1. Global total cases, deaths, countries
*-----------------------------------------
use "$task1/output/covid_cases_bycountry", clear
	qui su date
	local last_date = r(max)
	keep if date == `last_date'
	drop if cum_cases == 0
	distinct country
	
// numbers in report: total cases, total deaths, total countries
	global global_cumcountries = r(ndistinct)			
	egen total_cumcases = total(cum_cases)
	global global_cumcases = total_cumcases
	egen total_cumdeaths = total(cum_deaths)
	global global_cumdeaths = total_cumdeaths

// numbers in report: new cases, new deaths
	egen total_newcases = total(cases)
	global global_newcases = total_newcases
	egen total_newdeaths = total(deaths)
	global global_newdeaths = total_newdeaths
