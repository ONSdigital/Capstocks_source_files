% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/calcPriceIndex.R
\name{OLDcalcPriceIndex}
\alias{OLDcalcPriceIndex}
\title{Calculate Price Index OLD}
\usage{
OLDcalcPriceIndex(cpData, cvmData)
}
\arguments{
\item{cpData}{one or more numeric values in current prices}

\item{cvmData}{one or more numeric values in chain volume measures}
}
\value{
a numeric vector
}
\description{
This was how the original Price Inxdex was calculated, not used anymore
}
\examples{
calcPriceIndex(10, 20)
calcPriceIndex(1:10, 20:30)
}
