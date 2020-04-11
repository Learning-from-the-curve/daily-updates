* First Version: March 24, 2020
* This Version: April 2, 2020
* Author: Glenn Magerman

/*
- epidemic curve 1: PDF
- new cases/deaths per day by event time, match against China
- moving average
- absolute numbers and per million inhabitants
*/

local MA = 3

*-------------------------------
* 1. New cases, by date of onset
*-------------------------------
// load data
use "$task1/output/covid_cases_bycountry", clear
	merge m:1 country using "$task1/output/world_population_2020", ///
	nogen keep(match) keepusing(population)
	
// moving average	
	xtset cty date
	egen ma_cases = filter(cases), lags(0/`MA') normalise	
	gen lnma_cases = ln(ma_cases)

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
	
// graph (levels)
	foreach country in `countrylist' {
		local line `line' (tsline ma_cases ///
		if country == "`country'", recast(connected) lwidth(medthick))  ||
	}
	twoway `line', ///
	legend(on size(small) `legend') xoverhangs ///
	ysize(7) xsize(7) note("$ref_source" "$ref_data") ///
	title("Epicurve cases, top 10 world", size(medium)) ///
	ytitle("New cases (`MA'-day MA)") xtitle("Days since 100th case") 
	macro drop _line
	graph export "./output/global_epicurve_cases_pdf.svg", replace 
	
// graph (logs)
	foreach country in `countrylist' {
		local line `line' (tsline lnma_cases ///
		if country == "`country'", recast(connected) lwidth(medthick))  ||
	}
	twoway `line', ///
	legend(on size(small) `legend') xoverhangs ///
	ysize(7) xsize(7) note("$ref_source" "$ref_data") ///
	title("Epicurve cases, top 10 world", size(medium)) ///
	ytitle("New cases (`MA'-day MA)") xtitle("Days since 100th case")  ///
	ylab(4.6 "100" 6.9 "1,000" 9.2 "10,000" 11.5 "100,000")
	macro drop _line
	graph export "./output/global_epicurve_cases_logs_pdf.svg", replace 
	
*--------------------------------
* 2. New deaths, by date of onset
*--------------------------------
// load data
use "$task1/output/covid_cases_bycountry", clear
	merge m:1 country using "$task1/output/world_population_2020", ///
	nogen keep(match) keepusing(population)
	
// moving average	
	xtset cty date
	egen ma_deaths = filter(deaths), lags(0/`MA') normalise	
	gen lnma_deaths = ln(ma_deaths)

//sync events
	drop if cum_deaths < 100
	bys country: gen event_time = _n
	xtset cty event_time

// local with names of countries in top 10
	preserve
		qui su date
		local last_date = r(max)
		keep if date == `last_date'
		gsort - cum_deaths
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
	
// graph (levels)
	foreach country in `countrylist' {
		local line `line' (tsline ma_deaths ///
		if country == "`country'", recast(connected) lwidth(medthick))  ||
	}
	twoway `line', ///
	legend(on size(small) `legend') xoverhangs ///
	ysize(7) xsize(7) note("$ref_source" "$ref_data") ///
	title("Epicurve deaths, top 10 world", size(medium)) ///
	ytitle("New deaths (`MA'-day MA)") xtitle("Days since 100th death") 
	macro drop _line
	graph export "./output/global_epicurve_deaths_pdf.svg", replace 
	
// graph (logs)
	foreach country in `countrylist' {
		local line `line' (tsline lnma_deaths ///
		if country == "`country'", recast(connected) lwidth(medthick))  ||
	}
	twoway `line', ///
	legend(on size(small) `legend') xoverhangs ///
	ysize(7) xsize(7) note("$ref_source" "$ref_data") ///
	title("Epicurve deaths, top 10 world", size(medium)) ///
	ytitle("New deaths (`MA'-day MA)") xtitle("Days since 100th death")  ///
	ylab(2.3 "10" 4.6 "100" 6.9 "1,000" 9.2 "10,000")
	macro drop _line
	graph export "./output/global_epicurve_deaths_logs_pdf.svg", replace 
	
*-------------------------------------------
* 3. New cases per million, by date of onset
*-------------------------------------------
// load data
use "$task1/output/covid_cases_bycountry", clear
	merge m:1 country using "$task1/output/world_population_2020", ///
	nogen keep(match) keepusing(population)
	
