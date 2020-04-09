* First Version: April 4, 2020
* This Version: April 4, 2020
* Author: Glenn Magerman

*-----------------------
* 1. National, over time
*-----------------------
// collect datasets: daily numbers national level
tempfile cases hosp
use "$task1/output/Belgium_CASES_AGESEX", clear
	collapse (sum) cases, by(date)
	gen total_cases = sum(cases)
	drop cases
save `cases'

use "$task1/output/Belgium_HOSP", clear
	collapse (sum) total_in total_in_icu total_in_resp new_out, by(date)
	gen total_out = sum(new_out)
	drop new_out
save `hosp'

use "$task1/output/Belgium_MORT", clear	
	collapse (sum) deaths, by(date)
	gen total_deaths = sum(deaths)
	drop deaths
	merge 1:1 date using `cases', nogen
	merge 1:1 date using `hosp', nogen
	foreach x in total_deaths total_cases total_in total_in_icu total_in_resp total_out {
		replace `x' = 0 if missing(`x')
	}	
	drop if missing(date)

// graph
	tsset date
	foreach var in total_cases total_in total_in_icu total_in_resp total_out total_deaths {
		local line `line' (tsline `var', recast(connected) lwidth(medthick))  ||
	}
	twoway `line' , yline(2293) text(3000 21979 "ICU capacity", size(vsmall) col(red)) ///
	legend(on size(small) lab(1 cases) lab(2 hospitalized) lab(3 ICU) ///
	lab(4 respiratory) lab(5 released) lab(6 deceased)) xoverhangs ///
	tlabel(, format(%tdmd)) ysize(7) xsize(7) note("$ref_source" "$ref_data")
	macro drop _line
	graph export "./output/BE_cases_hosp_dead.svg", replace 	
	
	
