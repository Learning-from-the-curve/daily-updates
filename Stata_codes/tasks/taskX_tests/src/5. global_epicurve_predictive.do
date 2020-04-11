* This Version: April 5, 2020
* First Version: April 3, 2020
* Author: Glenn Magerman

local MA = 3


	/*
	twoway (line lnshare_cases event_time, yaxis(1)) ///
	(line ma_gr_cases event_time, yaxis(2))  
	*/
	
*-----------------------------------
* 1. growth rates and polynomial fit
*-----------------------------------
use "$task1/output/covid_cases_bycountry", clear
	keep if country == "China" 
	
// moving average	
	xtset cty date
	gen gr_cases = cases/cum_cases*100
	egen ma_cases = filter(gr_cases), lags(0/3) normalise
	
//sync events
	drop if cum_cases < 100
	bys country: gen event_time = _n
	xtset cty event_time

// firt 4th degree polynomial

	fp ma_cases
	
	
	pfit ma_cases event_time, estopts(degree(4))	
// forecast



	tsset event_time
	
	forecast create, replace
	var ma_cases, lags(1/3)
	forecast estimates var_lag5
	tsappend, add(200)
	 forecast solve, prefix(fc5) begin(78) end(200)
	
// graph	
*twoway (tsline ma_cases) (fpfit ma_cases event_time, estopts(degree(4)))	
	twoway (tsline fc5ma_cases) 
	(fpfit ma_cases event_time, estopts(degree(4)))	
////////////////////////////////////////////////////////////////////////	
*---------------------------------------
* 4. Growth rate cases, since 100th case
*---------------------------------------
// load data
use "$task1/output/covid_cases_bycountry", clear
	merge m:1 country using "$task1/output/world_population_2020", ///
	nogen keep(match) keepusing(population)
	
// moving average	
	xtset cty date
	gen gr_cases = cases/cum_cases*100
	egen ma_cases = filter(gr_cases), lags(0/3) normalise
	
//sync events
	drop if cum_cases < 100
	bys country: gen event_time = _n
	xtset cty event_time
	
// local with names of countries in top 10
	preserve
		qui su date
		local last_date = r(max)
		keep if date == `last_date'
		gsort -cum_cases
		keep in 1/$top_world
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
	
// graph
	foreach country in `countrylist' {
		local line `line' (tsline ma_cases ///
		if country == "`country'", recast(connected) lwidth(medthick))  ||
	}
	twoway `line', ///
	legend(on size(small) `legend') xoverhangs ylab(0(10)50) ///
	ysize(7) xsize(7) note("$ref_source" "$ref_data") ///
	title("Growth rate", size(medium)) ///
	ytitle("growth rate (%), 3-day MA") ///
	xtitle("Days since 100th case") 
	macro drop _line
	graph export "./output/global_growthcases_post100.svg", replace	
	
*---------------------------------	
* 1. China epicurve + growth rates	
*---------------------------------
use "$task1/output/covid_cases_bycountry", clear
	keep if country == "China" 
	
// fraction of cases out of total
	egen tot_cases = total(cases)
	gen share_cases = cases/tot_cases*100
	gen lnshare_cases = ln(share_cases)
	
// growth rate
	xtset cty date
	gen gr_cases = cases/cum_cases*100	

// moving average	
	egen lnma_share_cases = filter(lnshare_cases), lags(0/`MA') normalise	
	egen ma_gr_cases = filter(gr_cases), lags(0/`MA') normalise	

	
	drop if share_cases < 0.001
// event: highest daily share (MA) = top, and t=0 	
	bys country: egen max = max(lnma_share_cases)
	gen top = (lnma_share_cases == max)
	gen count = _n
	fcollapse (min) count, by(top) merge
	qui su min_count
	local offset = `r(max)'
	gen event_time = count - `offset' 
	drop top count min_count max

//sync events
	xtset cty event_time
	
// graph	
	twoway (line lnshare_cases event_time, yaxis(1)) ///
	(line ma_gr_cases event_time, yaxis(2))  
	
*---------------------------------------
* 4. Growth rate cases, since 100th case
*---------------------------------------
// load data
use "$task1/output/covid_cases_bycountry", clear
	merge m:1 country using "$task1/output/world_population_2020", ///
	nogen keep(match) keepusing(population)
	
// moving average	
	xtset cty date
	gen gr_cases = cases/cum_cases*100
	*gen gr_cases = lncases - l.lncases
	egen ma_cases = filter(gr_cases), lags(0/3) normalise
	
//sync events
	drop if cum_cases < 100
	bys country: gen event_time = _n
	xtset cty event_time
	
// local with names of countries in top 10
	preserve
		qui su date
		local last_date = r(max)
		keep if date == `last_date'
		gsort -cum_cases
		keep in 1/$top_world
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
	
// graph
	foreach country in `countrylist' {
		local line `line' (tsline ma_cases ///
		if country == "`country'", recast(connected) lwidth(medthick))  ||
	}
	twoway `line', ///
	legend(on size(small) `legend') xoverhangs ylab(0(10)50) ///
	ysize(7) xsize(7) note("$ref_source" "$ref_data") ///
	title("Growth rate", size(medium)) ///
	ytitle("growth rate (%), 3-day MA") ///
	xtitle("Days since 100th case") 
	macro drop _line
	graph export "./output/global_growthcases_post100.svg", replace	

	
	* This Version: April 3, 2020
* First Version: April 3, 2020
* Author: Glenn Magerman

local MA = 3

*---------
* 1. China
*---------

	
*----------------	
* 2. top 10 cases
*----------------
use "$task1/output/covid_cases_bycountry", clear
	
// fraction of cases out of total
	bys country: egen tot_cases = total(cases)
	bys country: gen share_cases = cases/tot_cases*100
	bys country: gen lnshare_cases = ln(share_cases)
		
// moving average	
	xtset cty date
	egen lnma_share_cases = filter(lnshare_cases), lags(0/`MA') normalise	
	
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
	
// local with names of countries in top 10
	preserve
		qui su date
		local last_date = r(max)
		keep if date == `last_date'
		gsort -cum_cases
		keep in 1/$top_world
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

// graph (logs)
	foreach country in `countrylist' {
		local line `line' (tsline lnma_share_cases ///
		if country == "`country'", recast(connected) lwidth(medthick))  ||
	}
	twoway `line', ///
	legend(on size(small) `legend') xoverhangs ///
	ysize(7) xsize(7) note("$ref_source" "$ref_data") ///
	title("Epicurve cases, top 10 world", size(medium)) ///
	ytitle("% of total cases (`MA'-day MA)") xtitle("Days relative to epidemic midpoint") ///
	ylab(-6.9 "10{sup:-3}" -4.6 "10{sup:-2}" -2.3 "10{sup:-1}" 0 "10{sup:0}" 2.3 "10{sup:1}")
	macro drop _line
	graph export "./output/global_epicurve_cases.svg", replace 
	

