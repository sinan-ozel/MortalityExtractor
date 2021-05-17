generate within_neighborhood = 0
local year_neighborhood = 4

generate treatment_state = 0

local law discretionary
capture drop `law'
capture generate `law' = 0
label variable `law' "Discretionary"

replace `law' = 1 if staters=="AL" & year >= 1989
replace within_neighborhood = 1 if year >= 1989 - `year_neighborhood' & year <= 1989 + `year_neighborhood' & staters == "AL"
replace `law' = 1 if staters=="AZ" & year >= 1991
replace within_neighborhood = 1 if year >= 1991 - `year_neighborhood' & year <= 1991 + `year_neighborhood' & staters == "AZ"
* CA is interesting
replace `law' = 1 if staters=="DE" & year >= 1984
replace within_neighborhood = 1 if year >= 1984 - `year_neighborhood' & year <= 1984 + `year_neighborhood' & staters == "DE"
replace `law' = 1 if staters=="FL" & year >= 1992
replace within_neighborhood = 1 if year >= 1992 - `year_neighborhood' & year <= 1992 + `year_neighborhood' & staters == "FL"
replace `law' = 1 if staters=="GA" & year >= 1981
replace within_neighborhood = 1 if year >= 1981 - `year_neighborhood' & year <= 1981 + `year_neighborhood' & staters == "GA"
replace `law' = 1 if staters=="HI" & year >= 1980
replace within_neighborhood = 1 if year >= 1980 - `year_neighborhood' & year <= 1980 + `year_neighborhood' & staters == "HI"
replace `law' = 1 if staters=="ID" & year >= 1979
replace within_neighborhood = 1 if year >= 1979 - `year_neighborhood' & year <= 1979 + `year_neighborhood' & staters == "ID"
replace `law' = 1 if staters=="IN" & year >= 2000
replace within_neighborhood = 1 if year >= 2000 - `year_neighborhood' & year <= 2000 + `year_neighborhood' & staters == "IN"
replace `law' = 1 if staters=="IA" & year >= 1986
replace within_neighborhood = 1 if year >= 1986 - `year_neighborhood' & year <= 1986 + `year_neighborhood' & staters == "IA"
replace `law' = 1 if staters=="KY" & year >= 1980
replace within_neighborhood = 1 if year >= 1980 - `year_neighborhood' & year <= 1980 + `year_neighborhood' & staters == "KY"
replace `law' = 1 if staters=="MD" & year >= 1986
replace within_neighborhood = 1 if year >= 1986 - `year_neighborhood' & year <= 1986 + `year_neighborhood' & staters == "MD"
replace `law' = 1 if staters=="MI" & year >= 1978
replace within_neighborhood = 1 if year >= 1978 - `year_neighborhood' & year <= 1978 + `year_neighborhood' & staters == "MI"
replace `law' = 1 if staters=="MN" & year >= 1978
replace within_neighborhood = 1 if year >= 1978 - `year_neighborhood' & year <= 1978 + `year_neighborhood' & staters == "MN"
replace `law' = 1 if staters=="NE" & year >= 1989
replace within_neighborhood = 1 if year >= 1989 - `year_neighborhood' & year <= 1989 + `year_neighborhood' & staters == "NE"
replace `law' = 1 if staters=="NH" & year >= 1979
replace within_neighborhood = 1 if year >= 1979 - `year_neighborhood' & year <= 1979 + `year_neighborhood' & staters == "NH"
replace `law' = 1 if staters=="NC" & year >= 1991
replace within_neighborhood = 1 if year >= 1991 - `year_neighborhood' & year <= 1991 + `year_neighborhood' & staters == "NC"
replace `law' = 1 if staters=="OK" & year >= 1987
replace within_neighborhood = 1 if year >= 1987 - `year_neighborhood' & year <= 1987 + `year_neighborhood' & staters == "OK"
replace `law' = 1 if staters=="PA" & year >= 1986
replace within_neighborhood = 1 if year >= 1986 - `year_neighborhood' & year <= 1986 + `year_neighborhood' & staters == "PA"
replace `law' = 1 if staters=="SC" & year >= 1995
replace within_neighborhood = 1 if year >= 1995 - `year_neighborhood' & year <= 1995 + `year_neighborhood' & staters == "SC"
replace `law' = 1 if staters=="TX" & year >= 1989
replace within_neighborhood = 1 if year >= 1989 - `year_neighborhood' & year <= 1989 + `year_neighborhood' & staters == "TX"
replace `law' = 1 if staters=="VT" & year >= 1985
replace within_neighborhood = 1 if year >= 1985 - `year_neighborhood' & year <= 1985 + `year_neighborhood' & staters == "VT"
replace `law' = 1 if staters=="VA" & year >= 1997
replace within_neighborhood = 1 if year >= 1997 - `year_neighborhood' & year <= 1997 + `year_neighborhood' & staters == "VA"
replace `law' = 1 if staters=="WV" & year >= 1994
replace within_neighborhood = 1 if year >= 1994 - `year_neighborhood' & year <= 1994 + `year_neighborhood' & staters == "WV"
replace `law' = 1 if staters=="WY" & year >= 1982
replace within_neighborhood = 1 if year >= 1982 - `year_neighborhood' & year <= 1982 + `year_neighborhood' & staters == "WY"


