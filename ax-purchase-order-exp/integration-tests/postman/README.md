# Purchase Order API - Postman Integration Tests

This folder contains comprehensive Postman tests for the Purchase Order Experience API that processes PDF files through MuleSoft Intelligent Document Processing (IDP).

## Overview

The API has been transformed from APIKit-based routing to direct subflow calls, providing:
- Simplified architecture without APIKit dependencies
- Direct HTTP listener with specific endpoint routing
- Preserved business logic through well-organized subflows
- Comprehensive error handling and validation

## Files Included

### Test Collections
- **`purchase-order-api-tests.json`** - Main Postman collection with comprehensive test cases
- **`local-environment.json`** - Environment configuration for local testing

### Test Categories

#### 1. Positive Tests
- **Valid PDF Upload** - Tests successful PDF processing through the entire IDP workflow
- Validates response structure, timing, and IDP integration

#### 2. Validation Tests  
- **Missing File Parameter** - Tests 400 error when no file is provided
- **Invalid File Type** - Tests 400 error when non-PDF files are uploaded
- **Empty Request Body** - Tests error handling with empty requests

#### 3. Error Scenario Tests
- **Service Health Check** - Verifies the API service is running and accessible
- Tests various error conditions and response codes

## API Endpoint

```
POST /api/v1/order
Content-Type: multipart/form-data
Parameter: file (PDF file)
```

## Setup Instructions

### 1. Import into Postman

1. Open Postman
2. Click **Import** button
3. Select **File** tab
4. Choose `purchase-order-api-tests.json`
5. Import the environment file `local-environment.json`

### 2. Configure Environment

1. In Postman, select **Environments** 
2. Choose **Purchase Order API - Local Environment**
3. Verify/update these variables:
   - `baseUrl`: `http://localhost:8081` (default)
   - `apiVersion`: `v1`
   - `environment`: `local`
   - `timeout`: `30000`

### 3. Prepare Test Data

Create sample files in the `test-data/` folder:

#### Required Test Files:
- **`sample-purchase-order.pdf`** - Valid PDF file for positive testing
- **`invalid-file.txt`** - Text file for validation testing  
- **`health-check.pdf`** - Small PDF for health checks

#### Sample PDF Creation:
You can create simple PDF files for testing:
```bash
# Create a simple PDF using any method (LibreOffice, online converters, etc.)
# Or use existing PDF files from your system
```

## Running Tests

### Individual Tests
1. Select the desired test from the collection
2. Ensure the correct environment is selected
3. Click **Send** to execute

### Collection Runner
1. Click on the collection name
2. Click **Run** button  
3. Select environment: **Purchase Order API - Local Environment**
4. Choose which tests to run
5. Click **Run Purchase Order API Tests**

### Command Line (Newman)
```bash
# Install Newman if not already installed
npm install -g newman

# Run the collection
newman run purchase-order-api-tests.json \
  -e local-environment.json \
  --reporters cli,json \
  --reporter-json-export results.json
```

## Test Scenarios Covered

### ✅ Positive Scenarios
- Valid PDF file upload and processing
- Successful IDP integration workflow
- Response structure validation
- Performance timing checks

### ❌ Validation Scenarios  
- Missing file parameter (400 error)
- Invalid file types (400 error)
- Empty request handling (400 error)
- Error response structure validation

### 🔧 Service Health
- API accessibility checks
- Response time validation
- Service availability monitoring

## Expected Responses

### Success Response (200)
```json
{
  "executionId": "12345-67890-abcde",
  "status": "COMPLETED",
  "extractedData": {
    // IDP extracted data structure
  }
}
```

### Validation Error (400)
```json
{
  "error": "Missing required file parameter",
  "timestamp": "2025-12-09T22:18:00.000Z",
  "correlationId": "abc123-def456-ghi789"
}
```

### Service Error (500/502)
```json
{
  "error": "External service is currently unavailable",
  "timestamp": "2025-12-09T22:18:00.000Z", 
  "correlationId": "abc123-def456-ghi789"
}
```

## Prerequisites

### Application Setup
1. **Mule Application Running**: Ensure the purchase order API is deployed and running
2. **IDP Configuration**: Verify IDP service credentials are configured in `application.properties`
3. **Network Access**: Ensure connectivity to MuleSoft IDP services

### Required Properties
Verify these properties are set in `src/main/resources/application.properties`:
```properties
# HTTP Listener Configuration
http.listener.host=0.0.0.0
http.listener.port=8081
http.listener.basePath=/api/v1

# IDP Configuration  
idp.client.id=${IDP_CLIENT_ID}
idp.client.secret=${IDP_CLIENT_SECRET}
idp.poll.wait.seconds=10

# HTTP Request Timeouts
http.request.timeout=30000
```

## Troubleshooting

### Common Issues

#### Connection Refused
- **Problem**: Cannot connect to `http://localhost:8081`
- **Solution**: Ensure Mule application is running locally

#### 401 Authentication Errors  
- **Problem**: OAuth token acquisition fails
- **Solution**: Verify IDP client credentials in application.properties

#### 400 Validation Errors
- **Problem**: File validation fails
- **Solution**: Ensure PDF files are valid and properly formatted

#### Timeout Errors
- **Problem**: Requests timeout waiting for IDP
- **Solution**: Check IDP service availability and increase timeout values

### Debug Tips

1. **Check Mule Logs**: Monitor application logs for detailed error information
2. **Verify Environment**: Ensure correct Postman environment is selected  
3. **Test Connectivity**: Use the Service Health Check test first
4. **File Validation**: Ensure test PDF files are valid and accessible

## Environment Variations

### Development Environment
Create additional environment files for different deployment targets:

```json
{
  "name": "Purchase Order API - Development",
  "values": [
    {
      "key": "baseUrl", 
      "value": "https://dev-api.company.com"
    }
  ]
}
```

### Production Environment  
```json
{
  "name": "Purchase Order API - Production",
  "values": [
    {
      "key": "baseUrl",
      "value": "https://api.company.com"  
    }
  ]
}
```

## Integration with CI/CD

### Automated Testing
```bash
# Example CI/CD pipeline step
newman run integration-tests/postman/purchase-order-api-tests.json \
  -e integration-tests/postman/local-environment.json \
  --reporters junit,json \
  --reporter-junit-export test-results.xml \
  --reporter-json-export test-results.json
```

This test suite provides comprehensive coverage for the transformed Purchase Order API, ensuring all subflows work correctly without APIKit dependencies.
