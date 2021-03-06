#' @import miniUI
#' @import shiny
#' @import rstudioapi
pipefittrAddin <- function() {
  
  ui <- miniPage(
    gadgetTitleBar("Reformat Code"),
    miniContentPanel(
      h4("Use pipefittr to reformat code."), 
      hr(),
      checkboxInput("pretty", "Pretty?", FALSE),
      uiOutput("document", container = rCodeContainer)
    )
  )
  
  server <- function(input, output, session) {
    
    # Get the document context.
    context <- rstudioapi::getActiveDocumentContext()
    text <- context$selection[[1]]$text
    
    reactiveDocument <- reactive({
      
      # Collect inputs
      pretty <- input$pretty
      
      # Build formatted document
      formatted <- pipefittr(text, pretty)
      
      formatted
    })
    
    output$document <- renderCode({
      document <- reactiveDocument()
      highlightCode(session, "document")
      document
    })
    
    observeEvent(input$done, {
      result <- paste(reactiveDocument(), collapse = "\n")
      rstudioapi::insertText(result)
      invisible(stopApp())
    })
    
  }
  
  viewer <- dialogViewer("Reformat Code", width = 1000, height = 800)
  runGadget(ui, server, viewer = viewer)
  
}