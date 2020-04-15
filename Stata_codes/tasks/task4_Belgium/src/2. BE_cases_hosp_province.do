* First Version: April 4, 2020
* This Version: April 4, 2020
* Author: Glenn Magerman

*--------------------------------
* 1. Cases by province, last date
*--------------------------------
// total numbers by province, last date
tempfile cases
use "$task1/output/Belgium_CASES_AGESEX", clear
	collapse (sum) cases, by(date province)
	encode province, gen(prv)
	xtset prv date
	bys prv: gen total_cases = sum(cases)
	drop cases
save `cases'

use "$task1/output/Belgium_HOSP", clear
	collapse (sum) total_in total_in_icu total_in_resp new_out, by(date province)
	
	encode province, gen(prv)
	xtset prv date
	bys prv: gen total_out = sum(new_out)
	drop new_out
	merge 1:1 date province using `cases', nogen
	drop if date < 21989  | missing(date)			// no hospital date pre 15mar2020
	drop if missing(province) 						// cannot allocate some cases to province
	foreach x in total_in total_in_icu total_in_resp total_out total_cases {
		replace `x' = 0 if missing(`x')
	}	
	
// graph 
	/*
	qui su date
	local last_date = r(max)
	keep if date == `last_date'
	*/
	keep if date == 22018							// always lagging info
	
	graph bar total_cases total_in total_in_icu total_in_resp total_out, ///
	over(province, label(angle(45))) ///
	legend( on lab(1 cases) lab(2 hospitalized) lab(3 ICU) lab(4 respiratory) ///
	lab(5 released))
	graph export "./output/BE_hosp_by_province.svg", replace
	
