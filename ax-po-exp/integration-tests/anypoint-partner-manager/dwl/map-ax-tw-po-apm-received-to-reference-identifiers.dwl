output application/json
---
{
    partnerReferenceId: payload.partnerReferenceId,
    hostReferenceId: payload.hostReferenceId,
    businessDocumentKey: payload.referenceId,
    customAttributes: [
    {
        alias: "purchaseOrderNumber",
        values: payload.transaction.PurchaseOrderNumber,
    },
    {
        alias: "purchaseOrderDate",
        values: payload.transaction.PurchaseOrderDate,
    },
    {
        alias: "amountDue",
        values: payload.transaction.AmountDue,
    }
 ]
}