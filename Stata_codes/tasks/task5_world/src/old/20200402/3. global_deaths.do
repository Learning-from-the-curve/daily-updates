* First Version: March 24, 2020
* This Version: April 2, 2020
* Author: Glenn Magerman

/*
- total deaths by country, as of today
- total deaths by country, by date
- total deaths by country, since 10th death
- total deaths per million by country, since 10th death per million
- growth rate deaths by country, since 10th death
- evolution mortality rate by country
- evolution case fatality rate by country
*/

*----------------------------------
* 1. Total deaths by country, today
*----------------------------------
// select countries
use "$task1/output/covid_cases_bycountry", clear
	qui su date
	local last_date = r(max)
	keep if date == `last_date'

// numbers in report: top 3 with numbers
	gsort -cum_deaths
	forvalues i = 1/3 {
		global n`i'_country_cumdeaths_global = "country[`i']"
		global n`i'_ncumdeaths_global = cum_cases[`i']
	}
	
*-------------------------------------
* 2. Cumulative deaths top 10, by date
*-------------------------------------
// local with names of countries in top 10
use "$task1/output/covid_cases_bycountry", clear
	qui su date
	local last_date = r(max)
	keep if date == `last_date'
	gsort -cum_deaths
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
		local line `line' (tsline cum_deaths ///
		if country == "`country'", recast(connected) lwidth(medthick))  ||
	}
	twoway `line', ///
	legend(on size(small) `legend') xoverhangs ///
	tlabel(, format(%tdmd)) ysize(7) xsize(7) note("$ref_source" "$ref_data") ///
	title("Total deaths", size(medium)) ytitle("Number of deaths") xtitle("") 
	macro drop _line
	graph export "./output/global_top${top_world}_cumdeaths_bydate.svg", replace 

// graph (logs)
	foreach country in `countrylist' {
		local line `line' (tsline lncum_deaths ///
		if country == "`country'", recast(connected) lwidth(medthick))  ||
	}
	twoway `line', ///
	legend(on size(small) `legend') xoverhangs ///
	tlabel(, format(%tdmd)) ysize(7) xsize(7) note("$ref_source" "$ref_data") ///
	title("Total deaths", size(medium)) ytitle("Number of deaths") ///
	ylab(2.3 "10" 4.6 "100" 6.9 "1,000" 9.2 "10,000" 11.5 "100,000")
	macro drop _line
	graph export "./output/global_top${top_world}_lncumdeaths_bydate.svg", replace 
	
*---------------------------------------------
* 3. Total deaths by country, since 10th death
*---------------------------------------------
// load data
use "$task1/output/covid_cases_bycountry", clear
	merge m:1 country using "$task1/output/world_population_2020", ///
	nogen keep(match) keepusing(population)
	
//sync events
	drop if cum_deaths < 10
	bys country: gen event_time = _n
	xtset cty event_time
	
// local with names of countries in top 10
	preserve
		qui su date
		local last_date = r(max)
		keep if date == `last_date'
		gsort -cum_deaths
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
		local line `line' (tsline lncum_deaths ///
		if country == "`country'", recast(connected) lwidth(medthick))  ||
	}
	twoway `line', ///
	legend(on size(small) `legend') xoverhangs ///
	ysize(7) xsize(7) note("$ref_source" "$ref_data") ///
	title("Total deaths, per mln inhabitants", size(medium)) ///
	ytitle("Number of deaths, per mln inhabitants") ///
	xtitle("Days since 10th death per mln")  ///
	ylab(4.6 "100" 6.9 "1,000" 9.2 "10,000" 11.5 "100,000")
	macro drop _line
	graph export "./output/global_top${top_world}_lncumdeaths_post10.svg", replace 

*----------------------------------------------------------	
* 4. Total deaths per million, since 10th death per million
*----------------------------------------------------------
// load data
use "$task1/output/covid_cases_bycountry", clear
	merge m:1 country using "$task1/output/world_population_2020", ///
	nogen keep(match) keepusing(population)

// variables per million inhabitants	
	gen pop_perMln = population/1000000
	gen double deaths_perMln = deaths/pop_perMln
	bys country: gen double cum_deaths_perMln = sum(deaths_perMln)
	gen lncum_deaths_perMln  = ln(cum_deaths_perMln)
	
