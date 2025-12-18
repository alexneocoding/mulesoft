%dw 2.0
output application/json

var po =
  payload.TransactionSets.v004010."850"[0]

// --- PO Number
var poNumber =
  po.Heading."020_BEG".BEG03 default "UNKNOWN"

// --- PO Date formatted MM-DD-YYYY
var rawPoDate =
  po.Heading."020_BEG".BEG05 default null

var poDate =
  if (rawPoDate != null)
    (rawPoDate as DateTime)
      as String { format: "MM-dd-yyyy" }
  else
    "UNKNOWN"

// --- Calculate amount due
var amountDue =
  (po.Detail."010_PO1_Loop" default [])
    reduce ((line, acc = 0) ->
      acc +
      ((line."010_PO1".PO102 default 0) as Number) *
      ((line."010_PO1".PO104 default 0) as Number)
    )

---
{
  partnerReferenceId: poNumber,
  hostReferenceId: po.SetHeader.ST02 default null,
  businessDocumentKey: poNumber,

  customAttributes: [
    {
      alias: "purchaseOrderNumber",
      values: [poNumber]
    },
    {
      alias: "purchaseOrderDate",
      values: [poDate]
    },
    {
      alias: "amountDue",
      values: [amountDue as String]
    }
  ]
}
