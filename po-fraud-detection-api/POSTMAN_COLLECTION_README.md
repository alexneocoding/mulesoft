# PO Fraud Detection API - Postman Collection

This directory contains a simplified Postman collection for testing the PO Fraud Detection API with AI-powered analysis.

## Files Included

- `PO-Fraud-Detection-API.postman_collection.json` - Main test collection
- `PO-Fraud-Detection-API.postman_environment.json` - Environment configuration
- `POSTMAN_COLLECTION_README.md` - This documentation file

## Collection Overview

The collection includes two essential test cases:

### 1. Success Case - Valid PO Request
- **Purpose**: Tests a valid PO request that should be successfully processed
- **Expected Result**: 200 status code with fraud risk assessment
- **Test Data**: Moderate amount ($25,000) with complete required fields
- **Automated Tests**: Validates response structure, risk levels, and data types

### 2. Failure Case - Missing Required Field
- **Purpose**: Tests validation error handling
- **Expected Result**: 400 status code with validation error message
- **Test Data**: Missing `poNumber` field to trigger validation failure
- **Automated Tests**: Validates error response structure and error messages

## Setup Instructions

### 1. Import Collection
1. Open Postman
2. Click "Import" button
3. Select `PO-Fraud-Detection-API.postman_collection.json`
4. Click "Import"

### 2. Import Environment
1. In Postman, click the gear icon (Manage Environments)
2. Click "Import"
3. Select `PO-Fraud-Detection-API.postman_environment.json`
4. Click "Import"
5. Select the "PO Fraud Detection API - Local Environment" from the environment dropdown

### 3. Configure Environment Variables
The environment includes:
- `baseUrl`: Set to `http://localhost:8081` (default Mule runtime port)
- `apiPath`: Set to `/api/fraud-detection/analyze`

Update the `baseUrl` if your API is running on a different host/port.

## Running Tests

### Individual Tests
1. Select a request from the collection
2. Click "Send"
3. View the test results in the "Test Results" tab

### Collection Runner
1. Click on the collection name
2. Click "Run" button
3. Select both requests
4. Click "Run PO Fraud Detection API - Essential Test Suite"
5. View detailed test results

## API Endpoint Details

**Endpoint**: `POST /api/fraud-detection/analyze`

**Required Fields**:
- `poNumber` (string): Purchase order number
- `vendorId` (string): Vendor identifier
- `amount` (number): Purchase order amount
- `poDate` (string): Purchase order date (YYYY-MM-DD format)
- `description` (string): Description of the purchase

**Success Response** (200):
```json
{
  "transactionId": "uuid",
  "timeStamp": "timestamp",
  "poNumber": "PO-2024-001",
  "fraudAssessment": {
    "riskLevel": "MEDIUM",
    "riskScore": 45,
    "fraudIndicators": ["array of indicators"],
    "recommendation": "recommendation text",
    "aiConfidence": 85,
    "analysisDetails": "detailed analysis"
  },
  "status": "ANALYZED"
}
```

**Error Response** (400):
```json
{
  "error": "VALIDATION_ERROR",
  "message": "Invalid input data provided",
  "details": "Validation failed",
  "timestamp": "timestamp"
}
```

## Test Assertions

The collection includes comprehensive automated tests:

### Success Case Tests
- Status code is 200
- Response contains all required fields
- Fraud assessment has proper structure
- Risk level is valid (HIGH/MEDIUM/LOW/MINIMAL)
- Risk score is within 0-100 range
- Status is "ANALYZED"

### Failure Case Tests
- Status code is 400
- Error response has proper structure
- Error type is "VALIDATION_ERROR"
- Error message indicates validation failure

## Extending the Collection

To add more test cases:

1. **Duplicate existing requests**: Right-click on a request and select "Duplicate"
2. **Modify test data**: Update the request body with new test scenarios
3. **Update test scripts**: Modify the test assertions as needed
4. **Add descriptions**: Document the purpose of each new test case

## Troubleshooting

### Common Issues

1. **Connection Refused**: Ensure the Mule application is running on the correct port
2. **404 Not Found**: Verify the API path is correct (`/api/fraud-detection/analyze`)
3. **Test Failures**: Check that the API response format matches expected structure

### Debugging Tips

1. Check the Postman Console for detailed request/response logs
2. Verify environment variables are set correctly
3. Ensure the Mule application logs show incoming requests
4. Test with a simple REST client first to verify API functionality

## API Configuration

The API uses these fraud detection thresholds (from `config.properties`):
- Low threshold: $10,000
- Medium threshold: $50,000
- High threshold: $100,000
- Round number minimum: $5,000

Risk score thresholds:
- High risk: 80+
- Medium risk: 50+
- Low risk: 20+
