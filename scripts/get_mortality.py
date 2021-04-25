#!python3

import random
import argparse
import os
import errno
from zipfile import ZipFile
import re
import numpy as np
import pandas as pd
from datetime import datetime
from lib.mapping import fips_to_two_letter, geocode_to_fips
import gc

parser = argparse.ArgumentParser(description="Get the number of deaths per year per state for any given cause of death.")
parser.add_argument("-i", "--input", type=str, default='.', help="Input folder: this folder should contain raw death data files in zipped Stata format from NBER, under a subfolder called NBER. (See README.md files in each folder to look at what goes in each folder.)")
parser.add_argument("-s", "--start", type=int, default=1959, help="Starting year")
parser.add_argument("-e", "--end", type=int, default=2004, help="Ending year")
parser.add_argument("-b", "--by", choices=['state'], help="Aggregation level. Only state is implemented.")
parser.add_argument("-7", "--icd7", type=str, help="Regex for ICD7 codes")
parser.add_argument("-8", "--icda8", type=str, help="Regex for ICDA8 codes")
parser.add_argument("-9", "--icd9", type=str, help="Regex for ICD9 codes")
parser.add_argument("-10", "--icd10", type=str, help="Regex for ICD10 codes")
parser.add_argument("-o", "--output", type=str, default="output.dta", help="Output file, in Stata format. Include the .dta extension.")
parser.add_argument("--invert", action="store_true", help="Invert the regular expression filter - ie this is the logical negation operator on the mortality cause filter.")
parser.add_argument("-v", "--verbose", action="store_true", help="Print out messages.")
parser.set_defaults(feature=True)
args = parser.parse_args()

folder = args.input
verbose = args.verbose

def get_cod_regex_for_year(args, year):
	"""Get ICD code filter for each year.

	Different versions of ICD codes were used to report
	cause of death for different years.
	This method returns the relevant code for the given year.
	"""
	if year < 1968:
		return args.icd7
	elif year < 1979:
		return args.icda8
	elif year < 1999:
		return args.icd9
	else:
		return args.icd10


# Load macroeconomic controls.
# The files are available from Bureau of Economic Research
# http://www.bea.gov/iTable/iTable.cfm?reqid=70&step=1&isuri=1&acrdn=6#reqid=70&step=1&isuri=1
def get_bea_control_from_files(filenames, field_name):
	dfs = list()
	for filename in filenames:
		df = pd.read_csv(os.path.join(args.input, 'BEA', filename), skiprows=4)
		fips_column = 'Fips' if 'Fips' in df.columns else 'GeoFips'
		df = df[df[fips_column].apply(len) == 5]
		df = df[df[fips_column].str[2:] == '000']
		df = df[df[fips_column].str[0:2].astype(int) > 0]
		df = df[df[fips_column].str[0:2].astype(int) < 90]
		df['staters'] = df[fips_column].str[0:2].map(fips_to_two_letter)
		year_columns = list(set(df.columns) - set([fips_column, 'GeoName', 'Area', 'staters']))
		state_year_df = df.melt(id_vars='staters',
								value_vars=year_columns,
								var_name='year',
								value_name=field_name)
		state_year_df['year'] = state_year_df['year'].astype(int)
		state_year_df = state_year_df[state_year_df['year'] >= 1959]
		state_year_df[field_name] = state_year_df[field_name].astype(float)
		dfs.append(state_year_df)
	return pd.concat(dfs).drop_duplicates(subset=['staters', 'year'])

# Load population data
# This is only the total population, and not broken down by gender
# It is loaded for cross-checking the actual data source.
# Source: http://www.nber.org/data/census-intercensal-county-population.html
if verbose:
	print("Loading population data.")
	datetime_at_start = datetime.now()
	print("Started at {:}.".format(datetime_at_start))
