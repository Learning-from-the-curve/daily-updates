* Version: April 6, 2020
* Author: Glenn Magerman

// change to directory of task
cd "$task2"
	
// code	
	do "./src/1. tsplot_date.do" 		
	do "./src/2. tsplot_event.do" 		
	do "./src/3. tsplot_logs_cases.do"
 	do "./src/4. tsplot_logs_deaths.do"
	do "./src/5. tsplot_epicurve.do"
	
// back to main folder of tasks
cd "$folder"		
