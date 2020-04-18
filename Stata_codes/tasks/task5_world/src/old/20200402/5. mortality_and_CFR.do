* First Version: March 24, 2020
* This Version: April 2, 2020
* Author: Glenn Magerman

/*
- mortality rates and case fatality rates, match against China
- moving average
*/

local MA 3

*---------------------------------------------	
* 1. Evolution of mortality rate in population	
*---------------------------------------------
// load data
use "$task1/output/covid_cases_bycountry", clear
	merge m:1 country using "$task1/output/world_population_2020", ///
	nogen keep(match) keepusing(population)

// mortality rate by date
	gen share_death = cum_deaths/population*100	
	
// moving average	
	egen ma_share_death = filter(share_death), lags(0/`MA') normalise	
	
//sync events
	drop if cum_deaths < 10
	bys country: gen event_time = _n
	xtset cty event_time

// local with names of countries in top 10
	preserve
		qui su date
		local last_date = r(max)
		keep if date == `last_date'
		gsort -share_death
		keep in 1/$top_EU
		sort country
		levelsof country, local(countrylist)
		local nvar = r(N)
		forvalues i = 1/`nvar' {
			local l`i' = "lab(`i' `=country[`i']')"
		}
		forvalues i = 1/`nvar' {
			local legend `legend' `l`i''
		}
	restore

// graph (levels)
	foreach country in `countrylist' {
		local line `line' (tsline ma_share_death ///
		if country == "`country'", recast(connected) lwidth(medthick))  ||
	}
	twoway `line', ///
	legend(on size(small) `legend') xoverhangs ///
	ysize(7) xsize(7) note("$ref_source" "$ref_data") ///
	title("Estimated mortality in population", size(medium)) ///
	ytitle("`MA'-day moving average (%)") xtitle("") xtitle("Days since 10th death")
	macro drop _line
	graph export "./output/global_top10_sharemortality_post10.svg", replace 
	
*--------------------------------	
* 7. Evolution case/fatality rate 	
*--------------------------------	
// load data
use "$task1/output/covid_cases_bycountry", clear
	merge m:1 country using "$task1/output/world_population_2020", ///
	nogen keep(match) keepusing(population)

// case fatality rate by date
	gen CFR = cum_death/cum_cases*100	
	
// moving average	
	egen ma_CFR = filter(CFR), lags(0/`MA') normalise	

//sync events
	drop if cum_deaths < 10
	bys country: gen event_time = _n
	xtset cty event_time

// local with names of countries in top 10
	preserve
		qui su date
		local last_date = r(max)
		keep if date == `last_date'
		gsort -CFR
		keep in 1/$top_EU
		sort country
		levelsof country, local(countrylist)
		local nvar = r(N)
		forvalues i = 1/`nvar' {
			local l`i' = "lab(`i' `=country[`i']')"
		}
		forvalues i = 1/`nvar' {
			local legend `legend' `l`i''
		}
	restore

// graph (levels)
	foreach country in `countrylist' {
		local line `line' (tsline ma_CFR ///
		if country == "`country'", recast(connected) lwidth(medthick))  ||
	}
	twoway `line', ///
	legend(on size(small) `legend') xoverhangs ///
	ysize(7) xsize(7) note("$ref_source" "$ref_data") ///
	title("Estimated case fatality rate", size(medium)) ///
	ytitle("`MA'-day moving average (%)") xtitle("") xtitle("Days since 10th death")
	macro drop _line
	graph export "./output/global_top10_CFR_post10.svg", replace 
	
