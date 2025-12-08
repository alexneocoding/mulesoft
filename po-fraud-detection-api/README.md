# AI-Powered PO Fraud Detection API

A basic MuleSoft API that leverages AI Chain connector with OpenAI GPT-4 to detect fraudulent patterns in Purchase Orders (POs). This API uses advanced AI prompts to analyze fraud indicators and provides intelligent risk assessments with actionable recommendations.

## Table of Contents

- [Features](#features)
- [Prerequisites](#prerequisites)
- [Configuration](#configuration)
- [API Endpoints](#api-endpoints)
- [Historical Data Integration](#historical-data-integration)
- [Application Architecture](#application-architecture)
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
4. **SECURITY WARNING**: Never commit your actual API key to version control

**File Path Configuration:**
The AI Chain connector dynamically constructs the config file path as: `{mule.home}/apps/{app.name}/llm-config.json`

### AI Model Configuration
The AI Chain connector is configured in `global.xml` with these settings:
- **Model**: `gpt-4o-mini` (optimized for fraud detection)
- **LLM Type**: `OPENAI`
- **Configuration**: JSON file-based configuration
- **Connector Namespace**: `ms-aichain` (MuleSoft AI Chain Connector)
- **Max Tokens**: 5000
- **Temperature**: 0 (deterministic responses)
- **Top P**: 1

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
  "timeStamp": "2023-12-03T17:15:30.123Z",
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

## Historical Data Integration

The API leverages historical partner transaction data to enhance AI analysis accuracy:

### Historical Data Features
- **Partner History Loading**: Automatically loads historical transaction data for each vendor
- **Data Filtering**: Filters historical data by vendor ID for contextual analysis
- **AI Context Enhancement**: Provides historical patterns to AI models for better fraud detection
- **Data Source**: `src/main/resources/data/partner-history-data.json`

### How Historical Data Works
1. **Data Loading Flow**: The `load-historical-data-flow` retrieves and filters partner history
2. **Vendor-Specific Filtering**: Historical data is filtered by the current PO's vendor ID
3. **AI Integration**: Historical patterns are included in all three AI analysis stages
4. **Context Enhancement**: AI models use historical data to identify anomalies and patterns

### Historical Data Structure
The historical data includes:
- Previous transaction amounts and patterns
- Vendor transaction history
- Timing patterns and frequencies
- Risk indicators from past transactions

This historical context significantly improves the accuracy of fraud detection by allowing AI models to compare current transactions against established vendor patterns.

## Application Architecture

### Flow Architecture Overview
The application follows a modular flow-based architecture with clear separation of concerns:

```
HTTP Request → Validation → Historical Data Loading → AI Analysis → Response Formation
     ↓              ↓              ↓                    ↓              ↓
  api.xml    api-implementation.xml  common.xml    api-implementation.xml  api.xml
```

### Core Flow Components

#### 1. Main Flow (`main-flow`)
- **Location**: `src/main/mule/api.xml`
- **Purpose**: Entry point for all fraud detection requests
- **Responsibilities**: HTTP listener, request logging, orchestration, response formatting, error handling

#### 2. Validation Flow (`validate-po-data-flow`)
- **Location**: `src/main/mule/api-implementation.xml`
- **Purpose**: Comprehensive input validation
- **Validations**: Required fields, data types, business rules (positive amounts, valid dates)

#### 3. Historical Data Flow (`load-historical-data-flow`)
- **Location**: `src/main/mule/common.xml`
- **Purpose**: Load and filter partner transaction history
- **Process**: Reads `partner-history-data.json`, filters by vendor ID, provides context for AI analysis

#### 4. AI Analysis Flows
All located in `src/main/mule/api-implementation.xml`:
- **Amount Analysis Flow** (`ai-amount-analysis-flow`): Analyzes transaction amounts for fraud patterns
- **Vendor Analysis Flow** (`ai-vendor-analysis-flow`): Evaluates vendor information for suspicious patterns  
- **Timing Analysis Flow** (`ai-timing-analysis-flow`): Examines temporal fraud indicators
- **Final Assessment Flow** (`ai-final-assessment-flow`): Synthesizes all analysis results

### Data Flow Sequence
1. **Request Reception**: HTTP listener receives POST request
2. **Input Validation**: All required fields and business rules validated
3. **Historical Context**: Partner history loaded and filtered by vendor ID
4. **AI Analysis Chain**: Sequential execution of specialized AI analysis flows
5. **Result Synthesis**: Final assessment combines all analysis results
6. **Response Formation**: Structured JSON response with fraud assessment

### Configuration Management
- **Global Configuration**: `src/main/mule/global.xml` - HTTP listener, AI Chain connector, error handlers
- **Properties**: `src/main/resources/config.properties` - HTTP host/port configuration
- **AI Configuration**: `src/main/resources/llm-config.json` - OpenAI API key and settings
- **Prompts**: `src/main/resources/prompts/` - Specialized AI prompts for each analysis type

## AI Analysis Process

The API performs a sophisticated 4-stage AI analysis using specialized prompts and historical data:

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

This project includes an essential Postman test collection for API validation:

### Files Available
- `integration-tests/postman/api-test-suite.json` - Essential test collection

### Collection Details
- **Name**: "PO Fraud Detection API - Essential Test Suite"
- **Description**: Essential test collection with AI-powered analysis validation
- **Base URL**: `http://localhost:8081` (configurable via environment variables)

### Test Cases Included
- ✅ **Success Case - Partner with History**: Tests vendor with historical data (`APL-RSLR-0101`)
- ✅ **Success Case - No Historical Data**: Tests vendor without historical data (`APL-RESSELER`)
- 🔍 **Automated Validation**: Response structure, risk levels, and field validation

### Quick Setup
1. **Import Collection**: Import `integration-tests/postman/api-test-suite.json` into Postman
2. **Set Base URL**: The collection uses `{{baseUrl}}` variable (defaults to `http://localhost:8081`)
3. **Run Tests**: Execute individual requests or run the entire collection

### Test Scenarios
Both test cases use realistic scenarios:
- **Vendor ID**: Tests both partners with and without historical transaction data
- **Amount**: $1,998.00 (realistic iPhone purchase amount)
- **Description**: "iPhone 15, 2 unit" (legitimate business purchase)
- **Date**: Current date (2025-12-08)

### Automated Test Validations
Each test case includes comprehensive validations:
- HTTP 200 status code verification
- Required response fields validation
- Risk level validation (HIGH, MEDIUM, LOW, MINIMAL)
- Risk score range validation (0-100)
- Status field verification ("ANALYZED")
- Fraud assessment structure validation

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
