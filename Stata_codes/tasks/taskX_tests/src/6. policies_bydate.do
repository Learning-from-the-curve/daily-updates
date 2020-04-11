* This version: April 5, 2020
* First version: April 5, 2020
* Author: Glenn Magerman

*------------------------------
* Date of most stringent policy
*------------------------------
use "./output/stringency_bycountry", clear
	
	bys country: keep if s1_schoolclosing == 2
	sort country date
	by country: keep if _n == 1
	
	global BE_close_schools = 
