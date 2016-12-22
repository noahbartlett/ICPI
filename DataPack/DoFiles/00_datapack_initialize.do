**   Data Pack
**   COP FY17
**   Aaron Chafetz
**   Purpose: Initialize folder structure and global file paths
**   Adapted from Tim Essam, USAID
**   Date: November 29, 2016
**   Updated: 12/22/16

** SET DIRECTORIES **

	clear
	set more off

*  must be run each time Stata is opened
	/* Choose the project path location to where you want the project parent 
	   folder to go on your machine. Make sure it ends with a forward slash */
	global projectpath "C:/Users/achafetz/Documents/GitHub/ICPI"
	cd "$projectpath"
	
* Run a macro to set up study folder
	* Name the file path below
	local pFolder DataPack
	foreach dir in `pFolder' {
		confirmdir "`dir'"
		if `r(confirmdir)'==170 {
			mkdir "`dir'"
			display in yellow "Project directory named: `dir' created"
			}
		else disp as error "`dir' already exists, not created."
		cd "$projectpath/`dir'"
		}
	* end

* Run initially to set up folder structure
* Choose your folders to set up as the local macro `folders'
	local folders RawData StataOutput ExcelOutput DoFiles
	foreach dir in `folders' {
		confirmdir "`dir'"
		if `r(confirmdir)'==170 {
				mkdir "`dir'"
				disp in yellow "`dir' successfully created."
			}
		else disp as error "`dir' already exists. Skipped to next folder."
	}
	*end
*Set up global file paths located within project path
	*these folders must exist in the parent folder
	global projectpath `c(pwd)'
	global data "$projectpath/RawData"
	global output "$projectpath/StataOutput"
	global excel "$projectpath/ExcelOutput"
	global dofiles "$projectpath/DoFiles"
	*these folders paths are in a seperate file location due to data size and usage
	*you can change these directories to point to $data & $excel and $output, respectively
	global fvdata "C:/Users/achafetz/Documents/ICPI/Data"
	global dpexcel "C:/Users/achafetz/Documents/DataPack/DataPulls"

	disp as error "If initial setup, move data to RawData folder."
	
	

********************************************************************************
********************************************************************************
	