population = pd.read_stata(os.path.join(args.input, 'Population', 'county_population.dta'), 'rb')
state_population = population\
	.query('county_fips == 0')\
	.melt(id_vars='state_fips',
		  value_vars=[c for c in population.columns if c.startswith('pop')],
		  var_name='year')
state_population['year'] = state_population['year'].str[3:].astype(int)
state_population['st'] = state_population['state_fips'].astype(str).str.zfill(2).map(fips_to_two_letter)
state_population['value'] = state_population['value'].fillna(0).astype(int)
del population

# Load population by race, gender and age group.
# Source: https://www.nber.org/data/seer_u.s._county_population_data.html
detailed_population = pd.read_stata(os.path.join(args.input, 'Population', 'uswbo19agesadj.dta'), 'rb')
detailed_population['age_group'] = detailed_population['age'].str[0] + '0s'
detailed_population['age_group_lower'] = detailed_population['age'].str[0].astype(int) * 10
detailed_population['age_group_upper'] = detailed_population['age'].str[0].astype(int) * 10 + 9

# Cross-check
# detailed_population.pivot_table(index='st', columns=['year'], values=['pop'], aggfunc='sum')
comparison = state_population.merge(detailed_population.groupby(['st', 'year'])['pop'].sum().to_frame(),
					   				how='outer',
					   				left_on=['st', 'year'],
									right_index=True)

if verbose:
	print("Population data loaded.")
	datetime_after_load = datetime.now()
	if verbose:
		print("Population data load finished at: {}. Took {} seconds.".format(datetime_after_load, datetime_after_load - datetime_at_start))

if verbose:
	print("Cross-check: Percent difference between the two population files.")
	print(((comparison['value'] / comparison['pop']) / comparison['pop']).describe())

# Load macroeconomic controls.
# The files are available from Bureau of Economic Research
# http://www.bea.gov/iTable/iTable.cfm?reqid=70&step=1&isuri=1&acrdn=6#reqid=70&step=1&isuri=1
employment = get_bea_control_from_files(
	['AnnualEmploymentByState-(69-01).csv', 'AnnualEmploymentByState-(98-14).csv'],
	'employment')
real_gdp = get_bea_control_from_files(
	['AnnualRealGDPByState-(63-97).csv', 'AnnualRealGDPByState-(97-15).csv'],
	'real_gdp')
personal_income = get_bea_control_from_files(
	['AnnualPerCapitaPersonalIncomeByState.csv'],
	'personal_income')

# Load State Legislature Control Data
# https://dataverse.harvard.edu/dataset.xhtml?persistentId=hdl:1902.1/20403
partisan_balance = pd.read_excel(os.path.join(args.input,
										      'PoliticalControls',
										      'Partisan_Balance_For_Use2011_06_09b.xlsx'),
								 engine='openpyxl')
partisan_balance['st'] = partisan_balance['fips'].astype(str).str.zfill(2).map(fips_to_two_letter)
partisan_balance['sen_dem_majority'] = (partisan_balance['sen_dem_in_sess'] > partisan_balance['sen_rep_in_sess']).astype(int)
partisan_balance['hs_dem_majority'] = (partisan_balance['hs_dem_in_sess'] > partisan_balance['hs_rep_in_sess']).astype(int)
partisan_balance['sen_rep_majority'] = (partisan_balance['sen_dem_in_sess'] < partisan_balance['sen_rep_in_sess']).astype(int)
partisan_balance['hs_rep_majority'] = (partisan_balance['hs_dem_in_sess'] < partisan_balance['hs_rep_in_sess']).astype(int)




