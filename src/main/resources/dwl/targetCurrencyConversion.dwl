%dw 2.0
output application/json
var requestedCurrencyCode = vars.currencyCode
var filterTargetCurrencyCurrentRate = vars.currentCurrencyRates filter ($.currency == requestedCurrencyCode) reduce $
fun getConvertedProductPrice(price,currentCurrencyCode,targetCurrencyCode) = {
    (if(currentCurrencyCode == targetCurrencyCode) ({
        "productPrice": price as String {format: "0.00"},
        "currencyCode": currentCurrencyCode
    }) else ({
        "productPrice": (price * filterTargetCurrencyCurrentRate.rate) as String {format: "0.00"},
        "currencyCode": requestedCurrencyCode
    }))
}
---
payload map ((item, index) -> {
    (if(vars.operation == "CREATE") (externalId: item.externalId) else (productId: item.productId)),
    productCode: item.productCode,
    name: item.name,
    (getConvertedProductPrice(item.productPrice,item.currencyCode,requestedCurrencyCode)),
    description: item.description
})