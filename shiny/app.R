# A small Shiny app that reuses the project's engine (R/functions/) and the
# same mock data as the analysis — no logic is duplicated here.
library(shiny)

# Load the shared engine: packages, paths, cleaning functions, plot helpers.
source(here::here("R", "01_setup.R"))

# Same cleaned dataset the website and manuscript use (mock data by default).
consumer <- get_clean_consumer_data()

ui <- fluidPage(
  titlePanel("The Science Repository — example app"),
  sidebarLayout(
    sidebarPanel(
      sliderInput("age_range", "Age range:",
                  min = 18, max = 80, value = c(25, 65))
    ),
    mainPanel(
      plotOutput("pi_plot"),
      tableOutput("summary")
    )
  )
)

server <- function(input, output, session) {
  filtered <- reactive({
    subset(consumer, age >= input$age_range[1] & age <= input$age_range[2])
  })

  # Reuse the project's plotting function — same figure as on the website.
  output$pi_plot <- renderPlot({
    plot_pi_by_condition(filtered())
  })

  output$summary <- renderTable({
    d <- filtered()
    data.frame(
      n             = nrow(d),
      mean_intention = round(mean(d$purchase_intention, na.rm = TRUE), 2),
      sd_intention   = round(sd(d$purchase_intention, na.rm = TRUE), 2)
    )
  })
}

shinyApp(ui, server)
