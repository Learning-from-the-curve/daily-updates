* First Version: March 28, 2020
* This Version: March 28, 2020
* Author: Glenn Magerman

*----------------------------------------
* 1. Select Belgium + reference countries
*----------------------------------------
use "$task1/output/covid_cases_bycountry", clear
	keep if country == "Belgium"  | country == "Italy"
	qui su date
	local last_date = r(max)
	keep if date == `last_date'
	
// create local with names of analyzed countries 
	sort country
	levelsof country, local(countrylist)
	local nvar = r(N)
	forvalues i = 1/`nvar' {
		local l`i' = "lab(`i' `=country[`i']')"
	}
	forvalues i = 1/`nvar' {
		local legend `legend' `l`i''
	}
	di "`legend'"

// table with ndeaths for Belgium	
	export delimited country cum_deaths ///
	using "./output/rank_deaths_Belgium.csv", replace delim(",")

*------------------------------	
* 2. Cumulative deaths, by date
*------------------------------
use "$task1/output/covid_cases_bycountry", clear
	foreach country in `countrylist' {
		local line `line' (tsline cum_deaths ///
		if country == "`country'", recast(connected) lwidth(medthick))  ||
	}
	twoway `line', ///
	legend(on size(small) `legend') xoverhangs ///
	tlabel(, format(%tdmd)) ysize(7) xsize(7) note("$ref_source" "$ref_data") ///
	title("Cumulative deaths", size(medium)) ///
	ytitle("Number of deaths")
	macro drop _line
	graph export "./output/cumdeaths_byday_Belgium.svg", replace 
	
*----------------------------------	
* 3. Cumul deaths, since 10th death
*----------------------------------	
use "$task1/output/covid_cases_bycountry", clear
//sync events
	drop if cum_deaths < 10
	bys country: gen event_time = _n
	xtset cty event_time
	
// graph
	foreach country in `countrylist' {
		local line `line' (tsline cum_deaths ///
		if country == "`country'", recast(connected) lwidth(medthick))  ||
	}
	twoway `line', ///
	legend(on size(small) `legend') xoverhangs ///
	tlabel(, format(%tdmd)) ysize(7) xsize(7) note("$ref_source" "$ref_data") ///
	title("Cumulative deaths") ytitle(Number of deaths) ///
	xtitle("Days since 10th death") 
	macro drop _line
	graph export "./output/cumdeaths_post10_Belgium.svg", replace 

*----------------------------------------------	-
* 4. Cumul deaths, since 10th death, per million		
*-----------------------------------------------
// load data
use "$task1/output/covid_cases_bycountry", clear
	merge m:1 country using "$task1/output/world_population_2020", ///
	nogen keep(match) keepusing(population)

// variables per million inhabitants	
	gen pop_perMln = population/1000000
	gen double deaths_perMln = deaths/pop_perMln
	
// cumulative cases	
	bys country: gen double cum_deaths_perMln = sum(deaths_perMln)
	
//sync events
	drop if cum_deaths_perMln < 10
	bys country: gen event_time = _n
	xtset cty event_time
	
// graph
	foreach country in `countrylist' {
		local line `line' (tsline cum_deaths_perMln ///
		if country == "`country'", recast(connected) lwidth(medthick))  ||
	}
	twoway `line', ///
	legend(on size(small) `legend') xoverhangs ///
	tlabel(, format(%tdmd)) ysize(7) xsize(7) note("$ref_source" "$ref_data") ///
	title("Cumulative deaths, per million inhabitants") ///
	ytitle("Number of deaths, per million inhabitants") ///
	xtitle("Days since 10th death per million") 
	macro drop _line
	graph export "./output/cumcases_perMln_post100_Belgium.svg", replace 
	
