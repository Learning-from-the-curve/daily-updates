* This version: April 7, 2020
* First version: April 4, 2020
* Author: Glenn Magerman


*--------------------------------
* 1. Benchmark graph BE mortality
*--------------------------------
// choose year(s) to benchmark
// 2018 had overmortality due to large flu epidemic
use "$task1/output/Belgium_lifetables", clear
	keep if year >= 2015 & year <= 2017			// take avg over last 3 years
	collapse (mean) density*, by(age)
	
// benchmark continuous
	line density_male density_female density_all age, ///
	legend(on lab(1 Male) lab(2 Female) lab(3 All)) ///
	ytitle(probability of death) xtitle(age)
	graph export "./output/BE_lifetables_cont_bysex.svg", replace
	
// discretize BE life tables to match COVID age bins (take midpoint)
	replace age = 12 if age >= 0 & age <= 24
	replace age = 30 if age >= 25 & age <= 44
	replace age = 50 if age >= 45 & age <= 64
	replace age = 70 if age >= 65 & age <= 74
	replace age = 80 if age >= 75 & age <= 84
	replace age = 90 if age >= 85
	fcollapse (last) density*, by(age)
	
//	benchmark discrete bins
line density_male density_female density_all age, ///
	legend(on lab(1 Male) lab(2 Female) lab(3 All)) ///
	ytitle(probability of death) xtitle(age)
	graph export "./output/BE_lifetables_bins_bysex.svg", replace	
save "./tmp/BE_life_expectancy", replace
		
*-------------------------------
* 2. COVID deaths by age and sex	
*-------------------------------
// 	discrete deaths COVID (auto updated)
use "$task1/output/Belgium_MORT", clear
	collapse (sum) deaths, by(agegroup sex)	
	drop if missing(agegroup)						

	// there are deaths unallocated to age groups, drop 
	
// make age groups integers instead of strings/bins (take midpoints)
	gen age = 12 if agegroup =="0-24"
	replace age = 30 if agegroup =="25-44"
	replace age = 50 if agegroup =="45-64"
	replace age = 70 if agegroup =="65-74"
	replace age = 80 if agegroup =="75-84"
	replace age = 90 if agegroup =="85+"	
	drop agegroup
	
// create all bins by sex	
	fillin sex age
	drop _fillin
	replace deaths = 0 if missing(deaths)
	replace sex = "missing" if missing(sex)
	encode sex, gen(sexe)
	xtset sexe age
	replace sex = "male" if sex=="M"
	replace sex = "female" if sex=="F"
save "./tmp/COVID_deaths_by_age_sex", replace	
	
*----------------------------------
* 3. CDF COVID and lifetable by sex	
*----------------------------------	
foreach sex in male female {
use "./tmp/COVID_deaths_by_age_sex", clear	
	keep if sex == "`sex'"
	
	// generate CDF COVID
	gen cum_deaths = sum(deaths)
	egen tot_deaths = total(deaths)
	gen cdf_deaths = cum_deaths/tot_deaths
	keep sex age cdf

	// merge with life tables
	merge 1:1 age using "./tmp/BE_life_expectancy", nogen
	ren (density_`sex' cdf_deaths) (life_expectancy cdf_covid)
	
	// graph
	line life_expectancy cdf_covid age, ///
	legend(on lab(1 Life table (`sex')) lab(2 COVID deaths (`sex'))) ///
	xtitle(age) ytitle(probability of death)
	graph export "./output/BE_lifetable_`sex'.svg", replace
}	
	
*-----------------------
* 4. COVID CDF by region
*-----------------------
use "$task1/output/Belgium_MORT", clear
	drop if missing(agegroup)
	fillin agegroup region
	replace deaths = 0 if missing(deaths)
collapse (sum) deaths, by(agegroup region)	

// make age groups integers instead of strings/bins (take midpoints)
	gen age = 12 if agegroup =="0-24"
	replace age = 30 if agegroup =="25-44"
	replace age = 50 if agegroup =="45-64"
	replace age = 70 if agegroup =="65-74"
	replace age = 80 if agegroup =="75-84"
	replace age = 90 if agegroup =="85+"	
	drop agegroup		

// generate cumulative
	encode region, gen(region2)
	xtset region2 age
	bys region2: gen cum_deaths = sum(deaths)
	
// normalize density
	foreach region in Brussels Flanders Wallonia {
		egen tot_deaths_`region' = total(deaths) if region == "`region'"
		gen deaths_`region' = cum_deaths/tot_deaths_`region' if region == "`region'"
	}	
	
// graph	
	line deaths_Brussels deaths_Flanders deaths_Wallonia age, ///
	legend(on lab(1 Brussels) lab(2 Flanders) lab(3 Wallonia)) ///
	xtitle(age) ytitle(probability of death)
	graph export "./output/BE_lifetable_regions.svg", replace	
	
