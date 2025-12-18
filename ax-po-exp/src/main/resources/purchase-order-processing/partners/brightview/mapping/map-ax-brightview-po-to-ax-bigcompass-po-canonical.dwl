%dw 2.0
output application/json

var po = payload.TransactionSets.v004010."850"[0]

// --- Date (safe)
var rawPoDate = po.Heading."020_BEG".BEG05 default null
var poDate =
    if (rawPoDate != null)
        (rawPoDate as Date) as String { format: "yyyy-MM-dd" }
    else
        null


// --- N1 loops (safe)
var n1Loops = po.Heading."310_N1_Loop" default []

var buyer =
    (n1Loops filter ($."310_N1".N101 == "BY"))[0] default null

var vendor =
    (n1Loops filter ($."310_N1".N101 == "SE"))[0] default null


var poLines = po.Detail."010_PO1_Loop" default []

var shipTo =
    (n1Loops filter ($."310_N1".N101 == "ST"))[0] default buyer


// --- Freight detection helpers
fun isFreight(line) =
    upper(line."010_PO1".PO107 default "") == "SHIP"
    or
    (
        upper(
            (line."050_PID_Loop"[0]."050_PID".PID05) default ""
        ) contains "FREIGHT"
    )

// --- Product items (exclude freight)
var items =
    (poLines
        filter (line) -> !isFreight(line)
    )
    map (line) -> {
        productCode: line."010_PO1".PO107 default null,
        description:
            (line."050_PID_Loop"[0]."050_PID".PID05) default null,
        quantity: (line."010_PO1".PO102 default 0) as Number,
        unitPrice: (line."010_PO1".PO104 default 0) as Number,
        lineAmount:
            ((line."010_PO1".PO102 default 0) as Number) *
            ((line."010_PO1".PO104 default 0) as Number)
    }

// --- Totals (safe reduce)
var subtotal =
    items reduce ((item, acc = 0) -> acc + (item.lineAmount default 0))

---
{
  id: uuid(),
  purchaseOrder: {
    purchaseOrderNumber: po.Heading."020_BEG".BEG03 default null,
    purchaseOrderDate: poDate,
    amounts: {
      subtotal: subtotal,
      tax: 0,
      total: subtotal,
      amountDue: subtotal,
      currency: "USD"
    },
    buyer: {
        name: buyer."310_N1".N102 default null,
        address: {
            line1: buyer."330_N3"[0].N301 default null,
            city: buyer."340_N4"[0].N401 default null,
            state: buyer."340_N4"[0].N402 default null,
            postalCode: buyer."340_N4"[0].N403 default null,
            country: buyer."340_N4"[0].N404 default "US"
        }
    },
    vendor: {
        name: vendor."310_N1".N102 default null,
        address: {
            line1: vendor."330_N3"[0].N301 default null,
            city: vendor."340_N4"[0].N401 default null,
            state: vendor."340_N4"[0].N402 default null,
            postalCode: vendor."340_N4"[0].N403 default null,
            country: vendor."340_N4"[0].N404 default "US"
        }
    },
    shipTo: {
        name: shipTo."310_N1".N102 default null,
        address: {
            line1: shipTo."330_N3"[0].N301 default null,
            city: shipTo."340_N4"[0].N401 default null,
            state: shipTo."340_N4"[0].N402 default null,
            postalCode: shipTo."340_N4"[0].N403 default null,
            country: shipTo."340_N4"[0].N404 default "US"
        }
    },
    items: items
  }
}
