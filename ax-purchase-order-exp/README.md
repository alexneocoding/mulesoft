# Purchase Order Experience API (ax-purchase-order-exp)

## Overview

The ax-purchase-order-exp Experience API receives a PDF file containing a purchase order, processes it through MuleSoft Intelligent Document Processing (IDP), and returns the extracted data as JSON.

## API Specification

### Endpoint
- **POST** `/api/v1/order`

### Input
- **Content-Type**: `multipart/form-data`
- **Field**: `file` (required PDF file)

### Output
- **200 OK**: JSON response from IDP containing extracted purchase order data
- **400 Bad Request**: Invalid input (missing file, wrong format, etc.)
- **401 Unauthorized**: Authentication failed with IDP service
- **500 Internal Server Error**: Processing error
- **502 Bad Gateway**: External service unavailable

## Processing Flow

The API follows this exact sequence:

1. **Input Validation**: Validates PDF file presence, format, and size
2. **OAuth Token Acquisition**: Obtains access token from MuleSoft Anypoint
3. **IDP Submission**: Submits PDF to IDP service for processing
4. **Wait Period**: Waits configured seconds for processing
5. **Result Retrieval**: Retrieves and returns extraction results

## Configuration

### Required Properties

Update `src/main/resources/application.properties` with your values:

```properties
# IDP OAuth Configuration
idp.client.id=your_actual_client_id
idp.client.secret=your_actual_client_secret

# Processing Configuration
idp.poll.wait.seconds=5

# File Upload Limits (10MB default)
file.upload.max.size=10485760
```

### Environment-Specific Configuration

For different environments, create additional property files:
- `application-dev.properties`
- `application-test.properties`
- `application-prod.properties`

## Security Features

- OAuth 2.0 client credentials flow for IDP authentication
- Secure logging (OAuth tokens are never logged)
- File size validation and content type checking
- No persistent storage of uploaded files
- HTTPS enforcement for all external calls

## Setup Instructions

### Prerequisites
- Java 8 or 11
- Maven 3.6+
- MuleSoft Anypoint Studio (optional, for development)
- Valid MuleSoft IDP credentials

### Installation

1. **Clone/Download the project**
2. **Configure credentials** in `application.properties`
3. **Build the project**:
   ```bash
   mvn clean compile
   ```
4. **Run locally**:
   ```bash
   mvn mule:run
   ```

The API will be available at: `http://localhost:8081/api/v1`

## Testing

### Using cURL

```bash
# Test with a PDF file
curl -X POST \
  http://localhost:8081/api/v1/order \
  -H 'Content-Type: multipart/form-data' \
  -F 'file=@/path/to/your/purchase-order.pdf'
```

### Using Postman

1. Create a new POST request to `http://localhost:8081/api/v1/order`
2. Set Content-Type to `multipart/form-data`
3. Add a form field named `file` and upload a PDF
4. Send the request

### Expected Response

```json
{
  "executionId": "12345-67890-abcde",
  "status": "COMPLETED",
  "extractedData": {
    "purchaseOrderNumber": "PO-2023-001",
    "vendor": "ABC Supply Company",
    "date": "2023-12-09",
    "items": [
      {
        "description": "Office Supplies",
        "quantity": 10,
        "unitPrice": 25.50,
        "total": 255.00
      }
    ],
    "totalAmount": 255.00
  }
}
```

## Error Responses

### Validation Error (400)
```json
{
  "error": "Invalid file format. Only PDF files are allowed.",
  "timestamp": "2023-12-09T15:30:00Z",
  "correlationId": "abc123-def456-ghi789"
}
```

### Authentication Error (401)
```json
{
  "error": "Authentication failed with external service",
  "timestamp": "2023-12-09T15:30:00Z",
  "correlationId": "abc123-def456-ghi789"
}
```

### Service Unavailable (502)
```json
{
  "error": "External service is currently unavailable",
  "timestamp": "2023-12-09T15:30:00Z",
  "correlationId": "abc123-def456-ghi789"
}
```

## Deployment

### CloudHub 2.0 Deployment

1. **Package the application**:
   ```bash
   mvn clean package
   ```

2. **Deploy using Anypoint CLI**:
   ```bash
   anypoint-cli runtime-mgr cloudhub-application deploy \
     --applicationName ax-purchase-order-exp \
     --artifact target/ax-purchase-order-exp-1.0.0-SNAPSHOT-mule-application.jar \
     --runtime 4.9.11
   ```

### Runtime Fabric Deployment

1. **Build and deploy** using Maven plugin:
   ```bash
   mvn clean deploy -DmuleDeploy
   ```

## Monitoring and Logging

### Log Levels
- **INFO**: Request/response logging with correlation IDs
- **DEBUG**: Detailed processing steps
- **ERROR**: Error conditions and exceptions

### Key Metrics to Monitor
- Request processing time
- IDP service response times
- Error rates by type
- File upload sizes

## Troubleshooting

### Common Issues

1. **Authentication Failures**
   - Verify `idp.client.id` and `idp.client.secret` are correct
   - Check if credentials have proper permissions

2. **File Upload Errors**
   - Ensure file is valid PDF format
   - Check file size against `file.upload.max.size` limit

3. **Timeout Issues**
   - Increase `http.request.timeout` in properties
   - Adjust `idp.poll.wait.seconds` if processing takes longer

4. **IDP Service Errors**
   - Verify IDP service URLs are accessible
   - Check network connectivity and firewall rules

### Debug Mode

Enable debug logging by adding to `log4j2.xml`:
```xml
<Logger name="com.mycompany" level="DEBUG"/>
```

## API Documentation

The RAML specification is available at:
- File: `src/main/resources/api/purchase-order-api.raml`
- Runtime: `http://localhost:8081/console/` (when running)

## Support

For issues and questions:
1. Check the troubleshooting section above
2. Review application logs for error details
3. Verify all configuration properties are set correctly
4. Test with a simple PDF file first

## Version History

- **1.0.0**: Initial implementation with IDP integration
  - POST /order endpoint
  - PDF file processing
  - OAuth 2.0 authentication
  - Comprehensive error handling
