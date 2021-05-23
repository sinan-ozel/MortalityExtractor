generate years_after_law_pass = .

generate treatment_state = 0

local law discretionary
capture drop `law'
capture generate `law' = 0
label variable `law' "Discretionary"

replace `law' = 1 if staters=="AL" & year >= 1989
replace years_after_law_pass = year - 1989 if staters == "AL"
replace `law' = 1 if staters=="AZ" & year >= 1991
replace years_after_law_pass = year - 1991 if staters == "AZ"
* CA is interesting
replace `law' = 1 if staters=="DE" & year >= 1984
replace years_after_law_pass = year - 1984 if staters == "DE"
replace `law' = 1 if staters=="FL" & year >= 1992
replace years_after_law_pass = year - 1992 if staters == "FL"
replace `law' = 1 if staters=="GA" & year >= 1981
replace years_after_law_pass = year - 1981 if staters == "GA"
replace `law' = 1 if staters=="HI" & year >= 1980
replace years_after_law_pass = year - 1980 if staters == "HI"
replace `law' = 1 if staters=="ID" & year >= 1979
replace years_after_law_pass = year - 1979 if staters == "ID"
replace `law' = 1 if staters=="IN" & year >= 2000
replace years_after_law_pass = year - 2000 if staters == "IN"
replace `law' = 1 if staters=="IA" & year >= 1986
replace years_after_law_pass = year - 1986 if staters == "IA"
replace `law' = 1 if staters=="KY" & year >= 1980
replace years_after_law_pass = year - 1980 if staters == "KY"
replace `law' = 1 if staters=="MD" & year >= 1986
replace years_after_law_pass = year - 1986 if staters == "MD"
replace `law' = 1 if staters=="MI" & year >= 1978
replace years_after_law_pass = year - 1978 if staters == "MI"
replace `law' = 1 if staters=="MN" & year >= 1978
replace years_after_law_pass = year - 1978 if staters == "MN"
replace `law' = 1 if staters=="NE" & year >= 1989
replace years_after_law_pass = year - 1989 if staters == "NE"
replace `law' = 1 if staters=="NH" & year >= 1979
replace years_after_law_pass = year - 1979 if staters == "NH"
replace `law' = 1 if staters=="NC" & year >= 1991
replace years_after_law_pass = year - 1991 if staters == "NC"
replace `law' = 1 if staters=="OK" & year >= 1987
replace years_after_law_pass = year - 1987 if staters == "OK"
replace `law' = 1 if staters=="PA" & year >= 1986
replace years_after_law_pass = year - 1986 if staters == "PA"
replace `law' = 1 if staters=="SC" & year >= 1995
replace years_after_law_pass = year - 1995 if staters == "SC"
replace `law' = 1 if staters=="TX" & year >= 1989
replace years_after_law_pass = year - 1989 if staters == "TX"
replace `law' = 1 if staters=="VT" & year >= 1985
replace years_after_law_pass = year - 1985 if staters == "VT"
replace `law' = 1 if staters=="VA" & year >= 1997
replace years_after_law_pass = year - 1997 if staters == "VA"
replace `law' = 1 if staters=="WV" & year >= 1994
replace years_after_law_pass = year - 1994 if staters == "WV"
replace `law' = 1 if staters=="WY" & year >= 1982
replace years_after_law_pass = year - 1982 if staters == "WY"


local law mand_n_rec
capture drop `law'
capture generate `law' = 0
label variable `law' "Mandatory or Recommended"

replace `law' = 1 if staters=="AR" & year >= 1991
replace treatment_state = 1 if staters == "AR"
replace years_after_law_pass = year - 1991 if staters == "AR"
replace `law' = 1 if staters=="CA" & year >= 1996
replace treatment_state = 1 if staters == "CA"
replace years_after_law_pass = year - 1996 if staters == "CA"
* CA is interesting
replace `law' = 1 if staters=="MA" & year >= 1988
replace treatment_state = 1 if staters == "MA"
replace years_after_law_pass = year - 1988 if staters == "MA"
replace `law' = 1 if staters=="MT" & year >= 1991
replace treatment_state = 1 if staters == "MT"
replace years_after_law_pass = year - 1991 if staters == "MT"
* ND had an earlier, more discretionary law
replace `law' = 1 if staters=="ND" & year >= 1995
replace treatment_state = 1 if staters == "ND"
replace years_after_law_pass = year - 1995 if staters == "ND"
replace `law' = 1 if staters=="TN" & year >= 1995
replace treatment_state = 1 if staters == "TN"
replace years_after_law_pass = year - 1995 if staters == "TN"


