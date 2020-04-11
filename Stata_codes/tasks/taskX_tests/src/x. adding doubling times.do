*---------------------------------
* 3. Total cases, by date of onset
*---------------------------------
// load data
use "$task1/output/covid_cases_bycountry", clear
	merge m:1 country using "$task1/output/world_population_2020", ///
	nogen keep(match) keepusing(population)

//sync events
	drop if cum_cases < 100 
	bys country: gen event_time = _n
	xtset cty event_time

// local with names of countries in top 10
	preserve
		qui su date
		local last_date = r(max)
		keep if date == `last_date'
		gsort -cum_cases
		keep in 1/$top_world
		sort country
		levelsof country, local(countrylist)
		local nvar = r(N)
		forvalues i = 1/`nvar' {
			local l`i' = "lab(`i' `=country[`i']')"
		}
		forvalues i = 1/`nvar' {
			local legend `legend' `l`i''
		}
	restore
	
// graph (logs)
	foreach country in `countrylist' {
		local line `line' (tsline lncum_cases ///
		if country == "`country'", recast(connected) lwidth(medthick))  ||
	}
	twoway `line'  (function y=70/35*x, range(0 7)) (function y=70/23.33*x, range(0 5)), ///
	legend(on size(small) `legend') xoverhangs ///
	ysize(7) xsize(7) note("$ref_source" "$ref_data") ///
	title("Total cases", size(medium)) ///
	ytitle("Total cases") xtitle("Days since 100th case")  ///
	ylab(4.6 "100" 6.9 "1,000" 9.2 "10,000" 11.5 "100,000" 13.8 "1000,000")
	macro drop _line
	graph export "./output/global_lncumcases_post100.svg", replace 
