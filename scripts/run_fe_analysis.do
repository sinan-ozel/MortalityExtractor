cls
set matsize 11000
set more off
clear

* ssc install estout

cd D:/Home/Academic/Research/MAL_and_Mortality_Final

local data_version = "3.5"
local filename_prefix = "mortality"
* local filename_prefix = "ischaemic_attack_mortality"
* local filename_prefix = "cancer_mortality"
* local filename_prefix = "lung_cancer_mortality"
* local filename_prefix = "suicide_mortality"

use processed_data/`filename_prefix'_by_state_v`data_version'.dta, clear
local results_filename results/`filename_prefix'_fe_results


local year_start = 1969
local year_end = 2004

local lags = 5


local replaceonce replace

local weights = ""

foreach lhs in "female_black" "male_black" "female_white" "male_white"{
	* Generate mortality rate
	gen `lhs'_mortality = (`lhs'_deaths / pop_`lhs') * 100000
	label variable `lhs'_mortality "`=strproper(subinstr("`lhs'_mortality", "_", " ", 10))'"
}

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
	generate lag_`treatment'_LT = L`=`lags'+1'.`treatment'
	local treatment_with_lags = "`treatment_with_lags' lag_`treatment'_LT"

	* Drop territories
	drop if staters=="ZZ"
	drop if staters=="PR"
	drop if staters=="VI"
	drop if staters=="GU"
	drop if staters=="AS"

	foreach x in "`treatment'" "`treatment_with_lags'"{

		foreach lhs in "female_black" "male_black" "female_white" "male_white"{

			if "`x'" == "`treatment'"{
				local tex_filename manuscript/tables/`lhs'_`filename_prefix'_fe.tex
			}
			else{
				local tex_filename manuscript/tables/`lhs'_`filename_prefix'_fe_lags_`lags'.tex
			}

			eststo clear

			local spec 1
			reg `lhs'_mortality `x' i.state i.year `weights' if year>=`year_start' & year<=`year_end' `cond', vce(cluster state)
			eststo
			regsave `x' using `results_filename'.dta, pval addlabel(lhs, `lhs', specification, `spec') `replaceonce'
			local replaceonce append

			local spec `=`spec' + 1'
			reg `lhs'_mortality `x' i.state i.year employment real_gdp personal_income `weights' if year>=`year_start' & year<=`year_end' `cond', vce(cluster state)
			eststo
			regsave `x' using `results_filename'.dta, pval addlabel(lhs, `lhs', specification, `spec') append
			
			local spec `=`spec' + 1'
			reg `lhs'_mortality `x' i.state i.year employment real_gdp personal_income hs_dem_majority sen_dem_majority `weights' if year>=`year_start' & year<=`year_end' `cond', vce(cluster state)
			eststo
			regsave `x' using `results_filename'.dta, pval addlabel(lhs, `lhs', specification, `spec') append
			
			local spec `=`spec' + 1'
			reg `lhs'_mortality `x' i.state i.year employment real_gdp personal_income i.state#c.year `weights' if year>=`year_start' & year<=`year_end' `cond', vce(cluster state)
			eststo
			regsave `x' using `results_filename'.dta, pval addlabel(lhs, `lhs', specification, `spec') append
			
			local spec `=`spec' + 1'
			reg `lhs'_mortality `x' i.state i.year employment real_gdp personal_income hs_dem_majority sen_dem_majority i.state#c.year `weights' if year>=`year_start' & year<=`year_end' `cond', vce(cluster state)
			eststo
			regsave `x' using `results_filename'.dta, pval addlabel(lhs, `lhs', specification, `spec') append
			
			local spec `=`spec' + 1'
			xtpoisson `lhs'_mortality `x' i.state i.year `weights' if year>=`year_start' & year<=`year_end' `cond', fe vce(robust)
			eststo
			regsave `x' using `results_filename'.dta, pval addlabel(lhs, `lhs', specification, `spec') append
			
			local spec `=`spec' + 1'
			xtpoisson `lhs'_mortality `x' i.state i.year employment real_gdp personal_income `weights' if year>=`year_start' & year<=`year_end' `cond', fe vce(robust)
			eststo
			regsave `x' using `results_filename'.dta, pval addlabel(lhs, `lhs', specification, `spec') append
			
			local spec `=`spec' + 1'
			xtpoisson `lhs'_mortality `x' i.state i.year employment real_gdp personal_income hs_dem_majority sen_dem_majority `weights' if year>=`year_start' & year<=`year_end' `cond', fe vce(robust)
			eststo
			regsave `x' using `results_filename'.dta, pval addlabel(lhs, `lhs', specification, `spec') append
			
			local spec `=`spec' + 1'
			xtpoisson `lhs'_mortality `x' i.state i.year employment real_gdp personal_income i.state#c.year `weights' if year>=`year_start' & year<=`year_end' `cond', fe vce(robust)
			eststo
			regsave `x' using `results_filename'.dta, pval addlabel(lhs, `lhs', specification, `spec') append

			local spec `=`spec' + 1'
			xtpoisson `lhs'_mortality `x' i.state i.year employment real_gdp personal_income hs_dem_majority sen_dem_majority i.state#c.year `weights' if year>=`year_start' & year<=`year_end' `cond', fe vce(robust)
			eststo
			regsave `x' using `results_filename'.dta, pval addlabel(lhs, `lhs', specification, `spec') append

			#delimit ;
			esttab using `tex_filename', 
				se
				label
				replace
				indicate(
					"Economics Controls = employment real_gdp personal_income"
					"Political Controls = *_dem_*"
					"State Time Trends = *state#c.year"
					"Year FE = *year"
					"State FE = *state"
				)
				drop(_cons)
				star(* 0.10 ** 0.05 *** 0.01)
				long;
			#delimit cr

		}

	}
}



use `results_filename'.dta, clear
outsheet using `results_filename'.csv, comma replace
list