replace `law' = 1 if staters=="AK" & year >= 1996
replace treatment_state = 1 if staters == "AK"
replace years_after_law_pass = year - 1996 if staters == "AK"
replace `law' = 1 if staters=="AZ" & year >= 1991
replace treatment_state = 1 if staters == "AZ"
replace years_after_law_pass = year - 1991 if staters == "AZ"
* CA is interesting
replace `law' = 1 if staters=="CO" & year >= 1994
replace treatment_state = 1 if staters == "CO"
replace years_after_law_pass = year - 1994 if staters == "CO"
replace `law' = 1 if staters=="CT" & year >= 1986
replace treatment_state = 1 if staters == "CT"
replace years_after_law_pass = year - 1986 if staters == "CT"
replace `law' = 1 if staters=="DC" & year >= 1991
replace treatment_state = 1 if staters == "DC"
replace years_after_law_pass = year - 1991 if staters == "DC"
replace `law' = 1 if staters=="IA" & year >= 1986
replace treatment_state = 1 if staters == "IA"
replace years_after_law_pass = year - 1986 if staters == "IA"
replace `law' = 1 if staters=="IL" & year >= 1993
replace treatment_state = 1 if staters == "IL"
replace years_after_law_pass = year - 1993 if staters == "IL"
* KS had an earlier, more discretionary law
replace `law' = 1 if staters=="KS" & year >= 1992
replace treatment_state = 1 if staters == "KS"
replace years_after_law_pass = year - 1992 if staters == "KS"
replace `law' = 1 if staters=="LA" & year >= 1985
replace treatment_state = 1 if staters == "LA"
replace years_after_law_pass = year - 1985 if staters == "LA"
replace `law' = 1 if staters=="ME" & year >= 1980
replace treatment_state = 1 if staters == "ME"
replace years_after_law_pass = year - 1980 if staters == "ME"
replace `law' = 1 if staters=="MO" & year >= 1989
replace treatment_state = 1 if staters == "MO"
replace years_after_law_pass = year - 1989 if staters == "MO"
replace `law' = 1 if staters=="MS" & year >= 1995
replace treatment_state = 1 if staters == "MS"
replace years_after_law_pass = year - 1995 if staters == "MS"
replace `law' = 1 if staters=="NJ" & year >= 1991
replace treatment_state = 1 if staters == "NJ"
replace years_after_law_pass = year - 1991 if staters == "NJ"
replace `law' = 1 if staters=="NV" & year >= 1985
replace treatment_state = 1 if staters == "NV"
replace years_after_law_pass = year - 1985 if staters == "NV"
replace `law' = 1 if staters=="NM" & year >= 1987
replace treatment_state = 1 if staters == "NM"
replace years_after_law_pass = year - 1987 if staters == "NM"
* NM had an earlier, more discretionary law
replace `law' = 1 if staters=="NY" & year >= 1996
replace treatment_state = 1 if staters == "NY"
replace years_after_law_pass = year - 1996 if staters == "NY"
replace `law' = 1 if staters=="OH" & year >= 1995
replace treatment_state = 1 if staters == "OH"
replace years_after_law_pass = year - 1995 if staters == "OH"
replace `law' = 1 if staters=="OR" & year >= 1978
replace treatment_state = 1 if staters == "OR"
replace years_after_law_pass = year - 1978 if staters == "OR"
replace `law' = 1 if staters=="RI" & year >= 1988
replace treatment_state = 1 if staters == "RI"
replace years_after_law_pass = year - 1988 if staters == "RI"
replace `law' = 1 if staters=="SC" & year >= 1995
replace treatment_state = 1 if staters == "SC"
replace years_after_law_pass = year - 1995 if staters == "SC"
replace `law' = 1 if staters=="SD" & year >= 1989
replace treatment_state = 1 if staters == "SD"
replace years_after_law_pass = year - 1989 if staters == "SD"
replace `law' = 1 if staters=="UT" & year >= 1995
replace treatment_state = 1 if staters == "UT"
replace years_after_law_pass = year - 1995 if staters == "UT"
replace `law' = 1 if staters=="VA" & year >= 1997
replace treatment_state = 1 if staters == "VA"
replace years_after_law_pass = year - 1997 if staters == "VA"
replace `law' = 1 if staters=="WA" & year >= 1995
replace treatment_state = 1 if staters == "WA"
replace years_after_law_pass = year - 1995 if staters == "WA"
replace `law' = 1 if staters=="WI" & year >= 1989
replace treatment_state = 1 if staters == "WI"
replace years_after_law_pass = year - 1989 if staters == "WI"

