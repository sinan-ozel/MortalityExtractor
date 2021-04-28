local law discretionary
capture drop `law'
capture generate `law' = 0

replace `law' = 1 if staters=="AL" & year >= 1989
replace `law' = 1 if staters=="AZ" & year >= 1991
* CA is interesting
replace `law' = 1 if staters=="DE" & year >= 1984
replace `law' = 1 if staters=="FL" & year >= 1992
replace `law' = 1 if staters=="GA" & year >= 1981
replace `law' = 1 if staters=="HI" & year >= 1980
replace `law' = 1 if staters=="ID" & year >= 1979
replace `law' = 1 if staters=="IN" & year >= 2000
replace `law' = 1 if staters=="IA" & year >= 1986
replace `law' = 1 if staters=="KY" & year >= 1980
replace `law' = 1 if staters=="MD" & year >= 1986
replace `law' = 1 if staters=="MI" & year >= 1978
replace `law' = 1 if staters=="MN" & year >= 1978
replace `law' = 1 if staters=="NE" & year >= 1989
replace `law' = 1 if staters=="NH" & year >= 1979
replace `law' = 1 if staters=="NC" & year >= 1991
replace `law' = 1 if staters=="OK" & year >= 1987
replace `law' = 1 if staters=="PA" & year >= 1986
replace `law' = 1 if staters=="SC" & year >= 1995
replace `law' = 1 if staters=="TX" & year >= 1989
replace `law' = 1 if staters=="VT" & year >= 1985
replace `law' = 1 if staters=="VA" & year >= 1997
replace `law' = 1 if staters=="WV" & year >= 1994
replace `law' = 1 if staters=="WY" & year >= 1982


local law mand_n_rec
capture drop `law'
capture generate `law' = 0

replace `law' = 1 if staters=="AR" & year >= 1991
replace `law' = 1 if staters=="CA" & year >= 1996
* CA is interesting
replace `law' = 1 if staters=="MA" & year >= 1988
replace `law' = 1 if staters=="MT" & year >= 1991
* ND had an earlier, more discretionary law
replace `law' = 1 if staters=="ND" & year >= 1995
replace `law' = 1 if staters=="TN" & year >= 1995


replace `law' = 1 if staters=="AK" & year >= 1996
replace `law' = 1 if staters=="AZ" & year >= 1991
* CA is interesting
replace `law' = 1 if staters=="CO" & year >= 1994
replace `law' = 1 if staters=="CT" & year >= 1986
replace `law' = 1 if staters=="DC" & year >= 1991
replace `law' = 1 if staters=="IA" & year >= 1986
replace `law' = 1 if staters=="IL" & year >= 1993
* KS had an earlier, more discretionary law
replace `law' = 1 if staters=="KS" & year >= 1992
replace `law' = 1 if staters=="LA" & year >= 1985
replace `law' = 1 if staters=="ME" & year >= 1980
replace `law' = 1 if staters=="MO" & year >= 1989
replace `law' = 1 if staters=="MS" & year >= 1995
replace `law' = 1 if staters=="NJ" & year >= 1991
replace `law' = 1 if staters=="NV" & year >= 1985
replace `law' = 1 if staters=="NM" & year >= 1987
* NM had an earlier, more discretionary law
replace `law' = 1 if staters=="NY" & year >= 1996
replace `law' = 1 if staters=="OH" & year >= 1995
replace `law' = 1 if staters=="OR" & year >= 1978
replace `law' = 1 if staters=="RI" & year >= 1988
replace `law' = 1 if staters=="SC" & year >= 1995
replace `law' = 1 if staters=="SD" & year >= 1996
replace `law' = 1 if staters=="UT" & year >= 1995
replace `law' = 1 if staters=="VA" & year >= 1997
replace `law' = 1 if staters=="WA" & year >= 1995
replace `law' = 1 if staters=="WI" & year >= 1989

