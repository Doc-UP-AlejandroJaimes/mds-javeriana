# -*- coding: utf-8 -*-
# !!! Abrir este archivo en RStudio con: File > Reopen with Encoding > UTF-8
# =============================================================================
# ACTIVIDAD 3 - Metodos y Simulacion Estadistica - 20261
# Autor: Juan Alejandro Carrillo Jaimes
# App Shiny: Regresion Lineal Simple - Rendimiento Academico
# =============================================================================

library(shiny)
library(shinythemes)
library(ggplot2)
library(corrplot)
library(DT)
library(moments)

# =============================================================================
# CARGA DE DATOS
# =============================================================================
mat <- read.csv("student-mat.csv", sep = ";", header = TRUE)
por <- read.csv("student-por.csv", sep = ";", header = TRUE)

# Variables candidatas (sin G1, G2, G3)
candidatas <- c("failures", "Medu", "studytime", "age", "Fedu",
                "absences", "goout", "Dalc", "Walc", "health",
                "traveltime", "famrel", "freetime")

# Paleta Javeriana
col_azul <- "#2C5697"
col_amar <- "#F8CD00"
col_gris <- "#6c757d"
col_rojo <- "#E24B4A"

# =============================================================================
# CSS PERSONALIZADO
# =============================================================================
css_javeriana <- "
  /* Fondo general */
  body { background-color: #f5f7fa; font-family: 'Georgia', serif; }

  /* Navbar */
  .navbar { background-color: #2C5697 !important; border: none; }
  .navbar .navbar-brand,
  .navbar-default .navbar-nav > li > a {
    color: #ffffff !important;
    font-weight: bold;
  }
  .navbar-default .navbar-nav > .active > a,
  .navbar-default .navbar-nav > .active > a:hover {
    background-color: #F8CD00 !important;
    color: #2C5697 !important;
  }
  .navbar-default .navbar-nav > li > a:hover {
    color: #F8CD00 !important;
  }

  /* Tarjetas de panel */
  .well {
    background-color: #ffffff;
    border: 1px solid #dce3ef;
    border-radius: 8px;
    box-shadow: 0 2px 6px rgba(44,86,151,0.08);
  }

  /* Titulos de seccion */
  h3, h4 { color: #2C5697; font-weight: bold; }

  /* Boton principal */
  .btn-primary {
    background-color: #2C5697 !important;
    border-color: #2C5697 !important;
    color: #ffffff !important;
    font-weight: bold;
  }
  .btn-primary:hover {
    background-color: #F8CD00 !important;
    border-color: #F8CD00 !important;
    color: #2C5697 !important;
  }

  /* Selectores y sliders */
  .selectize-input { border-color: #2C5697 !important; }
  .irs-bar, .irs-bar-edge { background: #2C5697 !important;
                             border-color: #2C5697 !important; }
  .irs-single { background: #2C5697 !important; }

  /* Caja de resultado */
  .caja-modelo {
    background: #eef3fb;
    border-left: 5px solid #2C5697;
    padding: 14px 18px;
    border-radius: 6px;
    margin-bottom: 16px;
  }
  .caja-modelo code { color: #2C5697; font-size: 1.05em; }

  /* Badge significancia */
  .badge-sig {
    background-color: #2C5697;
    color: white;
    padding: 3px 8px;
    border-radius: 10px;
    font-size: 0.85em;
  }

  /* Header superior decorativo */
  .header-app {
    background: linear-gradient(135deg, #2C5697 0%, #1a3a6b 100%);
    color: white;
    padding: 18px 24px;
    border-radius: 8px;
    margin-bottom: 20px;
  }
  .header-app h2 { color: #F8CD00; margin: 0 0 4px 0; font-size: 1.4em; }
  .header-app p  { margin: 0; font-size: 0.9em; opacity: 0.85; }
"

# =============================================================================
# UI
# =============================================================================
ui <- navbarPage(
  title       = "Regresion Lineal -- Rendimiento Academico",
  theme       = shinytheme("flatly"),
  id          = "tabs",
  header      = tags$head(tags$style(HTML(css_javeriana))),

  # ── PANEL LATERAL GLOBAL (controles compartidos) ─────────────────────────
  # Se replica en cada pestaña via sidebarLayout

  # ── PESTAÑA 1: CORRELACIONES ─────────────────────────────────────────────
  tabPanel(
    title = "Correlaciones",
    icon  = icon("chart-bar"),

    sidebarLayout(
      sidebarPanel(
        width = 3,
        div(class = "header-app",
            tags$h2("Controles"),
            tags$p("Configura el modelo")),

        selectInput("materia", "Materia:",
                    choices = c("Matematicas" = "mat",
                                "Portugues"   = "por")),

        selectInput("x_var", "Variable predictora:",
                    choices  = candidatas,
                    selected = "failures"),

        hr(),
        tags$h4("Excluir observaciones"),
        tags$p("Ingresa indices separados por coma (ej: 3, 48, 132)",
               style = "font-size:0.85em; color:#6c757d;"),
        textInput("excluir", label = NULL, placeholder = "ej: 3, 48, 132"),
        actionButton("btn_excluir", "Actualizar modelo",
                     class = "btn-primary btn-block",
                     icon  = icon("sync")),
        br(),
        actionButton("btn_reset", "Resetear exclusiones",
                     class = "btn-default btn-block",
                     icon  = icon("undo")),

        hr(),
        tags$small(style = "color:#6c757d;",
          "Pontificia Universidad Javeriana - 2026")
      ),

      mainPanel(
        width = 9,
        fluidRow(
          column(12,
            div(class = "header-app",
                tags$h2("Matriz de Correlaciones"),
                tags$p("Correlaciones de Pearson entre variables cuantitativas y G3"))
          )
        ),
        br(),
        fluidRow(
          column(6,
            wellPanel(
              tags$h4("Correlaciones con G3 (ordenadas)"),
              plotOutput("plot_barras_corr", height = "380px")
            )
          ),
          column(6,
            wellPanel(
              tags$h4("Matriz completa de correlaciones"),
              plotOutput("plot_matriz_corr", height = "380px")
            )
          )
        ),
        br(),
        fluidRow(
          column(12,
            wellPanel(
              tags$h4("Diagrama de dispersion G3 vs variable predictora"),
              plotOutput("plot_dispersion", height = "320px")
            )
          )
        )
      )
    )
  ),

  # ── PESTAÑA 2: RESUMEN DEL MODELO ────────────────────────────────────────
  tabPanel(
    title = "Modelo",
    icon  = icon("calculator"),

    sidebarLayout(
      sidebarPanel(
        width = 3,
        div(class = "header-app",
            tags$h2("Controles"),
            tags$p("Configura el modelo")),

        selectInput("materia2", "Materia:",
                    choices = c("Matematicas" = "mat",
                                "Portugues"   = "por")),

        selectInput("x_var2", "Variable predictora:",
                    choices  = candidatas,
                    selected = "failures"),

        hr(),
        tags$h4("Excluir observaciones"),
        tags$p("Ingresa indices separados por coma",
               style = "font-size:0.85em; color:#6c757d;"),
        textInput("excluir2", label = NULL, placeholder = "ej: 3, 48"),
        actionButton("btn_excluir2", "Actualizar modelo",
                     class = "btn-primary btn-block",
                     icon  = icon("sync")),
        br(),
        actionButton("btn_reset2", "Resetear exclusiones",
                     class = "btn-default btn-block",
                     icon  = icon("undo"))
      ),

      mainPanel(
        width = 9,
        fluidRow(
          column(12,
            div(class = "header-app",
                tags$h2("Resumen del Modelo de Regresion"),
                tags$p("Estimaciones MCO, pruebas t, F y coeficiente de determinacion"))
          )
        ),
        br(),
        fluidRow(
          column(12,
            wellPanel(
              uiOutput("ecuacion_modelo")
            )
          )
        ),
        fluidRow(
          column(6,
            wellPanel(
              tags$h4("Estimaciones de parametros"),
              DTOutput("tabla_params")
            )
          ),
          column(6,
            wellPanel(
              tags$h4("Tabla ANOVA"),
              DTOutput("tabla_anova")
            )
          )
        ),
        br(),
        fluidRow(
          column(4,
            wellPanel(
              tags$h4("Metricas globales"),
              uiOutput("metricas_modelo")
            )
          ),
          column(8,
            wellPanel(
              tags$h4("Recta ajustada"),
              plotOutput("plot_recta", height = "280px")
            )
          )
        )
      )
    )
  ),

  # ── PESTAÑA 3: DIAGNÓSTICO ───────────────────────────────────────────────
  tabPanel(
    title = "Diagnostico",
    icon  = icon("stethoscope"),

    sidebarLayout(
      sidebarPanel(
        width = 3,
        div(class = "header-app",
            tags$h2("Controles"),
            tags$p("Configura el modelo")),

        selectInput("materia3", "Materia:",
                    choices = c("Matematicas" = "mat",
                                "Portugues"   = "por")),

        selectInput("x_var3", "Variable predictora:",
                    choices  = candidatas,
                    selected = "failures"),

        hr(),
        tags$h4("Excluir observaciones"),
        textInput("excluir3", label = NULL, placeholder = "ej: 3, 48"),
        actionButton("btn_excluir3", "Actualizar modelo",
                     class = "btn-primary btn-block",
                     icon  = icon("sync")),
        br(),
        actionButton("btn_reset3", "Resetear exclusiones",
                     class = "btn-default btn-block",
                     icon  = icon("undo")),

        hr(),
        tags$h4("Umbral Cook's D"),
        radioButtons("umbral_cook", label = NULL,
                     choices  = c("4/n (recomendado)" = "4n",
                                  "D > 1 (estricto)"  = "1"),
                     selected = "4n")
      ),

      mainPanel(
        width = 9,
        fluidRow(
          column(12,
            div(class = "header-app",
                tags$h2("Analisis de Diagnostico"),
                tags$p("Verificacion de supuestos: linealidad, normalidad, homocedasticidad"))
          )
        ),
        br(),
        fluidRow(
          column(6,
            wellPanel(
              tags$h4("Residuos vs. Valores ajustados"),
              plotOutput("plot_res_ajust", height = "260px")
            )
          ),
          column(6,
            wellPanel(
              tags$h4("Grafico Q-Q"),
              plotOutput("plot_qq", height = "260px")
            )
          )
        ),
        fluidRow(
          column(6,
            wellPanel(
              tags$h4("Distancia de Cook"),
              plotOutput("plot_cook", height = "260px")
            )
          ),
          column(6,
            wellPanel(
              tags$h4("Scale-Location"),
              plotOutput("plot_scale", height = "260px")
            )
          )
        ),
        br(),
        fluidRow(
          column(12,
            wellPanel(
              tags$h4("Pruebas formales de supuestos"),
              DTOutput("tabla_supuestos")
            )
          )
        ),
        br(),
        fluidRow(
          column(12,
            wellPanel(
              tags$h4("Observaciones influyentes (Cook D > umbral)"),
              DTOutput("tabla_influyentes")
            )
          )
        )
      )
    )
  ),

  # ── PESTAÑA 4: PREDICCIÓN ────────────────────────────────────────────────
  tabPanel(
    title = "Prediccion",
    icon  = icon("bullseye"),

    sidebarLayout(
      sidebarPanel(
        width = 3,
        div(class = "header-app",
            tags$h2("Controles"),
            tags$p("Configura el modelo")),

        selectInput("materia4", "Materia:",
                    choices = c("Matematicas" = "mat",
                                "Portugues"   = "por")),

        selectInput("x_var4", "Variable predictora:",
                    choices  = candidatas,
                    selected = "failures"),

        hr(),
        tags$h4("Excluir observaciones"),
        textInput("excluir4", label = NULL, placeholder = "ej: 3, 48"),
        actionButton("btn_excluir4", "Actualizar modelo",
                     class = "btn-primary btn-block",
                     icon  = icon("sync")),
        br(),
        actionButton("btn_reset4", "Resetear exclusiones",
                     class = "btn-default btn-block",
                     icon  = icon("undo")),

        hr(),
        tags$h4("Valor a predecir"),
        uiOutput("slider_prediccion"),

        br(),
        tags$h4("Nivel de confianza"),
        sliderInput("nivel_conf", label = NULL,
                    min = 0.90, max = 0.99,
                    value = 0.95, step = 0.01,
                    post = "")
      ),

      mainPanel(
        width = 9,
        fluidRow(
          column(12,
            div(class = "header-app",
                tags$h2("Prediccion de la Nota Final"),
                tags$p("Intervalos de confianza para la media e intervalos de prediccion individual"))
          )
        ),
        br(),
        fluidRow(
          column(12,
            wellPanel(
              uiOutput("resultado_prediccion")
            )
          )
        ),
        br(),
        fluidRow(
          column(12,
            wellPanel(
              tags$h4("Recta ajustada con bandas de confianza y prediccion"),
              plotOutput("plot_bandas", height = "380px")
            )
          )
        ),
        br(),
        fluidRow(
          column(12,
            wellPanel(
              tags$h4("Tabla de predicciones para todos los valores observados"),
              DTOutput("tabla_predicciones")
            )
          )
        )
      )
    )
  )
)

# =============================================================================
# FUNCIONES AUXILIARES
# =============================================================================

# Obtiene el dataset según selección, aplica exclusiones
get_datos <- function(materia, excluir_txt) {
  df <- if (materia == "mat") mat else por
  if (nchar(trimws(excluir_txt)) > 0) {
    idx <- suppressWarnings(
      as.integer(unlist(strsplit(excluir_txt, "[,\\s]+")))
    )
    idx <- idx[!is.na(idx) & idx >= 1 & idx <= nrow(df)]
    if (length(idx) > 0) df <- df[-idx, ]
  }
  df
}

# Ajusta el modelo y devuelve lista con todo
ajustar_modelo <- function(df, x_var) {
  formula  <- as.formula(paste("G3 ~", x_var))
  modelo   <- lm(formula, data = df)
  x        <- df[[x_var]]
  y        <- df$G3
  n        <- nrow(df)
  x_bar    <- mean(x);  y_bar <- mean(y)
  Sxx      <- sum((x - x_bar)^2)
  Sxy      <- sum((x - x_bar) * (y - y_bar))
  Syy      <- sum((y - y_bar)^2)
  b1       <- Sxy / Sxx
  b0       <- y_bar - b1 * x_bar
  SCReg    <- b1^2 * Sxx
  SCE      <- Syy - SCReg
  CME      <- SCE / (n - 2)
  sigma    <- sqrt(CME)
  R2       <- SCReg / Syy
  F_stat   <- (SCReg / 1) / CME
  p_F      <- pf(F_stat, 1, n - 2, lower.tail = FALSE)
  SE_b1    <- sqrt(CME / Sxx)
  SE_b0    <- sqrt(CME * (1/n + x_bar^2 / Sxx))
  t_b1     <- b1 / SE_b1
  t_b0     <- b0 / SE_b0
  p_b1     <- 2 * pt(abs(t_b1), df = n - 2, lower.tail = FALSE)
  p_b0     <- 2 * pt(abs(t_b0), df = n - 2, lower.tail = FALSE)
  list(
    modelo = modelo, df = df, x = x, y = y, n = n,
    x_var = x_var, x_bar = x_bar, y_bar = y_bar,
    b0 = b0, b1 = b1, SE_b0 = SE_b0, SE_b1 = SE_b1,
    t_b0 = t_b0, t_b1 = t_b1, p_b0 = p_b0, p_b1 = p_b1,
    SCReg = SCReg, SCE = SCE, Syy = Syy,
    CME = CME, sigma = sigma, R2 = R2,
    F_stat = F_stat, p_F = p_F, Sxx = Sxx
  )
}

fmt_p <- function(p) {
  if (p < 0.0001) "< 0.0001" else round(p, 4)
}

# =============================================================================
# SERVER
# =============================================================================
server <- function(input, output, session) {

  # ── Reactivos de exclusión con botones ─────────────────────────────────
  excluir_val  <- reactiveVal("")
  excluir_val2 <- reactiveVal("")
  excluir_val3 <- reactiveVal("")
  excluir_val4 <- reactiveVal("")

  observeEvent(input$btn_excluir,  { excluir_val(input$excluir)   })
  observeEvent(input$btn_reset,    { excluir_val(""); updateTextInput(session, "excluir",  value = "") })
  observeEvent(input$btn_excluir2, { excluir_val2(input$excluir2) })
  observeEvent(input$btn_reset2,   { excluir_val2(""); updateTextInput(session, "excluir2", value = "") })
  observeEvent(input$btn_excluir3, { excluir_val3(input$excluir3) })
  observeEvent(input$btn_reset3,   { excluir_val3(""); updateTextInput(session, "excluir3", value = "") })
  observeEvent(input$btn_excluir4, { excluir_val4(input$excluir4) })
  observeEvent(input$btn_reset4,   { excluir_val4(""); updateTextInput(session, "excluir4", value = "") })

  # ── Modelos reactivos ──────────────────────────────────────────────────
  mod1 <- reactive({ m <- ajustar_modelo(get_datos(input$materia,  excluir_val()),  input$x_var);  m })
  mod2 <- reactive({ m <- ajustar_modelo(get_datos(input$materia2, excluir_val2()), input$x_var2); m })
  mod3 <- reactive({ m <- ajustar_modelo(get_datos(input$materia3, excluir_val3()), input$x_var3); m })
  mod4 <- reactive({ m <- ajustar_modelo(get_datos(input$materia4, excluir_val4()), input$x_var4); m })

  # ════════════════════════════════════════════════════════════════════════
  # PESTAÑA 1: CORRELACIONES
  # ════════════════════════════════════════════════════════════════════════

  output$plot_barras_corr <- renderPlot({
    df  <- get_datos(input$materia, excluir_val())
    r   <- sapply(candidatas, function(v) cor(df[[v]], df$G3))
    dat <- data.frame(variable = names(r), r = as.numeric(r))
    ggplot(dat, aes(x = reorder(variable, abs(r)), y = r,
                   fill = ifelse(r >= 0, "Positiva", "Negativa"))) +
      geom_col(alpha = 0.85) +
      geom_hline(yintercept = 0, linewidth = 0.4) +
      coord_flip() +
      scale_fill_manual(values = c("Positiva" = col_azul, "Negativa" = col_rojo),
                        name = "Direccion") +
      labs(x = "", y = "r de Pearson") +
      theme_minimal(base_size = 12) +
      theme(legend.position = "bottom",
            axis.text = element_text(color = "#2d2d2d"))
  })

  output$plot_matriz_corr <- renderPlot({
    df      <- get_datos(input$materia, excluir_val())
    vars_c  <- cor(df[, c(candidatas, "G3")], use = "complete.obs")
    corrplot(vars_c, method = "color", type = "upper",
             tl.col = "black", tl.srt = 45, tl.cex = 0.7,
             col = colorRampPalette(c(col_rojo, "white", col_azul))(200),
             addCoef.col = "black", number.cex = 0.45,
             mar = c(0, 0, 0.5, 0))
  })

  output$plot_dispersion <- renderPlot({
    m   <- mod1()
    r_v <- round(cor(m$x, m$y), 4)
    df_disp <- data.frame(x = m$x, G3 = m$y)
    ggplot(df_disp, aes(x = x, y = G3)) +
      geom_point(color = col_azul, alpha = 0.45, size = 2.5) +
      geom_smooth(method = "lm", color = col_amar, se = TRUE,
                  fill = col_amar, alpha = 0.15) +
      labs(title    = paste0("G3 vs ", m$x_var),
           subtitle = paste0("r = ", r_v, "  |  n = ", m$n),
           x = m$x_var, y = "Nota Final (G3)") +
      theme_minimal(base_size = 13) +
      theme(plot.title    = element_text(color = col_azul, face = "bold"),
            plot.subtitle = element_text(color = col_gris))
  })

  # ════════════════════════════════════════════════════════════════════════
  # PESTAÑA 2: MODELO
  # ════════════════════════════════════════════════════════════════════════

  output$ecuacion_modelo <- renderUI({
    m   <- mod2()
    sig <- if (m$p_F < 0.001) "[OK] Modelo significativo (p < 0.001)"
           else if (m$p_F < 0.05) paste0("[OK] Modelo significativo (p = ", fmt_p(m$p_F), ")")
           else paste0("[!] Modelo NO significativo (p = ", fmt_p(m$p_F), ")")
    div(class = "caja-modelo",
        tags$h4("Modelo estimado"),
        tags$p(HTML(paste0(
          "<code>G3_hat = ", round(m$b0, 4),
          ifelse(m$b1 >= 0,
                 paste0(" + ", round(m$b1, 4)),
                 paste0(" - ", abs(round(m$b1, 4)))),
          " * ", m$x_var, "</code>"
        ))),
        tags$p(HTML(paste0(
          "<b>R2 = </b>", round(m$R2, 4),
          " &nbsp;|&nbsp; <b>sigma = </b>", round(m$sigma, 4),
          " &nbsp;|&nbsp; <b>n = </b>", m$n,
          " &nbsp;|&nbsp; ", sig
        )))
    )
  })

  output$tabla_params <- renderDT({
    m <- mod2()
    df_t <- data.frame(
      Parametro  = c("b0 (Intercepto)", paste0("b1 (", m$x_var, ")")),
      Estimacion = round(c(m$b0, m$b1), 4),
      Error.Std  = round(c(m$SE_b0, m$SE_b1), 4),
      t          = round(c(m$t_b0, m$t_b1), 4),
      p.valor    = c(fmt_p(m$p_b0), fmt_p(m$p_b1)),
      Sig        = c(
        ifelse(m$p_b0 < 0.001, "***",
               ifelse(m$p_b0 < 0.01, "**",
                      ifelse(m$p_b0 < 0.05, "*", "ns"))),
        ifelse(m$p_b1 < 0.001, "***",
               ifelse(m$p_b1 < 0.01, "**",
                      ifelse(m$p_b1 < 0.05, "*", "ns")))
      )
    )
    datatable(df_t, options = list(dom = "t", paging = FALSE),
              rownames = FALSE) |>
      formatStyle("Sig", color = col_azul, fontWeight = "bold")
  })

  output$tabla_anova <- renderDT({
    m  <- mod2()
    df_a <- data.frame(
      Fuente  = c("Regresion", "Error", "Total"),
      GL      = c(1, m$n - 2, m$n - 1),
      SC      = round(c(m$SCReg, m$SCE, m$Syy), 3),
      CM      = c(as.character(round(m$SCReg, 3)),
                  as.character(round(m$CME,   3)), ""),
      F.stat  = c(as.character(round(m$F_stat, 4)), "", ""),
      p.valor = c(fmt_p(m$p_F), "", "")
    )
    datatable(df_a, options = list(dom = "t", paging = FALSE),
              rownames = FALSE) |>
      formatStyle("Fuente", fontWeight = "bold")
  })

  output$metricas_modelo <- renderUI({
    m <- mod2()
    tags$table(style = "width:100%; font-size:0.95em;",
      tags$tr(tags$td("R2"),      tags$td(tags$b(round(m$R2, 4)))),
      tags$tr(tags$td("R2 adj"),  tags$td(tags$b(round(summary(m$modelo)$adj.r.squared, 4)))),
      tags$tr(tags$td("Sigma"),   tags$td(tags$b(round(m$sigma, 4)))),
      tags$tr(tags$td("F"),       tags$td(tags$b(round(m$F_stat, 4)))),
      tags$tr(tags$td("p (F)"),   tags$td(tags$b(fmt_p(m$p_F)))),
      tags$tr(tags$td("n"),       tags$td(tags$b(m$n)))
    )
  })

  output$plot_recta <- renderPlot({
    m <- mod2()
    df_r <- data.frame(x = m$x, G3 = m$y)
    ggplot(df_r, aes(x = x, y = G3)) +
      geom_point(color = col_azul, alpha = 0.35, size = 2) +
      geom_smooth(method = "lm", color = col_rojo, se = FALSE, linewidth = 1.2) +
      labs(x = m$x_var, y = "G3") +
      theme_minimal(base_size = 12)
  })

  # ════════════════════════════════════════════════════════════════════════
  # PESTAÑA 3: DIAGNÓSTICO
  # ════════════════════════════════════════════════════════════════════════

  output$plot_res_ajust <- renderPlot({
    m        <- mod3()
    y_hat    <- fitted(m$modelo)
    res_std  <- rstandard(m$modelo)
    df_p     <- data.frame(ajustados = y_hat, residuos = res_std)
    ggplot(df_p, aes(x = ajustados, y = residuos)) +
      geom_point(color = col_azul, alpha = 0.45, size = 1.8) +
      geom_hline(yintercept = 0,    color = col_rojo,   linetype = "dashed") +
      geom_hline(yintercept =  2,   color = "orange",   linetype = "dotted") +
      geom_hline(yintercept = -2,   color = "orange",   linetype = "dotted") +
      labs(title = "Residuos vs. Valores ajustados",
           x = "Valores ajustados (G3_hat)", y = "Residuos estandarizados") +
      theme_minimal(base_size = 12) +
      theme(plot.title = element_text(color = col_azul, face = "bold"))
  })

  output$plot_qq <- renderPlot({
    m       <- mod3()
    res_std <- rstandard(m$modelo)
    df_q    <- data.frame(sample = sort(res_std))
    n_      <- length(res_std)
    probs   <- (seq_len(n_) - 0.5) / n_
    df_q$theoretical <- qnorm(probs)
    ggplot(df_q, aes(x = theoretical, y = sample)) +
      geom_point(color = col_azul, alpha = 0.5, size = 1.8) +
      geom_abline(slope = 1, intercept = 0, color = col_rojo, linewidth = 1) +
      labs(title = "Grafico Q-Q",
           x = "Cuantiles teoricos", y = "Cuantiles muestrales") +
      theme_minimal(base_size = 12) +
      theme(plot.title = element_text(color = col_azul, face = "bold"))
  })

  output$plot_cook <- renderPlot({
    m       <- mod3()
    cook_d  <- cooks.distance(m$modelo)
    umbral  <- if (input$umbral_cook == "4n") 4 / m$n else 1
    df_c    <- data.frame(obs = seq_along(cook_d), cook = cook_d,
                          supera = cook_d > umbral)
    ggplot(df_c, aes(x = obs, y = cook, color = supera)) +
      geom_segment(aes(xend = obs, yend = 0), linewidth = 0.6) +
      geom_hline(yintercept = umbral, linetype = "dashed",
                 color = col_azul, linewidth = 0.8) +
      scale_color_manual(values = c("FALSE" = "#B4B2A9", "TRUE" = col_rojo),
                         guide = "none") +
      annotate("text", x = m$n * 0.7, y = umbral * 1.3,
               label = paste0("Umbral = ", round(umbral, 4)),
               color = col_azul, size = 3.5) +
      labs(title = "Distancia de Cook",
           x = "Indice de observacion", y = expression(D[i])) +
      theme_minimal(base_size = 12) +
      theme(plot.title = element_text(color = col_azul, face = "bold"))
  })

  output$plot_scale <- renderPlot({
    m       <- mod3()
    y_hat   <- fitted(m$modelo)
    res_std <- rstandard(m$modelo)
    df_s    <- data.frame(ajustados = y_hat, sqrtres = sqrt(abs(res_std)))
    ggplot(df_s, aes(x = ajustados, y = sqrtres)) +
      geom_point(color = col_azul, alpha = 0.45, size = 1.8) +
      geom_smooth(method = "loess", se = FALSE,
                  color = col_rojo, linewidth = 1) +
      labs(title = "Scale-Location",
           x = "Valores ajustados", y = "sqrt|Residuos estandarizados|") +
      theme_minimal(base_size = 12) +
      theme(plot.title = element_text(color = col_azul, face = "bold"))
  })

  output$tabla_supuestos <- renderDT({
    m       <- mod3()
    res     <- residuals(m$modelo)
    y_hat   <- fitted(m$modelo)
    sw      <- shapiro.test(res)
    sp      <- suppressWarnings(cor.test(abs(res), y_hat, method = "spearman"))
    df_s <- data.frame(
      Prueba      = c("Shapiro-Wilk (normalidad)",
                      "Spearman |e| vs y_hat (homocedasticidad)"),
      Estadistico = round(c(sw$statistic, sp$estimate), 4),
      p.valor     = c(fmt_p(sw$p.value), fmt_p(sp$p.value)),
      Conclusion  = c(
        ifelse(sw$p.value < 0.05, "[!] Rechaza normalidad",
               "[OK] No rechaza normalidad"),
        ifelse(sp$p.value < 0.05, "[!] Posible heterocedasticidad",
               "[OK] No rechaza homocedasticidad")
      )
    )
    datatable(df_s, options = list(dom = "t", paging = FALSE),
              rownames = FALSE)
  })

  output$tabla_influyentes <- renderDT({
    m       <- mod3()
    cook_d  <- cooks.distance(m$modelo)
    res_std <- rstandard(m$modelo)
    hat_v   <- hatvalues(m$modelo)
    umbral  <- if (input$umbral_cook == "4n") 4 / m$n else 1
    idx     <- which(cook_d > umbral | abs(res_std) > 2)
    if (length(idx) == 0) {
      df_i <- data.frame(Mensaje = "No se identificaron observaciones influyentes.")
    } else {
      df_i <- data.frame(
        Obs      = idx,
        x_val    = round(m$x[idx], 3),
        G3       = m$y[idx],
        Res.Std  = round(res_std[idx], 3),
        Leverage = round(hat_v[idx], 4),
        Cook.D   = round(cook_d[idx], 4)
      )
      names(df_i)[2] <- m$x_var
    }
    datatable(df_i, options = list(pageLength = 10, scrollX = TRUE),
              rownames = FALSE)
  })

  # ════════════════════════════════════════════════════════════════════════
  # PESTAÑA 4: PREDICCIÓN
  # ════════════════════════════════════════════════════════════════════════

  output$slider_prediccion <- renderUI({
    m   <- mod4()
    x_v <- m$x
    sliderInput("x_pred",
                label = paste0("Valor de ", m$x_var, ":"),
                min   = min(x_v),
                max   = max(x_v),
                value = round(mean(x_v)),
                step  = 1)
  })

  output$resultado_prediccion <- renderUI({
    req(input$x_pred)
    m       <- mod4()
    alpha   <- 1 - input$nivel_conf
    t_crit  <- qt(1 - alpha / 2, df = m$n - 2)
    x_star  <- input$x_pred
    y_star  <- m$b0 + m$b1 * x_star
    se_med  <- m$sigma * sqrt(1/m$n + (x_star - m$x_bar)^2 / m$Sxx)
    se_pred <- m$sigma * sqrt(1 + 1/m$n + (x_star - m$x_bar)^2 / m$Sxx)
    ci_lo   <- y_star - t_crit * se_med
    ci_hi   <- y_star + t_crit * se_med
    pi_lo   <- y_star - t_crit * se_pred
    pi_hi   <- y_star + t_crit * se_pred

    div(class = "caja-modelo",
        tags$h4(paste0("Prediccion para ", m$x_var, " = ", x_star)),
        fluidRow(
          column(4,
            tags$p(tags$b("Prediccion puntual:")),
            tags$h3(style = paste0("color:", col_azul, "; margin:0;"),
                    round(y_star, 3))
          ),
          column(4,
            tags$p(tags$b(paste0("IC ", round(input$nivel_conf*100), "% para E(G3|x*):"))),
            tags$h4(style = "color:#0F6E56; margin:0;",
                    paste0("[", round(ci_lo, 3), ", ", round(ci_hi, 3), "]"))
          ),
          column(4,
            tags$p(tags$b(paste0("IP ", round(input$nivel_conf*100), "% individual:"))),
            tags$h4(style = paste0("color:", col_rojo, "; margin:0;"),
                    paste0("[", round(pi_lo, 3), ", ", round(pi_hi, 3), "]"))
          )
        )
    )
  })

  output$plot_bandas <- renderPlot({
    m       <- mod4()
    alpha   <- 1 - input$nivel_conf
    x_seq   <- seq(min(m$x), max(m$x), length.out = 300)
    pred_ic <- predict(m$modelo,
                       newdata  = data.frame(setNames(list(x_seq), m$x_var)),
                       interval = "confidence", level = input$nivel_conf)
    pred_ip <- predict(m$modelo,
                       newdata  = data.frame(setNames(list(x_seq), m$x_var)),
                       interval = "prediction", level = input$nivel_conf)

    df_band <- data.frame(
      x      = x_seq,
      fit    = pred_ic[, "fit"],
      ic_lo  = pred_ic[, "lwr"], ic_hi = pred_ic[, "upr"],
      ip_lo  = pred_ip[, "lwr"], ip_hi = pred_ip[, "upr"]
    )
    df_pts <- data.frame(x = m$x, y = m$y)

    # Punto de prediccion actual
    req(input$x_pred)
    x_star <- input$x_pred
    y_star <- m$b0 + m$b1 * x_star

    ggplot() +
      geom_ribbon(data = df_band,
                  aes(x = x, ymin = ip_lo, ymax = ip_hi),
                  fill = col_rojo, alpha = 0.08) +
      geom_ribbon(data = df_band,
                  aes(x = x, ymin = ic_lo, ymax = ic_hi),
                  fill = "#0F6E56", alpha = 0.15) +
      geom_point(data = df_pts,
                 aes(x = x, y = y),
                 color = col_azul, alpha = 0.3, size = 2) +
      geom_line(data = df_band,
                aes(x = x, y = fit),
                color = col_rojo, linewidth = 1.4) +
      geom_line(data = df_band,
                aes(x = x, y = ic_lo),
                color = "#0F6E56", linetype = "dashed", linewidth = 0.9) +
      geom_line(data = df_band,
                aes(x = x, y = ic_hi),
                color = "#0F6E56", linetype = "dashed", linewidth = 0.9) +
      geom_line(data = df_band,
                aes(x = x, y = ip_lo),
                color = col_rojo, linetype = "dotted", linewidth = 0.9) +
      geom_line(data = df_band,
                aes(x = x, y = ip_hi),
                color = col_rojo, linetype = "dotted", linewidth = 0.9) +
      geom_vline(xintercept = x_star,
                 color = col_amar, linetype = "dashed", linewidth = 1) +
      geom_point(aes(x = x_star, y = y_star),
                 color = col_amar, size = 5, shape = 18) +
      annotate("text", x = x_star + diff(range(m$x)) * 0.04,
               y = max(m$y) * 0.95,
               label = paste0("x* = ", x_star, "\nG3_hat = ", round(y_star, 2)),
               color = col_amar, size = 4, fontface = "bold", hjust = 0) +
      labs(x = m$x_var, y = "G3",
           title = paste0("G3 ~ ", m$x_var,
                          "  |  IC y IP al ", round(input$nivel_conf*100), "%"),
           caption = paste0("Verde = IC para E(G3|x*)  |  ",
                            "Rojo = IP individual  |  ",
                            "Diamante amarillo = prediccion")) +
      theme_minimal(base_size = 13) +
      theme(plot.title   = element_text(color = col_azul, face = "bold"),
            plot.caption = element_text(color = col_gris, size = 9))
  })

  output$tabla_predicciones <- renderDT({
    req(input$x_pred)
    m       <- mod4()
    x_vals  <- sort(unique(m$x))
    pred_ic <- predict(m$modelo,
                       newdata  = data.frame(setNames(list(x_vals), m$x_var)),
                       interval = "confidence", level = input$nivel_conf)
    pred_ip <- predict(m$modelo,
                       newdata  = data.frame(setNames(list(x_vals), m$x_var)),
                       interval = "prediction", level = input$nivel_conf)
    df_t <- data.frame(
      x_val   = x_vals,
      G3_hat  = round(pred_ic[, "fit"], 3),
      IC_LI   = round(pred_ic[, "lwr"], 3),
      IC_LS   = round(pred_ic[, "upr"], 3),
      IP_LI   = round(pred_ip[, "lwr"], 3),
      IP_LS   = round(pred_ip[, "upr"], 3)
    )
    names(df_t) <- c(m$x_var, "G3_hat",
                     paste0("IC LI ", round(input$nivel_conf*100), "%"),
                     paste0("IC LS ", round(input$nivel_conf*100), "%"),
                     paste0("IP LI ", round(input$nivel_conf*100), "%"),
                     paste0("IP LS ", round(input$nivel_conf*100), "%"))
    datatable(df_t,
              options  = list(pageLength = 10, scrollX = TRUE),
              rownames = FALSE) |>
      formatStyle(m$x_var,
                  backgroundColor = styleEqual(input$x_pred, col_amar))
  })
}

# =============================================================================
# LANZAR APP
# =============================================================================
shinyApp(ui = ui, server = server)
