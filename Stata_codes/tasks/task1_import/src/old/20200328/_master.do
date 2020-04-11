* Version: March 24, 2020
* Author: Glenn Magerman

// change to directory of task
clear all
cd "$task1"

// initialize task (build from inputs)
foreach dir in tmp output {
	cap !rm -rf "./`dir'"
}

// create task folders
foreach dir in input src output tmp {
	cap !mkdir "./`dir'"
}	
	
// code	
	do "./src/1. ECDC_cases.do" 					
	do "./src/2. population.do" 
	do "./src/3. Oxford_policies.do" 
	
// maintenance
cap !rm -rf "./tmp"									// Linux/Mac
cap !rmdir /q /s "./tmp"							// Windows		

// back to main folder of tasks
cd "$folder"		
