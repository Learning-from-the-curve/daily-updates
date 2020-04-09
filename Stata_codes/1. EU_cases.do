* This Version: April 7, 2020
* First Version: March 24, 2020
* Author: Glenn Magerman

*-----------------------------------
* 1. Total cases by country, by date
*-----------------------------------
// load data
use "$task1/output/covid_cases_bycountry", clear
	keep if EU28 == 1
	
// graph
	tsplot_date cum_cases cum_cases
	graph export "./output/EU_cumcases_bydate.svg", replace 
	
*---------------------------------
* 2. Total cases, by date of onset
*---------------------------------
// load data
use "$task1/output/covid_cases_bycountry", clear
	keep if EU28 == 1
	
//sync events
	drop if cum_cases < 100 
	bys country: gen event_time = _n
	xtset cty event_time

// graph
	label var event_time "Days since 100th case"
	tsplot_logs_cases lncum_cases lncum_cases
	graph export "./output/EU_lncumcases_post100.svg", replace 
	
*---------------------------------------
* 3. Growth rate cases, since 100th case
*---------------------------------------
// load data
use "$task1/output/covid_cases_bycountry", clear
	keep if EU28 == 1
	
// moving average	
	xtset cty date
	gen gr_cases = cases/l.cum_cases*100
	egen ma_cases = filter(gr_cases), lags(0/$MA) normalise
	drop if ma_cases > 100
	
//sync events
	drop if cum_cases < 100
	bys country: gen event_time = _n
	xtset cty event_time
	
// graph	
	label var ma_cases "Growth rate (%), ${MA}-day MA"
	label var event_time "Days since 100th case"
	tsplot_event ma_cases cum_cases
	graph export "./output/EU_growthcases_post100.svg", replace	
	
*--------------------------------------------
* 4. Total cases as a share of the population	
*--------------------------------------------
// load data
use "$task1/output/covid_cases_bycountry", clear
	merge m:1 country using "$task1/output/world_population_2020", ///
	nogen keep(match) keepusing(population)
	keep if EU28 == 1	

// shares
	gen sh_cases = cases/population*100
	bys country: gen double cum_sh_cases = sum(sh_cases)
	
//sync events
	drop if cum_sh_cases < 0.01
	bys country: gen event_time = _n
	xtset cty event_time
	
// graph	
	label var cum_sh_cases "% of the population infected"
	label var event_time "Days since 0.01% infection rate"
	tsplot_event cum_sh_cases cum_cases
	graph export "./output/EU_sh_cumcases.svg", replace 
			
