* This Version: April 8, 2020
* First Version: April 1, 2020
* Author: Glenn Magerman

*-------------------------
* 1. Open file to write to
*-------------------------
	file close _all
	file open myfile using "./output/EU_macros.txt", write replace
	file write myfile "variable" _tab "value" _n


*-----------------------------------------------
* 2. Number of cases, deaths and countries today
*-----------------------------------------------
use "$task1/output/covid_cases_bycountry", clear
	qui su date
	local last_date = r(max)
	keep if date == `last_date'
	drop if cum_cases == 0
	keep if EU28 == 1

	collapse (sum) EU_ncases = cum_cases EU_ndeaths = cum_deaths
	
// write to file
	foreach var of varlist EU_ncases EU_ndeaths {
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
	keep if EU28 == 1
	
// top 3 cases
	gsort -cum_cases
	forvalues i = 1/3 {
	local EU_ncases_name`i' = country[`i']
	local EU_ncases`i' = cum_cases[`i']
	di "`EU_ncases_name`i''"
	}
	
// save to file			
	forvalues i = 1/3 {	
		foreach x in EU_ncases`i' {
			local temp : display ``x''
			file write myfile %20s "`EU_ncases_name`i''_cases" _tab  %10.0fc `"`temp'"' _n
		}	
	}	
	
*--------------------------
* 4. Top 3 countries deaths
*--------------------------
use "$task1/output/covid_cases_bycountry", clear
	qui su date
	local last_date = r(max)
	keep if date == `last_date'
	keep if EU28 == 1
	egen EU_deaths = total(cum_deaths)

// top 3 deaths	
	gsort -cum_deaths
	forvalues i = 1/3 {
	local EU_ndeaths_name`i' = country[`i']
	local EU_ndeaths`i' = cum_deaths[`i']
	di "`EU_ndeaths_name`i''"
	}

// write to file
	forvalues i = 1/3 {	
		foreach x in EU_ndeaths`i' {
			local temp : display ``x''
			file write myfile %20s "`EU_ndeaths_name`i''_deaths" _tab  %12.0fc `"`temp'"' _n
		}	
	}
	
*------------------------------------------------------	
* 5. Top 3 countries account for X% of worldwide deaths
*------------------------------------------------------	
	keep in 1/3
	egen top3_deaths = total(cum_deaths) 
	local sh_top3_deaths = round(top3_deaths/EU_deaths*100)
	
// write to file
	file write myfile %20s "share top3 deaths" _tab  %12.0fc "`sh_top3_deaths'" _n	

*-------------------------------	
* 6. average infection rate EU28	
*-------------------------------
use "$task1/output/covid_cases_bycountry", clear
	merge m:1 country using "$task1/output/world_population_2020", ///
	nogen keep(match) keepusing(population)
	keep if EU28 == 1
	collapse (sum) cum_cases cum_deaths population

	local sh_cases = round(cum_cases/population*100, .0001)
	local sh_deaths = round(cum_deaths/population*100, .0001)

// save to file
		
	file write myfile %20s "avg infection rate EU cases" _tab  %12.0fc "`sh_cases'" _n
	file write myfile %20s "avg infection rate EU deaths" _tab  %12.0fc "`sh_deaths'" _n

*--------------	
* 7. Close file
*--------------	
	file close myfile		
