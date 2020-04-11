* First Version: March 24, 2020
* This Version: March 27, 2020
* Author: Glenn Magerman

*------------------
* 1. Daily cases EU
*------------------
// select countries
use "$task1/output/covid_cases_bycountry", clear
	keep if EU28 == 1
	qui su date
	local last_date = r(max)
	keep if date == `last_date'
	gsort -cum_cases
	gen rank = _n	
	keep if rank <= $top_EU
	
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

// table with ncases for top EU28	
	sort rank
	export delimited rank country cum_cases ///
	using "./output/rank_cases_EU28_top${top_EU}.csv", replace delim(",")
	
*-----------------------------
* 2. Cumulative cases, by date
*-----------------------------
use "$task1/output/covid_cases_bycountry", clear
foreach country in `countrylist' {
		local line `line' (tsline cum_cases ///
		if country == "`country'", recast(connected) lwidth(medthick))  ||
	}
	twoway `line', ///
	legend(on size(small) `legend') xoverhangs ///
	tlabel(, format(%tdmd)) ysize(7) xsize(7) note("$ref_source" "$ref_data") ///
	title("Cumulative cases", size(medium)) ytitle("Number of cases") 
	macro drop _line
	graph export "./output/cumcases_byday_EU28_top${top_EU}.svg", replace 
	
*---------------------------------	
* 3. Cumul cases, since 100th case	
*---------------------------------
use "$task1/output/covid_cases_bycountry", clear
//sync events
	drop if cum_cases < 100
	bys country: gen event_time = _n
	xtset cty event_time

// graph
	foreach country in `countrylist' {
		local line `line' (tsline cum_cases ///
		if country == "`country'", recast(connected) lwidth(medthick))  ||
	}
	twoway `line', ///
	legend(on size(small) `legend') xoverhangs ///
	tlabel(, format(%tdmd)) ysize(7) xsize(7) note("$ref_source" "$ref_data") ///
	title("Cumulative cases", size(medium)) ytitle("Number of cases") ///
	xtitle("Days since 100th case") 
	macro drop _line 
	graph export "./output/cumcases_post100_EU28_top${top_EU}.svg", replace 

*----------------------------------------------	
* 4. Cumul cases, since 100th case, per million	
*----------------------------------------------
// load data
use "$task1/output/covid_cases_bycountry", clear
	merge m:1 country using "$task1/output/world_population_2020", ///
	nogen keep(match) keepusing(population)

// variables per million inhabitants	
	gen pop_perMln = population/1000000
	gen double cases_perMln = cases/pop_perMln
	
// cumulative cases	
	bys country: gen double cum_cases_perMln = sum(cases_perMln)
	
//sync events
	drop if cum_cases_perMln < 100
	bys country: gen event_time = _n
	xtset cty event_time

// graph
	foreach country in `countrylist' {
		local line `line' (tsline cum_cases_perMln ///
		if country == "`country'", recast(connected) lwidth(medthick))  ||
	}
	twoway `line', ///
	legend(on size(small) `legend') xoverhangs ///
	tlabel(, format(%tdmd)) ysize(7) xsize(7) note("$ref_source" "$ref_data") ///
	title("Cumulative cases, per million inhabitants", size(medium)) ///
	ytitle("Number of cases, per million inhabitants") ///
	xtitle("Days since 100th case per million") 
	macro drop _line
	graph export "./output/cumcases_perMln_post100_EU28_top${top_EU}.svg", replace 
