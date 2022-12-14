% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/calcPriceIndex.R
\name{calcPriceIndex}
\alias{calcPriceIndex}
\title{Calculate Price Index}
\usage{
calcPriceIndex(cpData, cvmData)
}
\arguments{
\item{cpData}{one or more numeric values in current prices - UPDATED LeighP 15-11-18}

\item{cvmData}{one or more numeric values in chain volume measures - UPDATED LeighP 15-11-18}
}
\value{
a numeric vector
}
\description{
Calls the function calcPriceIndexUsingAvgs, which does the main processing after joining data up and adding row number
}
\examples{
NEWcalcPriceIndex(10, 20)
NEWcalcPriceIndex(1:10, 20:30)
}
