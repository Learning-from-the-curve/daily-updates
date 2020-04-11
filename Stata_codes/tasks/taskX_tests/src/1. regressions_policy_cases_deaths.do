* This version: April 11, 2020
* First version: April 11, 2020
* Author: Glenn Magerman


// Some regressions of cases/deaths on policy measures
// issues: dlny >0 always if use cum_cases, hence newver use cum, since only goes up. use MA(gr rates)

*-------------
* 1. Prep data
*-------------
// load data
use "$task1/output/covid_cases_bycountry", clear
	keep date country cases deaths cum_cases cum_deaths EU28
	fillin country date	
	merge 1:1 country date using "$task1/output/stringency_bycountry", ///
	nogen keep(match master)
	drop *notes ai confirmed* iso* _fillin cty
	ren stringency index
	replace index = index/100					// scale from 0 to 1
	
	*keep if EU28 == 1

// create balanced panel	
	encode country, gen(cty)
	xtset cty date				// strongly balanced
	xtdescribe
		
// fillin missing data	
	bys country: carryforward country cases deaths cum_cases cum_deaths EU28 index, replace // fillin last dates index with last available index number

// transform LHS variables (dlny)
	foreach x in cases deaths cum_cases cum_deaths {
		gen ln`x' = ln(`x')
	}
	
	xtset cty date
	foreach x in cases deaths cum_cases cum_deaths {
		gen dln_`x' = ln`x' - l.ln`x'
	}
	
// transform index (dx)
	gen d_index = d.index
save "./output/policy_deathrates", replace	

*-------------------------
* 2. OLS, dummy policy S6: restrictions on internal movement
*-------------------------
// S6 = {0,1,2}
use "./output/policy_deathrates", clear
	drop if missing(s6_restrictions)
	
// dichotomize for now	
	bys cty: egen max_pol = max(s6_rest)
	bys cty: gen treated_1 = 0
	replace treated = 1 if max_pol > 0

	
	
// moving average	
	xtset cty date
	egen ma_dln_deaths = filter(dln_deaths), lags(0/5) normalise

// sync events
	drop if cum_deaths < 10
	bys country: gen event_time = _n
	xtset cty event_time	
	
// plot: 0 vs 1
	twoway (tsline lncum_deaths if treated == 1) (tsline lncum_deaths if treated == 0)
	
// regressions	
	eststo clear
	tsline dln_deaths if 

	

*------------------------------
* 2. OLS with daily lags, index
*------------------------------
use "./output/policy_deathrates", clear

// regress dlny on sum_k(dx_t-k) for some choices of K
	eststo clear
	forvalues K = 1/31 {
		eststo lag_`K': reg dln_deaths l(0/`K').d_index 			// take up to K lags
	}
	esttab using "./output/OLS_dlndeaths_policy.csv", ///
	b(3) se(3) r2(3) not nogaps star parentheses ar2 replace
	
// add date FE	
	eststo clear
	forvalues K = 1/14 {
		eststo lag_`K': xtreg dln_deaths l(0/`K').d_index i.date, fe 	// take up to K lags, add date FE
	}
	esttab using "./output/OLS_dlndeaths_policy_dateFE.csv", ///
	b(3) se(3) r2(3) not nogaps star parentheses ar2 replace
	
// levels with country FE	
	eststo clear
	forvalues K = 1/14 {
		eststo lag_`K': xtreg lndeaths l(0/`K').index i.date, fe 	// take up to K lags, add date FE
	}
	esttab using "./output/OLS_dlndeaths_policy_dateFE.csv", ///
	b(3) se(3) r2(3) not nogaps star parentheses ar2 replace
	
	
*--------------------------
* 3. OLS with MA LHS, index
*--------------------------
use "./output/policy_deathrates", clear
	xtset cty date
	egen ma_dln_deaths = filter(dln_deaths), lags(0/5) normalise

// no use to use MA_index, sincs are sharp policies	
	
// changes within country	
	eststo clear
	forvalues K = 1/14 {
		eststo lag_`K': xtreg ma_dln_deaths l(0/`K').ma_d_index, fe 			// take up to K lags
	}
	esttab 
// levels with FE	
	eststo clear
	forvalues K = 1/14 {
		eststo lag_`K': xtreg ma_dln_deaths l(0/`K').ma_d_index, fe 			// take up to K lags
	}
		
	
	
	eststo clear	
	forvalues K = 1/14 {
		eststo lag_`K': xtreg ma_dln_deaths l(0/`K').d_index i.date, fe 	// take up to K lags, add date FE
	}
	
*-------------------------
* 5. OLS with MA LHS, index use event time
*-------------------------
// use avg policies of other countries as instrument for own policy
use "./output/policy_deathrates", clear
	
// moving average	
	xtset cty date
	egen ma_dln_deaths = filter(dln_deaths), lags(0/5) normalise

// sync events
	drop if cum_deaths < 10
	bys country: gen event_time = _n
	xtset cty event_time	
	
// regression	
	eststo clear
	forvalues K = 1/14 {
		eststo lag_`K': xtreg ma_dln_deaths l(0/`K').d_index, fe 
	}		
	
*-------------------------
* 4. IV with MA LHS, index
*-------------------------
// use avg policies of other countries as instrument for own policy
use "./output/policy_deathrates", clear
	xtset cty date
	egen ma_dln_deaths = filter(dln_cum_deaths), lags(0/5) normalise

// create instrument: leave out mean policy of other countries (for each date)
	tempvar tot_invar count_invar
	egen `tot_invar' = total(index), by(date)
	egen `count_invar' = count(index), by(date)
	gen policy_iv = (`tot_invar' - index) / (`count_invar' - 1)
	gen d_policy_iv = d.policy_iv
	
	
	eststo clear
	forvalues K = 1/14 {
		eststo lag_`K': ivregress gmm ma_dln_deaths (l(0/`K').d_index = l(0/`K').d_policy_iv) , ///
		vce(robust)  first 
		estat first, all 
	}
		
*-------------------------
* 5. IV with MA LHS, index use event time
*-------------------------
// use avg policies of other countries as instrument for own policy
use "./output/policy_deathrates", clear
	
// moving average	
	xtset cty date
	egen ma_dln_deaths = filter(dln_cum_deaths), lags(0/5) normalise

// sync events
	drop if cum_deaths < 10
	bys country: gen event_time = _n
	xtset cty event_time	
	
// create instrument: leave out mean policy of other countries (for each date)
	tempvar tot_invar count_invar
	egen `tot_invar' = total(index), by(date)
	egen `count_invar' = count(index), by(date)
	gen policy_iv = (`tot_invar' - index) / (`count_invar' - 1)
	gen d_policy_iv = d.policy_iv
	
// regression	
	eststo clear
	forvalues K = 1/14 {
		eststo lag_`K': ivregress gmm ma_dln_deaths (l(0/`K').d_index = l(0/`K').d_policy_iv) , ///
		vce(robust)  first 
		estat first, all 
	}	
