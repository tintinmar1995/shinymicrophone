% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/module.R
\name{audioRecordServer}
\alias{audioRecordServer}
\title{Write a MP3 file}
\usage{
audioRecordServer(id)
}
\arguments{
\item{input, output, session}{Standard Shiny server arguments.}
}
\value{
A \code{reactiveValues} with 2 slots :
 \itemize{
  \item \strong{url} : character, mediaURL.
  \item \strong{type} : character, type (e.g. base64).
  \item \strong{mime} : character, mime (e.g. audio/mp3).
  \item \strong{data} : character, audio data (in base64).
 }
}
\description{
Write a MP3 file from the returns of audioRecordServer
}
