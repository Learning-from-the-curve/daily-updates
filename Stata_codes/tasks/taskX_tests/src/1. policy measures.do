* This version: April 10, 2020
* First version: April 10, 2020
* Author: Glenn Magerman

// Need to add dates > 22005 (March 31) for policy index (assume remains contant)
// bys country: carryforwar index, replace // fillin gaps

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
	
*--------------------------------
* 2. Correlation index and deaths
*--------------------------------
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
