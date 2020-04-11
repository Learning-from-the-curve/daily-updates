* This Version: April 5, 2020
* First Version: April 3, 2020
* Author: Glenn Magerman


// TEST - take one time series and forecast it

/* Notes
- look at single time series and predict it
- use dlnx since is easiest way to make TS stationary
- use daily rates and correct for MA using ARIMA if needed
- goal is to find event time where growth rate becomes zero
- from there, calculate number of cases (use current cases * (1 + growth rate))
- optimal ARIMA will be different country by country!!

*/

/* Strategy
- start with linear model
- try to forecast
- other models: linear, logit, polynomial, ARIMA neural net)
- use China as an input for other trajectories (exogenous??)
- combine models into ensemble or start with ARIMA
*/

*---------------------------------
* 1. Growth rates and stationarity
*---------------------------------
use "$task1/output/covid_cases_bycountry", clear
	keep if country == "China" 
	keep date cases country
	
// growth rate (variable to forecast)
	tsset date
	gen dln_cases = ln(cases/l.cases)

// stationarity test 1, classical ADF
	dfuller dln_cases, lags(3) regress trend
	
	// if DF |Test statistic| > |critical value|, 
	// can reject H0 of unit root, in favor of Ha: stationarity
	// here = OK
	
// stationarity test 2, modified Dickey–Fuller test
	// higher power for small sample, transform series in GLS before test
	// chooses lags endogenously
	dfgls dln_cases
	// optimal lags at bottom of output = 5 or 7
	
// stationarity test 3, Philips-Perron	
	pperron dln_cases
	// robust to unspecified autocorrelation and heteroskedasticity in the disturbance process of the test equation. 
	// The main difference between the PP and the ADF tests is that the former uses Newey and West  ( 1987 ) standard errors to account for serial correlation, whereas the latter uses additional lags of the first difference. 

// OK, our TS are plausibly stationary	(note stationarity + optimal lags can be different for different TS (countries)!
	
*---------------------	
* 2. Estimate AR model
*---------------------
// We expect growth rates to be serially correlated (persistence) as the virus spreads.	
// we take the optimal lags as suggested by the stationarity tests	
	
	arima dln_cases, ar(7)
	
// check AC and PAC
	ac dln_cases, lags(20)
	pac dln_cases, lags(20)	
	
// The AC shows a decaying pattern.
// In the PAC , only the first peak is negative and statistically significant. 
// This is the typical pattern that the AC and PAC follow in the presence of an AR() model.
	
	
// check that residuals follow a white noise process
	predict res_ar, resid
	corrgram res_ar, lags(20)

// Portmanteau statistics leading us to not reject the null hypothesis of no autocorrelation. (soso)
// We can therefore conclude that the model is correctly specified. 

*---------------------
* 3. Estimate MA model	
*---------------------
// normally MA model assumes the level of a r.v. at time t is affected by both
// time t and also previous times
// here we use it to smooth reporting delays
	arima dln_cases, ma(7)
	predict res_ma, resid
	corrgram res_ma, lags(20)
	
*---------------------	
* 4. Now do full ARIMA 	
*---------------------
	*arima dln_cases, arima(7,0,7)
	arima dln_cases, ar(7) ma(7)
	predict res_arma, resid
	corrgram res_arma, lags(20)
	
