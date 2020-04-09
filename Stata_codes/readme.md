## Description of Stata code and workflow

This folder contains the Stata code to generate the graphs and numbers in the daily reports. 
Everything here is unsupported unless otherwise stated. Use at your own risk.

The workflow is structured as follows.

### 1. The one that calls them all

The _master_call.do file calls all other files. Running this generates all output. No need to run other files.
Depending on your Stata configuration, you might need to install packages/ado files that are used in the programs (lines 5-15). 
You need to set the full path to a folder on your machine where you want the project to live (lines 15-25).
From there, the rest is just watching everything unfold.

The COVID data at ECDC is updated daily at 13:00 CET. Before that time, you need to call yesterday's date instead. For now, I have just added that option commented out in task1/src/1. ECDC_cases.do.

### 2. Tasks

The coding pipeline is structured in tasks. Each task has a master.do file that calls all other code and data in that task.
Each task is organized in the same way: 
  - input/ contains input files to be used in that task.
  - src/ contains all code (there is no "source" code in Stata, but what the heck).
  - output/ contains all produced results from the inputs that are passed through the code.

Here's a short description of each task.
  - Task 1, imports: calls all datasets online and saves them locally.
  - Task 2, functions: contains functions (Stata programs) I wrote to create the graphs.
  - Task 3, macros: generates all numbers that change daily in the report. The report is written in markdown, and calls these values.
  - Task 4, Belgium: runs all analysis for Belgium
  - Task 5, world: runs all analysis for the world
  - Task6, EU: same, but for EU28 countries.
  
  Here's a [great video](https://www.youtube.com/watch?v=ZSunU9GQdcI) by Patrick Ball on organizing code workflow into tasks.
  
### 3. Data sources

  - Detailed COVID data for Belgium from [Epistat](https://epistat.wiv-isp.be/covid/).
  - Vector maps for Belgium from [geo.be](geo.be).
  - Life tables for Belgium from [Statbel](https://statbel.fgov.be/sites/default/files/files/documents/bevolking/5.4%20Sterfte%2C%20levensverwachting%20en%20doodsoorzaken/5.4.3%20Sterftetafels%20en%20levensverwachting/sterftetafelsAE.xls).
  - COVID data by country around the world from [ECDC](https://qap.ecdc.europa.eu/public/extensions/COVID-19/COVID-19.html).
  - Country population data from [UN World population prospects](https://population.un.org/wpp/Download/Standard/Population/).


Thanks,
Glenn
