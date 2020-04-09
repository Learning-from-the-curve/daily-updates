* This Version: April 8, 2020
* First Version: April 1, 2020
* Author: Glenn Magerman

*-------------------------
* 1. Open file to write to
*-------------------------
	file close _all
	file open myfile using "./output/world_macros.txt", write replace
	file write myfile "variable" _tab "value" _n

*-------------------------------------------
* 2. Total cases, deaths and countries today
*-------------------------------------------
use "$task1/output/covid_cases_bycountry", clear
	qui su date
	local last_date = r(max)
	keep if date == `last_date'
	drop if cum_cases == 0

	collapse (sum) world_ncases = cum_cases world_ndeaths = cum_deaths ///
	(count) world_ncountries = cty

// write to file
	foreach var of varlist world_ncases world_ndeaths world_ncountries {
		qui su `var'
		file write myfile %20s "`var'" _tab  %12.0fc (r(mean)) _n
	}	

*-------------------------
* 3. Top 3 countries cases
*-------------------------
use "$task1/output/covid_cases_bycountry", clear
	qui su date
	local last_date = r(max)
	keep if date == `last_date'
	
// top 3 cases
	gsort -cum_cases
	forvalues i = 1/3 {
	local world_ncases_name`i' = country[`i']
	local world_ncases`i' = cum_cases[`i']
	di "`world_ncases_name`i''"
	}
	
// write to file
	forvalues i = 1/3 {	
		foreach x in world_ncases`i' {
			local temp : display ``x''
			file write myfile %20s "`world_ncases_name`i''_cases" _tab  %12.0fc `"`temp'"' _n
		}	
	}	
	
*--------------------------
* 4. Top 3 countries deaths
*--------------------------
use "$task1/output/covid_cases_bycountry", clear
	qui su date
	local last_date = r(max)
	keep if date == `last_date'
	egen world_deaths = total(cum_deaths)

// top 3 deaths	
	gsort -cum_deaths
	forvalues i = 1/3 {
	local world_ndeaths_name`i' = country[`i']
	local world_ndeaths`i' = cum_deaths[`i']
	di "`world_ndeaths_name`i''"
	}

// write to file
	forvalues i = 1/3 {	
		foreach x in world_ndeaths`i' {
			local temp : display ``x''
			file write myfile %20s "`world_ndeaths_name`i''_deaths" _tab  %12.0fc `"`temp'"' _n
		}	
	}

*------------------------------------------------------	
* 5. Top 3 countries account for X% of worldwide deaths
*------------------------------------------------------	
	keep in 1/3
	egen top3_deaths = total(cum_deaths) 
	local sh_top3_deaths = round(top3_deaths/world_deaths*100)
	
// write to file
	file write myfile %20s "share top3 deaths" _tab  %12.0fc "`sh_top3_deaths'" _n
	
*--------------	
* 6. Close file
*--------------	
	file close myfile		

	
	
