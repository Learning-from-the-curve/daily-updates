* Version: March 24, 2020
* Author: Glenn Magerman

// change to directory of task
cd "$task3"

// initialize task (build from inputs)
foreach dir in tmp output {
	cap !rm -rf "./`dir'"
}

// create task folders
foreach dir in input src output tmp {
	cap !mkdir "./`dir'"
}	
	
// code	
	do "./src/1. global.do"
	do "./src/2. EU.do"
	do "./src/3. Belgium.do"
	
// maintenance
cap !rm -rf "./tmp"									// Linux/Mac
cap !rmdir /q /s "./tmp"							// Windows		

// back to main folder of tasks
cd "$folder"		
