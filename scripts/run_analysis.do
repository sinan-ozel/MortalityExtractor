cls
set matsize 11000
set more off
clear

cd D:/Home/Academic/Research/MAL_and_Mortality_Final

local data_version = "3.4"
local filename_prefix = "mortality"
* local ischaemic_attack_mortality

use processed_data/`filename_prefix'_by_state_v`data_version'.dta, clear
local results_filename results/`filename_prefix'_results.dta


local year_start = 1969
local year_end = 2004

local lags = 5


local replaceonce replace

local weights = ""

foreach treatment in "mand_n_rec"{
	run treatment/`treatment'.do

	* Set panel and time variables
	* Needed for lags and for xtpoisson command
	capture encode staters, gen(state)
	xtset state year

	* Generate lags
	generate lag_`treatment'_00 = D.`treatment'
	replace lag_`treatment'_00 = 0 if lag_`treatment'_00==.
	local treatment_with_lags = "lag_`treatment'_00"
	forvalues lag = 1/`lags'{
		local suffix = string(`lag',"%02.0f")
		generate lag_`treatment'_`suffix' = L`lag'.lag_`treatment'_00
		local treatment_with_lags = "`treatment_with_lags' lag_`treatment'_`suffix'"
	}
	local suffix = string(`=`lags'+1',"%02.0f")
	generate lag_`treatment'_`suffix' = L`=`lags'+1'.`treatment'
	local treatment_with_lags = "`treatment_with_lags' lag_`treatment'_`suffix'"

	* Drop territories
	drop if staters=="ZZ"
	drop if staters=="PR"
	drop if staters=="VI"
	drop if staters=="GU"
	drop if staters=="AS"

	foreach lhs in "female_black" "female_black_over_50"{
		* Generate mortality rate
		gen `lhs'_mortality = (`lhs'_deaths / pop_`lhs') * 100000

		foreach x in "`treatment'" "`treatment_with_lags'"{
		

			local spec 1
			reg `lhs'_mortality `x' i.state i.year `weights' if year>=`year_start' & year<=`year_end' `cond', vce(cluster state)
			regsave `x' using `results_filename', pval addlabel(lhs, `lhs', specification, `spec') `replaceonce'
			local replaceonce append

			local spec `=`spec' + 1'
			reg `lhs'_mortality `x' i.state i.year employment real_gdp personal_income `weights' if year>=`year_start' & year<=`year_end' `cond', vce(cluster state)
			regsave `x' using `results_filename', pval addlabel(lhs, `lhs', specification, `spec') append
			
			local spec `=`spec' + 1'
			reg `lhs'_mortality `x' i.state i.year employment real_gdp personal_income hs_dem_majority sen_dem_majority `weights' if year>=`year_start' & year<=`year_end' `cond', vce(cluster state)
			regsave `x' using `results_filename', pval addlabel(lhs, `lhs', specification, `spec') append
			
			local spec `=`spec' + 1'
			reg `lhs'_mortality `x' i.state i.year employment real_gdp personal_income hs_dem_majority sen_dem_majority i.state#c.year `weights' if year>=`year_start' & year<=`year_end' `cond', vce(cluster state)
			regsave `x' using `results_filename', pval addlabel(lhs, `lhs', specification, `spec') append
			
			local spec `=`spec' + 1'
			xtpoisson `lhs'_mortality `x' i.year `weights' if year>=`year_start' & year<=`year_end' `cond', fe vce(robust)
			regsave `x' using `results_filename', pval addlabel(lhs, `lhs', specification, `spec') append
			
			local spec `=`spec' + 1'
			xtpoisson `lhs'_mortality `x' i.year employment real_gdp personal_income `weights' if year>=`year_start' & year<=`year_end' `cond', fe vce(robust)
			regsave `x' using `results_filename', pval addlabel(lhs, `lhs', specification, `spec') append
			
			local spec `=`spec' + 1'
			xtpoisson `lhs'_mortality `x' i.year employment real_gdp personal_income hs_dem_majority sen_dem_majority `weights' if year>=`year_start' & year<=`year_end' `cond', fe vce(robust)
			regsave `x' using `results_filename', pval addlabel(lhs, `lhs', specification, `spec') append
			
			local spec `=`spec' + 1'
			xtpoisson `lhs'_mortality `x' i.year employment real_gdp personal_income hs_dem_majority sen_dem_majority i.state#c.year `weights' if year>=`year_start' & year<=`year_end' `cond', fe vce(robust)
			regsave `x' using `results_filename', pval addlabel(lhs, `lhs', specification, `spec') append
		}
	}
}

use `results_filename', clear
list
