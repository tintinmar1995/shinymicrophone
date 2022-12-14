require(shiny)
require(RCurl)

#' @param input,output,session Standard Shiny server arguments.
#'
#' @export
#'
#' @title Write a MP3 file
#'
#' @description Write a MP3 file from the returns of audioRecordServer
#'
#'
#' @return A \code{reactiveValues} with 2 slots :
#'  \itemize{
#'   \item \strong{url} : character, mediaURL.
#'   \item \strong{type} : character, type (e.g. base64).
#'   \item \strong{mime} : character, mime (e.g. audio/mp3).
#'   \item \strong{data} : character, audio data (in base64).
#'  }
#'
#' @importFrom shiny reactive isolate
#' @importFrom stringr str_replace str_split
#'
audioRecordServer <- function(id){

  moduleServer(
    id,
    function(input, output, session){

      out <- reactive({

        input$data
        isolate({
          if (is.null(input$data)){
            return(NULL)
          } else {
            str = stringr::str_split(input$data, ',')
            data = str[[1]][2]

            mime_type = stringr::str_replace(str[[1]][1], 'data:', '')
            str = stringr::str_split(mime_type, ';')
            mime = str[[1]][1]
            type = str[[1]][2]

            return(list(
              url=input$url,
              type=type,
              mime=mime,
              data=data
            ))
          }
        })

      })

      return(out)
    }
  )
}


#' Buttons to manage audio recording
#'
#' @param id Module's id.
#' @param label_start Label for the start button.
#' @param label_stop Label for the stop button.
#'
#'
#' @export
#'
#' @importFrom shiny NS actionButton includeHTML tags tagList
#'
audioRecordButtons <- function(id, label_start = "Record", label_stop = "Stop") {
  ns <- NS(id)
  tagList(
    useShinyjs(),

    # Add Shiny Buttons
    actionButton(ns("record"), label = label_start),
    actionButton(ns("stop"), label = label_stop),

    # Create JS objects from Shiny-UI
    tags$script(paste0(
      "const startAudioButton = document.querySelector('#",
      ns("record"), "');")),
    tags$script(paste0(
      "const stopButton = document.querySelector('#",
      ns("stop"), "');")),

    # Add script linked to shiny button
    includeHTML(paste0(
      system.file(file.path("templates"), package = "shinymicrophone"),
      '/audio-script.html'
    )),

  )
}
