* First Version: March 24, 2020
* This Version: March 29, 2020
* Author: Glenn Magerman

/* Latest updates: 
- add statistics (March 29, 2020)
- automate choice of top_world (March 28, 2020)
- update color pallette (March 27, 2020)
- automate legend for auto-selected countries (March 27, 2020)
- try svg and html interactive output (March 27, 2020)
*/

*------------------------------------
* 1. World top x, number of new cases
*------------------------------------
use "$task1/output/covid_cases_bycountry", clear

// select top x	of today
	qui su date
	local last_date = r(max)
	keep if date == `last_date'
	gsort -cases
	gen rank = _n	
	keep if rank <= $top_world
	
// table: top x new cases today
	export delimited rank country cases using ///
	"./output/rank_new_cases_global_top${top_world}.csv", replace delim(",")
		
*------------------------------------------------
* 2. World top x, number of new cases per million
*------------------------------------------------		
use "$task1/output/covid_cases_bycountry", clear
	merge m:1 country using "$task1/output/world_population_2020", ///
	nogen keep(match) keepusing(population)

// variables per million inhabitants	
	gen pop_perMln = population/1000000
	gen double cases_perMln = cases/pop_perMln
	
// select top x	of today
	qui su date
	local last_date = r(max)
	keep if date == `last_date'
	gsort -cases_perMln
	gen rank = _n	
	keep if rank <= $top_world
	
// table: top 10 new cases today, per million inhabitants
	export delimited rank country cases_perMln population using ///
	"./output/rank_new_cases_perMln_global_top${top_world}.csv", replace delim(",")

*--------------------------
* 3. World top x, cum cases
*--------------------------
use "$task1/output/covid_cases_bycountry", clear

// select top x	of today
	qui su date
	local last_date = r(max)
	keep if date == `last_date'
	gsort -cum_cases
	gen rank = _n	
	keep if rank <= $top_world

// table with ncases for top global
	export delimited rank country cum_cases using ///
	"./output/rank_cum_cases_global_top${top_world}.csv", replace delim(",")
	
*--------------------------------------
* 4. World top x, cum cases per million
*--------------------------------------
use "$task1/output/covid_cases_bycountry", clear
	merge m:1 country using "$task1/output/world_population_2020", ///
	nogen keep(match) keepusing(population)

// variables per million inhabitants	
	gen pop_perMln = population/1000000
	gen double cum_cases_perMln = cum_cases/pop_perMln
	
// select top x	of today
	qui su date
	local last_date = r(max)
	keep if date == `last_date'
	gsort -cum_cases_perMln
	gen rank = _n	
	keep if rank <= $top_world

// table with ncases for top global
	export delimited rank country cum_cases_perMln using ///
	"./output/rank_cum_cases_perMln_global_top${top_world}.csv", replace delim(",")
		
*-------------------------------------------	
* 5. World top x, largest increase new cases (day on day)
*-------------------------------------------	
use "$task1/output/covid_cases_bycountry", clear
	xtset cty date
	by cty: gen d_cases = d.cases
	gen perc_change = round(d.cases/cases*100)
	
// select top x	of today
	qui su date
	local last_date = r(max)
	keep if date == `last_date'
	gsort -d_cases
	gen rank = _n	
	keep if rank <= $top_world

// table with ncases for top global
	export delimited rank country d_cases perc_change using ///
	"./output/rank_increase_cases_global_top${top_world}.csv", replace delim(",")
	
*-------------------------------------------	
* 6. World top x, largest decrease new cases (day on day)
*-------------------------------------------	
use "$task1/output/covid_cases_bycountry", clear
	xtset cty date
	by cty: gen d_cases = d.cases
	gen perc_change = round(d.cases/cases*100)
	
// select top x	of today
	qui su date
	local last_date = r(max)
	keep if date == `last_date'
	gsort d_cases
	gen rank = _n	
	keep if rank <= $top_world

// table with ncases for top global
	export delimited rank country d_cases perc_change using ///
	"./output/rank_decrease_cases_global_top${top_world}.csv", replace delim(",")
	
	
////////////////////////// OK TILL HERE /////////////////
///////// PERHAPS FIRST CONTINUE WITH PLOTS, THEN GROWTH RATES	
	
*-------------------------------------------
* 7. World top x, highest growth rates cases (dlnx)	
*-------------------------------------------	
use "$task1/output/covid_cases_bycountry", clear
	xtset cty date
	by cty: gen dln_cases = d.lncases
	
// select top x	of today
	qui su date
	local last_date = r(max)
	keep if date == `last_date'
	gsort -d_cases
	gen rank = _n	
	keep if rank <= $top_world

///////////////////////////////////////////////////////////
	
	
*-----------------------------
* 2. Cumulative cases, by date
*-----------------------------
use "$task1/output/covid_cases_bycountry", clear

// select top x	of today
	qui su date
	local last_date = r(max)
	keep if date == `last_date'
	gsort -cum_cases
	gen rank = _n	
	keep if rank <= $top_world

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
	graph export "./output/cumcases_byday_global_top${top_world}.svg", replace 

	/*
	gen hoverfacts = "Date: " + strofreal(date) + ", Cases:" + strofreal(cum_cases)
	d3, hovertip(hoverfacts) htmlfile("d3_html_test.html") locald3 replace:  ///
	scatter cum_cases date if country=="USA"
	*/	
	
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
	ysize(7) xsize(7) note("$ref_source" "$ref_data") ///
	title("Cumulative cases", size(medium)) ytitle("Number of cases") ///
	xtitle("Days since 100th case") 
	macro drop _line
	graph export "./output/cumcases_post100_global_top${top_world}.svg", replace 

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
	ysize(7) xsize(7) note("$ref_source" "$ref_data") ///
	title("Cumulative cases, per million inhabitants", size(medium)) ///
	ytitle("Number of cases, per million inhabitants") ///
	xtitle("Days since 100th case per million") 
	macro drop _line
	graph export "./output/cumcases_perMln_post100_global_top${top_world}.svg", replace 
	
clear	
	
