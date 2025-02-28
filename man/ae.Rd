% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/ae.R
\name{ae}
\alias{ae}
\title{Age Estimate}
\usage{
ae(
  samp,
  refdata,
  ref.time_series,
  cor.method = "spearman",
  nb.cores = 2,
  bootstrap.n = 30,
  bootstrap.set_size = NULL,
  prior = NULL,
  prior.params = NULL,
  verbose = T
)
}
\arguments{
\item{samp}{the sample matrix, genes as rows, individuals as columns}

\item{refdata}{the reference time series matrix, same format as \code{samp}}

\item{ref.time_series}{the reference time series (\emph{e.g.} \code{interpol$time.series} if using interpolated reference data)}

\item{cor.method}{correlation method argument passed on to \code{\link{cor.gene_expr}}. Note that the Spearman coefficient performs much better than Pearson (while a bit slower).}

\item{nb.cores}{the number of cores on which to parallelize the process, defaults to 2.}

\item{bootstrap.n}{the number of bootstrap steps. Should ideally be >5}

\item{bootstrap.set_size}{the size of the random sub genesets for the bootstrap, defaults to ngenes/3 (ngenes being the number of \emph{overlapping} genes between sample and reference).}

\item{prior}{a vector with an approximate development time of the samples, must be in the same units than \code{ref.time_series}. Vector is recycled if its length is smaller than the number of samples}

\item{prior.params}{the std. deviation of the prior scoring distribution. \emph{Note that setting this value too low can cause a significant bias in the age estimation.}}

\item{verbose}{boolean ; if TRUE, displays messages of the various steps of the method.}
}
\value{
an \code{ae} object, which is a list of the age estimates, the correlation matrix between sample and reference,
the reference time series as well as the bootstrap correlation matrices and age estimates.
There are \code{plot}, \code{print} and \code{summary} methods for this object.
}
\description{
This function estimates the developmental age of sample individuals based on
correlation with given reference data.
}
\details{
The implemented bootstrap procedure re-estimates the age on random gene subsets
of fixed size to evaluate the robustness of the estimate, given in the form of
the Median Absolute Deviation of the bootstrap age estimates to the global estimate.

Using interpolated reference data gives more precise results.

A prior can be given to help with the estimate, in which case the peaks
of the correlation profiles will be scored according to a gaussian
of the specified parameters.
}
\examples{
\donttest{
requireNamespace('wormRef', quietly = TRUE)

# get some samples to stage
samp <- wormRef::Cel_larval$g[,13:15]

# load interpolated reference
r_larv <- prepare_refdata(ref = 'Cel_larval', datapkg = 'wormRef' , n.inter = 200)

# perform age estimate
ae_test <- ae(samp = samp, 
              refdata = r_larv$interpGE, 
              ref.time_series = r_larv$time.series)

# check output
summary(ae_test)
plot(ae_test, show.boot_estimates = TRUE) # plot all sample estimates
plot_cor.ae(ae_test) # plot individual correlation profiles of samples

# get results
ae_test$age.estimates
}
}
