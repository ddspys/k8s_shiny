# 필수 라이브러리를 불러옵니다.
library(shiny)

# UI 설정
ui <- fluidPage(
  titlePanel("Dynamic Histogram"),
  sidebarLayout(
    sidebarPanel(
      actionButton("drawButton", "Draw New Histogram")  # 버튼 생성
    ),
    mainPanel(
      plotOutput("histPlot")  # 히스토그램을 표시할 영역
    )
  )
)

# 서버 로직
server <- function(input, output) {
  observeEvent(input$drawButton, {  # 버튼 이벤트 감지
    # drawButton이 클릭될 때마다 새로운 히스토그램 데이터를 생성
    output$histPlot <- renderPlot({
      data <- rnorm(100)  # 100개의 난수를 생성합니다.
      hist(data, main = "Histogram", xlab = "Value", ylab = "Frequency", col = "skyblue", border = "white")
    })
  })
}

# 애플리케이션 실행
shinyApp(ui = ui, server = server)