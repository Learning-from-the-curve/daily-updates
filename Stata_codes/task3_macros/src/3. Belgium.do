* First Version: April 8, 2020
* This Version: April 4, 2020
* Author: Glenn Magerman

*-------------------------
* 1. Open file to write to
*-------------------------
	file close _all
	file open myfile using "./output/BE_macros.txt", write replace
	file write myfile "variable" _tab "value" _n

*---------------
* 2. Total cases
*---------------
use "$task1/output/Belgium_CASES_AGESEX", clear
	collapse (sum) cases, by(date)
	gen cum_cases = sum(cases)
	
	qui su date
	local last_date = r(max)
	keep if date == `last_date'
	local BE_ncases = cum_cases
	
*----------------	
* 3. Hospitalized	
*----------------	
use "$task1/output/Belgium_HOSP", clear	
	collapse (sum) nr_reporting total_in total_in_icu total_in_resp ///
	total_in_ecmo new_in new_out, by(date)
	gen total_out = sum(new_out)
	
	qui su date
	local last_date = r(max)
	keep if date == `last_date'
	
	local BE_nhosp = total_in
	local BE_nicu = total_in_icu
	local BE_nresp = total_in_resp
	local BE_nreleased = total_out	
	
// share of ICU beds taken
	qui su date
	local last_date = r(max)
	keep if date == `last_date'
	local sh_icu = round(total_in_icu/2293*100)

*------------	
* 4. Deceased	
*------------
use "$task1/output/Belgium_MORT", clear	
	collapse (sum) deaths, by (date)
	gen cum_deaths = sum(deaths)
	
	qui su date
	local last_date = r(max)
	keep if date == `last_date'
	
	local BE_ndeaths = cum_deaths

// write to file		
	foreach x in BE_ncases BE_nhosp BE_nicu BE_nresp BE_nreleased BE_ndeaths sh_icu {
		local temp : display ``x''
		file write myfile %20s "`x'" _tab  %12.0fc `"`temp'"' _n
	}	
	
*-------------------------	
* 5. Top 3 infected cities	
*-------------------------
// cases
use "$task1/output/Belgium_CASES_MUNI_CUM", clear		// no dates in this dataset, only latest
	destring cases, force replace						// drop < 5
	ren cases cum_cases
	drop if missing(tx_descr_nl)
	
	gsort -cum_cases
	forvalues i = 1/3 {
	local BE_ncases_name`i' = tx_descr_nl[`i']
	local BE_ncases`i' = cum_cases[`i']
	}

// write to file
	forvalues i = 1/3 {	
		foreach x in BE_ncases`i' {
			local temp : display ``x''
			file write myfile %20s "`BE_ncases_name`i''_cases" _tab  %12.0fc `"`temp'"' _n
		}	
	}
		
*--------------	
* 6. Close file
*--------------	
	file close myfile			
	
