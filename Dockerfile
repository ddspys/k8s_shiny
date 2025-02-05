# R과 Shiny Server가 설치된 기반 이미지 선택
FROM rocker/shiny:latest

# 필요한 R 패키지를 설치 (필요에 따라 추가 가능)
RUN R -e "install.packages(c('shiny'))"
RUN R -e "remotes::install_github("Appsilon/shiny.telemetry", dependencies = TRUE)"

# 애플리케이션 코드와 데이터를 이미지에 복사
COPY app.R /srv/shiny-server/

# 권한 수정 (권한 문제가 발생할 가능성이 있을 경우)
RUN chown -R shiny:shiny /srv/shiny-server

# Shiny Server가 특정 포트에서 요청을 수신하도록 설정
EXPOSE 3838

# Shiny Server 시작
CMD ["/usr/bin/shiny-server"]