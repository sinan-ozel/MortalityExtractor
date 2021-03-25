cls
set matsize 11000
set more off
clear

use ../processed_data/mortality_by_state_v3.1.dta, clear

local year_start = 1969
local year_end = 2002

local lhs = "female_black"

local weights = ""

local stderrs = "cluster state"

local x = "mand_n_rec"

run ../treatment/`x'.do

drop if staters=="ZZ"
drop if staters=="PR"
drop if staters=="VI"
drop if staters=="GU"
drop if staters=="AS"

drop if year == 1972

gen `lhs'_mortality = (`lhs'_deaths / pop_`lhs') * 100000

capture encode staters, gen(state)
xtset state year

reg `lhs'_mortality `x' i.state i.year `weights' if year>=`year_start' & year<=`year_end' `cond', vce(`stderrs')

