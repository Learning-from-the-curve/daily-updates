* First Version: March 24, 2020
* This Version: April 2, 2020
* Author: Glenn Magerman

/*
- total cases by country, as of today
- total cases by country, by date
- total cases by country, since 100th case
- total cases per million by country, since 100th case per million
- growth rate cases by country, since 100th case
- evolution share infected population by country
*/

*---------------------------------
* 1. Total cases by country, today
*---------------------------------
// select countries
use "$task1/output/covid_cases_bycountry", clear
	qui su date
	local last_date = r(max)
	keep if date == `last_date'

// numbers in report: top 3 with numbers
	gsort -cum_cases
	forvalues i = 1/3 {
		global n`i'_country_cumcases_global = "country[`i']"
		global n`i'_ncumcases_global = cum_cases[`i']
	}
	
*-----------------------------------
* 2. Total cases by country, by date
*-----------------------------------
// local with names of countries in top 10
use "$task1/output/covid_cases_bycountry", clear
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

// graph (levels)
use "$task1/output/covid_cases_bycountry", clear
	foreach country in `countrylist' {
		local line `line' (tsline cum_cases ///
		if country == "`country'", recast(connected) lwidth(medthick))  ||
	}
	twoway `line', ///
	legend(on size(small) `legend') xoverhangs ///
	tlabel(, format(%tdmd)) ysize(7) xsize(7) note("$ref_source" "$ref_data") ///
	title("Total cases", size(medium)) ytitle("Number of cases") xtitle("") 
	macro drop _line
	graph export "./output/global_top${top_world}_cumcases_bydate.svg", replace 

// graph (logs)
	foreach country in `countrylist' {
		local line `line' (tsline lncum_cases ///
		if country == "`country'", recast(connected) lwidth(medthick))  ||
	}
	twoway `line', ///
	legend(on size(small) `legend') xoverhangs ///
	tlabel(, format(%tdmd)) ysize(7) xsize(7) note("$ref_source" "$ref_data") ///
	title("Total cases", size(medium)) ytitle("Number of cases") xtitle("") ///
	ylab(2.3 "10" 4.6 "100" 6.9 "1,000" 9.2 "10,000" 11.5 "100,000" 13.9 "1000,000")
	macro drop _line
	graph export "./output/global_top${top_world}_lncumcases_bydate.svg", replace 
		
*--------------------------------------------
* 3. Total cases by country, since 100th case	
*--------------------------------------------
// load data
use "$task1/output/covid_cases_bycountry", clear
	merge m:1 country using "$task1/output/world_population_2020", ///
	nogen keep(match) keepusing(population)

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

// graph (logs)
	foreach country in `countrylist' {
		local line `line' (tsline lncum_cases ///
		if country == "`country'", recast(connected) lwidth(medthick))  ||
	}
	twoway `line', ///
	legend(on size(small) `legend') xoverhangs ///
	ysize(7) xsize(7) note("$ref_source" "$ref_data") ///
	title("Total cases", size(medium)) ///
	ytitle("Number of cases") xtitle("Days since 100th case")  ///
	ylab(4.6 "100" 6.9 "1,000" 9.2 "10,000" 11.5 "100,000" 13.9 "1000,000")
	macro drop _line
	graph export "./output/global_top${top_world}_lncumcases_post100.svg", replace 
	
*---------------------------------------------------------	
* 4. Total cases per million, since 100th case per million	
*---------------------------------------------------------
// load data
use "$task1/output/covid_cases_bycountry", clear
	merge m:1 country using "$task1/output/world_population_2020", ///
	nogen keep(match) keepusing(population)

// variables per million inhabitants	
	gen pop_perMln = population/1000000
	gen double cases_perMln = cases/pop_perMln
	bys country: gen double cum_cases_perMln = sum(cases_perMln)
	gen lncum_cases_perMln =ln(cum_cases_perMln)
	
//sync events
	drop if cum_cases_perMln < 100
	bys country: gen event_time = _n
	xtset cty event_time
	
// local with names of countries in top 10
	preserve
		qui su date
		local last_date = r(max)
		keep if date == `last_date'
		gsort -cum_cases_perMln
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
		local line `line' (tsline lncum_cases_perMln ///
		if country == "`country'", recast(connected) lwidth(medthick))  ||
	}
	twoway `line', ///
	legend(on size(small) `legend') xoverhangs ///
	ysize(7) xsize(7) note("$ref_source" "$ref_data") ///
	title("Total cases, per mln inhabitants", size(medium)) ///
	ytitle("Cases, per mln inhabitants") ///
	xtitle("Days since 100th case per mln") ///
	ylab(4.6 "100" 6.9 "1,000" 9.2 "10,000" 11.5 "100,000")
	macro drop _line
	graph export "./output/global_top${top_world}_lncumcasesperMln_post100perMln.svg", replace 
	
*---------------------------------------
* 5. Growth rate cases, since 100th case
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
	title("Growth rate (%)", size(medium)) ///
	ytitle("3-day moving average") ///
	xtitle("Days since 100th case") 
	macro drop _line
	graph export "./output/global_top${top_world}_ma3cases_post100.svg", replace 
	
*---------------------------------------------	
* 6. Evolution of share infected in population	
*---------------------------------------------
// load data
use "$task1/output/covid_cases_bycountry", clear
	merge m:1 country using "$task1/output/world_population_2020", ///
	nogen keep(match) keepusing(population)
	
// share infected by date
	gen share_infected = cum_cases/population	

//sync events
	drop if cum_cases < 100
	bys country: gen event_time = _n
	xtset cty event_time
	
// local with names of countries in top 10
	preserve
		qui su date
		local last_date = r(max)
		keep if date == `last_date'
		gsort -share_infected
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
		local line `line' (tsline share_infected ///
		if country == "`country'", recast(connected) lwidth(medthick))  ||
	}
	twoway `line', ///
	legend(on size(small) `legend') xoverhangs ///
	ysize(7) xsize(7) note("$ref_source" "$ref_data") ///
	title("Estimated infections in population", size(medium)) ///
	ytitle("Infected population (%)") xtitle("") xtitle("Days since 100th case")
	macro drop _line
	graph export "./output/global_top${top_world}_shareinfected_post100.svg", replace 		