// variables per million inhabitants	
	gen pop_perMln = population/1000000
	gen double cases_perMln = cases/pop_perMln
	gen double cum_cases_perMln = cum_cases/pop_perMln
	gen lncases_perMln  = ln(cases_perMln)	
	
// moving average	
	xtset cty date
	egen ma_cases_perMln = filter(cases_perMln), lags(0/`MA') normalise	
	gen lnma_cases_perMln = ln(ma_cases_perMln)

//sync events
	drop if cum_cases_perMln < 100
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
	
// graph (levels)
	foreach country in `countrylist' {
		local line `line' (tsline ma_cases_perMln ///
		if country == "`country'", recast(connected) lwidth(medthick))  ||
	}
	twoway `line', ///
	legend(on size(small) `legend') xoverhangs ///
	ysize(7) xsize(7) note("$ref_source" "$ref_data") ///
	title("Epicurve cases per mln population, top 10 world", size(medium)) ///
	ytitle("New cases per million (`MA'-day MA)") xtitle("Days since 100th case per million") 
	macro drop _line
	graph export "./output/global_epicurve_cases_perMln_pdf.svg", replace 
	
// graph (logs)
	foreach country in `countrylist' {
		local line `line' (tsline lnma_cases_perMln ///
		if country == "`country'", recast(connected) lwidth(medthick))  ||
	}
	twoway `line', ///
	legend(on size(small) `legend') xoverhangs ///
	ysize(7) xsize(7) note("$ref_source" "$ref_data") ///
	title("Epicurve cases per million, top 10 world", size(medium)) ///
	ytitle("New cases per million (`MA'-day MA)") xtitle("Days since 100th case per million") ///
	ylab(0 "1" 2.3 "10" 4.6 "100")
	macro drop _line
	graph export "./output/global_epicurve_cases_perMln_logs_pdf.svg", replace 
	
*--------------------------------------------
* 4. New deaths per million, by date of onset
*--------------------------------------------
// load data
use "$task1/output/covid_cases_bycountry", clear
	merge m:1 country using "$task1/output/world_population_2020", ///
	nogen keep(match) keepusing(population)
	
// variables per million inhabitants	
	gen pop_perMln = population/1000000
	gen double deaths_perMln = deaths/pop_perMln
	gen double cum_deaths_perMln = cum_deaths/pop_perMln
	gen lndeaths_perMln  = ln(deaths_perMln)		
	
// moving average	
	xtset cty date
	egen ma_deaths_perMln = filter(deaths_perMln), lags(0/`MA') normalise	
	gen lnma_deaths_perMln = ln(ma_deaths_perMln)

//sync events
	drop if cum_deaths_perMln < 10
	bys country: gen event_time = _n
	xtset cty event_time

// local with names of countries in top 10
	preserve
		qui su date
		local last_date = r(max)
		keep if date == `last_date'
		gsort - cum_deaths_perMln
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
	
// graph (levels)
	foreach country in `countrylist' {
		local line `line' (tsline ma_deaths_perMln ///
		if country == "`country'", recast(connected) lwidth(medthick))  ||
	}
	twoway `line', ///
	legend(on size(small) `legend') xoverhangs ///
	ysize(7) xsize(7) note("$ref_source" "$ref_data") ///
	title("Epicurve deaths per million, top 10 world", size(medium)) ///
	ytitle("New deaths per million (`MA'-day MA)") xtitle("Days since 10th death per million") 
	macro drop _line
	graph export "./output/global_epicurve_deaths_perMln_pdf.svg", replace 
	
// graph (logs)
	foreach country in `countrylist' {
		local line `line' (tsline lnma_deaths_perMln ///
		if country == "`country'", recast(connected) lwidth(medthick))  ||
	}
	twoway `line', ///
	legend(on size(small) `legend') xoverhangs ///
	ysize(7) xsize(7) note("$ref_source" "$ref_data") ///
	title("Epicurve deaths per million, top 10 world", size(medium)) ///
	ytitle("New deaths per million (`MA'-day MA)") xtitle("Days since 10th death per million")  ///
	ylab(0 "1" 2.3 "10" 4.6 "100")
	macro drop _line
	graph export "./output/global_epicurve_deaths_perMln_logs_pdf.svg", replace 	
		
	
