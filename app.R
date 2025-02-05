# 필수 라이브러리를 불러옵니다.
library(shiny)
library(shiny.telemetry)

data_storage <- DataStorageLogFile$new(log_file_path = "/var/log/shiny/shiny.log")
telemetry <- Telemetry$new(data_storage = data_storage)

# UI 설정
ui <- fluidPage(
  use_telemetry(),
  titlePanel("Dynamic Histogram with Session Info"),
  sidebarLayout(
    sidebarPanel(
      actionButton("drawButton", "Draw New Histogram"),  # 버튼 생성
      h4("Session Information:"),
      verbatimTextOutput("sessionInfo"),  # 세션 정보를 출력할 영역
      h4("Request Headers:"),
      verbatimTextOutput("requestHeaders")  # 요청 헤더 정보를 출력할 영역
    ),
    mainPanel(
      plotOutput("histPlot")  # 히스토그램을 표시할 영역
    )
  )
)

# 서버 로직
server <- function(input, output, session) {
  telemetry$start_session()
  
  observeEvent(input$drawButton, {  # 버튼 이벤트 감지
    # drawButton이 클릭될 때마다 새로운 히스토그램 데이터를 생성
    output$histPlot <- renderPlot({
      data <- rnorm(100)  # 100개의 난수를 생성합니다.
      hist(data, main = "Histogram", xlab = "Value", ylab = "Frequency", col = "skyblue", border = "white")
    })
  })
  
  # 세션 정보 출력
  output$sessionInfo <- renderPrint({
    list(
      clientData = session$clientData,  # 클라이언트 관련 데이터
      token = session$token,  # 세션 토큰
      user = session$user  # 사용자 정보 (null by default)
    )
  })
  
  # 요청 헤더 출력
  output$requestHeaders <- renderPrint({
    session$request$HEADERS
  })
}

# 애플리케이션 실행
shinyApp(ui = ui, server = server)