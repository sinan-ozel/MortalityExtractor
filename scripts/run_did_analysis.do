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
local results_filename results/`filename_prefix'_did_results


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

local treatment "mand_n_rec"
local control "discretionary"

run treatment/`treatment'.do


* Drop territories
drop if staters=="ZZ"
drop if staters=="PR"
drop if staters=="VI"
drop if staters=="GU"
drop if staters=="AS"

generate after = `treatment' | discretionary


foreach x in "`treatment'"{

	foreach lhs in "female_black" "male_black" "female_white" "male_white"{

		local tex_filename manuscript/tables/`lhs'_`filename_prefix'_did.tex

		eststo clear

		local spec 1
		reg `lhs'_mortality `x' after treatment_state if within_neighborhood == 1 `cond', vce(cluster state)
		eststo
		regsave `x' using `results_filename'.dta, pval addlabel(lhs, `lhs', specification, `spec') `replaceonce'
		local replaceonce append

		local spec `=`spec' + 1'
		reg `lhs'_mortality `x' after treatment_state employment real_gdp personal_income if within_neighborhood == 1 `cond', vce(cluster state)
		eststo
		regsave `x' using `results_filename'.dta, pval addlabel(lhs, `lhs', specification, `spec') append

		local spec `=`spec' + 1'
		reg `lhs'_mortality `x' after treatment_state employment real_gdp personal_income hs_dem_majority sen_dem_majority if within_neighborhood == 1 `cond', vce(cluster state)
		eststo
		regsave `x' using `results_filename'.dta, pval addlabel(lhs, `lhs', specification, `spec') append

		local spec `=`spec' + 1'
		poisson `lhs'_mortality `x' after treatment_state if within_neighborhood == 1 `cond', vce(cluster state)
		eststo
		regsave `x' using `results_filename'.dta, pval addlabel(lhs, `lhs', specification, `spec') append

		local spec `=`spec' + 1'
		poisson `lhs'_mortality `x' after treatment_state employment real_gdp personal_income if within_neighborhood == 1 `cond', vce(cluster state)
		eststo
		regsave `x' using `results_filename'.dta, pval addlabel(lhs, `lhs', specification, `spec') append

		local spec `=`spec' + 1'
		poisson `lhs'_mortality `x' after treatment_state employment real_gdp personal_income hs_dem_majority sen_dem_majority if within_neighborhood == 1 `cond', vce(cluster state)
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

			)
			drop(_cons)
			star(* 0.10 ** 0.05 *** 0.01)
			long;
		#delimit cr

	}

}



use `results_filename'.dta, clear
outsheet using `results_filename'.csv, comma replace
list
