*! version 0.1, April 6, 2020
* Author: Glenn Magerman

// time series plot with chosen list of series
// takes as arguments: (1) variable to plot, (2) values to sort on (e.g. top 10 for variable to plot)
// this version of tsplot graphs epicurves with event time and y-axis in fraction of total cases by date


	// define program
	cap program drop tsplot_epicurve
	program define tsplot_epicurve
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
	xlab(-40(20)60) ///
	ylab(-6.9 "10{sup:-3}" -4.6 "10{sup:-2}" -2.3 "10{sup:-1}" 0 "10{sup:0}" 2.3 "10{sup:1}")
	macro drop _line
	end
