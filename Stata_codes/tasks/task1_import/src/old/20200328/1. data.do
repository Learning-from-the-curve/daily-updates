* Version: March 24, 2020
* Author: Glenn Magerman

*---------------------------
* 1. Import world COVID data 
*---------------------------
import excel "./input/COVID-19-geographic-disbtribution-worldwide-2020-03-25.xlsx", ///
	firstrow case(lower) clear
	ren (daterep countriesandterritories geoid) (date country iso2)
	keep date day month year cases deaths country iso2
	
// harmonize country names	
	replace country = "UK" if country == "United_Kingdom"
	replace country = "USA" if country == "United_States_of_America"
	replace country = subinstr(country, "_", " ", .)
	replace country = "SouthKorea" if country == "South Korea"
	
// panel dimension
	encode country, gen(country2)
	xtset country2 date 

// calculate cumulative cases	
	bys country: gen cum_cases = sum(cases)
	bys country: gen cum_deaths = sum(deaths)
	
// gen logs	
	foreach x in cases deaths cum_cases cum_deaths {
		gen ln`x' = ln(`x')
	}		
	
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

	gen EU12 = 0
	replace EU12 = 1 if country == "Belgium" | country == "Denmark" | ///
	country == "France" | country == "Germany" | country == "Greece" | ///
	country == "Ireland" | country == "Italy" | country == "Luxembourg" | ///
	country == "Netherlands" | country == "Portugal" | country == "Spain" | ///
	country == "UK"	
	
// label vars for graphs	
	label var date Date
	label var day Day
	label var month Month
	label var year Year
	label var cases Cases
	label var deaths Deaths
	label var country Country
	label var iso2 Country
	label var lncases "Cases"
	label var lndeaths "Deaths"
	label var cum_cases "Total cases"
	label var cum_deaths "Total deaths"
	label var lncum_cases "Total cases"
	label var lncum_deaths "Total deaths"
save "./output/covid_cases_bycountry", replace	

*--------------------------------
* 2. Import world population data
*--------------------------------
import delimited "./input/world_population_2020.csv", ///
	case(lower) clear
	ren (name pop2019) (country population)
	drop pop2018
	
// population is in 1000s	
	replace population = population*1000
	
// harmonize country names	
	replace country = "UK" if country == "United Kingdom"	
	replace country = "USA" if country == "United States"	
	
// label vars for graphs
	label var rank Rank
	label var country Country
	label var population Population
	label var growthrate "Growth rate"
	label var area	Area
	label var density Density
	
save "./output/world_population_2020", replace	
