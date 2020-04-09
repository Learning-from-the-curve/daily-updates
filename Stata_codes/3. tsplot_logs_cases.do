*! version 0.1, April 6, 2020
* Author: Glenn Magerman

// time series plot with chosen list of series
// takes as arguments: (1) variable to plot, (2) selected series
// this version of tsplot graphs event dates and log y-axis up to 100,000 for cases

	// define program
	cap program drop tsplot_logs_cases
	program define tsplot_logs_cases
	syntax varlist
	args varname sorting
	
	// select countries based on last data
	preserve
		qui su date
		keep if date == r(max)
	
	// select countries
		gsort -`sorting' 
		keep in 1/$top
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
	
	// graph
	foreach country in `countrylist' {
		local line `line' (tsline `varname' ///
		if country == "`country'", recast(connected) lwidth(medthick))  ||
	}
	twoway `line', ///
	legend(on size(small) `legend') xoverhangs ///
	ysize(7) xsize(7) note("$ref_source" "$ref_data") /// 
	ylab(4.6 "100" 6.9 "1,000" 9.2 "10,000" 11.5 "100,000")
	macro drop _line
	end
	
	
	
	
