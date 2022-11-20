# HOUSEHOLDS.R
#
# This script creates a table of household attributes.
#
# Ben Davies
# November 2022

library(bldr)
library(dplyr)
library(haven)
library(readr)
library(stringr)
library(usethis)

data_dir = 'data-raw/datav4.0/Data/'

households_raw = paste0(data_dir, '2. Demographics and Outcomes/') %>%
  paste0('household_characteristics.dta') %>%
  read_dta()

households = households_raw %>%
  select(hhid, village, caste = castesubcaste) %>%
  mutate(caste = sub('SCHEDULE', 'SCHEDULED', caste),
         caste = ifelse(caste == 'OBC', caste, str_to_title(caste)),
         caste = ifelse(caste == '', NA, caste)) %>%
  mutate_all(zap_label) %>%
  arrange(hhid)

use_data(households, overwrite = T)
write_csv(households, 'data-raw/households.csv')

save_session_info('data-raw/households.log')
