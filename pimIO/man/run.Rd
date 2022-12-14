% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/run.R
\name{run}
\alias{run}
\title{Run PIM with pre and post processing.}
\usage{
run(inputData, config, referenceYear)
}
\arguments{
\item{inputData}{a data.frame}

\item{config}{a list of configuration parameters returned from pim::pimConfig}

\item{referenceYear}{a numeric value indicating the year against which all prices are set}
}
\value{
the given data.frame with additional columns
}
\description{
Processes the input data before executing the PIM. Results from the PIM are
then further processed to obtain additional time series.
}
