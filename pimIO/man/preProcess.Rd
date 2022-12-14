% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/preProcess.R
\name{preProcess}
\alias{preProcess}
\title{Pre-process Input Data.}
\usage{
preProcess(timeSeries)
}
\arguments{
\item{timeSeries}{a data.frame with a column for GFCF in CP (gfcfCP), a Price
Index (PriceIndex), K.1 in CP (K1CP), K.3 in CP (K3CP), K.4 in CP (K4CP),
K.5 in CP (K5CP), K.61 in CP (K61CP) and K.62 in CP (K62CP)}
}
\value{
the given data.frame with the addition of CVM variables
}
\description{
Pre-process the time series of gfcf and other changes in volume. This includes
calculating GFCF and K-Value adjustments in CVM using the provided Price Index.
}
