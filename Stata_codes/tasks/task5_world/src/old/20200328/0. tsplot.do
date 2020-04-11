	/*
	*! version 0.1, March 28, 2020
	cap program drop tsplot
	program tsplot
		tsline `0' , recast(connected) lwidth(medthick) ///
		legend(on size(small) `legend') xoverhangs ///
		tlabel(, format(%tdmd)) ///
		ysize(7) xsize(7) note("$ref_source" "$ref_data")
	end
	*/
	
	
	*! version 0.1, March 28, 2020
	cap program drop tsplot
	program tsplot
	syntax varname
	*levelsof country, local(countrylist)
	foreach country in `countrylist' {
		local line `line' (tsline cum_deaths ///
		if country == "`country'", recast(connected) lwidth(medthick))  ||
	}
	twoway `line'
	macro drop _line
	end
	
	
	/*
	cap program drop tsplot
	program tsplot
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
	end
	*/

	
	
	 
	
	