local law mand_n_rec
capture drop `law'
capture generate `law' = 0
label variable `law' "Mandatory or Recommended"

replace `law' = 1 if staters=="AR" & year >= 1991
replace treatment_state = 1 if staters == "AR"
replace within_neighborhood = 1 if year >= 1991 - `year_neighborhood' & year <= 1991 + `year_neighborhood' & staters == "AR"
replace `law' = 1 if staters=="CA" & year >= 1996
replace treatment_state = 1 if staters == "CA"
replace within_neighborhood = 1 if year >= 1996 - `year_neighborhood' & year <= 1996 + `year_neighborhood' & staters == "CA"
* CA is interesting
replace `law' = 1 if staters=="MA" & year >= 1988
replace treatment_state = 1 if staters == "MA"
replace within_neighborhood = 1 if year >= 1988 - `year_neighborhood' & year <= 1988 + `year_neighborhood' & staters == "MA"
replace `law' = 1 if staters=="MT" & year >= 1991
replace treatment_state = 1 if staters == "MT"
replace within_neighborhood = 1 if year >= 1991 - `year_neighborhood' & year <= 1991 + `year_neighborhood' & staters == "MT"
* ND had an earlier, more discretionary law
replace `law' = 1 if staters=="ND" & year >= 1995
replace treatment_state = 1 if staters == "ND"
replace within_neighborhood = 1 if year >= 1995 - `year_neighborhood' & year <= 1995 + `year_neighborhood' & staters == "ND"
replace `law' = 1 if staters=="TN" & year >= 1995
replace treatment_state = 1 if staters == "TN"
replace within_neighborhood = 1 if year >= 1995 - `year_neighborhood' & year <= 1995 + `year_neighborhood' & staters == "TN"


