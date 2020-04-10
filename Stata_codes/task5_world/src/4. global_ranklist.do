* This Version: April 8, 2020
* First Version: April 8, 2020
* Author: Glenn Magerman

*---------
* 1. Cases
*---------
use "$task1/output/covid_cases_bycountry", clear
	xtset cty date
	
// ncases (cum_cases), change with yesterday nrs (cases) and % (pct_cases)	
	gen pct_cases = round(cases/l.cum_cases*100, .01)

// pick last date	
	qui su date
	keep if date == r(max)

// sort on cases	
	gsort -cum_cases
	gen rank = _n
	
// table
	ren (cum_cases cases pct_cases) (total new change)
	outsheet rank country total new change ///
	using "./output/world_cases_ranklist.csv", replace comma
	
*----------
* 2. Deaths
*----------
use "$task1/output/covid_cases_bycountry", clear
	xtset cty date
	gen pct_deaths = round(deaths/l.cum_deaths*100, .01)

// pick last date	
	qui su date
	keep if date == r(max)

// sort on cases	
	gsort -cum_deaths
	gen rank = _n
	
// table
	ren (cum_deaths deaths pct_deaths) (total new change)
	outsheet rank country total new change ///
	using "./output/world_deaths_ranklist.csv", replace comma	
