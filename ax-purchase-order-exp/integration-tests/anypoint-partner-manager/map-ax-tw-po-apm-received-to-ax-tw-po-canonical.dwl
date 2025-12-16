%dw 2.0
output application/json

var data = payload.transaction.payload

fun mapAddress(addr) = {
    line1: addr.line1,
    city: addr.city,
    state: addr.state,
    postalCode: addr.zipCode,
    country: addr.country
}

---
{
  id: payload.referenceId,

  purchaseOrder: {
    purchaseOrderNumber: data.PurchaseOrderNumber,
    purchaseOrderDate: data.PurchaseOrderDate,

    amounts: {
      subtotal: data.Subtotal,
      tax: data.Tax,
      total: data.Total,
      amountDue: data.AmountDue,
      currency: "USD"
    },

    buyer: {
      name: data.Buyer.Name,
      address: mapAddress(data.Buyer.Address)
    },

    vendor: {
      name: data.Vendor.Name,
      address: mapAddress(data.Vendor.Address)
    },

    shipTo: {
      name: data.ShipToName,
      address: mapAddress(data.ShipToAddress)
    },

    items: data.Items map (item) -> {
      productCode: item.productCode,
      description: item.description,
      quantity: item.quantity,
      unitPrice: item.unitPrice,
      lineAmount: item.price
    }
  }
}