replace `law' = 1 if staters=="AK" & year >= 1996
replace treatment_state = 1 if staters == "AK"
replace within_neighborhood = 1 if year >= 1996 - `year_neighborhood' & year <= 1996 + `year_neighborhood' & staters == "AK"
replace `law' = 1 if staters=="AZ" & year >= 1991
replace treatment_state = 1 if staters == "AZ"
replace within_neighborhood = 1 if year >= 1991 - `year_neighborhood' & year <= 1991 + `year_neighborhood' & staters == "AZ"
* CA is interesting
replace `law' = 1 if staters=="CO" & year >= 1994
replace treatment_state = 1 if staters == "CO"
replace within_neighborhood = 1 if year >= 1994 - `year_neighborhood' & year <= 1994 + `year_neighborhood' & staters == "CO"
replace `law' = 1 if staters=="CT" & year >= 1986
replace treatment_state = 1 if staters == "CT"
replace within_neighborhood = 1 if year >= 1986 - `year_neighborhood' & year <= 1986 + `year_neighborhood' & staters == "CT"
replace `law' = 1 if staters=="DC" & year >= 1991
replace treatment_state = 1 if staters == "DC"
replace within_neighborhood = 1 if year >= 1991 - `year_neighborhood' & year <= 1991 + `year_neighborhood' & staters == "DC"
replace `law' = 1 if staters=="IA" & year >= 1986
replace treatment_state = 1 if staters == "IA"
replace within_neighborhood = 1 if year >= 1986 - `year_neighborhood' & year <= 1986 + `year_neighborhood' & staters == "IA"
replace `law' = 1 if staters=="IL" & year >= 1993
replace treatment_state = 1 if staters == "IL"
replace within_neighborhood = 1 if year >= 1993 - `year_neighborhood' & year <= 1993 + `year_neighborhood' & staters == "IL"
* KS had an earlier, more discretionary law
replace `law' = 1 if staters=="KS" & year >= 1992
replace treatment_state = 1 if staters == "KS"
replace within_neighborhood = 1 if year >= 1992 - `year_neighborhood' & year <= 1992 + `year_neighborhood' & staters == "KS"
replace `law' = 1 if staters=="LA" & year >= 1985
replace treatment_state = 1 if staters == "LA"
replace within_neighborhood = 1 if year >= 1985 - `year_neighborhood' & year <= 1985 + `year_neighborhood' & staters == "LA"
replace `law' = 1 if staters=="ME" & year >= 1980
replace treatment_state = 1 if staters == "ME"
replace within_neighborhood = 1 if year >= 1980 - `year_neighborhood' & year <= 1980 + `year_neighborhood' & staters == "ME"
replace `law' = 1 if staters=="MO" & year >= 1989
replace treatment_state = 1 if staters == "MO"
replace within_neighborhood = 1 if year >= 1989 - `year_neighborhood' & year <= 1989 + `year_neighborhood' & staters == "MO"
replace `law' = 1 if staters=="MS" & year >= 1995
replace treatment_state = 1 if staters == "MS"
replace within_neighborhood = 1 if year >= 1995 - `year_neighborhood' & year <= 1995 + `year_neighborhood' & staters == "MS"
replace `law' = 1 if staters=="NJ" & year >= 1991
replace treatment_state = 1 if staters == "NJ"
replace within_neighborhood = 1 if year >= 1991 - `year_neighborhood' & year <= 1991 + `year_neighborhood' & staters == "NJ"
replace `law' = 1 if staters=="NV" & year >= 1985
replace treatment_state = 1 if staters == "NV"
replace within_neighborhood = 1 if year >= 1985 - `year_neighborhood' & year <= 1985 + `year_neighborhood' & staters == "NV"
replace `law' = 1 if staters=="NM" & year >= 1987
replace treatment_state = 1 if staters == "NM"
replace within_neighborhood = 1 if year >= 1987 - `year_neighborhood' & year <= 1987 + `year_neighborhood' & staters == "NM"
* NM had an earlier, more discretionary law
replace `law' = 1 if staters=="NY" & year >= 1996
replace treatment_state = 1 if staters == "NY"
replace within_neighborhood = 1 if year >= 1996 - `year_neighborhood' & year <= 1996 + `year_neighborhood' & staters == "NY"
replace `law' = 1 if staters=="OH" & year >= 1995
replace treatment_state = 1 if staters == "OH"
replace within_neighborhood = 1 if year >= 1995 - `year_neighborhood' & year <= 1995 + `year_neighborhood' & staters == "OH"
replace `law' = 1 if staters=="OR" & year >= 1978
replace treatment_state = 1 if staters == "OR"
replace within_neighborhood = 1 if year >= 1978 - `year_neighborhood' & year <= 1978 + `year_neighborhood' & staters == "OR"
replace `law' = 1 if staters=="RI" & year >= 1988
replace treatment_state = 1 if staters == "RI"
replace within_neighborhood = 1 if year >= 1988 - `year_neighborhood' & year <= 1988 + `year_neighborhood' & staters == "RI"
replace `law' = 1 if staters=="SC" & year >= 1995
replace treatment_state = 1 if staters == "SC"
replace within_neighborhood = 1 if year >= 1995 - `year_neighborhood' & year <= 1995 + `year_neighborhood' & staters == "SC"
replace `law' = 1 if staters=="SD" & year >= 1989
replace treatment_state = 1 if staters == "SD"
replace within_neighborhood = 1 if year >= 1989 - `year_neighborhood' & year <= 1989 + `year_neighborhood' & staters == "SD"
replace `law' = 1 if staters=="UT" & year >= 1995
replace treatment_state = 1 if staters == "UT"
replace within_neighborhood = 1 if year >= 1995 - `year_neighborhood' & year <= 1995 + `year_neighborhood' & staters == "UT"
replace `law' = 1 if staters=="VA" & year >= 1997
replace treatment_state = 1 if staters == "VA"
replace within_neighborhood = 1 if year >= 1997 - `year_neighborhood' & year <= 1997 + `year_neighborhood' & staters == "VA"
replace `law' = 1 if staters=="WA" & year >= 1995
replace treatment_state = 1 if staters == "WA"
replace within_neighborhood = 1 if year >= 1995 - `year_neighborhood' & year <= 1995 + `year_neighborhood' & staters == "WA"
replace `law' = 1 if staters=="WI" & year >= 1989
replace treatment_state = 1 if staters == "WI"
replace within_neighborhood = 1 if year >= 1989 - `year_neighborhood' & year <= 1989 + `year_neighborhood' & staters == "WI"

