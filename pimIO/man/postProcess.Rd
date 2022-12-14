% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/postProcess.R
\name{postProcess}
\alias{postProcess}
\title{Post-process PIM results.}
\usage{
postProcess(timeSeries, pimResults, referenceYear, discountRate)
}
\arguments{
\item{timeSeries}{The processed data as obtained from preProcess}

\item{pimResults}{The results from executing the pim function on the
processed data}

\item{referenceYear}{a numeric value indicating the year against which all prices are set}

\item{discountRate}{a numeric value between [0,1]}
}
\value{
the given data frames combined with the addition of numerous columns
}
\description{
Post-process the time series of pim results. This includes converting from
CP to CVM and calculating consumption of fixed capital, holding gains/losses
and capital services
}
