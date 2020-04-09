* This Version: April 7, 2020
* First Version: March 24, 2020
* Author: Glenn Magerman

*------------------------------------
* 1. Total deaths by country, by date
*------------------------------------
// load data
use "$task1/output/covid_cases_bycountry", clear
	
// graph
	tsplot_date cum_deaths cum_deaths
	graph export "./output/global_cumdeaths_bydate.svg", replace 
	
*---------------------------------
* 2. Total deaths by date of onset
*---------------------------------
// load data
use "$task1/output/covid_cases_bycountry", clear
	
//sync events
	drop if cum_deaths < 10
	bys country: gen event_time = _n
	xtset cty event_time
	
// graph
	label var event_time "Days since 10th death"
	tsplot_logs_deaths lncum_deaths lncum_deaths 
	graph export "./output/global_lncumdeaths_post10.svg", replace 
	
*----------------------------------------
* 3. Growth rate deaths, since 10th death
*----------------------------------------
// load data
use "$task1/output/covid_cases_bycountry", clear

// moving average	
	xtset cty date
	gen gr_deaths = deaths/l.cum_deaths*100
	egen ma_deaths = filter(gr_deaths), lags(0/$MA) normalise	
	drop if ma_deaths > 100

	
//sync events
	drop if cum_deaths < 10
	bys country: gen event_time = _n
	xtset cty event_time
	
// graph	
	label var ma_deaths "Growth rate (%), ${MA}-day MA"
	label var event_time "Days since 10th death"
	tsplot_event ma_deaths cum_deaths
	graph export "./output/global_growthdeaths_post10.svg", replace		
	
*---------------------------------------------
* 4. Total deaths as a share of the population
*---------------------------------------------
// load data
use "$task1/output/covid_cases_bycountry", clear
	merge m:1 country using "$task1/output/world_population_2020", ///
	nogen keep(match) keepusing(population)

// shares
	gen sh_deaths = deaths/population*100
	bys country: gen double cum_sh_deaths = sum(sh_deaths)
	
//sync events
	drop if cum_sh_deaths < 0.001
	bys country: gen event_time = _n
	xtset cty event_time
	
// graph	
	label var cum_sh_deaths "% of the population deceased"
	label var event_time "Days since 0.001% mortality rate"
	tsplot_event cum_sh_deaths cum_deaths
	graph export "./output/global_sh_cumdeaths.svg", replace 
