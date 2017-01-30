## Issues and Fixes to the Data Pack

updated: Jan 27

Here is a running list of issues that affect the Data Pack for SI and EA advisors to be aware of

1. Wrong columns referenced
    - Issue: Due some updated in the template, a few formulas point to the wrong reference columns
    - Affected Tab: SNU Targets for EA
    - Fix:
        1. Change the formulas in the 3 cells identified below, updating the column letter in bold (note that [LastColumn] will be the last row number in your Data Pack)
            * O7 =INDEX('Target Calculation'!$**BO**$5:$**BO**$[LastRow],MATCH(Tsnulist, snu,0))
            * Q7 =INDEX('Target Calculation'!$**BC**$5:$**BC**$[LastRow],MATCH(Tsnulist, snu,0))
            * U7 =INDEX('HTC Target Calculation'!**O**$5:**O**$[LastRow],MATCH(Tsnulist, snu,0))
        2. For each affected column (O, Q, U), copy the new formula down to all rows
2. KP_MAT data missing
    - Issue: The KP_MAT column in the IM distribution was missing data (only affected 5 OUs - Central Asia Region, India, Kenya, Tanzania, and Vietnam)
    - Affected Tab - Allocation by IM
    - Fix:
        1. SI advisors were identified regarding this issue, and provided either (a) the rows in column X to add KP_MAT % to if <5 rows affected, or (b) were issued new Data Packs and can be found on PEPFAR.net
3. VMMC included in EA HTC calculation
    - Issue: For the purposes of EA, VMMC and PMTCT test needs to be removed from the HTC to ensure we are not double counting those expenses in our Unit Expenditures. VMMC was mistakenly included in HTC total.
    - Affected Tab: SNU Targets for EA
    - Fix:
        1. Navigate to the HTC Target Calculation tab
        2. Unhide columns M through P
        3. Insert a new column after P
        4. In cell Q4, add the header title Total EA HTC
        5. Add a formula to columns M-P in column Q
            * Q7 = SUM(M7:P7)
        6. Copy this new formula down to all the rows in this column
        7. Navigate to the SNU Targets for EA tab
        8. Replace the formula in S7, HTC_TST(excluding PMTCT & VMMC), with the formula below
            * S7 = INDEX(**'HTC Target Calculation'!$Q$7:$Q$[LastRow]**,MATCH(Tsnulist, snu,0))
        9. Copy this formula down to the rest of the rows in the column

4. TX_CURR Patient Year calculation
    - Issue: The current formula to calculate the patient year uses PMTCT_EID as a proxy for TX_CURR <1 (which is used to get TX_CURR 1-15 from the TX_CUR <15 calcuated in the Data Pack). Since PMTCT_EID over estimates those on treatment since it includes negative tests as well, so TX_NEW <1 should be used instead (as is used for the FY18 calculation).
    - Affected Tab: SNU Targets for EA
    - Fix:
        1. Change the formula in cell F7 to point to the FY17 TX_NEW <1 Target located in the DATIM Indicator Table
            * F7 =INDEX(**tx_new_u1_T**,MATCH(Tsnulist,snulist,0))
        2. Copy the formula down to all rows in column F, TX_CURR (<1) [PMTCT_EID]
        3. Rename the header to TX_CURR (<1) [**TX_NEW <1**]
        
5. EA HTC pulling wrong from SNU list
    - Issue: The current formulas that pull the HTC data into the EA target tab use the wrong SNU list. They use SNU instead of SNU_HTC. This needs to be changed in four columns: "HTC_TST (excluding PMTCT & VMMC)" "HTC PITC" "HTC VCT" and "HTC CBCT"
    - Affected Tab: SNU Targets for EA
    - Fix:
        1. In columns S through V, search and replace "snu,0" with "snu_htc,0"
    
        
        
