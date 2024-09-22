%dw 2.0
output application/json
fun convertToUSD(price,code) = (price/(vars.currentCurrencyRates filter ($.currency == code) reduce $).rate)
---
vars.productMapping map ((item, index) -> {
    (if(vars.operation == "CREATE") (externalId: item.externalId) else (productId: item.productId)),
    productCode: item.productCode,
    name: item.name,
    productPrice: item.currencyCode  match {
        case is "USD" -> item.productPrice
        else -> convertToUSD(item.productPrice,item.currencyCode)
    },
    currencyCode: "USD",
    description: item.description
})