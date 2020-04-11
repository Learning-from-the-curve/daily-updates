* This version: April 2, 2020
* First version: April 2, 2020
* Author: Glenn Magerman

// change to directory of task
cd "$task4"

// initialize task (build from inputs)
foreach dir in tmp output {
	cap !rm -rf "./`dir'"
}

// create task folders
foreach dir in input src output tmp {
	cap !mkdir "./`dir'"
}	
	
// code	
	do "./src/1. BE_cases_hosp_bydate.do"
	do "./src/2. BE_cases_hosp_province.do"
	do "./src/3. BE_city_maps.do"
	do "./src/4. BE_epicurve.do"
	do "./src/5. BE_CDF_lifetable.do"

// maintenance
cap !rm -rf "./tmp"									// Linux/Mac
cap !rmdir /q /s "./tmp"							// Windows		

// back to main folder of tasks
cd "$folder"		
clear
