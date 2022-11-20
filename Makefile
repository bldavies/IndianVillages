all: data package

data: households household_relationships

households:
	Rscript 'data-raw/households.R'

household_relationships:
	Rscript 'data-raw/household_relationships.R'

package:
	Rscript -e 'devtools::install()'
