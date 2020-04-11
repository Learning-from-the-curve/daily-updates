*----------------------------------------
* 4. Growth rate deaths, since 10th death
*----------------------------------------
// load data
use "$task1/output/covid_cases_bycountry", clear
	merge m:1 country using "$task1/output/world_population_2020", ///
	nogen keep(match) keepusing(population)
	
// moving average	
	xtset cty date
	gen gr_deaths = deaths/cum_deaths*100
	*gen gr_deaths = lndeaths - l.lndeaths
	egen ma_deaths = filter(gr_deaths), lags(0/3) normalise	
	
//sync events
	drop if cum_deaths < 10
	bys country: gen event_time = _n
	xtset cty event_time
	
// local with names of countries in top 10
	preserve
		qui su date
		local last_date = r(max)
		keep if date == `last_date'
		gsort -cum_deaths
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

// graph (data)
	foreach country in `countrylist' {
		local line `line' (tsline ma_deaths ///
		if country == "`country'", recast(connected) lwidth(medthick))  ||
	}
	twoway `line', ///
	legend(on size(small) `legend') xoverhangs ylab(0(10)50) ///
	ysize(7) xsize(7) note("$ref_source" "$ref_data") ///
	title("Growth rate", size(medium)) ///
	ytitle("Growth rate (%), 3-day MA") ///
	xtitle("Days since 10th death") 
	macro drop _line
	graph export "./output/global_ma3deaths_post10.svg", replace 	
	
// graph (predictions)
// fractional polynomial
	foreach country in `countrylist' {
		local line `line' (fpfit ma_deaths event_time ///
		if country == "`country'", estopts(degree(4) all)	lwidth(medthick))  ||
	}
	twoway `line', ///
	legend(on size(small) `legend') xoverhangs ///
	ysize(7) xsize(7) note("$ref_source" "$ref_data") ///
	title("Growth rate", size(medium)) ///
	ytitle("Growth rate (%), 3-day MA") ///
	xtitle("Days since 10th death") 
	macro drop _line
	graph export "./output/global_ma3deaths_poly4_post10.svg", replace 	

twoway fpfit ma_deaths event_time  if country== "China", estopts(degree(4))	
predict

twoway fpfit ma_deaths event_time  if country== "Italy", estopts(degree(4))	
predict y_hat	
	
