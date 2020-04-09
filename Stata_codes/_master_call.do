* This version: April 7, 2020
* First version: March 24, 2020
* Author: Glenn Magerman

// ado files
// install uncluttered from: https://github.com/graykimbrough/uncluttered-stata-graphs
// install pandoc from: https://pandoc.org/installing 
/* install from ssc
foreach package in blindschemes markstat spmap shp2dta mif2dta egenmore svmachines carryforward {
	cap which `package'
	if _rc == 111 ssc install `package'
}	
*/
	
// main folder
clear all
macro drop _all
qui di c(os)
if c(os) == "MacOSX" {
	global folder	"~/Dropbox/work/research/COVID19/projects/daily_updates/tasks"
}

else if c(os) == "Unix"	{
	global folder "/home/gmagerman/research/projects/COVID19/projects/daily_updates/tasks"
}	
	
cd "$folder"

// tasks
global task1		"$folder/task1_import"
global task2		"$folder/task2_functions"
global task3		"$folder/task3_macros"
global task4 		"$folder/task4_Belgium"
global task5		"$folder/task5_world"
global task6		"$folder/task6_EU"
global task7		"$folder/task7_report"

// constants
global top = 10
global MA = 3

// macro for today's date
local today: display %td_CCYY-NN-DD date(c(current_date), "DMY")
local today = subinstr("`today'", " ", "", .)
di "`today'"

// reference
*global ref_source 	"Source: https://github.com/Learning-from-the-curve."
*global ref_data 	"Authors' calculations based on ECDC and UN data." 
*global ref_data2 	"Authors' calculations based on Epistat data." 

// graph formatting
set scheme uncluttered
// colors from http://ksrowell.com/blog-visualizing-data/2012/02/02/optimal-colors-for-graphs/

// rebuild all tasks
do "$task1/src/_master.do"
do "$task2/src/_master.do"
do "$task3/src/_master.do"
do "$task4/src/_master.do"
do "$task5/src/_master.do"
do "$task6/src/_master.do"
*do "$task7/src/_master.do"
