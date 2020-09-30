#
# This is the server logic of a Shiny web application. You can run the
# application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)
library(lme4)
library(dplyr)
library(ggplot2)
library(MuMIn)
library(MASS)

# Define server logic required to draw a histogram
shinyServer(function(input, output) {
    df <- reactive({
        coefs <- data.frame(alpha = c(input$mualpha, input$sigmaalphap, input$sigmaalpham),
                            beta0 = c(input$mubeta0, input$sigmabeta0p, input$sigmabeta0m),
                            beta1 = c(input$mubeta1, input$sigmabeta1p, input$sigmabeta1m),
                            beta2 = c(input$mubeta2, input$sigmabeta2p, input$sigmabeta2m),
                            beta3 = c(input$mubeta3, input$sigmabeta3p, input$sigmabeta3m),
                            beta4 = c(input$mubeta4, input$sigmabeta4p, input$sigmabeta4m),
                            beta5 = c(input$mubeta5, input$sigmabeta5p, input$sigmabeta5m))
        N_subjects = input$N_subjects
        n_movements_per_subject = input$n_movements_per_subject
        total_rows = N_subjects*n_movements_per_subject
        
        design_mat <- matrix(replicate(total_rows, rbinom(5, size = 1, .5)), nrow = total_rows)
        movements <- rep(1:n_movements_per_subject, N_subjects)
        participants <- sort(rep(1:N_subjects, n_movements_per_subject))
        design_mat  <- data.frame(cbind(participants, movements, design_mat))
        colnames(design_mat) <- c("participant_ID", "movement_ID", "X1", "X2", "X3", "X4", "X5")
        
        participant_ID <- 1:N_subjects
        political_affiliation <- rnorm(N_subjects, 0, 1.5)
        alpha_p <- mvrnorm(N_subjects, 0, coefs$alpha[2], empirical=TRUE)
        beta0_p <- mvrnorm(N_subjects, 0, coefs$beta0[2], empirical=TRUE)
        beta1_p <- mvrnorm(N_subjects, 0, coefs$beta1[2], empirical=TRUE)
        beta2_p <- mvrnorm(N_subjects, 0, coefs$beta2[2], empirical=TRUE)
        beta3_p <- mvrnorm(N_subjects, 0, coefs$beta3[2], empirical=TRUE)
        beta4_p <- mvrnorm(N_subjects, 0, coefs$beta4[2], empirical=TRUE)
        beta5_p <- mvrnorm(N_subjects, 0, coefs$beta5[2], empirical=TRUE)
        participants_mat  <- data.frame(participant_ID, political_affiliation, alpha_p, beta0_p, beta1_p, beta2_p, beta3_p, beta4_p, beta5_p)
        
        movement_ID <- 1:n_movements_per_subject
        alpha_m <- mvrnorm(n_movements_per_subject, 0, coefs$alpha[3], empirical=TRUE)
        beta0_m <- mvrnorm(n_movements_per_subject, 0, coefs$beta0[3], empirical=TRUE)
        beta1_m <- mvrnorm(n_movements_per_subject, 0, coefs$beta1[3], empirical=TRUE)
        beta2_m <- mvrnorm(n_movements_per_subject, 0, coefs$beta2[3], empirical=TRUE)
        beta3_m <- mvrnorm(n_movements_per_subject, 0, coefs$beta3[3], empirical=TRUE)
        beta4_m <- mvrnorm(n_movements_per_subject, 0, coefs$beta4[3], empirical=TRUE)
        beta5_m <- mvrnorm(n_movements_per_subject, 0, coefs$beta5[3], empirical=TRUE)
        movement_ideology <- seq(-2.5, 2.5, length.out = n_movements_per_subject)
        movements_mat  <- data.frame(movement_ID, movement_ideology, alpha_m, beta0_m, beta1_m, beta2_m, beta3_m, beta4_m, beta5_m)
        
        df <- inner_join(design_mat, participants_mat, by = "participant_ID")
        df <- inner_join(df, movements_mat, by = "movement_ID")
        df$affinity <- (6 - abs(df$movement_ideology - df$political_affiliation))/6
        df$support <- coefs$alpha[1] + df$alpha_p + df$alpha_m +
            as.matrix(df[,c("affinity", "X1", "X2", "X3", "X4", "X5")]) %*% t(coefs[1,2:7]) + 
            as.matrix(df[,c("affinity", "X1", "X2", "X3", "X4", "X5")]) %*% t(coefs[2,2:7]) + 
            as.matrix(df[,c("affinity", "X1", "X2", "X3", "X4", "X5")]) %*% t(coefs[3,2:7]) +
            rnorm(total_rows, 0, input$sigmaepsilon)
        pmin_pmax_clip <- function(x, a, b) pmax(a, pmin(x, b))
        df$support <- pmin_pmax_clip(df$support, -5, 5)
        return(df)
    })
    model <- reactive({
        df <- df()
        fit_lme <- lmer(support ~ 1 + affinity + X1 + X2 + X3 + X4 + X5 + (1 + affinity + X1 + X2 + X3 + X4 + X5 | movement_ID),
                        data = df)
        return(fit_lme)
    })
    
    toplot <- reactive({
        toplot <- data.frame(coef(summary(model())))[-1,]
        toplot$var <- row.names(toplot)
        toplot$True <- c(input$mubeta0, input$mubeta1, input$mubeta2, input$mubeta3, input$mubeta4, input$mubeta5)
        return(toplot)
    })

    output$coefplot <- renderPlot({
        ggplot(data = toplot(), aes(x = var, y = Estimate)) + geom_point() +
        geom_point(aes(y = True), color = "blue", shape = 4) +
        geom_errorbar(aes(ymin = Estimate - 2*Std..Error, ymax = Estimate + 2*Std..Error), width = 0.1) +
        coord_flip() + xlab("") + theme_bw() + geom_hline(aes(yintercept = 0), linetype = "dashed")
        })
    output$histplot <- renderPlot({
        ggplot(data = df(), aes(x = support)) + geom_histogram(bins = 40) + xlim(c(-5,5)) + theme_bw()
        })
    output$coeftable <- renderTable({
        coeftable <- toplot()
        coeftable$Power <- pnorm(coeftable$True/coeftable$Std..Error, 1.96, 1)
        coeftable$t.value = NULL
        coeftable$Estimate = NULL
        coeftable <- coeftable[c("var", "True", "Std..Error", "Power")]
        coeftable
    }, align = "c")
    output$powertext <- renderText({
        paste("An study such as this one would have 80% power for an effect size of approximately ", 
              round(2.8*mean(toplot()$Std..Error[2:6]), 2),
              ", or around",
              round(toplot()$True[1]/(2.8*mean(toplot()$Std..Error[2:6]))),
              "times less than the effect size of affinity")
    }) 
    output$r2 <- renderText({
        paste("The R^2 is", round(r.squaredGLMM(model())[2], 3), ", although this number is very sensible to Monte Carlo error")
    })
})
