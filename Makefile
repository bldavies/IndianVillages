all: data package

data: households

households:
	Rscript 'data-raw/households.R'

package:
	Rscript -e 'devtools::install()'
