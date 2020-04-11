* First Version: March 24, 2020
* This Version: March 30, 2020
* Author: Glenn Magerman

/* Latest updates: 
- updated color pallette (March 27, 2020)
- automate legend for auto-selected countries (March 27, 2020)
- try svg and html interactive output (March 27, 2020)
*/


*----------------------------------
* 1. Total deaths by country, top 10
*----------------------------------
// select countries
use "$task1/output/covid_cases_bycountry", clear
	qui su date
	local last_date = r(max)
	keep if date == `last_date'
	gsort -cum_deaths
	gen rank = _n	

// local with names of analyzed countries for graphs
	keep if rank <= $top_world
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

// globals for top 3 countries: country name and #cum_cases
	sort rank
	forvalues i = 1/3 {
		global n`i'_cumdeaths_country = "country[`i']"
		global n`i'_cumdeaths = cum_deaths[`i']
	}
	
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
	graph export "./output/cumdeaths_byday_global_top${top_world}.svg", replace 

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
	graph export "./output/cumdeaths_post10_global_top${top_world}.svg", replace 

*-----------------------------------------------	
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
	graph export "./output/cumdeaths_perMln_post10_global_top${top_world}.svg", replace 
			
