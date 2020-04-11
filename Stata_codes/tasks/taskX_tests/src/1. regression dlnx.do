* This version: March 29, 2020
* First version: March 29, 2020
* Author: Glenn Magerman


*-------------------------------
* 1. Correlation index and cases
*-------------------------------
use "$task1/output/covid_cases_bycountry", clear

	// select countries based on last data
	preserve
		qui su date
		keep if date == r(max)
	
	// select countries for graph
		gsort -cum_cases 
		keep in 1/10
		sort country
	
	// create legend
		levelsof country, local(countrylist)
		local nvar = r(N)
		forvalues i = 1/`nvar' {
			local l`i' = "lab(`i' `=country[`i']')"
		}
		forvalues i = 1/`nvar' {
			local legend `legend' `l`i''
		}
	restore
	
	// merge with policies
	merge 1:1 country date using "$task1/output/stringency_bycountry", ///
	nogen keep(match) keepusing(stringency)
	
	// can have multiple policies per # cases, take first occurrence of stringency
	collapse (first) stringency, by(country lncum_cases)
	
	// graph
	foreach country in `countrylist' {
		local line `line' (line stringency lncum_cases ///
		if country == "`country'", recast(connected) lwidth(medium))  ||
	}
	twoway `line', ///
	legend(on size(small) `legend') xoverhangs ///
	ysize(7) xsize(7) note("$ref_source" "$ref_data") ///
	ytitle(Policy index) xtitle(Total cases) ///
	xlab(0 "1" 2.3 "10" 4.6 "100" 6.9 "1,000" 9.2 "10,000" 11.5 "100,000")
	macro drop _line
	graph export "./output/policies_cases.svg", replace
	
*-------------------------------
* 2. Correlation index and deaths
*-------------------------------
use "$task1/output/covid_cases_bycountry", clear
	
	// select countries based on last data
	preserve
		qui su date
		keep if date == r(max)
	
	// select countries for graph
		gsort -cum_deaths 
		keep in 1/10
		sort country
	
	// create legend
		levelsof country, local(countrylist)
		local nvar = r(N)
		forvalues i = 1/`nvar' {
			local l`i' = "lab(`i' `=country[`i']')"
		}
		forvalues i = 1/`nvar' {
			local legend `legend' `l`i''
		}
	restore
	
	// merge with policies
	merge 1:1 country date using "$task1/output/stringency_bycountry", ///
	nogen keep(match)
	
	// can have multiple policies per # deaths, take first occurrence of stringency
	collapse (first) stringency, by(country lncum_deaths)

	// graph
	foreach country in `countrylist' {
		local line `line' (line stringency lncum_deaths ///
		if country == "`country'", recast(connected) lwidth(medium))  ||
	}
	twoway `line', ///
	legend(on size(small) `legend') xoverhangs ///
	ysize(7) xsize(7) note("$ref_source" "$ref_data") ///
	ytitle(Policy index) xtitle(Total deaths) ///
	xlab(0 "1" 2.3 "10" 4.6 "100" 6.9 "1,000" 9.2 "10,000")
	macro drop _line
	graph export "./output/policies_deaths.svg", replace

*-------------------------------------------
* 2. Correlation index and deaths per capita
*------------------------------------------
use "$task1/output/covid_cases_bycountry", clear
	merge m:1 country using "$task1/output/world_population_2020", ///
	nogen keep(match) keepusing(population)
	
	// shares
	gen sh_deaths = deaths/population*100
	bys country: gen double cum_sh_deaths = sum(sh_deaths)
	
	// select countries based on last data
	preserve
		qui su date
		keep if date == r(max)
	
	// select countries for graph
		gsort -cum_deaths 
		keep in 1/10
		sort country
	
	// create legend
		levelsof country, local(countrylist)
		local nvar = r(N)
		forvalues i = 1/`nvar' {
			local l`i' = "lab(`i' `=country[`i']')"
		}
		forvalues i = 1/`nvar' {
			local legend `legend' `l`i''
		}
	restore
	
	// merge with policies
	merge 1:1 country date using "$task1/output/stringency_bycountry", ///
	nogen keep(match)
	
	// can have multiple policies per # deaths, take first occurrence of stringency
	collapse (first) stringency, by(country cum_sh_deaths)

	// graph
	foreach country in `countrylist' {
		local line `line' (line stringency cum_sh_deaths ///
		if country == "`country'", recast(connected) lwidth(medium))  ||
	}
	twoway `line', ///
	legend(on size(small) `legend') xoverhangs ///
	ysize(7) xsize(7) note("$ref_source" "$ref_data") ///
	ytitle(Policy index) xtitle(Total deaths) ///
	xlab(0(0.005)0.01)
	
	*xlab(0 "1" 2.3 "10" 4.6 "100" 6.9 "1,000" 9.2 "10,000")
	macro drop _line
	graph export "./output/policies_deaths_pop.svg", replace
		
	
*--------------------------------------	
* 2. Correlation index and growth rates	
*--------------------------------------
use "$task1/output/covid_cases_bycountry", clear
	merge 1:1 country date using "$task1/output/stringency_bycountry", nogen keep(match)
	xtset cty date
	
	// LHS variables
	foreach x in cases cum_cases deaths cum_deaths {
		gen dln_`x' = ln`x' - l.ln`x'
	}
	
	// lagged policy measures
	ren stringency index
	forvalues i = 1/31 {
		gen l`i'_index = l`i'.index
	}
	
	// some regressions
	eststo clear
	forvalues i = 1/31 {
		foreach x in cases cum_cases deaths cum_deaths {
			eststo `x'`i': xtreg dln_`x' l`i'_index, fe
		}
	}


// can do by type of policy
// run on MA


