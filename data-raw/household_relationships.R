# HOUSEHOLD_RELATIONSHIPS.R
#
# This script creates a table of inter-household relationships.
#
# Ben Davies
# November 2022

library(bldr)
library(dplyr)
library(data.table)
library(haven)
library(purrr)
library(readr)
library(tidyr)
library(usethis)

data_dir = 'data-raw/datav4.0/Data/'

households_raw = paste0(data_dir, '2. Demographics and Outcomes/') %>%
  paste0('household_characteristics.dta') %>%
  read_dta()

relationship_types = tribble(
  ~key, ~type,
  'borrowmoney',   'Borrow money from',          
  'giveadvice',    'Give advice to',           
  'helpdecision',  'Help with a decision',
  'keroricecome',  'Borrow kerosene or rice from',
  'keroricego',    'Lend kerosene or rice to',
  'lendmoney',     'Lend money to',     
  'medic',         'Obtain medical advice from',
  'nonrel',        'Engage socially with',        
  'rel',           'Are related to',             
  'templecompany', 'Go to temple with',
  'visitcome',     'Invite to one\'s home',
  'visitgo',       'Visit in another\'s home'
)

get_edgelist = function(f) {
  mat = as.matrix(data.table::fread(f))
  rownames(mat) = seq_len(nrow(mat))
  colnames(mat) = seq_len(ncol(mat))
  mat %>%
    mat2tbl() %>%
    filter(value == 1) %>%
    mutate_at(c('row', 'col'), as.double)
}

household_relationships = paste0(data_dir, '1. Network Data/Adjacency Matrices') %>%
  {tibble(file = list.files(., full.names = T))} %>%
  # Restrict to household data
  filter(grepl('HH', file)) %>%
  # Extract villages and relationship types from file names
  mutate(key = sub('.*/adj_(.*)_HH_vilno_([0-9]+)[.]csv', '\\1_\\2', file)) %>%
  separate(key, c('key', 'village'), sep = '_', convert = T) %>%
  left_join(relationship_types) %>%
  # Ignore data on union and intersection networks
  filter(!key %in% c('allVillageRelationships', 'andRelationships')) %>%
  # Import edge lists
  mutate(el = map(file, get_edgelist)) %>%
  unnest('el') %>%
  # Match to household IDs
  left_join(households_raw, by = c('village', 'row' = 'adjmatrix_key')) %>%
  left_join(households_raw, by = c('village', 'col' = 'adjmatrix_key')) %>%
  # Tidy data
  select(hhid.x, hhid.y, village, type) %>%
  distinct() %>%
  filter(hhid.x < hhid.y) %>%  # Networks are undirected
  mutate(type = factor(type, levels = relationship_types$type)) %>%
  mutate_all(zap_label) %>%
  arrange(hhid.x, hhid.y, type)

use_data(household_relationships, overwrite = T)
write_csv(household_relationships, 'data-raw/household_relationships.csv')

save_session_info('data-raw/household_relationships.log')
