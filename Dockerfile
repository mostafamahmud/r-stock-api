FROM rstudio/plumber:latest

COPY api.R /app/api.R

EXPOSE 8000

CMD ["/app/api.R"]
