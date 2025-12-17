# Purchase Order Experience API

## Overview
MuleSoft API that processes PDF purchase orders through Intelligent Document Processing (IDP) and returns extracted JSON data.

## Quick Start

### Prerequisites
- Java 8/11, Maven 3.6+
- MuleSoft IDP credentials

### Setup
1. Configure `src/main/resources/application.properties`:
   ```properties
   idp.client.id=your_client_id
   idp.client.secret=your_client_secret
   ```

2. Run locally:
   ```bash
   mvn clean compile
   mvn mule:run
   ```

3. Test endpoint:
   ```bash
   curl --location POST 'http://localhost:8081/api/v1/order' \
   --header 'Accept: application/json' \
   --form 'file=@"Invoice-PO-2025-012.pdf"'
   ```

## API Specification

**Endpoint:** `POST /api/v1/order`
- **Input:** PDF file via `multipart/form-data`
- **Output:** JSON with extracted purchase order data

**Response Codes:**
- `200` - Success
- `400` - Invalid input
- `401` - Authentication failed
- `502` - Service unavailable

## Configuration

Key properties in `application.properties`:
```properties
# HTTP Configuration
http.listener.port=8081
http.request.timeout=30000

# IDP Configuration  
idp.client.id=${IDP_CLIENT_ID}
idp.client.secret=${IDP_CLIENT_SECRET}
idp.poll.wait.seconds=5
idp.poll.max.attempts=30

# File Limits
file.upload.max.size=10485760
```

## Architecture
1. Input validation (PDF format, size limits)
2. OAuth token acquisition
3. IDP submission and polling
4. Result extraction and response
5. Transform response to BigCompass Anypoint Partner Manager
6. Send to BigCompass Anypoint Partner Manager


## Error Handling
Global error handler provides structured JSON responses with correlation IDs for all error scenarios.
