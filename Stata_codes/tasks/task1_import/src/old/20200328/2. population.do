* Version: March 28, 2020
* Author: Glenn Magerman

*--------------------------------
* 2. Import world population data
*--------------------------------
import delimited "./input/world_population_2020.csv", case(lower) clear
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
