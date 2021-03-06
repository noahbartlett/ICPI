**   Data Pack
**   COP FY17
**   Aaron Chafetz
**   Purpose: generate output for Excel based IM targeting Data Pack appendix
**   Date: December 10, 2016
**   Updated: 1/25/17

*** SETUP ***

*define date for Fact View Files
	global datestamp "20161230_v2_2"

*set today's date for saving
	global date: di %tdCCYYNNDD date(c(current_date), "DMY")

*import/open data
	capture confirm file "$fvdata/ICPI_FactView_PSNU_IM_${datestamp}.dta"
		if !_rc{
			use "$fvdata/ICPI_FactView_PSNU_IM_${datestamp}.dta", clear
		}
		else{
			import delimited "$fvdata/ICPI_FactView_PSNU_IM_${datestamp}.txt", clear
			save "$fvdata/ICPI_FactView_PSNU_IM_${datestamp}.dta", replace
		}
		*end


*clean
	run "$dofiles/06_datapack_dup_snus"
	rename ïregion region
	replace psnu = "[no associated SNU]" if psnu==""

*update all partner and mech to offical names (based on FACTS Info)
	run "$dofiles/05_datapack_officialnames"

*generate a dup im for all OUs
	preserve
	*collapse to unique list of psnus
		replace mechanismid = 0
		collapse mechanismid, fast by(operatingunit psnuuid psnu)

	*create a dsd and ta dedup mech for every snu
		expand 2, gen(new)
		gen indicatortype =""
			replace indicatortype="DSD" if new==1
			replace indicatortype="TA" if new==0
		drop new
	*save
		save "$output/temp_snu_dups", replace
	restore

* gen vars for distro tabs (see 01_datapack_outputs)
	*HTC_TST
		gen htc_tst = fy2016apr if indicator=="HTC_TST" & disaggregate=="Total Numerator" & numeratordenom=="N"
	*HTC_TST [CBTC]
		gen htc_tst_cbtc = fy2016apr if indicator=="HTC_TST" & disaggregate=="ServiceDeliveryPoint/Result" & inlist(otherdisaggregate, "Home-based", "Mobile") & numeratordenom=="N"
	*HTC_TST [PITC]
		gen htc_tst_pitc = fy2016apr if indicator=="HTC_TST" & disaggregate=="ServiceDeliveryPoint/Result" & inlist(otherdisaggregate, "Inpatient","HIV Care and Treatment Clinic", "Outpatient Department", "Other Service Delivery Point") & numeratordenom=="N"
	*HTC_TST [VCT]
		gen htc_tst_vct = fy2016apr if indicator=="HTC_TST" & disaggregate=="ServiceDeliveryPoint/Result" & inlist(otherdisaggregate, "Voluntary Counseling & Testing standalone", "Voluntary Counseling & Testing co-located") & numeratordenom=="N"
	*KP_MAT
		gen kp_mat = fy2016apr if indicator=="KP_MAT" & disaggregate=="Total Numerator" & numeratordenom=="N"
	*KP_PREV_FSW
		gen kp_prev_fsw = fy2016apr if indicator=="KP_PREV" & disaggregate=="KeyPop" & otherdisaggregate=="FSW" & numeratordenom=="N"
	*KP_PREV_MSMTG
		gen kp_prev_msmtg = fy2016apr if indicator=="KP_PREV" & disaggregate=="KeyPop" & otherdisaggregate=="MSM/TG" & numeratordenom=="N"
	*KP_PREV_PWID
		gen kp_prev_pwid = fy2016apr if indicator=="KP_PREV" & disaggregate=="KeyPop"& inlist(otherdisaggregate, "Female PWID", "Male PWID") & numeratordenom=="N"
	*OVC_SERV
		gen ovc_serv = fy2016apr if indicator=="OVC_SERV" & disaggregate=="Total Numerator" & numeratordenom=="N"
	*PMTCT_ARV
		gen pmtct_arv = fy2016apr if indicator=="PMTCT_ARV" & disaggregate=="Total Numerator" & numeratordenom=="N"
	*PMTCT_EID
		gen pmtct_eid = fy2016apr if indicator=="PMTCT_EID" & disaggregate=="Total Numerator" & numeratordenom=="N"
	*PMTCT_STAT
		gen pmtct_stat = fy2016apr if indicator=="PMTCT_STAT" & disaggregate=="Total Numerator" & numeratordenom=="N"
	*PMTCDT_STAT_POS
		gen pmtct_stat_pos = fy2016apr if indicator=="PMTCT_STAT" & disaggregate=="Known/New" & numeratordenom=="N"
	*PP_PREV
		gen pp_prev = fy2016apr if indicator=="PP_PREV" & disaggregate=="Total Numerator" & numeratordenom=="N"
	*TX_CURR <1 [=EID]
		gen tx_curr_u1_fy18 = fy2016apr if indicator=="PMTCT_EID" & disaggregate=="Total Numerator" & numeratordenom=="N"
	*TX_CURR 1-14
		gen tx_curr_1to14 = fy2016apr if indicator=="TX_CURR" & disaggregate=="Age/Sex" & inlist(age, "01-04", "05-14") & numeratordenom=="N"
	*TX_CURR 15+
		gen tx_curr_o15 = fy2016apr if indicator=="TX_CURR" & disaggregate=="Age/Sex" & inlist(age, "15-19", "20+") & numeratordenom=="N"
	*VMMC_CIRC
		gen vmmc_circ = fy2016apr if indicator=="VMMC_CIRC" & disaggregate=="Total Numerator" & numeratordenom=="N"
		
	*fix TX_CURR disaggs
	/*J. Houston
	- TX_CURR: fine disags for all countries except (coarse) Mozambique and Vietnam, (fine + coarse)  Uganda and South Africa */
	replace tx_curr_1to14 = . if inlist(operatingunit, "Mozambique", ///
		"South Africa", "Uganda", "Vietnam")
	replace tx_curr_1to14 = fy2016apr if indicator=="TX_CURR" & inlist(disaggregate, "Age/Sex", "Age/Sex Aggregated", "Age/Sex, Aggregated") & inlist(age, "01-04", "05-14", "01-14") & numeratordenom=="N" & inlist(operatingunit, "Uganda", "South Africa")
	replace tx_curr_1to14 = fy2016apr if indicator=="TX_CURR" & inlist(disaggregate, "Age/Sex Aggregated", "Age/Sex, Aggregated") & age=="01-14" & numeratordenom=="N" & inlist(operatingunit, "Mozambique", "Vietnam")
	replace tx_curr_o15 = fy2016apr if indicator=="TX_CURR" & inlist(disaggregate, "Age/Sex", "Age/Sex Aggregated", "Age/Sex, Aggregated") & inlist(age, "15-19", "20+", "15+") & numeratordenom=="N" & inlist(operatingunit, "Uganda", "South Africa")
	replace tx_curr_o15 = fy2016apr if indicator=="TX_CURR" & inlist(disaggregate, "Age/Sex Aggregated", "Age/Sex, Aggregated") & inlist(age, "15+") & numeratordenom=="N" & inlist(operatingunit, "Mozambique", "Vietnam")

