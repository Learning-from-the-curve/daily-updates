#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Fri Mar 27 10:56:56 2020

@author: glenn
"""

# load libraries
import pandas as pd
import os
from pandasdmx import Request 
import eurostat

# Choose location downloaded data on local machine
data_dir = "/Users/glenn/Dropbox/work/research/COVID19/projects/daily_updates/tasks/task1_import/output"

# Data from Johns Hopkins
url_JH_confirmed = 'https://raw.githubusercontent.com/CSSEGISandData/COVID-19/master/csse_covid_19_data/csse_covid_19_time_series/time_series_covid19_confirmed_global.csv'
url_JH_death     = 'https://raw.githubusercontent.com/CSSEGISandData/COVID-19/master/csse_covid_19_data/csse_covid_19_time_series/time_series_covid19_deaths_global.csv'
url_JH_recovered = 'https://raw.githubusercontent.com/CSSEGISandData/COVID-19/master/csse_covid_19_data/csse_covid_19_time_series/time_series_covid19_recovered_global.csv'
df_JH_confirmed  = pd.read_csv(url_JH_confirmed,index_col=0,parse_dates=[0])
df_JH_death      = pd.read_csv(url_JH_death,index_col=0,parse_dates=[0])
df_JH_recovered  = pd.read_csv(url_JH_recovered,index_col=0,parse_dates=[0])

df_JH_confirmed.head()

# Data from UN world population 
url_WPP_tot_pop     = 'https://population.un.org/wpp/Download/Files/1_Indicators%20(Standard)/CSV_FILES/WPP2019_TotalPopulationBySex.csv'
url_WPP_pop_age_sex = 'https://population.un.org/wpp/Download/Files/1_Indicators%20(Standard)/CSV_FILES/WPP2019_PopulationByAgeSex_Medium.csv'
url_WPP_feritlity   = 'https://population.un.org/wpp/Download/Files/1_Indicators%20(Standard)/CSV_FILES/WPP2019_Fertility_by_Age.csv'
df_WPP_tot_pop      = pd.read_csv(url_WPP_tot_pop,index_col=0,parse_dates=[0])
df_WPP_pop_age_sex  = pd.read_csv(url_WPP_pop_age_sex,index_col=0,parse_dates=[0])
df_WPP_feritlity    = pd.read_csv(url_WPP_feritlity,index_col=0,parse_dates=[0])

df_WPP_tot_pop.head()


# Data from Eurostat
data_EU_pop        = eurostat.get_data_df('demo_r_gind3')   # Population
data_EU_gdp        = eurostat.get_data_df('nama_10_gdp')    # GDP
data_EU_cons       = eurostat.get_data_df('nama_10_fcs')    # Consumption
data_EU_trade      = eurostat.get_data_df('nama_10_exi')    # Import export
data_EU_short_rate = eurostat.get_data_df('irt_st_a')       # Short term int rates on govt bonds
data_EU_long_rate  = eurostat.get_data_df('irt_lt_gby10_a') # 10 y int rates on govt bonds
data_EU_unemp      = eurostat.get_data_df('une_rt_a')       # Unemployment by sex and age
data_EU_inv        = eurostat.get_data_df('nama_10_an6')    # Gross capital formation (gross investment)

data_EU_gdp.head()

# Save all data
print(os.getcwd())        # Current directory
print(os.chdir(data_dir)) # New directory

df_JH_confirmed    = df_JH_confirmed.to_csv("df_JH_confirmed.csv", index=False)
df_JH_death        = df_JH_death.to_csv("df_JH_death.csv", index=False)
df_JH_recovered    = df_JH_recovered.to_csv("df_JH_recovered.csv", index=False)
df_WPP_tot_pop     = df_WPP_tot_pop.to_csv("df_WPP_tot_pop.csv", index=False)
df_WPP_pop_age_sex = df_WPP_pop_age_sex.to_csv("df_WPP_pop_age_sex.csv", index=False)
df_WPP_feritlity   = df_WPP_feritlity.to_csv("df_WPP_feritlity.csv", index=False)
data_EU_pop        = data_EU_pop.to_csv("data_EU_pop.csv", index=False)
data_EU_gdp        = data_EU_gdp.to_csv("data_EU_gdp.csv", index=False)
data_EU_cons       = data_EU_cons.to_csv("data_EU_cons.csv", index=False)
data_EU_trade      = data_EU_trade.to_csv("data_EU_trade.csv", index=False)
data_EU_short_rate = data_EU_short_rate.to_csv("data_EU_short_rate.csv", index=False)
data_EU_long_rate  = data_EU_long_rate.to_csv("data_EU_long_rate.csv", index=False)
data_EU_unemp      = data_EU_unemp.to_csv("data_EU_unemp.csv", index=False)
data_EU_inv        = data_EU_inv.to_csv("data_EU_inv.csv", index=False)