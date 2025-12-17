%dw 2.0
output application/json

fun val(x) =
    if (x is Object and x.value?) x.value
    else x

fun toMoney(value) =
    value as Number

var page = payload.pages[0]
var fields = page.fields
var parties = fields.parties
---

{
  partnerReferenceId: page.fields.parties.buyer.name.value,
  hostReferenceId: page.fields.parties.vendor.name.value,
  businessDocumentKey: payload.id,
  transaction: {
    transactionType: "JSON-ax-techwave-po-apm-schema",
    payload: {
      DocumentName: payload.documentName,
      Status: payload.status,
      Vendor: {
          Name: val(parties.vendor.name),
          Address: 
          {
            line1: val(parties.vendor.street),
            city: val(parties.vendor.city),
            state: val(parties.vendor.state),
            zipCode: val(parties.vendor.zipCode),
            country: val(parties.vendor.country default "US"),
          },
      },
      Buyer : {
          Name: val(parties.buyer.name),
          BuyerPhone: val(parties.buyer.headerPhone),
          Address: 
          {
              line1: val(parties.buyer.street),
              city: val(parties.buyer.city),
              state: val(parties.buyer.state),
              zipCode: val(parties.buyer.zipCode),
              country: val(parties.buyer.country default "US"),
          },
      },
      PurchaseOrderNumber: val(fields.purchaseOrderNumber),
      PurchaseOrderDate: val(fields.purchaseOrderDate),
      Subtotal: toMoney(val(fields.subtotal)),
      Tax: toMoney(val(fields.tax)),
      Total: toMoney(val(fields.total)),
      AmountDue: toMoney(val(fields.total)),
      ShipToName: val(parties.buyer.headerName),
      ShipToAddress: {
              line1: val(parties.buyer.street),
              city: val(parties.buyer.city),
              state: val(parties.buyer.state),
              zipCode: val(parties.buyer.zipCode),
              country: val(parties.buyer.country default "US"),
      },
      Items: page.tables.table1 map (item) -> {
        productCode: val(item.productCode),
        quantity: val(item.quantity) as Number,
        unitPrice: toMoney(val(item.unitPrice)),
        price: toMoney(val(item.price)),
        description: val(item.description)
      }
    }
  }
}
