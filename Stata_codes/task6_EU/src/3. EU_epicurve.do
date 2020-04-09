* This Version: April 7, 2020
* First Version: April 3, 2020
* Author: Glenn Magerman

*----------------	
* 1. Top 10 cases	
*----------------
use "$task1/output/covid_cases_bycountry", clear
	keep if EU28 == 1 | country == "China"

// fraction of cases out of total
	bys country: egen tot_cases = total(cases)
	bys country: gen share_cases = cases/tot_cases*100
	bys country: gen lnshare_cases = ln(share_cases)
		
// moving average	
	xtset cty date
	egen lnma_share_cases = filter(lnshare_cases), lags(0/$MA) normalise	
	drop if share_cases < 0.001
	
// event: highest daily share (MA) = top, and t=0 	
	bys country: egen max = max(lnma_share_cases)
	bys country: gen top = (lnma_share_cases == max)
	bys country: gen count = _n
	fcollapse (min) count, by(top cty) merge
	by country: egen offset = max(min_count)
	gen event_time = count - offset
	drop top count min_count max

//sync events
	xtset cty event_time
	
// graph
	label var lnma_share_cases "% of total cases (${MA}-day MA)"
	label var event_time "Days relative to epidemic turning point"
	tsplot_epicurve lnma_share_cases cum_cases
	graph export "./output/EU_epicurve_cases.svg", replace 

*-----------------	
* 2. Top 10 deaths
*-----------------
use "$task1/output/covid_cases_bycountry", clear
	keep if EU28 == 1 | country == "China"
	
// fraction of cases out of total
	bys country: egen tot_deaths = total(deaths)
	bys country: gen share_deaths = deaths/tot_deaths*100
	bys country: gen lnshare_deaths = ln(share_deaths)
		
// moving average	
	xtset cty date
	egen lnma_share_deaths = filter(lnshare_deaths), lags(0/$MA) normalise	
	*drop if share_deaths < 0.001
	
	
// event: highest daily share (MA) = top, and t=0 	
	bys country: egen max = max(lnma_share_deaths)
	bys country: gen top = (lnma_share_deaths == max)
	bys country: gen count = _n
	fcollapse (min) count, by(top cty) merge
	by country: egen offset = max(min_count)
	gen event_time = count - offset
	drop top count min_count max

//sync events
	xtset cty event_time
	drop if event_time < -40
	
// graph
	label var lnma_share_deaths "% of total deaths (${MA}-day MA)"
	label var event_time "Days relative to epidemic turning point"
	tsplot_epicurve lnma_share_deaths cum_deaths
	graph export "./output/EU_epicurve_deaths.svg", replace 
	
