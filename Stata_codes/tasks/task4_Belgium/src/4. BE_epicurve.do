* This Version: April 7, 2020
* First Version: April 4, 2020
* Author: Glenn Magerman

*------------------------------
* 1. Select reference countries
*------------------------------
foreach country in Belgium China Japan SouthKorea {
	use "$task1/output/covid_cases_bycountry", clear
		keep if country == "`country'" 
		keep date country cases
	save "./tmp/epicurve_`country'", replace	
}

*------------------
* 2. Epicurve cases
*------------------	
// use ECDC country-level data
use "./tmp/epicurve_Belgium", clear
	foreach country in China Japan SouthKorea {
		append using "./tmp/epicurve_`country'"
	}	
	encode country, gen(cty)
	
// fraction of cases out of total
	bys country: egen tot_cases = total(cases)
	bys country: gen share_cases = cases/tot_cases*100
	bys country: gen lnshare_cases = ln(share_cases)

// moving average	
	xtset cty date
	egen lnma_share_cases = filter(lnshare_cases), lags(0/$MA) normalise	
	drop if share_cases < 0.001	

// event: highest daily share (MA) = top, and t=0 	
	bys country: egen max = max(lnma_share_cases)
	bys country: gen top = (lnma_share_cases == max)
	bys country: gen count = _n
	fcollapse (min) count, by(top cty) merge
	by country: egen offset = max(min_count)
	gen event_time = count - offset
	drop top count min_count max

//sync events
	xtset cty event_time
	*drop if event_time < -40

// graph (logs)
	foreach country in Belgium China {
		local line `line' (tsline lnma_share_cases ///
		if country == "`country'", recast(connected) lwidth(medthick))  ||
	}
	twoway `line', ///
	legend(on size(small) lab(1 "Belgium") lab(2 "China") lab(3 "Japan") lab(4 "South Korea")) xoverhangs ///
	ysize(7) xsize(7) note("$ref_source" "$ref_data") ///
	title("Epicurve cases", size(medium)) ///
	ytitle("% of total cases (${MA}-day MA)") xtitle("Days relative to turning point") ///
	ylab(-6.9 "10{sup:-3}" -4.6 "10{sup:-2}" -2.3 "10{sup:-1}" 0 "10{sup:0}" 2.3 "10{sup:1}")
	macro drop _line
	graph export "./output/BE_epicurve_cases.svg", replace 
	
*----------
* 2. Deaths	
*----------
use "$task1/output/covid_cases_bycountry", clear
	keep if country =="Belgium" | country == "China"
	
// fraction of cases out of total
	bys country: egen tot_deaths = total(deaths)
	bys country: gen share_deaths = deaths/tot_deaths*100
	bys country: gen lnshare_deaths = ln(share_deaths)
		
// moving average	
	xtset cty date
	egen lnma_share_deaths = filter(lnshare_deaths), lags(0/$MA) normalise	
	drop if share_deaths < 0.001
	
// event: highest daily share (MA) = top, and t=0 	
	bys country: egen max = max(lnma_share_deaths)
	bys country: gen top = (lnma_share_deaths == max)
	bys country: gen count = _n
	fcollapse (min) count, by(top cty) merge
	by country: egen offset = max(min_count)
	gen event_time = count - offset
	drop top count min_count max

//sync events
	xtset cty event_time
	*drop if event_time < -40


// graph (logs)
	foreach country in Belgium China {
		local line `line' (tsline lnma_share_deaths ///
		if country == "`country'", recast(connected) lwidth(medthick))  ||
	}
	twoway `line', ///
	legend(on size(small)lab(1 "Belgium") lab(2 "China")) xoverhangs ///
	ysize(7) xsize(7) note("$ref_source" "$ref_data") ///
	title("Epicurve deaths", size(medium)) ///
	ytitle("% of total deaths (${MA}-day MA)") xtitle("Days relative to epidemic turning point") ///
	ylab( -4.6 "10{sup:-2}" -2.3 "10{sup:-1}" 0 "10{sup:0}" 2.3 "10{sup:1}")
	macro drop _line
	graph export "./output/BE_epicurve_deaths.svg", replace 
	
	
