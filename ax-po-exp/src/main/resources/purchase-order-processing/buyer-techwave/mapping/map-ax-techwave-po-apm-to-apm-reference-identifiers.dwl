output application/json
---
{
    partnerReferenceId: payload.partnerReferenceId,
    hostReferenceId: payload.hostReferenceId,
    businessDocumentKey: payload.transaction.payload.PurchaseOrderNumber as String default "UNKNOWN",
    customAttributes: [
    {
        alias: "purchaseOrderNumber",
        values: [payload.transaction.payload.PurchaseOrderNumber as String default "UNKNOWN"],
    },
    {
        alias: "purchaseOrderDate",
        values: [payload.transaction.payload.PurchaseOrderDate as String default "UNKNOWN"],
    },
    {
        alias: "amountDue",
        values: [payload.transaction.payload.AmountDue as String default "UNKNOWN"],
    }
 ]
}