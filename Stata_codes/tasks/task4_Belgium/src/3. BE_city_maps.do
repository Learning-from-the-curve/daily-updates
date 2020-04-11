* First Version: April 4, 2020
* This Version: April 2, 2020
* Author: Glenn Magerman

// cannot do death by nis, or new cases by nis

*---------------------
* 1. Import shapefiles
*---------------------
// from geo.be
local files "AD_2_Municipality"
foreach file in `files' {
	spshape2dta "./input/shapefiles/`file'"	, replace
	copy "./`file'.dta" "./tmp/`file'.dta", replace
	copy "./`file'_shp.dta" "./tmp/`file'_shp.dta", replace
	!rm "./`file'.dta"
	!rm "./`file'_shp.dta"
}	

*-----------------------	
* 2. Total cases, by NIS	
*-----------------------
cd "$task4/tmp"
use "$task1/output/Belgium_CASES_MUNI_CUM", clear
	keep nis5 tx_descr_nl cases
	ren (nis5 tx_descr_nl) (NISCode city)
	destring cases, force replace
	
// merge with polygons for map
	merge m:1 NIS using "AD_2_Municipality", nogen keep(match using)

// graph	
	grmap cases, clnumber(9) note("$ref_source" "$ref_data2") title("Total cases", size(medium))
	graph export "$task4/output/BE_cumcases_bycity.svg", replace

*----------------------------	
* 3. Per capita cases, by NIS	
*----------------------------
use "$task1/output/Belgium_CASES_MUNI_CUM", clear
	keep nis5 tx_descr_nl cases
	ren (nis5 tx_descr_nl) (NISCode city)
	destring cases, force replace
	
// merge with population
	merge 1:1 NIS using "$task1/output/Belgium_pop_bynis", nogen keepusing(Totaal)
	ren Totaal population
	
// merge with polygons for map
	merge m:1 NIS using "AD_2_Municipality", nogen keep(match using)
	gen sh_pop = round(cases/population*100, 0.01)
	
// graph	
	grmap sh_pop, clnumber(9) note("$ref_source" "$ref_data2") title("Cases (% of population)", size(medium))
	graph export "$task4/output/BE_share_cases_bycity.svg", replace

	
cd $task4
