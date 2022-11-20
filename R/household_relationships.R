#' Inter-household relationships
#' 
#' Data frame containing inter-household relationships.
#' 
#' All relationships are undirected.
#' Rows with \code{hhid.x} > \code{hhid.y} have been omitted for brevity.
#' 
#' There are no between-village relationships.
#' 
#' \code{type} values correspond to questions asked in Banerjee et al.'s (2013) surveys.
#' 
#' @name household_relationships
#' 
#' @docType data
#' 
#' @usage data(household_relationships)
#' 
#' @format Data frame with columns
#' \describe{
#' \item{hhid.x}{Source household ID}
#' \item{hhid.y}{Target household ID}
#' \item{village}{Village number}
#' \item{type}{Relationship type}
#' }
#' 
#' @references
#' Banerjee, A., Chandrasekhar, A. G., Duflo, E., and Jackson, M. O. (2013).
#' The Diffusion of Microfinance.
#' \emph{Science} 341(6144):1236498.
#' \doi{10.1126/science.1236498}
#' 
#' @source \href{https://doi.org/10.7910/21538/4POS1J}{Harvard Dataverse}
"household_relationships"