for year in range(args.start, args.end + 1):
	# The file in 1972 has 50% sampling. This is unique to 1972. It is in the manual for the year, dt78icd8.pdf.
	# Other than visual inspection, I double-checked this with an email with Jean Roth at NBER.
	if verbose:
		print("Currently processing year: {:}. (Range: {:} to {:})".format(year, args.start, args.end))

	multiplier = (2 if year==1972 else 1)
	filename = 'mort' + str(year) + '.dta'

	cod_regex = get_cod_regex_for_year(args, year)

	# Marital status and gender values change from year yo year.
	if year < 2003:
		genders = {1: 'male', 2: 'female'}
		single = 1
		married = 2
		widowed = 3
		divorced = 4
	else:
		genders = {'M': 'male', 'F': 'female'}
		single = 'S'
		married = 'M'
		widowed = 'W'
		divorced = 'D'

	races = {1: 'white', 2: 'black'}


	datetime_at_start = datetime.now()

	# Death by cause of death are in separate files, by year.
	# Source: https://www.nber.org/research/data/mortality-data-vital-statistics-nchs-multiple-cause-death-data
	if verbose:
		print("Started at {:}.".format(datetime_at_start))
	if os.path.isfile(os.path.join(args.input, 'NBER', filename)):
		if verbose:
			print('{:} found, opening...'.format(os.path.join(args.input, 'NBER', filename)))
		dta_file = open(os.path.join(args.input, 'NBER', filename), 'rb')
	elif os.path.isfile(os.path.join(args.input, 'NBER', filename + '.zip')):
		if verbose:
			print('{:} found, unzipping...'.format(os.path.join(args.input, 'NBER', filename + '.zip')))
		with ZipFile(os.path.join(args.input, 'NBER', filename + '.zip'), 'r') as zip_file:
			if verbose:
				zip_file.printdir()
			dta_file = zip_file.open(zip_file.namelist()[0])
	else:
		raise FileNotFoundError(errno.ENOENT, os.strerror(errno.ENOENT), filename)
	if verbose:
		print("Loading the data for the year {:} into memory.".format(year))
	df = pd.read_stata(dta_file)
	if verbose:
		print("Data loaded. {:} rows in file.".format(len(df)))

	datetime_after_load = datetime.now()
	if verbose:
		print("Load finished at: {}. Took {} seconds.".format(datetime_after_load, datetime_after_load - datetime_at_start))
	if args.icd7 or args.icda8 or args.icd9 or args.icd10:
		print("Filtering by CoD. Make sure that all ICD specifications have an associated regular expression for filtering.")
		if args.invert:
			df = df[~(df['ucod'].str.contains(cod_regex))]
			if verbose:
				print("Regular expression filter inverted.")
		else:
			df = df[df['ucod'].str.contains(cod_regex)]

	df = df[df['race'].isin(races.keys())]

	if year < 2003:
		df = df[df['age'].between(20, 99)]
		df['age_group'] = df['age'].astype(str).str[0] + '0s'
		df['age_group_lower'] = df['age'].astype(str).str[0].astype(int) * 10
		df['age_group_upper'] = df['age'].astype(str).str[0].astype(int) * 10 + 9
	else:
		df = df[df['age'].between(1020, 1099)]
		df['age_group'] = (df['age'] - 1000).astype(str).str[0] + '0s'
		df['age_group_lower'] = (df['age'] - 1000).astype(str).str[0].astype(int) * 10
		df['age_group_upper'] = (df['age'] - 1000).astype(str).str[0].astype(int) * 10 + 9


	# Between the years 1983 and 2002, inclusive, the FIPS code of
	# the state of residence has been used. To ensure compatibility,
	# convert to the 2-letter state code for the state of residence.
	if year < 1982:
		df['staters'] = df['staters'].map(geocode_to_fips).map(fips_to_two_letter)
	elif year < 2003:
		df['staters'] = df['fipsstr'].map(fips_to_two_letter)
	else:
		pass  # staters is already in there, as the two-letter code

	random_state = random.choice(df['staters'].dropna().unique().tolist())
	print(f"Data sample from random state {random_state} (Year: {year})")
	with pd.option_context('display.max_rows', None):
		try:
			print(df[df['staters'] == random_state].sample(5).T)
		except ValueError:  # This happens when a territory like Virgin Islands is picked at random.
			pass

	total_deaths = len(df[df['staters'].notnull()])
	print(f"Total death count in year {year}: {total_deaths}")

	# Overall death count:
	yearly_df = df\
		.groupby('staters')\
		.apply(lambda x: len(x) * multiplier)\
		.rename('total_deaths')\
		.to_frame()\
		.reset_index()
	print(f"Total death count in year {year}: {total_deaths}")
	print(f"Cross-check for death count by state:", yearly_df['total_deaths'].sum())
	print("Sample for death count for state and by gender")
	yearly_df = yearly_df\
		.merge(
			detailed_population\
				.query(f'year == {year}')\
				.groupby('st')\
				[['pop']]\
				.sum()\
				.rename(columns={'pop': 'total_pop'}),
			how='left',
			left_on='staters',
			right_index=True,
		)

	# Death count by gender
	if verbose:
		print("Calculating death count by gender.")
	death_count_by_gender = df\
		.groupby(['staters', 'sex'])\
		.apply(lambda x: len(x) * multiplier)\
		.to_frame()\
		.reset_index()\
		.pivot(index='staters', columns='sex')
	death_count_by_gender.columns = \
		death_count_by_gender.columns.get_level_values(1)
	death_count_by_gender.rename(columns=genders, inplace=True)
	death_count_by_gender.rename(columns={'male': 'male_deaths', 'female': 'female_deaths'}, inplace=True)
	print(f"Total death count in year {year}: {total_deaths}")
	print(f"Cross-check for death count by state and gender:", death_count_by_gender['male_deaths'].sum() + death_count_by_gender['female_deaths'].sum())
	print("Sample for death count for state and by gender")
	with pd.option_context('display.max_rows', None):
		print(death_count_by_gender)
	yearly_df = yearly_df.merge(
		death_count_by_gender,
		left_on='staters',
		right_index=True,
		how='left',
	)
	yearly_df = yearly_df.merge(
		detailed_population\
			.query(f'year == {year}')\
			.pivot_table(index='st', columns='sex', aggfunc='sum', values='pop')
			.rename(columns={'Male': 'pop_male', 'Female': 'pop_female'}),
		left_on='staters',
		right_index=True,
		how='left',
	)


	with pd.option_context('display.max_rows', None):
		print(yearly_df.sample(5).T)



	# Death count by gender & by race
	if verbose:
		print("Calculating death count by gender & race.")
	death_count_by_gender_and_race = df\
		.groupby(['staters', 'sex', 'race'])\
		['ucod']\
		.apply(lambda x: len(x) * multiplier)\
		.to_frame()\
		.reset_index()
	print("Sample for death count for state, by gender and by race")
	print(death_count_by_gender.sample(5))
	death_count_by_gender_and_race['race'] = \
		death_count_by_gender_and_race['race'].map(races)
	death_count_by_gender_and_race['sex'] = \
		death_count_by_gender_and_race['sex'].map(genders)
	death_count_by_gender_and_race = \
		death_count_by_gender_and_race\
			.pivot(index='staters', columns=['sex', 'race'])\
			.fillna(0)
	multiindex_columns = death_count_by_gender_and_race.columns.values
	flat_columns = ['_'.join(col[1:]).strip() + '_deaths' for col in multiindex_columns]
	death_count_by_gender_and_race.columns = flat_columns
	yearly_df = yearly_df.merge(
		death_count_by_gender_and_race,
		left_on='staters',
		right_index=True,
		how='left',
	)

	population_by_gender_and_race = detailed_population\
		[detailed_population['race'].isin(['White', 'Black'])]\
		.query(f'year == {year}')\
		.pivot_table(index='st', columns=['sex', 'race'], aggfunc='sum', values='pop')

	multiindex_columns = population_by_gender_and_race.columns.values
	flat_columns = ['pop_' + '_'.join(col).lower().strip() for col in multiindex_columns]
	population_by_gender_and_race.columns = flat_columns

	yearly_df = yearly_df.merge(
		population_by_gender_and_race,
		left_on='staters',
		right_index=True,
		how='left',
	)

	print(f"Overall black female mortality for the year {year}. (Visual check to see if this figure looks correct.)")
	print(100000 * yearly_df['female_black_deaths'].sum() / yearly_df['pop_female_black'].sum())
	yearly_df['black_female_mortality_rate'] = 100000 * yearly_df['female_black_deaths'] / yearly_df['pop_female_black']
	with pd.option_context('display.max_rows', None):
		print(yearly_df[['staters', 'black_female_mortality_rate']])
	del yearly_df['black_female_mortality_rate']

	# Death count by gender, by race & by age
	death_count_by_gender_race_and_age = df\
		.groupby(['staters', 'sex', 'race', 'age_group'])\
		.apply(lambda x: len(x) * multiplier)\
		.to_frame()\
		.reset_index()
	print(f"Sample for death count for state, by gender, race and age group for the year {year}")
	print(death_count_by_gender_race_and_age.sample(5).T)
	death_count_by_gender_race_and_age['race'] = \
		death_count_by_gender_race_and_age['race'].map(races)
	death_count_by_gender_race_and_age['sex'] = \
		death_count_by_gender_race_and_age['sex'].map(genders)
	death_count_by_gender_race_and_age = \
		death_count_by_gender_race_and_age\
			.pivot(index='staters', columns=['sex', 'race', 'age_group'])\
			.fillna(0)
	multiindex_columns = death_count_by_gender_race_and_age.columns.values
	flat_columns = ['_'.join(col[1:]).strip() + '_deaths' for col in multiindex_columns]
	death_count_by_gender_race_and_age.columns = flat_columns
	yearly_df = yearly_df.merge(
		death_count_by_gender_race_and_age,
		left_on='staters',
		right_index=True,
		how='left',
	)

	population_by_gender_race_and_age = detailed_population\
		[detailed_population['race'].isin(['White', 'Black'])]\
		.query(f'year == {year}')\
		.pivot_table(index='st', columns=['sex', 'race', 'age_group'], aggfunc='sum', values='pop')

	multiindex_columns = population_by_gender_race_and_age.columns.values
	flat_columns = ['pop_' + '_'.join(col).lower().strip() for col in multiindex_columns]
	population_by_gender_race_and_age.columns = flat_columns

	yearly_df = yearly_df.merge(
		population_by_gender_race_and_age,
		left_on='staters',
		right_index=True,
		how='left',
	)

	print(f"Sample from the entire data for the year {year}")
	with pd.option_context('display.max_rows', None):
		print(yearly_df.sample(5).T)

	yearly_df['year'] = year

	# Add macroeconomics controls from BEA
	yearly_df = yearly_df.merge(
		employment.query(f'year == {year}'),
		on=['staters', 'year'],
		how='left',
	)

	yearly_df = yearly_df.merge(
		real_gdp.query(f'year == {year}'),
		on=['staters', 'year'],
		how='left',
	)

	yearly_df = yearly_df.merge(
		personal_income.query(f'year == {year}'),
		on=['staters', 'year'],
		how='left',
	)

	# Add political controls from Harvard DataVerse
	yearly_df = yearly_df.merge(
		partisan_balance\
			[['st', 'year', 'sen_dem_majority', 'hs_dem_majority', 'sen_rep_majority', 'hs_rep_majority']]\
			.query(f'year == {year}'),
		left_on=['staters', 'year'],
		right_on=['st', 'year'],
		how='left',
	)

	with pd.option_context('display.max_rows', None):
		print(yearly_df.sample(5).T)

	if year == args.start:
		total_df = yearly_df
	else:
		total_df = pd.concat([total_df, yearly_df])
	print(total_df.columns)
	with pd.option_context('display.max_rows', None):
		print(total_df.dtypes)
	total_df.to_stata(args.output)
	del df
	del yearly_df
	gc.collect()