* keep just one dedup mechanism
	replace mechanismid = 0 if mechanismid==1
* append dup ims
	append using "$output/temp_snu_dups"
	
* aggregate up to PSNU level
	drop fy*
	tostring mechanismid, replace
	ds *, not(type string)
	foreach v in `r(varlist)'{
		rename `v' val_`v'
		}
	*end

*collapse
	collapse (sum) val_*, by(operatingunit psnu psnuuid indicatortype mechanismid)
*sort
	sort operatingunit indicatortype mechanismid psnu
*distro
	ds val_*
	foreach v in `r(varlist)' {
		egen `v'_tot = total(`v'), by(operatingunit psnuuid)
		gen `=subinstr("`v'", "val_","D_",.)'_fy18 = `v'/`v'_tot
		}
		*end
	drop val_*
*clean up
	recode D_* (0 = .)
	destring mechanismid, replace
	local varlist D_tx_curr_1to14_fy18 ///
		D_tx_curr_o15_fy18	D_tx_curr_u1_fy18 D_pmtct_arv_fy18 ///
		D_pmtct_eid_fy18 D_pmtct_stat_fy18 D_pmtct_stat_pos_fy18 ///
		D_vmmc_circ_fy18	D_htc_tst_fy18	D_htc_tst_pitc_fy18	D_htc_tst_vct_fy18 ///
		D_htc_tst_cbtc_fy18	D_ovc_serv_fy18	D_kp_prev_pwid_fy18 ///
		D_kp_prev_msmtg_fy18 D_kp_prev_fsw_fy18	D_pp_prev_fy18 ///
		D_kp_mat_fy18
	foreach v in `varlist'{
		capture confirm variable `v'
		if _rc gen `v' = .
		}
		*end
	gen placeholder = .
	order operatingunit psnuuid psnu placeholder mechanismid indicatortype `varlist'
	sort operatingunit psnu mechanismid indicatortype

*export
	export excel using "$dpexcel/Global_PSNU_${date}.xlsx", ///
		sheet("Allocation by IM") firstrow(variables) sheetreplace
