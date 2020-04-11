* Version: March 25, 2020
* Author: Glenn Magerman

*----------------------------------------
* 1. Daily cases/deaths, top 10 + Belgium
*----------------------------------------
// select countries
use "$task1/output/covid_cases_bycountry", clear
	qui su date
	local last_date = r(max)
	keep if date == `last_date'
	gsort -cum_deaths
	gen rank = _n	
	keep if rank <= 10 | country=="Belgium" 

// table with ncases and ndeaths for top 10 + Belgium 	
	export delimited date cases deaths country cum_cases cum_deaths ///
	using "./output/global_rank.csv", replace delim(",")
	
// create local with names of countries to analyze	
	levelsof country, local(countrylist)
	di r(levels)
	
// update daily:	
	local legend "lab(1 Belgium) lab(2 China) lab(3 France) lab(4 Germany) lab(5 Iran)lab(6 Italy) lab(7 Netherlands) lab(8 South Korea) lab(9 Spain) lab(10 UK) lab(11 USA)"

*--------------------
* 2. Cumulative cases
*--------------------
use "$task1/output/covid_cases_bycountry", clear
	foreach country in `countrylist' {
		local call `call' (connected cum_cases date if country=="`country'", ///
		lwidth(medthick))  ||
	}
	twoway `call', title("Cumulative cases") ytitle(Number of cases) ///
	legend(on size(small) `legend') ysize(6) xsize(5) note($reference) 
	graph export "./output/cumcases_byday_top10.eps", replace 

*---------------------	
* 3. Cumulative deaths
*---------------------
use "$task1/output/covid_cases_bycountry", clear
	foreach country in `countrylist' {
		local call2 `call2' (connected cum_deaths date if country=="`country'", ///
		lwidth(medthick)) ||
	}
	twoway `call2', title("Cumulative deaths") ytitle(Number of deaths) ///
	legend(on size(small) `legend') ysize(6) xsize(5) note($reference)
	graph export "./output/cumdeaths_byday_top10.eps", replace 

*---------------------------	
* 4. Event study cumul cases	
*---------------------------
use "$task1/output/covid_cases_bycountry", clear
//sync events
	drop if cum_cases < 100
	bys country: gen event_time = _n
	xtset country2 event_time

// graph
	foreach country in `countrylist' {
		local call3 `call3' (connected cum_cases event_time if country=="`country'", ///
		lwidth(medthick)) ||
	}
	twoway `call3', title("Cumulative cases") ytitle(Number of cases) ///
	xtitle("Days since 100th case") ///
	legend(on size(small) `legend') ysize(6) xsize(5) note($reference)
	graph export "./output/cumcases_event_top10.eps", replace 

*----------------------------	
* 5. Event study cumul deaths
*----------------------------	
// graph
	foreach country in `countrylist' {
		local call4 `call4' (connected cum_deaths event_time if country=="`country'", ///
		lwidth(medthick)) ||
	}
	twoway `call4', title("Cumulative deaths") ytitle(Number of deaths) ///
	xtitle("Days since 100th case") ///
	legend(on size(small) `legend') ysize(6) xsize(5) note($reference)
	graph export "./output/cumdeaths_event_top10.eps", replace 

*----------------------------------------	
* 6. Event study cumul cases, per million	
*----------------------------------------
// load data
use "$task1/output/covid_cases_bycountry", clear
	merge m:1 country using "$task1/output/world_population_2020", ///
	nogen keep(match) keepusing(population)

// variables per million inhabitants	
	gen pop_perMln = population/1000000
	foreach x in cases deaths {					// take logs
		gen double `x'_perMln = `x'/pop_perMln
	}	
	
// cumulative cases	
	bys country: gen double cum_cases_perMln = sum(cases_perMln)
	bys country: gen double cum_deaths_perMln = sum(deaths_perMln)
	
//sync events
	drop if cum_cases < 100
	bys country: gen event_time = _n
	xtset country2 event_time

// graph
	foreach country in `countrylist' {
		local call5 `call5' (connected cum_cases_perMln event_time if country=="`country'", ///
		lwidth(medthick)) ||
	}
	twoway `call5', title("Cumulative cases, per million inhabitants") ///
	ytitle("Number of cases, per million inhabitants") ///
	xtitle("Days since 100th case") ///
	legend(on size(small) `legend') ysize(6) xsize(5) note($reference)
	graph export "./output/cumcases_perMln_event_top10.eps", replace 
	
*----------------------------------------	
* 7. Event study cumul deaths, per million	
*----------------------------------------
// graph
	foreach country in `countrylist' {
		local call6 `call6' (connected cum_deaths_perMln event_time if country=="`country'", ///
		lwidth(medthick)) ||
	}
	twoway `call6', title("Cumulative deaths, per million inhabitants") ///
	ytitle("Number of deaths, per million inhabitants") ///
	xtitle("Days since 100th case") ///
	legend(on size(small) `legend') ysize(6) xsize(5) note($reference)
	graph export "./output/cumdeaths_perMln_event_top10.eps", replace 
		
	
