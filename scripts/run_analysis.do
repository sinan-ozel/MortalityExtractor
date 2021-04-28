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

local lhs = "female_black"

local weights = ""

local stderrs = "cluster state"

local x = "mand_n_rec"

run treatment/`x'.do

drop if staters=="ZZ"
drop if staters=="PR"
drop if staters=="VI"
drop if staters=="GU"
drop if staters=="AS"

gen `lhs'_mortality = (`lhs'_deaths / pop_`lhs') * 100000
gen ln_`lhs'_mortality = log(`lhs'_mortality)

capture encode staters, gen(state)
xtset state year

reg `lhs'_mortality `x' i.state i.year `weights' if year>=`year_start' & year<=`year_end' `cond', vce(`stderrs')
reg `lhs'_mortality `x' i.state i.year employment real_gdp personal_income `weights' if year>=`year_start' & year<=`year_end' `cond', vce(`stderrs')
reg `lhs'_mortality `x' i.state i.year employment real_gdp personal_income hs_dem_majority sen_dem_majority `weights' if year>=`year_start' & year<=`year_end' `cond', vce(`stderrs')
reg `lhs'_mortality `x' i.state i.year employment real_gdp personal_income hs_dem_majority sen_dem_majority i.state#c.year `weights' if year>=`year_start' & year<=`year_end' `cond', vce(`stderrs')

xtpoisson `lhs'_mortality `x' i.year `weights' if year>=`year_start' & year<=`year_end' `cond', fe vce(robust)
xtpoisson `lhs'_mortality `x' i.year employment real_gdp personal_income `weights' if year>=`year_start' & year<=`year_end' `cond', fe vce(robust)
xtpoisson `lhs'_mortality `x' i.year employment real_gdp personal_income hs_dem_majority sen_dem_majority `weights' if year>=`year_start' & year<=`year_end' `cond', fe vce(robust)
xtpoisson `lhs'_mortality `x' i.year employment real_gdp personal_income hs_dem_majority sen_dem_majority i.state#c.year `weights' if year>=`year_start' & year<=`year_end' `cond', fe vce(robust)