*------------------------------------	
* 5. Pick optimal model using AIC/BIC	
*------------------------------------
	forvalues ar = 1/7 {
		forvalues ma = 1/7 {
			eststo arma`ar'`ma': arima dln_cases, ar(`ar') ma(`ma')
		}	
	}
	estimates stats *
// eyeballing the results, actually arma31 gave the lowest AIC and BIC
// we pick that model for forecasting
	drop _est*

*---------------------
* 6. Forecasting ARIMA
*---------------------
use "$task1/output/covid_cases_bycountry", clear
	keep if country == "Belgium" 
	keep date cases country
	tsset date
	gen dln_cases = ln(cases/l.cases)
	
	// out of sample prediction
	tsappend, add(50)
	
	arima dln_cases, ar(7) ma(7)
	predict forecast_arma, xb
	tsline dln_cases forecast_arma, legend( on lab(1 observed) lab(2 forecasted))
	// not too bad!!
	
	// now pick dates with predicted growth rate (close to) zero 
	gen zero_date = 1 if abs(forecast) < 0.03
	
	// try with different thresholds
	
	// then lock in zero date if at least roughly 5 days predicted zero date, and pick that first date
	// first fill in gaps in timeseries where many 1's but still some gaps inbetween days
	// many 1s and a gap of 1 day inbetween 1's is ok
	*carryforward zero_date, gen(zero_filled)
	replace zero_date = 1 if missing(zero_date) & zero_date[_n-1] == 1 & zero_date[_n+1] == 1
	
	// identify spell lengths
	tsspell zero_date
	gen target_date = 1 if _seq >= 5 & zero_date == 1
	
	
	// fraction of cases out of total
	bys country: egen tot_cases = total(cases)
	bys country: gen share_cases = cases/tot_cases*100
	bys country: gen lnshare_cases = ln(share_cases)

// moving average	
	tsset date
	egen lnma_share_cases = filter(lnshare_cases), lags(0/$MA) normalise	
	drop if share_cases < 0.001	

// event: highest daily share (MA) = top, and t=0 	
	bys country: egen max = max(lnma_share_cases)
	bys country: gen top = (lnma_share_cases == max)
	bys country: gen count = _n
	fcollapse (min) count, by(top) merge
	by country: egen offset = max(min_count)
	gen event_time = count - offset
	drop top count min_count max

//sync events
	tsset event_time
	duplicates drop event_time ,force
	tsline lnma_share_cases, recast(connected) lwidth(medthick)
	
*---------------------------------------------	
* 7. Calculate predicted cases for future days	
*---------------------------------------------


	
/*	
// more formally, using the forecast suite of Stata	
	eststo clear
	forecast clear
	eststo model1: arima dln_cases, ar(3) ma(1)
	forecast create my_arima
	forecast estimates model1 
	forecast solve, prefix(fc_) begin(21914) end (22012)	// within sample forecasting
	tsline dln_cases forecast_arma, legend( on lab(1 observed) lab(2 forecasted))
*/	
	
	
	
	
	
*-----------------------------------
* 1. growth rates and polynomial fit
*-----------------------------------
use "$task1/output/covid_cases_bycountry", clear
	keep if country == "China" 
	
// moving average	
	xtset cty date
	gen gr_cases = cases/cum_cases*100
	egen ma_cases = filter(gr_cases), lags(0/3) normalise
	
//sync events
	drop if cum_cases < 100
	bys country: gen event_time = _n
	xtset cty event_time

// fit 4th degree polynomial

	fp ma_cases
	
	
	pfit ma_cases event_time, estopts(degree(4))	
// forecast



	tsset event_time
	
	forecast create, replace
	var ma_cases, lags(1/3)
	forecast estimates var_lag5
	tsappend, add(200)
	 forecast solve, prefix(fc5) begin(78) end(200)
	
// graph	
*twoway (tsline ma_cases) (fpfit ma_cases event_time, estopts(degree(4)))	
	twoway (tsline fc5ma_cases) 
	(fpfit ma_cases event_time, estopts(degree(4)))	
////////////////////////////////////////////////////////////////////////	
*---------------------------------------
* 4. Growth rate cases, since 100th case
*---------------------------------------
// load data
use "$task1/output/covid_cases_bycountry", clear
	merge m:1 country using "$task1/output/world_population_2020", ///
	nogen keep(match) keepusing(population)
	
// moving average	
	xtset cty date
	gen gr_cases = cases/cum_cases*100
	egen ma_cases = filter(gr_cases), lags(0/3) normalise
	
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
	
// graph
	foreach country in `countrylist' {
		local line `line' (tsline ma_cases ///
		if country == "`country'", recast(connected) lwidth(medthick))  ||
	}
	twoway `line', ///
	legend(on size(small) `legend') xoverhangs ylab(0(10)50) ///
	ysize(7) xsize(7) note("$ref_source" "$ref_data") ///
	title("Growth rate", size(medium)) ///
	ytitle("growth rate (%), 3-day MA") ///
	xtitle("Days since 100th case") 
	macro drop _line
	graph export "./output/global_growthcases_post100.svg", replace	
	
*---------------------------------	
* 1. China epicurve + growth rates	
*---------------------------------
use "$task1/output/covid_cases_bycountry", clear
	keep if country == "China" 
	
// fraction of cases out of total
	egen tot_cases = total(cases)
	gen share_cases = cases/tot_cases*100
	gen lnshare_cases = ln(share_cases)
	
// growth rate
	xtset cty date
	gen gr_cases = cases/cum_cases*100	

// moving average	
	egen lnma_share_cases = filter(lnshare_cases), lags(0/3) normalise	
	egen ma_gr_cases = filter(gr_cases), lags(0/3) normalise	

	
	drop if share_cases < 0.001
// event: highest daily share (MA) = top, and t=0 	
	bys country: egen max = max(lnma_share_cases)
	gen top = (lnma_share_cases == max)
	gen count = _n
	fcollapse (min) count, by(top) merge
	qui su min_count
	local offset = `r(max)'
	gen event_time = count - `offset' 
	drop top count min_count max

//sync events
	xtset cty event_time
	
// graph	
	twoway (line lnshare_cases event_time, yaxis(1)) ///
	(line ma_gr_cases event_time, yaxis(2))  
	
*---------------------------------------
* 4. Growth rate cases, since 100th case
*---------------------------------------
// load data
use "$task1/output/covid_cases_bycountry", clear
	merge m:1 country using "$task1/output/world_population_2020", ///
	nogen keep(match) keepusing(population)
	
// moving average	
	xtset cty date
	gen gr_cases = cases/cum_cases*100
	*gen gr_cases = lncases - l.lncases
	egen ma_cases = filter(gr_cases), lags(0/3) normalise
	
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
	
// graph
	foreach country in `countrylist' {
		local line `line' (tsline ma_cases ///
		if country == "`country'", recast(connected) lwidth(medthick))  ||
	}
	twoway `line', ///
	legend(on size(small) `legend') xoverhangs ylab(0(10)50) ///
	ysize(7) xsize(7) note("$ref_source" "$ref_data") ///
	title("Growth rate", size(medium)) ///
	ytitle("growth rate (%), 3-day MA") ///
	xtitle("Days since 100th case") 
	macro drop _line
	graph export "./output/global_growthcases_post100.svg", replace	

	
	* This Version: April 3, 2020
