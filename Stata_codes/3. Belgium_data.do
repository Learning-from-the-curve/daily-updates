* This version: April 1, 2020
* First version: April 1, 2020
* Author: Glenn Magerman

*---------------------------
* 1. Daily data from Epistat
*---------------------------
// download today's data  
// note: drop CASES_MUNI and only use CASES_MUNI_CUM
foreach sheet in CASES_AGESEX CASES_MUNI CASES_MUNI_CUM HOSP MORT TESTS {
import excel "https://epistat.sciensano.be/Data/COVID19BE.xlsx", ///
	clear sheet("`sheet'") firstrow case(lower) 

// format dates for graphs
	cap {
	gen date2 = date(date, "YMD")
	format date2 %td
	drop date
	ren date2 date
	format date %td	
	}
// rename provinces correctly
	cap {
	replace province = "Brabant Wallon" if province == "BrabantWallon"
	replace province = "Vlaams Brabant" if province == "VlaamsBrabant"
	replace province = "Oost Vlaanderen" if province == "OostVlaanderen"
	replace province = "West Vlaanderen" if province == "WestVlaanderen"
	}
save "./output/Belgium_`sheet'", replace	
}

*-----------------------------
* 2. Population Belgium by NIS (1/1/2019) Statbel
*-----------------------------
import excel "https://statbel.fgov.be/sites/default/files/files/documents/bevolking/5.1%20Structuur%20van%20de%20bevolking/Bevolking_per_gemeente.xlsx", ///
	clear cellrange(A2) firstrow 
	drop if missing(NIScode)
	ren NIScode NISCode
save "./output/Belgium_pop_bynis", replace	

*--------------------------
* 3. continuous life tables (Statbel)
*--------------------------
// import all years available
forvalues t = 1994/2018 {
import excel "./input/sterftetafelsAE.xls", clear sheet("`t'") cellrange(B3) firstrow case(lower)
	ren (exact overlevendenlx n u) (age surv_male surv_female surv_all)
	keep age surv_male surv_female surv_all
	destring age, force replace ignore("+")
	drop if missing(age)
	
// calculate cumulative density
foreach sex in male female all {
		gen density_`sex' = 1 - surv_`sex'/1000000
	}	
	drop surv*
	gen year = `t'
save "./tmp/BE_lifetable_`t'", replace
} 	
use "./tmp/BE_lifetable_1994", clear
	forvalues t = 1995/2018 {
		append using  "./tmp/BE_lifetable_`t'"
	}	
save "./output/Belgium_lifetables", replace