//sync events
	drop if cum_deaths_perMln < 10
	bys country: gen event_time = _n
	xtset cty event_time
	
// local with names of countries in top 10
	preserve
		qui su date
		local last_date = r(max)
		keep if date == `last_date'
		gsort -cum_deaths_perMln
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
		local line `line' (tsline lncum_deaths_perMln ///
		if country == "`country'", recast(connected) lwidth(medthick))  ||
	}
	twoway `line', ///
	legend(on size(small) `legend') xoverhangs ///
	ysize(7) xsize(7) note("$ref_source" "$ref_data") ///
	title("Total deaths, per mln inhabitants", size(medium)) ///
	ytitle("Number of deaths, per mln inhabitants") ///
	xtitle("Days since 10th death per mln") ///
	ylab(4.6 "100" 6.9 "1,000" 9.2 "10,000" 11.5 "100,000")
	macro drop _line
	graph export "./output/global_top${top_world}_lncumdeathsperMln_post10perMln.svg", replace 
	
*----------------------------------------
* 5. Growth rate deaths, since 10th death
*----------------------------------------
// load data
use "$task1/output/covid_cases_bycountry", clear
	merge m:1 country using "$task1/output/world_population_2020", ///
	nogen keep(match) keepusing(population)
	
// moving average	
	xtset cty date
	gen gr_deaths = deaths/cum_deaths*100
	*gen gr_deaths = lndeaths - l.lndeaths
	egen ma_deaths = filter(gr_deaths), lags(0/3) normalise	
	
//sync events
	drop if cum_deaths < 10
	bys country: gen event_time = _n
	xtset cty event_time
	
// local with names of countries in top 10
	preserve
		qui su date
		local last_date = r(max)
		keep if date == `last_date'
		gsort -cum_deaths
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
		local line `line' (tsline ma_deaths ///
		if country == "`country'", recast(connected) lwidth(medthick))  ||
	}
	twoway `line', ///
	legend(on size(small) `legend') xoverhangs ylab(0(10)50) ///
	ysize(7) xsize(7) note("$ref_source" "$ref_data") ///
	title("Growth rate (%)", size(medium)) ///
	ytitle("3-day moving average") ///
	xtitle("Days since 10th death") 
	macro drop _line
	graph export "./output/global_top${top_world}_ma3deaths_post10.svg", replace 
	
*---------------------------------------------	
* 6. Evolution of mortality rate in population	
*---------------------------------------------
// load data
use "$task1/output/covid_cases_bycountry", clear
	merge m:1 country using "$task1/output/world_population_2020", ///
	nogen keep(match) keepusing(population)
	
// mortality rate by date
gen share_death = cum_deaths/population*100	

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
		local line `line' (tsline share_death ///
		if country == "`country'", recast(connected) lwidth(medthick))  ||
	}
	twoway `line', ///
	legend(on size(small) `legend') xoverhangs ///
	ysize(7) xsize(7) note("$ref_source" "$ref_data") ///
	title("Estimated mortality in population", size(medium)) ///
	ytitle("Deceased population (%)") xtitle("") xtitle("Days since 10th death")
	macro drop _line
	graph export "./output/global_top${top_world}_sharemortality_post10.svg", replace 
	
*--------------------------------	
* 7. Evolution case/fatality rate 	
*--------------------------------	
// load data
use "$task1/output/covid_cases_bycountry", clear
	merge m:1 country using "$task1/output/world_population_2020", ///
	nogen keep(match) keepusing(population)
	
// case fatality rate by date
	gen CFR = cum_death/cum_cases*100	

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
		local line `line' (tsline CFR ///
		if country == "`country'", recast(connected) lwidth(medthick))  ||
	}
	twoway `line', ///
	legend(on size(small) `legend') xoverhangs ///
	ysize(7) xsize(7) note("$ref_source" "$ref_data") ///
	title("Estimated case fatality rate (%)", size(medium)) ///
	ytitle("Case fatality rate") xtitle("") xtitle("Days since 10th death")
	macro drop _line
	graph export "./output/global_top${top_world}_CFR_post10.svg", replace 
	
