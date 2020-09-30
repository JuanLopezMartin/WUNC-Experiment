#
# This is the user-interface definition of a Shiny web application. You can
# run the application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)

# Define UI for application that draws a histogram
shinyUI(fluidPage(

    # Application title
    titlePanel("Simulations for experiment"),

    # Sidebar with a slider input for number of bins
    sidebarLayout(
        sidebarPanel(
            sliderInput("N_subjects", "Sample size:", min = 100, max = 2000, value = 500, step = 100),
            sliderInput("n_movements_per_subject", "Number of movements per subject:", min = 2, max = 10, value = 5, step = 1),
            fluidRow(
                tags$h3("Intercepts", align = "center"),
                column(8, 
                       tags$h4("Alpha"),
                       div(style="display: inline-block;vertical-align:top; width: 75px;", numericInput("mualpha", ("Mu"), value = -4, min = -5, max = 5)),
                       div(style="display: inline-block;vertical-align:top; width: 1px;",HTML("<br>")),
                       div(style="display: inline-block;vertical-align:top; width: 75px;", numericInput("sigmaalphap", ("SigmaP"), value = 0.5, min = 0, max = 3)),
                       div(style="display: inline-block;vertical-align:top; width: 1px;",HTML("<br>")),
                       div(style="display: inline-block;vertical-align:top; width: 75px;", numericInput("sigmaalpham", ("SigmaM"), value = 1, min = 0, max = 3)),
                       
                ),
            ),
            fluidRow(
                tags$h3("Coefficients", align = "center"),
                column(6, 
                       tags$h4("Affinity"),
                       div(style="display: inline-block;vertical-align:top; width: 75px;", numericInput("mubeta0", ("Mu"), value = 2, min = -5, max = 5)),
                       div(style="display: inline-block;vertical-align:top; width: 1px;",HTML("<br>")),
                       div(style="display: inline-block;vertical-align:top; width: 75px;", numericInput("sigmabeta0m", ("SigmaM"), value = 0.5, min = 0, max = 3)),
                       div(style="display: inline-block;vertical-align:top; width: 1px;",HTML("<br>")),
                       div(style="display: inline-block;vertical-align:top; width: 75px;", numericInput("sigmabeta0p", ("SigmaP"), value = 1, min = 0, max = 3)),
                       tags$h4("X2"),
                       div(style="display: inline-block;vertical-align:top; width: 75px;", numericInput("mubeta2", ("Mu"), value = 0.4, min = -5, max = 5)),
                       div(style="display: inline-block;vertical-align:top; width: 1px;",HTML("<br>")),
                       div(style="display: inline-block;vertical-align:top; width: 75px;", numericInput("sigmabeta2m", ("SigmaM"), value = 0.1, min = 0, max = 3)),
                       div(style="display: inline-block;vertical-align:top; width: 1px;",HTML("<br>")),
                       div(style="display: inline-block;vertical-align:top; width: 75px;", numericInput("sigmabeta2p", ("SigmaP"), value = 0.2, min = 0, max = 3)),
                       tags$h4("X4"),
                       div(style="display: inline-block;vertical-align:top; width: 75px;", numericInput("mubeta4", ("Mu"), value = 0.1, min = -5, max = 5)),
                       div(style="display: inline-block;vertical-align:top; width: 1px;",HTML("<br>")),
                       div(style="display: inline-block;vertical-align:top; width: 75px;", numericInput("sigmabeta4m", ("SigmaM"), value = 0.025, min = 0, max = 3)),
                       div(style="display: inline-block;vertical-align:top; width: 1px;",HTML("<br>")),
                       div(style="display: inline-block;vertical-align:top; width: 75px;", numericInput("sigmabeta4p", ("SigmaP"), value = 0.05, min = 0, max = 3)),
                       ),
                column(6,
                        tags$h4("X1"),
                       div(style="display: inline-block;vertical-align:top; width: 75px;", numericInput("mubeta1", ("Mu"), value = 0.8, min = -5, max = 5)),
                       div(style="display: inline-block;vertical-align:top; width: 1px;",HTML("<br>")),
                       div(style="display: inline-block;vertical-align:top; width: 75px;", numericInput("sigmabeta1m", ("SigmaM"), value = 0.2, min = 0, max = 3)),
                       div(style="display: inline-block;vertical-align:top; width: 1px;",HTML("<br>")),
                       div(style="display: inline-block;vertical-align:top; width: 75px;", numericInput("sigmabeta1p", ("SigmaP"), value = 0.4, min = 0, max = 3)),
                       tags$h4("X3"),
                       div(style="display: inline-block;vertical-align:top; width: 75px;", numericInput("mubeta3", ("Mu"), value = 0.2, min = -5, max = 5)),
                       div(style="display: inline-block;vertical-align:top; width: 1px;",HTML("<br>")),
                       div(style="display: inline-block;vertical-align:top; width: 75px;", numericInput("sigmabeta3m", ("SigmaM"), value = 0.05, min = 0, max = 3)),
                       div(style="display: inline-block;vertical-align:top; width: 1px;",HTML("<br>")),
                       div(style="display: inline-block;vertical-align:top; width: 75px;", numericInput("sigmabeta3p", ("SigmaP"), value = 0.1, min = 0, max = 3)),
                       tags$h4("X5"),
                       div(style="display: inline-block;vertical-align:top; width: 75px;", numericInput("mubeta5", ("Mu"), value = 0.05, min = -5, max = 5)),
                       div(style="display: inline-block;vertical-align:top; width: 1px;",HTML("<br>")),
                       div(style="display: inline-block;vertical-align:top; width: 75px;", numericInput("sigmabeta5m", ("SigmaM"), value = 0.0125, min = 0, max = 3)),
                       div(style="display: inline-block;vertical-align:top; width: 1px;",HTML("<br>")),
                       div(style="display: inline-block;vertical-align:top; width: 75px;", numericInput("sigmabeta5p", ("SigmaP"), value = 0.025, min = 0, max = 3)),)
        ),
        tags$h3("Error term", align = "center"),
        div(style="display: inline-block;vertical-align:top; width: 75px;", numericInput("sigmaepsilon", ("Sigma"), value = 2, min = 0, max = 5))
        , width = 5),

        # Show a plot of the generated distribution
        mainPanel(
            h3("Data generating process: "),
            withMathJax("$$ y_{ij} = \\alpha + \\alpha_{[j]} + \\alpha_{[i]} + \\beta_{0[i]} *{\\rm Affinity}_{ij} + \\beta_{1[i]} *X_{1ij} + \\beta_{2[i]} *X_{2ij} + \\beta_{3[i]} *X_{3ij} + \\beta_{4[i]} *X_{4ij} + \\beta_{5[i]} *X_{5ij} + \\epsilon $$"),
            br(),
            h3("General Results: "),
            br(),
            column(12, tableOutput('coeftable'), align = "center"),
            br(),
            column(12, textOutput("powertext"), align = "center"),
            column(width = 12, style='padding:20px;'),
            h3("Results for this simulation: "),
            br(),
            column(5, plotOutput("histplot")),
            column(7, plotOutput("coefplot")),
            column(width = 12, style='padding:10px;'),
            column(12, textOutput("r2"), align = "center"),
            column(width = 12, style='padding:10px;'),
            width = 7
        )
    )
))