* First Version: April 3, 2020
* Author: Glenn Magerman

local MA = 3

*---------
* 1. China
*---------

	
*----------------	
* 2. top 10 cases
*----------------
use "$task1/output/covid_cases_bycountry", clear
	
// fraction of cases out of total
	bys country: egen tot_cases = total(cases)
	bys country: gen share_cases = cases/tot_cases*100
	bys country: gen lnshare_cases = ln(share_cases)
		
// moving average	
	xtset cty date
	egen lnma_share_cases = filter(lnshare_cases), lags(0/`MA') normalise	
	
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
		local line `line' (tsline lnma_share_cases ///
		if country == "`country'", recast(connected) lwidth(medthick))  ||
	}
	twoway `line', ///
	legend(on size(small) `legend') xoverhangs ///
	ysize(7) xsize(7) note("$ref_source" "$ref_data") ///
	title("Epicurve cases, top 10 world", size(medium)) ///
	ytitle("% of total cases (`MA'-day MA)") xtitle("Days relative to epidemic midpoint") ///
	ylab(-6.9 "10{sup:-3}" -4.6 "10{sup:-2}" -2.3 "10{sup:-1}" 0 "10{sup:0}" 2.3 "10{sup:1}")
	macro drop _line
	graph export "./output/global_epicurve_cases.svg", replace 
	

