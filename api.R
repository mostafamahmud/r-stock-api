library(plumber)
library(jsonlite)

#* @filter cors
function(req, res) {
  res$setHeader("Access-Control-Allow-Origin", "*")
  res$setHeader("Access-Control-Allow-Methods", "POST, GET, OPTIONS")
  res$setHeader("Access-Control-Allow-Headers", "Content-Type, ngrok-skip-browser-warning")
  
  if (req$REQUEST_METHOD == "OPTIONS") {
    res$status <- 200
    return(list())
  } else {
    plumber::forward()
  }
}

#* @serializer unboxedJSON
#* @post /predict
function(req) {
  body <- jsonlite::fromJSON(req$postBody)
  qty_sold <- as.numeric(body$amount_or_qty)
  stock <- as.numeric(body$remaining_stock)
  
  days_left <- ifelse(qty_sold > 0, round(stock / qty_sold, 1), 999)
  
  list(
    days_until_stockout = days_left,
    recommendation = ifelse(days_left <= 3, "طلب عاجل من الموردين", "المخزون آمن")
  )
}
