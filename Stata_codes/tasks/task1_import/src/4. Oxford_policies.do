* This version: March 29, 2020
* First version: March 29, 2020
* Author: Glenn Magerman

*--------------------------
* 1.Oxford data on policies
*--------------------------
// download latest policies data
import excel "https://www.bsg.ox.ac.uk/sites/default/files/OxCGRT_Download_latest_data.xlsx", clear firstrow case(lower) 
	ren (countryname countrycode)  (country iso3)
	*keep country iso3 date stringencyindex

// format dates for graphs	
	tostring date, gen(date2)
	gen date3 = date(date2, "YMD")
	drop date date2
	ren date3 date
	format date %td
	

// harmonize country names	
	replace country = "UK" if country == "United Kingdom"
	replace country = "USA" if country == "United States"
	replace country = "SouthKorea" if country == "South Korea"
	
// panel dimension
	encode country, gen(cty)
	xtset cty date	
	
// gen EU labels
	gen EU28 = 0
	replace EU28 = 1 if country == "Austria" | country == "Belgium" | ///
	country == "Bulgaria" | country == "Croatia" | country == "Cyprus" | ///
	country == "Czech Republic" | country == "Denmark" | country == "Estonia" | ///
	country == "Finland" | country == "France" | country == "Germany" | ///
	country == "Greece" | country == "Hungary" | country == "Ireland" | ///
	country == "Italy" | country == "Latvia" | country == "Lithuania" | ///
	country == "Luxembourg" | country == "Malta" | country == "Netherlands" | ///
	country == "Poland" | country == "Portugal" | country == "Romania" | ///
	country == "Slovakia" | country == "Slovenia" | country == "Spain" | ///
	country == "Sweden" | country == "UK"
	
// label vars for graphs	
	label var date Date
	label var stringencyindex "Stringency index"
	label var country Country
	label var EU28 "EU28 member"
save "./output/stringency_bycountry", replace	
