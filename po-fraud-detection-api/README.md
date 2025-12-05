# AI-Powered PO Fraud Detection API

A sophisticated MuleSoft API that leverages AI Chain connector with OpenAI GPT-4 to detect fraudulent patterns in Purchase Orders (POs). This API uses advanced AI prompts to analyze fraud indicators and provides intelligent risk assessments with actionable recommendations.

## Table of Contents

- [Features](#features)
- [Prerequisites](#prerequisites)
- [Configuration](#configuration)
- [API Endpoints](#api-endpoints)
- [AI Analysis Process](#ai-analysis-process)
- [Running the Application](#running-the-application)
- [Testing the API](#testing-the-api)
- [Postman Collection](#postman-collection)
- [Running Tests](#running-tests)
- [Deployment](#deployment)
- [Monitoring and Logging](#monitoring-and-logging)
- [Error Handling](#error-handling)
- [Troubleshooting](#troubleshooting)
- [Security Considerations](#security-considerations)
- [Performance](#performance)
- [Support](#support)
- [Version History](#version-history)

## Features

### AI-Powered Fraud Detection Capabilities
- **AI Amount Analysis**: Uses GPT-4 to detect suspicious high amounts, round number patterns, and amount inconsistencies
- **AI Vendor Analysis**: Leverages AI to identify suspicious vendor IDs, shell companies, and vendor-related fraud indicators
- **AI Timing Analysis**: AI-powered detection of future-dated POs, timing inconsistencies, and suspicious processing patterns
- **AI Risk Scoring**: Intelligent risk scoring (0-100) with AI confidence levels
- **Multi-Stage AI Analysis**: Sequential AI analysis with specialized prompts for each fraud category
- **Comprehensive Validation**: Validates all required PO fields before AI analysis

### Risk Levels
- **MINIMAL** (0-19): Low fraud risk - Approve
- **LOW** (20-49): Minor concerns - Monitor
- **MEDIUM** (50-79): Moderate risk - Manual review recommended
- **HIGH** (80+): High fraud risk - Reject transaction

## Prerequisites

Before running this application, ensure you have:

### Required Software
- Java 17 or higher
- Maven 3.6+
- MuleSoft Runtime 4.4.0+

### Required Dependencies
- **AI Chain Connector**: This project uses the MuleSoft AI Chain connector (version 1.2.0)
  ```xml
  <dependency>
      <groupId>io.github.mulesoft-ai-chain-project</groupId>
      <artifactId>mule4-aichain-connector</artifactId>
      <version>1.2.0</version>
      <classifier>mule-plugin</classifier>
  </dependency>
  ```

### OpenAI API Setup
1. **Create OpenAI Account**: Sign up at [https://platform.openai.com](https://platform.openai.com)
2. **Generate API Key**: Go to [https://platform.openai.com/api-keys](https://platform.openai.com/api-keys)
3. **Copy API Key**: You'll need this for the configuration step below

## Configuration

### Essential Configuration Files

#### 1. HTTP Configuration (`src/main/resources/config.properties`)
Configure the HTTP listener settings:

```properties
# HTTP Listener Configuration
# Host and port for the HTTP listener
http.host=0.0.0.0
http.port=8081
```

#### 2. AI Configuration (`src/main/resources/llm-config.json`)
**CRITICAL**: Configure your OpenAI API key in this file:

```json
{
  "OPENAI": {
    "OPENAI_API_KEY": "YOUR_ACTUAL_OPENAI_API_KEY_HERE"
  }
}
```

**Important Setup Steps:**
1. Replace `YOUR_ACTUAL_OPENAI_API_KEY_HERE` with your actual OpenAI API key
2. Keep the JSON structure exactly as shown
3. Ensure the file is saved in `src/main/resources/llm-config.json`

### AI Model Configuration
The AI Chain connector is configured in `global.xml` with these settings:
- **Model**: `gpt-4o-mini` (optimized for fraud detection)
- **LLM Type**: `OPENAI`
- **Configuration**: JSON file-based configuration

## API Endpoints

### POST /api/fraud-detection/analyze
Analyzes a Purchase Order for fraud indicators.

#### Request Body
```json
{
  "poNumber": "PO-2023-001",
  "vendorId": "VENDOR-12345",
  "amount": 50000,
  "poDate": "2023-12-01",
  "description": "Office equipment purchase"
}
```

#### Response
```json
{
  "transactionId": "550e8400-e29b-41d4-a716-446655440000",
  "timestamp": "2023-12-03T17:15:30.123Z",
  "poNumber": "PO-2023-001",
  "fraudAssessment": {
    "riskLevel": "MEDIUM",
    "riskScore": 65,
    "fraudIndicators": [
      "High amount transaction with round number pattern",
      "Vendor ID format appears legitimate but requires monitoring",
      "Processing timing within normal business parameters"
    ],
    "recommendation": "REVIEW - Manual review recommended due to amount patterns",
    "aiConfidence": 87,
    "analysisDetails": "AI analysis identified moderate risk based on amount patterns. The $50,000 round number amount combined with office equipment description suggests potential fraud indicators that warrant manual review."
  },
  "status": "ANALYZED"
}
```

## AI Analysis Process

The API performs a sophisticated 4-stage AI analysis using specialized prompts:

### 1. AI Amount Analysis
- **Prompt Focus**: Analyzes transaction amounts for fraud patterns
- **Detection**: Unusual amounts, round numbers, amount-description inconsistencies
- **AI Model**: GPT-4o-mini with financial fraud expertise context
- **Output**: Risk score, indicators, reasoning, confidence level

### 2. AI Vendor Analysis  
- **Prompt Focus**: Evaluates vendor information for suspicious patterns
- **Detection**: Shell companies, test vendors, suspicious ID formats
- **AI Model**: GPT-4o-mini with vendor fraud detection expertise
- **Output**: Risk score, vendor-specific indicators, detailed analysis

### 3. AI Timing Analysis
- **Prompt Focus**: Examines temporal fraud indicators
- **Detection**: Future dates, processing delays, timing inconsistencies
- **AI Model**: GPT-4o-mini with business process timing expertise
- **Output**: Timing risk assessment with contextual reasoning

### 4. AI Final Assessment
- **Prompt Focus**: Synthesizes all analysis results into final recommendation
- **Process**: Combines amount, vendor, and timing analysis results
- **AI Model**: Senior fraud expert persona for comprehensive assessment
- **Output**: Final risk level, consolidated indicators, actionable recommendations

## Running the Application

### Local Development
1. **Clone the repository**
   ```bash
   git clone <repository-url>
   cd po-fraud-detection-api
   ```

2. **Configure OpenAI API Key**
   - Edit `src/main/resources/llm-config.json`
   - Replace `YOUR_ACTUAL_OPENAI_API_KEY_HERE` with your OpenAI API key

3. **Run the application**
   ```bash
   mvn clean compile
   mvn mule:run
   ```

4. **Verify startup**
   - The API will be available at `http://localhost:8081`
   - Check logs for successful startup messages

## Testing the API

### Quick Test with curl

#### Test with low-risk PO
```bash
curl -X POST http://localhost:8081/api/fraud-detection/analyze \
  -H "Content-Type: application/json" \
  -d '{
    "poNumber": "PO-2023-001",
    "vendorId": "VENDOR-12345",
    "amount": 5000,
    "poDate": "2023-12-01",
    "description": "Office supplies"
  }'
```

#### Test with high-risk PO
```bash
curl -X POST http://localhost:8081/api/fraud-detection/analyze \
  -H "Content-Type: application/json" \
  -d '{
    "poNumber": "PO-2023-002",
    "vendorId": "12",
    "amount": 150000,
    "poDate": "2025-01-01",
    "description": "Suspicious purchase"
  }'
```

## Postman Collection

This project includes a comprehensive Postman collection for easy testing:

### Files Available
- `PO-Fraud-Detection-API.postman_collection.json` - Complete test collection
- `PO-Fraud-Detection-API.postman_environment.json` - Environment configuration
- `POSTMAN_COLLECTION_README.md` - Detailed setup and usage instructions

### Quick Setup
1. **Import Collection**: Import both JSON files into Postman
2. **Select Environment**: Choose "PO Fraud Detection API - Local Environment"
3. **Run Tests**: Execute individual requests or run the entire collection

### Test Cases Included
- ✅ **Success Case**: Valid PO request with expected fraud assessment
- ❌ **Failure Case**: Missing required fields with validation error handling
- 🔍 **Automated Tests**: Response validation, structure checks, and error handling

For detailed setup instructions, see [POSTMAN_COLLECTION_README.md](POSTMAN_COLLECTION_README.md).

## Running Tests

Execute MUnit tests:
```bash
mvn test
```

The test suite includes:
- Low risk PO validation
- High risk detection (large amounts)
- Medium risk detection (suspicious vendors)
- Validation error handling
- Round number detection
- Future date detection

## Deployment

### CloudHub 2.0 Deployment
```bash
mvn clean package deploy -DmuleDeploy
```

### Runtime Fabric Deployment
Configure deployment properties and run:
```bash
mvn clean package deploy -DmuleDeploy -Denv=production
```

**Note**: Ensure your OpenAI API key is properly configured in the target environment.

## Monitoring and Logging

The API includes comprehensive logging:
- Request/response logging
- Fraud analysis details
- Error tracking
- Performance metrics

Log levels can be configured in `src/main/resources/log4j2.xml`.

## Error Handling

### Validation Errors (400)
```json
{
  "error": "VALIDATION_ERROR",
  "message": "Invalid input data provided",
  "details": "PO Number is required",
  "timestamp": "2023-12-03T17:15:30.123Z"
}
```

### Processing Errors (500)
```json
{
  "error": "PROCESSING_ERROR",
  "message": "An error occurred during fraud analysis",
  "details": "Internal processing error",
  "timestamp": "2023-12-03T17:15:30.123Z"
}
```

## Troubleshooting

### Common Issues

#### 1. AI Configuration Problems
**Problem**: API returns errors about AI service unavailable
**Solutions**:
- Verify OpenAI API key is correctly set in `llm-config.json`
- Check that the API key has sufficient credits/quota
- Ensure the JSON format is valid (no extra commas, proper quotes)

#### 2. Connection Issues
**Problem**: Cannot connect to the API
**Solutions**:
- Verify the application started successfully (check logs)
- Confirm the port 8081 is not in use by another application
- Check firewall settings if accessing remotely

#### 3. Validation Errors
**Problem**: All requests return validation errors
**Solutions**:
- Ensure all required fields are provided: `poNumber`, `vendorId`, `amount`, `poDate`, `description`
- Verify `amount` is a positive number
- Check date format is valid (YYYY-MM-DD)

#### 4. AI Analysis Failures
**Problem**: API returns default risk scores instead of AI analysis
**Solutions**:
- Check application logs for AI connector errors
- Verify OpenAI API key permissions and quota
- Ensure internet connectivity for OpenAI API calls

### Debugging Tips
1. **Check Logs**: Review `logs/` directory for detailed error information
2. **Test OpenAI Key**: Verify your API key works with OpenAI's API directly
3. **Validate JSON**: Use a JSON validator to check `llm-config.json` format
4. **Network Issues**: Ensure outbound HTTPS connections are allowed

### Getting Help
If issues persist:
1. Check the application logs for detailed error messages
2. Verify all configuration files are properly formatted
3. Test with the provided Postman collection to isolate issues
4. Review the MUnit test cases for usage examples

## Security Considerations

- **API Key Security**: Never commit your OpenAI API key to version control
- **Input Validation**: All fields are validated before processing
- **Secure HTTP Headers**: Security headers are enabled
- **CORS Configuration**: CORS is properly configured
- **Request Size Limits**: Payload size is limited for security
- **Rate Limiting**: Consider implementing rate limiting for production use

## Performance

- **Lightweight Processing**: Efficient fraud detection algorithms
- **Optimized DataWeave**: Efficient DataWeave transformations
- **AI Response Caching**: Consider implementing caching for repeated analyses
- **Configurable Timeouts**: Timeout settings can be adjusted as needed
- **High Throughput**: Optimized for concurrent request processing

## Support

For issues and questions:
1. **Check Logs**: Review detailed error information in application logs
2. **Verify Configuration**: Ensure OpenAI API key and other settings are correct
3. **Test with Postman**: Use the provided collection to validate functionality
4. **Review Tests**: Check MUnit test cases for usage examples
5. **Configuration Issues**: Verify all required fields are provided in requests

## Version History

- **v1.0.0**: Initial release with comprehensive AI-powered fraud detection capabilities
  - Multi-stage AI analysis with GPT-4o-mini
  - Comprehensive validation and error handling
  - Postman collection for easy testing
  - Complete documentation and troubleshooting guide
