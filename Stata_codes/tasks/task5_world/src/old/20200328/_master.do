* Version: March 24, 2020
* Author: Glenn Magerman

// change to directory of task
clear all
cd "$task2"

// initialize task (build from inputs)
foreach dir in tmp output {
	cap !rm -rf "./`dir'"
}

// create task folders
foreach dir in input src output tmp {
	cap !mkdir "./`dir'"
}	
	
// code	
	do "./src/1. daily_global_cases.do"
 	do "./src/2. daily_global_deaths.do"
	do "./src/3. daily_EU_cases.do"
	do "./src/4. daily_EU_deaths.do"
	do "./src/5. daily_Belgium_cases.do"
	do "./src/6. daily_Belgium_deaths.do"
	
// maintenance
cap !rm -rf "./tmp"									// Linux/Mac
cap !rmdir /q /s "./tmp"							// Windows		

// back to main folder of tasks
cd "$folder"		
